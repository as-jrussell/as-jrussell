-- ================================================================
-- FUNCTION: deploy.SetCreateUser()
-- DESCRIPTION: Creates users, assigns roles, logs actions securely
-- OWNER: dba_team
-- ==============================================================

-- DROP FUNCTION IF EXISTS deploy.setcreateuser(text[], text, text[], boolean);

CREATE OR REPLACE FUNCTION deploy.setcreateuser(
    p_usernames TEXT[],
    p_user_password TEXT DEFAULT NULL,
    p_user_inherit_roles TEXT[] DEFAULT NULL,
    p_execute_flag BOOLEAN DEFAULT FALSE
)
RETURNS TEXT
LANGUAGE plpgsql
COST 100
VOLATILE PARALLEL UNSAFE
AS $$
DECLARE
    v_entity_exists BOOLEAN;
    v_is_member BOOLEAN;
    v_sql_command TEXT;
    v_sql_command_real TEXT;
    v_log_status TEXT;
    v_return_message TEXT := '';
    v_current_user_name TEXT;
    v_current_inherit_role TEXT;
    v_generated_password TEXT;
    password_mask_pattern TEXT := E'WITH (?:LOGIN\s+)?PASSWORD\s+''[^'']*''';
    masked_password_string TEXT := 'WITH LOGIN PASSWORD ''xxxxxxxxxxxxxx''';
BEGIN
    IF p_usernames IS NOT NULL AND array_length(p_usernames, 1) > 0 THEN
        FOREACH v_current_user_name IN ARRAY p_usernames LOOP
            SELECT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = v_current_user_name)
            INTO v_entity_exists;

            v_generated_password := p_user_password;
            IF v_generated_password IS NULL THEN
                v_generated_password := v_current_user_name || 'Pass123!';
                RAISE NOTICE 'Default password assigned for user "%".', v_current_user_name;
            END IF;

            IF NOT v_entity_exists THEN
                v_sql_command := format('CREATE ROLE %I WITH LOGIN PASSWORD ''xxxxxxxxxxxxxx''', v_current_user_name);
                v_sql_command_real := format('CREATE ROLE %I WITH LOGIN PASSWORD %L', v_current_user_name, v_generated_password);
                RAISE NOTICE '[DRY-RUN] Would create user: "%"', v_current_user_name;

                IF p_execute_flag THEN
                    EXECUTE v_sql_command_real;
                    v_log_status := 'EXECUTED';
                    RAISE NOTICE 'User "%s" created.', v_current_user_name;
                ELSE
                    v_log_status := 'DRY_RUN';
                END IF;

                INSERT INTO info.account_log_history (
                    action_type,
                    target_entity,
                    associated_entity,
                    status,
                    sql_command,
                    message
                ) VALUES (
                    'CREATE_USER',
                    v_current_user_name,
                    NULL,
                    v_log_status,
                    v_sql_command,
                    'User creation attempted.' || CASE WHEN v_log_status = 'EXECUTED' THEN ' Password set (not logged).' ELSE '' END
                );

                v_return_message := v_return_message || format('User "%s" created. ', v_current_user_name);
            ELSE
                v_log_status := 'ALREADY_EXISTS';
                INSERT INTO info.account_log_history (
                    action_type,
                    target_entity,
                    associated_entity,
                    status,
                    sql_command,
                    message
                ) VALUES (
                    'CREATE_USER',
                    v_current_user_name,
                    NULL,
                    v_log_status,
                    NULL,
                    'User already existed, no action taken.'
                );
            END IF;

            IF p_user_inherit_roles IS NOT NULL AND array_length(p_user_inherit_roles, 1) > 0 THEN
                FOREACH v_current_inherit_role IN ARRAY p_user_inherit_roles LOOP
                    SELECT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = v_current_inherit_role)
                    INTO v_entity_exists;

                    IF NOT v_entity_exists THEN
                        RAISE WARNING 'Inheritance role "%" for user "%" does not exist. Skipping grant.', v_current_inherit_role, v_current_user_name;
                        INSERT INTO info.account_log_history (
                            action_type,
                            target_entity,
                            associated_entity,
                            status,
                            sql_command,
                            message
                        ) VALUES (
                            'GRANT_MEMBERSHIP',
                            v_current_user_name,
                            v_current_inherit_role,
                            'SKIPPED',
                            NULL,
                            format('Inheritance role "%s" does not exist for user "%s". Grant skipped.', v_current_inherit_role, v_current_user_name)
                        );
                        CONTINUE;
                    END IF;

                    SELECT EXISTS (
                        SELECT 1
                        FROM pg_auth_members m
                        JOIN pg_roles r1 ON m.roleid = r1.oid
                        JOIN pg_roles r2 ON m.member = r2.oid
                        WHERE r1.rolname = v_current_inherit_role
                          AND r2.rolname = v_current_user_name
                    ) INTO v_is_member;

                    IF NOT v_is_member THEN
                        v_sql_command := format('GRANT %I TO %I', v_current_inherit_role, v_current_user_name);
                        IF p_execute_flag THEN
                            EXECUTE v_sql_command;
                            v_log_status := 'EXECUTED';
                        ELSE
                            v_log_status := 'DRY_RUN';
                        END IF;

                        INSERT INTO info.account_log_history (
                            action_type,
                            target_entity,
                            associated_entity,
                            status,
                            sql_command,
                            message
                        ) VALUES (
                            'GRANT_MEMBERSHIP',
                            v_current_user_name,
                            v_current_inherit_role,
                            v_log_status,
                            v_sql_command,
                            'Granted inheritance role to user.'
                        );
                    END IF;
                END LOOP;
            END IF;
        END LOOP;
    END IF;

    

            -- Grant USAGE on all non-system databases and all schemas
            FOR v_current_user_name IN SELECT unnest(p_usernames)
            LOOP
                FOR v_target_db IN
                    SELECT datname FROM pg_database
                    WHERE datistemplate = false
                      AND datname NOT IN ('postgres', 'DBA', 'dba', 'rdsadmin')
                LOOP
                    v_sql_command := format('GRANT CONNECT ON DATABASE %I TO %I;', v_target_db, v_current_user_name);
                    IF p_execute_flag THEN EXECUTE v_sql_command; END IF;
                    v_return_message := v_return_message || format('Granted CONNECT on DB %s to %s.\n', v_target_db, v_current_user_name);

                    -- Connect and grant USAGE on all schemas
                    FOR v_schema IN
                        SELECT schema_name
                        FROM information_schema.schemata
                        WHERE schema_name NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
                    LOOP
                        v_sql_command_real := format('GRANT USAGE ON SCHEMA %I TO %I;', v_schema.schema_name, v_current_user_name);
                        IF p_execute_flag THEN EXECUTE v_sql_command_real; END IF;
                        v_return_message := v_return_message || format('Granted USAGE on schema %s to %s in DB %s.\n', v_schema.schema_name, v_current_user_name, v_target_db);
                    END LOOP;
                END LOOP;
            END LOOP;


    RETURN v_return_message;
END;
$$;

ALTER FUNCTION deploy.setcreateuser(text[], text, text[], boolean)
    OWNER TO dba_team;
