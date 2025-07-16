-- Create or replace the child function to handle role creation with optional inheritance roles only
CREATE OR REPLACE FUNCTION deploy.SetRoleCreation(
    p_role_names TEXT[],
    p_user_inherit_roles TEXT[] DEFAULT NULL,
    p_execute_flag BOOLEAN DEFAULT FALSE
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
/*
==========================================================
🏗️ deploy.SetRoleCreation() - Example Use Cases
==========================================================

-- 🔧 BASIC: Create a single NOLOGIN role
SELECT deploy.SetRoleCreation(
    p_role_names := ARRAY['role_readonly']
);

-- 👪 INHERITANCE: Create a role that inherits from another role
SELECT deploy.SetRoleCreation(
    p_role_names := ARRAY['role_support'],
    p_user_inherit_roles := ARRAY['role_readonly']
);

-- 🧪 DRY-RUN: Show what would happen without making any changes
SELECT deploy.SetRoleCreation(
    p_role_names := ARRAY['role_dryrun'],
    p_user_inherit_roles := ARRAY['role_basic'],
    p_execute_flag := FALSE
);

-- 🛠️ EXECUTE MODE: Actually create the role and grant inheritance
SELECT deploy.SetRoleCreation(
    p_role_names := ARRAY['role_writer'],
    p_user_inherit_roles := ARRAY['db_datawriter'],
    p_execute_flag := TRUE
);

-- 🧬 MULTI-INHERITANCE: One role inherits multiple roles
SELECT deploy.SetRoleCreation(
    p_role_names := ARRAY['role_composite'],
    p_user_inherit_roles := ARRAY['db_datareader', 'db_function_exec'],
    p_execute_flag := TRUE
);

-- 🎯 MULTI-ROLE CREATION: Create several roles at once
SELECT deploy.SetRoleCreation(
    p_role_names := ARRAY['role_audit', 'role_temp', 'role_zombie'],
    p_execute_flag := TRUE
);

-- 💥 FULL LOADOUT: Create multiple roles and inheritances
SELECT deploy.SetRoleCreation(
    p_role_names := ARRAY['role_dataops', 'role_migrations'],
    p_user_inherit_roles := ARRAY['db_ddladmin', 'db_datawriter'],
    p_execute_flag := TRUE
);
*/

DECLARE
    v_entity_exists BOOLEAN;
    v_is_member BOOLEAN;
    v_sql_command TEXT;
    v_log_status TEXT;
    v_return_message TEXT := '';
    v_current_role_name TEXT;
    v_current_inherit_role TEXT;
BEGIN
    IF p_role_names IS NOT NULL AND array_length(p_role_names, 1) > 0 THEN
        FOREACH v_current_role_name IN ARRAY p_role_names LOOP
            SELECT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = v_current_role_name) INTO v_entity_exists;

            IF NOT v_entity_exists THEN
                v_sql_command := format('CREATE ROLE %I NOLOGIN', v_current_role_name);
                RAISE NOTICE '[DRY-RUN] Would create role: "%"', v_current_role_name;

                IF p_execute_flag THEN
                    EXECUTE v_sql_command;
                    v_log_status := 'EXECUTED';
                    RAISE NOTICE 'Role "%s" created.', v_current_role_name;
                ELSE
                    v_log_status := 'DRY_RUN';
                END IF;

                INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                VALUES (
                    'CREATE_ROLE',
                    v_current_role_name,
                    NULL,
                    v_log_status,
                    REGEXP_REPLACE(v_sql_command, E'WITH (?:LOGIN\\s+)?PASSWORD\\s+''[^'']*''', 'WITH LOGIN PASSWORD ''xxxxxxxxxxxxxx''', 'i'),
                    'Role creation attempted.'
                );
                v_return_message := v_return_message || format('Role "%s" created. ', v_current_role_name);
            ELSE
                v_log_status := 'ALREADY_EXISTS';
                INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                VALUES (
                    'CREATE_ROLE',
                    v_current_role_name,
                    NULL,
                    v_log_status,
                    NULL,
                    'Role already existed, no action taken.'
                );
            END IF;

            -- Grant inheritance roles
            IF p_user_inherit_roles IS NOT NULL THEN
                FOREACH v_current_inherit_role IN ARRAY p_user_inherit_roles LOOP
                    PERFORM 1 FROM pg_roles WHERE rolname = v_current_inherit_role;
                    IF NOT FOUND THEN
                        RAISE WARNING 'Inheritance role "%" does not exist. Skipping.', v_current_inherit_role;
                        CONTINUE;
                    END IF;

                    SELECT EXISTS (
                        SELECT 1
                        FROM pg_auth_members m
                        JOIN pg_roles r1 ON m.roleid = r1.oid
                        JOIN pg_roles r2 ON m.member = r2.oid
                        WHERE r1.rolname = v_current_inherit_role AND r2.rolname = v_current_role_name
                    ) INTO v_is_member;

                    IF NOT v_is_member THEN
                        v_sql_command := format('GRANT %I TO %I', v_current_inherit_role, v_current_role_name);
                        IF p_execute_flag THEN
                            EXECUTE v_sql_command;
                            v_log_status := 'EXECUTED';
                        ELSE
                            v_log_status := 'DRY_RUN';
                        END IF;

                        INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                        VALUES ('GRANT_ROLE_TO_ROLE', v_current_role_name, v_current_inherit_role, v_log_status, v_sql_command, 'Granted inheritance role to role.');
                    END IF;
                END LOOP;
            END IF;
        END LOOP;
    END IF;

    RETURN v_return_message;
END;
$$;
