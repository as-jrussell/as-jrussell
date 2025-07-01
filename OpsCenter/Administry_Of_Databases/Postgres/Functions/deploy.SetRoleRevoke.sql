CREATE OR REPLACE FUNCTION deploy.SetRoleRevoke(
    p_role_names TEXT[],
    p_execute_flag BOOLEAN DEFAULT FALSE
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
/*
==========================================================
🪦 deploy.SetRoleRevoke() - Example Use Cases
==========================================================

-- ⚰️ BASIC DROP: Drop one role
SELECT deploy.SetRoleRevoke(
    p_role_names := ARRAY['db_old_writer'],
    p_execute_flag := TRUE
);

-- 🔥 MULTI-ROLE DROP: Drop multiple roles
SELECT deploy.SetRoleRevoke(
    p_role_names := ARRAY['temp_read', 'test_exec'],
    p_execute_flag := TRUE
);

-- 🧪 DRY-RUN: Simulate dropping the role, don’t actually drop it
SELECT deploy.SetRoleRevoke(
    p_role_names := ARRAY['legacy_role'],
    p_execute_flag := FALSE
);
*/

DECLARE
    v_role_name TEXT;
    v_sql_command TEXT;
    v_log_status TEXT;
    v_return_message TEXT := '';
    v_exists BOOLEAN;
BEGIN
    IF p_role_names IS NULL OR array_length(p_role_names, 1) = 0 THEN
        RAISE EXCEPTION 'No role names provided.';
    END IF;

    FOREACH v_role_name IN ARRAY p_role_names LOOP
        SELECT EXISTS (
            SELECT 1 FROM pg_roles WHERE rolname = v_role_name
        ) INTO v_exists;

        IF v_exists THEN
            v_sql_command := format('DROP ROLE %I;', v_role_name);
            RAISE NOTICE '[DRY-RUN] Would drop role: %', v_sql_command;

            IF p_execute_flag THEN
                EXECUTE v_sql_command;
                v_log_status := 'EXECUTED';
                RAISE NOTICE 'Role "%" dropped.', v_role_name;
            ELSE
                v_log_status := 'DRY_RUN';
            END IF;

            INSERT INTO dba.account_log_history (
                action_type,
                target_entity,
                associated_entity,
                status,
                sql_command,
                message
            ) VALUES (
                'DROP_ROLE',
                v_role_name,
                NULL,
                v_log_status,
                v_sql_command,
                format('Role %s was dropped.', v_role_name)
            );

            v_return_message := v_return_message || format('Role "%s" dropped. ', v_role_name);

        ELSE
            v_log_status := 'NOT_FOUND';
            RAISE NOTICE 'Role "%" does not exist. Skipping.', v_role_name;

            INSERT INTO dba.account_log_history (
                action_type,
                target_entity,
                associated_entity,
                status,
                sql_command,
                message
            ) VALUES (
                'DROP_ROLE',
                v_role_name,
                NULL,
                v_log_status,
                NULL,
                'Role not found, no action taken.'
            );

            v_return_message := v_return_message || format('Role "%s" not found. ', v_role_name);
        END IF;
    END LOOP;

    RETURN v_return_message;
END;
$$;
