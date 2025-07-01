-- Create or replace the child function to handle user creation
CREATE OR REPLACE FUNCTION deploy.SetCreateUser(
    p_usernames TEXT[],
    p_user_password TEXT DEFAULT NULL,
    p_user_inherit_roles TEXT[] DEFAULT NULL,
    p_execute_flag BOOLEAN DEFAULT FALSE
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
/*
==========================================================
🚀 deploy.SetCreateUser() - Example Use Cases
==========================================================

-- 🧪 BASIC: Create a single user with a default password and no inherited roles
SELECT deploy.SetCreateUser(
    p_usernames := ARRAY['user_jdoe']
);

-- 🛡️ SECURE: Create a user with a custom password
SELECT deploy.SetCreateUser(
    p_usernames := ARRAY['user_secure'],
    p_user_password := 'BetterPassw0rd!'
);

-- 🧬 INHERITANCE: Create a user with inherited role(s)
SELECT deploy.SetCreateUser(
    p_usernames := ARRAY['user_analyst'],
    p_user_inherit_roles := ARRAY['db_datareader', 'db_function_exec']
);

-- 🧩 FULL CONTROL: Create user, custom password, and inherited roles
SELECT deploy.SetCreateUser(
    p_usernames := ARRAY['user_full'],
    p_user_password := 'Strong1Password',
    p_user_inherit_roles := ARRAY['db_datareader', 'db_datawriter']
);

-- 🧼 DRY-RUN: Test what would happen (no actual changes)
SELECT deploy.SetCreateUser(
    p_usernames := ARRAY['user_dryrun'],
    p_user_inherit_roles := ARRAY['db_viewer'],
    p_execute_flag := FALSE
);

-- 🛠️ EXECUTION MODE: Actually create the user and assign roles
SELECT deploy.SetCreateUser(
    p_usernames := ARRAY['user_exec'],
    p_user_password := 'Exec123!',
    p_user_inherit_roles := ARRAY['db_datareader'],
    p_execute_flag := TRUE
);

-- 🤖 MULTIPLE USERS: Provision multiple users at once
SELECT deploy.SetCreateUser(
    p_usernames := ARRAY['user_a', 'user_b', 'user_c'],
    p_user_password := 'DefaultPass123!',
    p_user_inherit_roles := ARRAY['db_basic'],
    p_execute_flag := TRUE
);

-- 🔐 MIXED: Each user can get the same inherited roles, default password if not set
SELECT deploy.SetCreateUser(
    p_usernames := ARRAY['user_alpha', 'user_beta'],
    p_user_inherit_roles := ARRAY['db_viewer'],
    p_execute_flag := TRUE
);
*/

DECLARE
    v_entity_exists BOOLEAN;
    v_is_member BOOLEAN;
    v_sql_command TEXT;
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
            SELECT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = v_current_user_name) INTO v_entity_exists;

            v_generated_password := p_user_password;
            IF v_generated_password IS NULL THEN
                v_generated_password := v_current_user_name || 'Pass123!';
                RAISE NOTICE 'Default password for user "%": %', v_current_user_name, v_generated_password;
            END IF;

            IF NOT v_entity_exists THEN
                v_sql_command := format('CREATE ROLE %I WITH LOGIN PASSWORD %L', v_current_user_name, v_generated_password);
                RAISE NOTICE '[DRY-RUN] Would create user: "%"', v_current_user_name;

                IF p_execute_flag THEN
                    EXECUTE v_sql_command;
                    v_log_status := 'EXECUTED';
                    RAISE NOTICE 'User "%s" created.', v_current_user_name;
                ELSE
                    v_log_status := 'DRY_RUN';
                END IF;

                INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                VALUES (
                    'CREATE_USER',
                    v_current_user_name,
                    NULL,
                    v_log_status,
                    REGEXP_REPLACE(v_sql_command, password_mask_pattern, masked_password_string, 'i'),
                    'User creation attempted.' || CASE WHEN v_log_status = 'EXECUTED' THEN ' Password set (not logged).' ELSE '' END
                );
                v_return_message := v_return_message || format('User "%s" created. ', v_current_user_name);
            ELSE
                v_log_status := 'ALREADY_EXISTS';
                INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                VALUES (
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
                    SELECT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = v_current_inherit_role) INTO v_entity_exists;
                    IF NOT v_entity_exists THEN
                        RAISE WARNING 'Inheritance role "%" for user "%" does not exist. Skipping grant.', v_current_inherit_role, v_current_user_name;
                        INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                        VALUES ('GRANT_MEMBERSHIP', v_current_user_name, v_current_inherit_role, 'SKIPPED', NULL,
                                format('Inheritance role "%s" does not exist for user "%s". Grant skipped.', v_current_inherit_role, v_current_user_name));
                        CONTINUE;
                    END IF;

                    SELECT EXISTS (
                        SELECT 1
                        FROM pg_auth_members m
                        JOIN pg_roles r1 ON m.roleid = r1.oid
                        JOIN pg_roles r2 ON m.member = r2.oid
                        WHERE r1.rolname = v_current_inherit_role AND r2.rolname = v_current_user_name
                    ) INTO v_is_member;

                    IF NOT v_is_member THEN
                        v_sql_command := format('GRANT %I TO %I', v_current_inherit_role, v_current_user_name);
                        IF p_execute_flag THEN
                            EXECUTE v_sql_command;
                            v_log_status := 'EXECUTED';
                        ELSE
                            v_log_status := 'DRY_RUN';
                        END IF;

                        INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                        VALUES ('GRANT_MEMBERSHIP', v_current_user_name, v_current_inherit_role, v_log_status, v_sql_command, 'Granted inheritance role to user.');
                    END IF;
                END LOOP;
            END IF;
        END LOOP;
    END IF;

    RETURN v_return_message;
END;
$$;
