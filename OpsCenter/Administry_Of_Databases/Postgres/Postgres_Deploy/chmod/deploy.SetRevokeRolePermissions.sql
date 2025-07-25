-- ===============================================
-- FUNCTION: deploy.SetRevokeRolePermissions()
-- DESCRIPTION: Revokes table/function privileges, removes users from roles,
--              optionally drops roles, and logs actions.
-- OWNER: dba_team
-- ===============================================
CREATE OR REPLACE FUNCTION deploy.SetRevokeRolePermissions(
    p_role_names TEXT[],
    p_users_to_remove TEXT[] DEFAULT NULL,
    p_schema_targets TEXT[] DEFAULT NULL,
    p_revoke_table_privileges TEXT[] DEFAULT NULL,
    p_revoke_function_privileges TEXT[] DEFAULT NULL,
    p_drop_roles BOOLEAN DEFAULT FALSE,
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
    v_log_status TEXT;
BEGIN
    FOREACH v_role IN ARRAY p_role_names LOOP

        -- Remove role from users
        IF p_users_to_remove IS NOT NULL THEN
            FOREACH v_user IN ARRAY p_users_to_remove LOOP
                v_sql := format('REVOKE %I FROM %I;', v_role, v_user);
                IF p_execute_flag THEN EXECUTE v_sql; END IF;
                v_log_status := CASE WHEN p_execute_flag THEN 'EXECUTED' ELSE 'DRY_RUN' END;
                INSERT INTO info.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                VALUES ('REVOKE_ROLE', v_user, v_role, v_log_status, v_sql, 'Revoked role from user');
                v_log := v_log || v_sql || E'\n';
            END LOOP;
        END IF;

        --Revoke schema/table/function privileges
        IF p_schema_targets IS NOT NULL THEN
            FOREACH v_schema IN ARRAY p_schema_targets LOOP

                -- Revoke TABLE privileges
                IF p_revoke_table_privileges IS NOT NULL THEN
                    FOREACH v_priv IN ARRAY p_revoke_table_privileges LOOP
                        v_sql := format('REVOKE %s ON ALL TABLES IN SCHEMA %I FROM %I;', v_priv, v_schema, v_role);
                        IF p_execute_flag THEN EXECUTE v_sql; END IF;
                        v_log_status := CASE WHEN p_execute_flag THEN 'EXECUTED' ELSE 'DRY_RUN' END;
                        INSERT INTO info.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                        VALUES ('REVOKE_TABLES', v_role, v_schema, v_log_status, v_sql, 'Revoked table privilege');
                        v_log := v_log || v_sql || E'\n';
                    END LOOP;
                END IF;

                -- Revoke FUNCTION privileges
                IF p_revoke_function_privileges IS NOT NULL THEN
                    FOREACH v_priv IN ARRAY p_revoke_function_privileges LOOP
                        v_sql := format('REVOKE %s ON ALL FUNCTIONS IN SCHEMA %I FROM %I;', v_priv, v_schema, v_role);
                        IF p_execute_flag THEN EXECUTE v_sql; END IF;
                        v_log_status := CASE WHEN p_execute_flag THEN 'EXECUTED' ELSE 'DRY_RUN' END;
                        INSERT INTO info.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                        VALUES ('REVOKE_FUNCTIONS', v_role, v_schema, v_log_status, v_sql, 'Revoked function privilege');
                        v_log := v_log || v_sql || E'\n';
                    END LOOP;
                END IF;
            END LOOP;
        END IF;

        -- Drop Role if requested
        IF p_drop_roles THEN
            v_sql := format('DROP ROLE IF EXISTS %I;', v_role);
            IF p_execute_flag THEN EXECUTE v_sql; END IF;
            v_log_status := CASE WHEN p_execute_flag THEN 'EXECUTED' ELSE 'DRY_RUN' END;
            INSERT INTO info.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
            VALUES ('DROP_ROLE', v_role, NULL, v_log_status, v_sql, 'Dropped role');
            v_log := v_log || v_sql || E'\n';
        END IF;
		
    END LOOP;
    RETURN v_log;
END;
$$;
ALTER FUNCTION deploy.SetRevokeRolePermissions(
    TEXT[], TEXT[], TEXT[], TEXT[], TEXT[],
    BOOLEAN, BOOLEAN
) OWNER TO dba_team;