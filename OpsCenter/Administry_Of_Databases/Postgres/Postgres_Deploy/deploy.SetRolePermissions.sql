-- ===============================================
-- FUNCTION: deploy.SetRolePermissions()
-- DESCRIPTION: Creates roles, grants table/function privileges,
--              optionally assigns users to roles, and logs actions.
-- OWNER: dba_team
-- ===============================================

CREATE OR REPLACE FUNCTION deploy.setrolepermissions(
    p_role_names TEXT[],
    p_users_to_assign TEXT[] DEFAULT NULL,
    p_apply_schema_privs_to_roles TEXT[] DEFAULT NULL,
    p_table_privileges TEXT[] DEFAULT NULL,
    p_function_privileges TEXT[] DEFAULT NULL,
    p_apply_to_existing_tables BOOLEAN DEFAULT FALSE,
    p_set_default_for_future_tables BOOLEAN DEFAULT FALSE,
    p_set_default_for_future_functions BOOLEAN DEFAULT FALSE,
    p_revoke_all_first BOOLEAN DEFAULT FALSE,
    p_execute_flag BOOLEAN DEFAULT FALSE
)
RETURNS TEXT
LANGUAGE plpgsql
COST 100
VOLATILE PARALLEL UNSAFE
AS $$
DECLARE
    v_role TEXT;
    v_user TEXT;
    v_schema TEXT;
    v_priv TEXT;
    v_sql TEXT;
    v_log TEXT := '';
    v_exists BOOLEAN;
    v_log_status TEXT;
BEGIN
    FOREACH v_role IN ARRAY p_role_names LOOP
        SELECT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = v_role) INTO v_exists;
        IF NOT v_exists THEN
            v_sql := format('CREATE ROLE %I;', v_role);
            IF p_execute_flag THEN EXECUTE v_sql; END IF;
            v_log_status := CASE WHEN p_execute_flag THEN 'EXECUTED' ELSE 'DRY_RUN' END;
            INSERT INTO info.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
            VALUES ('CREATE_ROLE', v_role, NULL, v_log_status, v_sql, 'Role creation');
            v_log := v_log || v_sql || E'\n';
        END IF;

        IF p_users_to_assign IS NOT NULL THEN
            FOREACH v_user IN ARRAY p_users_to_assign LOOP
                v_sql := format('GRANT %I TO %I;', v_role, v_user);
                IF p_execute_flag THEN EXECUTE v_sql; END IF;
                v_log_status := CASE WHEN p_execute_flag THEN 'EXECUTED' ELSE 'DRY_RUN' END;
                INSERT INTO info.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                VALUES ('GRANT_ROLE', v_role, v_user, v_log_status, v_sql, 'Granted role to user');
                v_log := v_log || v_sql || E'\n';
            END LOOP;
        END IF;

        IF p_apply_schema_privs_to_roles IS NOT NULL THEN
            FOREACH v_schema IN ARRAY p_apply_schema_privs_to_roles LOOP
                SELECT EXISTS (
                    SELECT 1
                    FROM information_schema.schemata
                    WHERE schema_name = v_schema
                ) INTO v_exists;

                IF NOT v_exists THEN
                    v_log := v_log || format('-- Skipped schema %I (not found)', v_schema) || E'\n';
                    CONTINUE;
                END IF;

                IF p_revoke_all_first THEN
                    v_sql := format('REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA %I FROM %I;', v_schema, v_role);
                    IF p_execute_flag THEN EXECUTE v_sql; END IF;
                    v_log_status := CASE WHEN p_execute_flag THEN 'EXECUTED' ELSE 'DRY_RUN' END;
                    INSERT INTO info.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                    VALUES ('REVOKE_TABLES', v_role, v_schema, v_log_status, v_sql, 'Revoked existing table privs');
                    v_log := v_log || v_sql || E'\n';
                END IF;

                IF p_apply_to_existing_tables AND p_table_privileges IS NOT NULL THEN
                    FOREACH v_priv IN ARRAY p_table_privileges LOOP
                        v_sql := format('GRANT %s ON ALL TABLES IN SCHEMA %I TO %I;', v_priv, v_schema, v_role);
                        IF p_execute_flag THEN EXECUTE v_sql; END IF;
                        v_log_status := CASE WHEN p_execute_flag THEN 'EXECUTED' ELSE 'DRY_RUN' END;
                        INSERT INTO info.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                        VALUES ('GRANT_TABLES', v_role, v_schema, v_log_status, v_sql, 'Granted table privilege');
                        v_log := v_log || v_sql || E'\n';
                    END LOOP;
                END IF;

                IF p_function_privileges IS NOT NULL THEN
                    FOREACH v_priv IN ARRAY p_function_privileges LOOP
                        v_sql := format('GRANT %s ON ALL FUNCTIONS IN SCHEMA %I TO %I;', v_priv, v_schema, v_role);
                        IF p_execute_flag THEN EXECUTE v_sql; END IF;
                        v_log_status := CASE WHEN p_execute_flag THEN 'EXECUTED' ELSE 'DRY_RUN' END;
                        INSERT INTO info.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                        VALUES ('GRANT_FUNCTIONS', v_role, v_schema, v_log_status, v_sql, 'Granted function privilege');
                        v_log := v_log || v_sql || E'\n';
                    END LOOP;
                END IF;

                IF p_set_default_for_future_tables AND p_table_privileges IS NOT NULL THEN
                    FOREACH v_priv IN ARRAY p_table_privileges LOOP
                        v_sql := format('ALTER DEFAULT PRIVILEGES FOR ROLE dba_team IN SCHEMA %I GRANT %s ON TABLES TO %I;', v_schema, v_priv, v_role);
                        IF p_execute_flag THEN EXECUTE v_sql; END IF;
                        v_log_status := CASE WHEN p_execute_flag THEN 'EXECUTED' ELSE 'DRY_RUN' END;
                        INSERT INTO info.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                        VALUES ('DEFAULT_TABLES', v_role, v_schema, v_log_status, v_sql, 'Default table privilege set');
                        v_log := v_log || v_sql || E'\n';
                    END LOOP;
                END IF;

                IF p_set_default_for_future_functions AND p_function_privileges IS NOT NULL THEN
                    FOREACH v_priv IN ARRAY p_function_privileges LOOP
                        v_sql := format('ALTER DEFAULT PRIVILEGES FOR ROLE dba_team IN SCHEMA %I GRANT %s ON FUNCTIONS TO %I;', v_schema, v_priv, v_role);
                        IF p_execute_flag THEN EXECUTE v_sql; END IF;
                        v_log_status := CASE WHEN p_execute_flag THEN 'EXECUTED' ELSE 'DRY_RUN' END;
                        INSERT INTO info.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                        VALUES ('DEFAULT_FUNCTIONS', v_role, v_schema, v_log_status, v_sql, 'Default function privilege set');
                        v_log := v_log || v_sql || E'\n';
                    END LOOP;
                END IF;
            END LOOP;
        END IF;
    END LOOP;
    RETURN v_log;
END;
$$;

ALTER FUNCTION deploy.setrolepermissions(
    TEXT[], TEXT[], TEXT[], TEXT[], TEXT[],
    BOOLEAN, BOOLEAN, BOOLEAN, BOOLEAN, BOOLEAN
) OWNER TO dba_team;
