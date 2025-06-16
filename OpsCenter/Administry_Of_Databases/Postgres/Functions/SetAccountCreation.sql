-- Ensure the dba schema exists (if not already done)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_namespace WHERE nspname = 'dba'
    ) THEN
        EXECUTE 'CREATE SCHEMA dba AUTHORIZATION current_user';
        RAISE NOTICE 'Schema "dba" created.';
    ELSE
        RAISE NOTICE 'Schema "dba" already exists.';
    END IF;
END
$$;

-- Ensure the account_log_history table exists (if not already done)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'dba'
          AND table_name = 'account_log_history'
    ) THEN
        CREATE TABLE dba.account_log_history (
            log_id SERIAL PRIMARY KEY,
            log_timestamp TIMESTAMPTZ DEFAULT NOW(),
            action_type TEXT NOT NULL,
            target_entity TEXT NOT NULL,
            associated_entity TEXT,
            status TEXT NOT NULL,
            sql_command TEXT,
            message TEXT
        );
        COMMENT ON TABLE dba.account_log_history IS 'Logs for role and user creation/modification attempts, and privilege applications.';
        RAISE NOTICE 'Table "dba.account_log_history" created.';
    ELSE
        RAISE NOTICE 'Table "dba.account_log_history" already exists.';
    END IF;
END
$$;

-- Create or replace the dba.SetAccountCreation function
CREATE OR REPLACE FUNCTION dba.SetAccountCreation(
    p_role_names TEXT[] DEFAULT NULL,
    p_role_parents TEXT[] DEFAULT NULL, -- Now supports multiple parent roles
    p_usernames TEXT[] DEFAULT NULL,
    p_user_password TEXT DEFAULT NULL,
    p_user_inherit_roles TEXT[] DEFAULT NULL, -- No default inheritance, lowest permission
    -- New parameters for object-level privilege application
    p_apply_schema_privs_to_roles TEXT[] DEFAULT NULL, -- Target roles for schema privileges
    p_table_privileges TEXT[] DEFAULT NULL,           -- Privileges for tables (e.g., ARRAY['SELECT', 'INSERT'])
    p_function_privileges TEXT[] DEFAULT NULL,        -- Privileges for functions (e.g., ARRAY['EXECUTE'])
    p_apply_to_existing_tables BOOLEAN DEFAULT FALSE, -- Default to FALSE (lowest action)
    p_set_default_for_future_tables BOOLEAN DEFAULT FALSE, -- Default to FALSE (lowest action)
    p_set_default_for_future_functions BOOLEAN DEFAULT FALSE, -- Default to FALSE (lowest action)
    p_revoke_all_first BOOLEAN DEFAULT FALSE,         -- Default to FALSE (lowest action)
    p_execute_flag BOOLEAN DEFAULT FALSE
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_entity_exists BOOLEAN;
    v_is_member BOOLEAN;
    v_generated_password TEXT;
    -- Moved these to top-level DECLARE for wider scope
    v_sql_command TEXT;
    v_log_status TEXT;
    v_message TEXT;
    v_return_message TEXT := '';
    v_action_performed BOOLEAN := FALSE;
    v_current_role_name TEXT;
    v_current_parent_role TEXT;
    v_current_user_name TEXT;
    v_current_inherit_role TEXT;
    v_roles_for_user_inheritance TEXT[];
    v_target_role_for_privs TEXT;
    s RECORD;
    fn RECORD;
    v_table_privs_str TEXT;
    v_func_privs_str TEXT;
    -- Regular expression for masking passwords
    password_mask_pattern TEXT := E'WITH (?:LOGIN\\s+)?PASSWORD\\s+''[^'']*''';
    masked_password_string TEXT := 'WITH LOGIN PASSWORD ''xxxxxxxxxxxxxx''';
BEGIN
    RAISE NOTICE 'Execution mode is %', CASE WHEN p_execute_flag THEN 'ON (changes will be applied)' ELSE 'OFF (dry-run only)' END;

    -- Convert array privileges to comma-separated strings for GRANT/ALTER DEFAULT PRIVILEGES
    IF p_table_privileges IS NOT NULL THEN
        v_table_privs_str := array_to_string(p_table_privileges, ', ');
    END IF;
    IF p_function_privileges IS NOT NULL THEN
        v_func_privs_str := array_to_string(p_function_privileges, ', ');
    END IF;

    -- =========================================================
    -- 1. Handle Role Creation (p_role_names)
    -- =========================================================
    IF p_role_names IS NOT NULL AND array_length(p_role_names, 1) > 0 THEN
        v_action_performed := TRUE;

        FOREACH v_current_role_name IN ARRAY p_role_names
        LOOP
            SELECT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = v_current_role_name) INTO v_entity_exists;

            IF NOT v_entity_exists THEN
                -- Assume roles created via p_role_names can optionally be LOGIN roles,
                -- and if so, might have a password (though not explicitly passed as param here)
                -- If no password is set, it's just 'CREATE ROLE %I NOLOGIN'
                v_sql_command := format('CREATE ROLE %I NOLOGIN', v_current_role_name); -- Default to NOLOGIN
                -- If you need to create LOGIN roles with passwords via p_role_names,
                -- you'd need a p_role_password param and logic here.
                -- For the jrussell example, the password would have been part of CREATE ROLE itself.

                RAISE NOTICE '[DRY-RUN] Would create role: "%"', v_current_role_name;

                IF p_execute_flag THEN
                    EXECUTE v_sql_command;
                    v_log_status := 'EXECUTED';
                    v_return_message := v_return_message || format('Role "%s" created. ', v_current_role_name);
                    RAISE NOTICE 'Role "%s" created.', v_current_role_name;
                ELSE
                    v_log_status := 'DRY_RUN';
                END IF;

                -- Log the (unmasked) SQL command. If a password were implicitly part of this
                -- CREATE ROLE, the regex below would mask it.
                INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                VALUES (
                    'CREATE_ROLE',
                    v_current_role_name,
                    NULL,
                    v_log_status,
                    REGEXP_REPLACE(v_sql_command, password_mask_pattern, masked_password_string, 'i'), -- Mask here
                    'Role creation attempted.'
                );
            ELSE
                RAISE NOTICE 'Role "%s" already exists.', v_current_role_name;
                v_log_status := 'ALREADY_EXISTS';
                INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                VALUES (
                    'CREATE_ROLE',
                    v_current_role_name,
                    NULL,
                    v_log_status,
                    NULL, -- No SQL command executed/planned
                    'Role already existed, no action taken.'
                );
            END IF;

            -- Handle granting multiple parent roles to the current role (v_current_role_name)
            IF p_role_parents IS NOT NULL AND array_length(p_role_parents, 1) > 0 THEN
                FOREACH v_current_parent_role IN ARRAY p_role_parents
                LOOP
                    SELECT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = v_current_parent_role) INTO v_entity_exists;
                    IF NOT v_entity_exists THEN
                        RAISE WARNING 'Parent role "%" for role "%" does not exist. Skipping grant.', v_current_parent_role, v_current_role_name;
                        INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                        VALUES ('GRANT_ROLE_TO_ROLE', v_current_role_name, v_current_parent_role, 'SKIPPED', NULL,
                                format('Parent role "%s" does not exist for role "%s". Grant skipped.', v_current_parent_role, v_current_role_name));
                    ELSE
                        SELECT EXISTS (
                            SELECT 1
                            FROM pg_auth_members m
                            JOIN pg_roles r1 ON m.roleid = r1.oid
                            JOIN pg_roles r2 ON m.member = r2.oid
                            WHERE r1.rolname = v_current_parent_role AND r2.rolname = v_current_role_name
                        ) INTO v_is_member;

                        IF NOT v_is_member THEN
                            v_sql_command := format('GRANT %I TO %I', v_current_parent_role, v_current_role_name);
                            RAISE NOTICE '[DRY-RUN] Would grant parent role "%" to role "%"', v_current_parent_role, v_current_role_name;
                            IF p_execute_flag THEN
                                EXECUTE v_sql_command;
                                v_log_status := 'EXECUTED';
                                v_return_message := v_return_message || format('Role "%s" granted to "%s". ', p_current_parent_role, v_current_role_name);
                                RAISE NOTICE 'Parent role "%s" granted to role "%s"', v_current_parent_role, v_current_role_name;
                            ELSE
                                v_log_status := 'DRY_RUN';
                            END IF;
                            INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                            VALUES ('GRANT_ROLE_TO_ROLE', v_current_role_name, v_current_parent_role, v_log_status, v_sql_command, 'Grant parent role to role attempted.');
                        ELSE
                            RAISE NOTICE 'Role "%s" is already a member of parent role "%s"', v_current_role_name, v_current_parent_role;
                            v_log_status := 'ALREADY_EXISTS';
                            INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                            VALUES ('GRANT_ROLE_TO_ROLE', v_current_role_name, v_current_parent_role, v_log_status, NULL,
                                    'Role already member of parent, no action taken.');
                        END IF;
                    END IF;
                END LOOP;
            END IF;

            -- Handle granting multiple inheritance roles to the current role (v_current_role_name)
            -- This applies p_user_inherit_roles to roles if p_role_names is used
            IF p_user_inherit_roles IS NOT NULL AND array_length(p_user_inherit_roles, 1) > 0 THEN
                FOREACH v_current_inherit_role IN ARRAY p_user_inherit_roles
                LOOP
                    SELECT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = v_current_inherit_role) INTO v_entity_exists;
                    IF NOT v_entity_exists THEN
                        RAISE WARNING 'Inheritance role "%" for role "%" does not exist. Skipping grant.', v_current_inherit_role, v_current_role_name;
                        INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                        VALUES ('GRANT_ROLE_TO_ROLE', v_current_role_name, v_current_inherit_role, 'SKIPPED', NULL,
                                format('Inheritance role "%s" does not exist for role "%s". Grant skipped.', v_current_inherit_role, v_current_role_name));
                    ELSE
                        SELECT EXISTS (
                            SELECT 1
                            FROM pg_auth_members m
                            JOIN pg_roles r1 ON m.roleid = r1.oid
                            JOIN pg_roles r2 ON m.member = r2.oid
                            WHERE r1.rolname = v_current_inherit_role AND r2.rolname = v_current_role_name
                        ) INTO v_is_member;

                        IF NOT v_is_member THEN
                            v_sql_command := format('GRANT %I TO %I', v_current_inherit_role, v_current_role_name);
                            RAISE NOTICE '[DRY-RUN] Would grant "%" to role "%"', v_current_inherit_role, v_current_role_name;
                            IF p_execute_flag THEN
                                EXECUTE v_sql_command;
                                v_log_status := 'EXECUTED';
                                v_return_message := v_return_message || format('Role "%s" granted to role "%s". ', v_current_inherit_role, v_current_role_name);
                                RAISE NOTICE 'Role "%s" granted to role "%s"', v_current_inherit_role, v_current_role_name;
                            ELSE
                                v_log_status := 'DRY_RUN';
                            END IF;
                            INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                            VALUES ('GRANT_ROLE_TO_ROLE', v_current_role_name, v_current_inherit_role, v_log_status, v_sql_command, 'Grant inheritance role to role attempted.');
                        ELSE
                            RAISE NOTICE 'Role "%s" is already a member of "%s"', v_current_role_name, v_current_inherit_role;
                            v_log_status := 'ALREADY_EXISTS';
                            INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                            VALUES ('GRANT_ROLE_TO_ROLE', v_current_role_name, v_current_inherit_role, v_log_status, NULL,
                                    'Role already member of inheritance role, no action taken.');
                        END IF;
                    END IF;
                END LOOP;
            END IF;
        END LOOP; -- End of FOREACH v_current_role_name loop
    END IF;

    -- =========================================================
    -- 2. Handle User Creation (p_usernames)
    -- =========================================================
    IF p_usernames IS NOT NULL AND array_length(p_usernames, 1) > 0 THEN
        v_action_performed := TRUE;

        -- Default p_user_inherit_roles to NULL (no inheritance)
        IF p_user_inherit_roles IS NULL THEN
            v_roles_for_user_inheritance := NULL; -- Explicitly set to NULL
            RAISE NOTICE 'No user inheritance roles provided. New users will have no default inheritance.';
        ELSE
            v_roles_for_user_inheritance := p_user_inherit_roles;
        END IF;

        FOREACH v_current_user_name IN ARRAY p_usernames
        LOOP
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
                    v_return_message := v_return_message || format('User "%s" created. ', v_current_user_name);
                    RAISE NOTICE 'User "%s" created.', v_current_user_name;
                ELSE
                    v_log_status := 'DRY_RUN';
                END IF;
                -- Insert the masked SQL command into the log
                INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                VALUES (
                    'CREATE_USER',
                    v_current_user_name,
                    NULL,
                    v_log_status,
                    REGEXP_REPLACE(v_sql_command, password_mask_pattern, masked_password_string, 'i'), -- Mask here
                    'User creation attempted.' || CASE WHEN v_log_status = 'EXECUTED' THEN ' Password set (not logged).' ELSE '' END
                );
            ELSE
                RAISE NOTICE 'User "%s" already exists.', v_current_user_name;
                v_log_status := 'ALREADY_EXISTS';
                INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                VALUES (
                    'CREATE_USER',
                    v_current_user_name,
                    NULL,
                    v_log_status,
                    NULL, -- No SQL command executed/planned
                    'User already existed, no action taken.'
                );
            END IF;

            IF v_roles_for_user_inheritance IS NOT NULL AND array_length(v_roles_for_user_inheritance, 1) > 0 THEN
                FOREACH v_current_inherit_role IN ARRAY v_roles_for_user_inheritance
                LOOP
                    SELECT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = v_current_inherit_role) INTO v_entity_exists;
                    IF NOT v_entity_exists THEN
                        RAISE WARNING 'Inheritance role "%" for user "%" does not exist. Skipping grant.', v_current_inherit_role, v_current_user_name;
                        INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                        VALUES ('GRANT_MEMBERSHIP', v_current_user_name, v_current_inherit_role, 'SKIPPED', NULL,
                                format('Inheritance role "%s" does not exist for user "%s". Grant skipped.', v_current_inherit_role, v_current_user_name));
                    ELSE
                        SELECT EXISTS (
                            SELECT 1
                            FROM pg_auth_members m
                            JOIN pg_roles r1 ON m.roleid = r1.oid
                            JOIN pg_roles r2 ON m.member = r2.oid
                            WHERE r1.rolname = v_current_inherit_role AND r2.rolname = v_current_user_name
                        ) INTO v_is_member;

                        IF NOT v_is_member THEN
                            v_sql_command := format('GRANT %I TO %I', v_current_inherit_role, v_current_user_name);
                            RAISE NOTICE '[DRY-RUN] Would grant "%" to user "%"', v_current_inherit_role, v_current_user_name;
                            IF p_execute_flag THEN
                                EXECUTE v_sql_command;
                                v_log_status := 'EXECUTED';
                                v_return_message := v_return_message || format('Role "%s" granted to user "%s". ', v_current_inherit_role, v_current_user_name);
                                RAISE NOTICE 'Role "%s" granted to user "%s"', v_current_inherit_role, v_current_user_name;
                            ELSE
                                v_log_status := 'DRY_RUN';
                            END IF;
                            INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                            VALUES ('GRANT_MEMBERSHIP', v_current_user_name, v_current_inherit_role, v_log_status, v_sql_command, 'Grant inheritance role to user attempted.');
                        ELSE
                            RAISE NOTICE 'User "%s" is already a member of "%s"', v_current_user_name, v_current_inherit_role;
                            v_log_status := 'ALREADY_EXISTS';
                            INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                            VALUES ('GRANT_MEMBERSHIP', v_current_user_name, v_current_inherit_role, v_log_status, NULL,
                                    'User already member of inheritance role, no action taken.');
                        END IF;
                    END IF;
                END LOOP;
            END IF;
        END LOOP;
    END IF;

    -- =========================================================
    -- 3. Handle Schema-Level Privilege Application
    -- =========================================================
    IF p_apply_schema_privs_to_roles IS NOT NULL AND array_length(p_apply_schema_privs_to_roles, 1) > 0 THEN
        v_action_performed := TRUE;

        FOREACH v_target_role_for_privs IN ARRAY p_apply_schema_privs_to_roles
        LOOP
            RAISE NOTICE 'Applying schema privileges for target role: "%"', v_target_role_for_privs;

            -- Validate target role for privileges exists
            IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = v_target_role_for_privs) THEN
                RAISE WARNING 'Target role "%" for schema privileges does not exist. Skipping privilege application for this role.', v_target_role_for_privs;
                INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                VALUES ('APPLY_SCHEMA_PRIVS', v_target_role_for_privs, NULL, 'SKIPPED', NULL,
                        format('Target role "%s" for schema privileges does not exist. Skipping.', v_target_role_for_privs));
                CONTINUE; -- Skip to next role in the loop
            END IF;

            FOR s IN
                SELECT nspname, nspowner::regrole::TEXT AS owner_role
                FROM pg_namespace
                WHERE nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast', 'pg_temp_1', 'pg_toast_temp_1')
                  AND nspname NOT LIKE 'pg_temp_%' AND nspname NOT LIKE 'pg_toast_temp_%'
            LOOP
                RAISE NOTICE '  - Processing schema: "%" (Owner: %)', s.nspname, s.owner_role;
                v_return_message := v_return_message || E'\n--- Schema "' || s.nspname || '" ---';

                -- A. Revoke all first (optional)
                IF p_revoke_all_first THEN
                    v_sql_command := format('REVOKE ALL ON ALL TABLES IN SCHEMA %I FROM %I;', s.nspname, v_target_role_for_privs);
                    v_message := format('Attempting to REVOKE ALL on all tables in schema %s from %s.', s.nspname, v_target_role_for_privs);
                    RAISE NOTICE '[DRY-RUN] %', v_sql_command;
                    IF p_execute_flag THEN
                        EXECUTE v_sql_command;
                        v_log_status := 'EXECUTED';
                    ELSE
                        v_log_status := 'DRY_RUN';
                    END IF;
                    INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                    VALUES ('REVOKE_SCHEMA_PRIVS', v_target_role_for_privs, s.nspname, v_log_status, v_sql_command, v_message);
                    v_return_message := v_return_message || E'\n  - ' || v_log_status || ': Revoked existing table privileges.';
                END IF;

                -- B. Grant privileges on all EXISTING tables
                IF p_apply_to_existing_tables AND v_table_privs_str IS NOT NULL THEN
                    v_sql_command := format('GRANT %s ON ALL TABLES IN SCHEMA %I TO %I;', v_table_privs_str, s.nspname, v_target_role_for_privs);
                    v_message := format('Attempting to GRANT %s on all EXISTING tables in schema %s to %s.', v_table_privs_str, s.nspname, v_target_role_for_privs);
                    RAISE NOTICE '[DRY-RUN] %', v_sql_command;
                    IF p_execute_flag THEN
                        EXECUTE v_sql_command;
                        v_log_status := 'EXECUTED';
                    ELSE
                        v_log_status := 'DRY_RUN';
                    END IF;
                    INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                    VALUES ('GRANT_SCHEMA_TABLES', v_target_role_for_privs, s.nspname, v_log_status, v_sql_command, v_message);
                    v_return_message := v_return_message || E'\n  - ' || v_log_status || ': Granted ' || v_table_privs_str || ' on existing tables.';
                END IF;

                -- C. Set default privileges for FUTURE tables
                IF p_set_default_for_future_tables AND v_table_privs_str IS NOT NULL THEN
                    v_sql_command := format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT %s ON TABLES TO %I;', s.owner_role, s.nspname, v_table_privs_str, v_target_role_for_privs);
                    v_message := format('Attempting to set DEFAULT privileges for FUTURE tables (%s) in schema %s (owned by %s) to %s.', v_table_privs_str, s.nspname, s.owner_role, v_target_role_for_privs);
                    RAISE NOTICE '[DRY-RUN] %', v_sql_command;
                    IF p_execute_flag THEN
                        EXECUTE v_sql_command;
                        v_log_status := 'EXECUTED';
                    ELSE
                        v_log_status := 'DRY_RUN';
                    END IF;
                    INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                    VALUES ('ALTER_DEFAULT_TABLES', v_target_role_for_privs, s.nspname, v_log_status, v_sql_command, v_message);
                    v_return_message := v_return_message || E'\n  - ' || v_log_status || ': Set default ' || v_table_privs_str || ' for future tables.';
                END IF;

                -- D. Set default privileges for FUTURE functions
                IF p_set_default_for_future_functions AND v_func_privs_str IS NOT NULL THEN
                    v_sql_command := format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT %s ON FUNCTIONS TO %I;', s.owner_role, s.nspname, v_func_privs_str, v_target_role_for_privs);
                    v_message := format('Attempting to set DEFAULT %s privileges for FUTURE functions in schema %s (owned by %s) to %s.', v_func_privs_str, s.nspname, s.owner_role, v_target_role_for_privs);
                    RAISE NOTICE '[DRY-RUN] %', v_sql_command;
                    IF p_execute_flag THEN
                        EXECUTE v_sql_command;
                        v_log_status := 'EXECUTED';
                    ELSE
                        v_log_status := 'DRY_RUN';
                    END IF;
                    INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                    VALUES ('ALTER_DEFAULT_FUNCS', v_target_role_for_privs, s.nspname, v_log_status, v_sql_command, v_message);
                    v_return_message := v_return_message || E'\n  - ' || v_log_status || ': Set default ' || v_func_privs_str || ' for future functions.';
                END IF;

                -- E. Grant EXECUTE/other on existing functions/procedures
                IF v_func_privs_str IS NOT NULL THEN
                    FOR fn IN
                        SELECT
                            n.nspname AS routine_schema,
                            p.proname AS routine_name,
                            pg_get_function_identity_arguments(p.oid) AS arglist
                        FROM pg_proc p
                        JOIN pg_namespace n ON p.pronamespace = n.oid
                        WHERE n.nspname = s.nspname
                    LOOP
                        BEGIN
                            v_sql_command := format('GRANT %s ON FUNCTION %I.%I(%s) TO %I;', v_func_privs_str, fn.routine_schema, fn.routine_name, fn.arglist, v_target_role_for_privs);
                            v_message := format('Attempting to GRANT %s on existing function %I.%I(%s) to %s.', v_func_privs_str, fn.routine_schema, fn.routine_name, fn.arglist, v_target_role_for_privs);
                            RAISE NOTICE '[DRY-RUN] %', v_sql_command;
                            IF p_execute_flag THEN
                                EXECUTE v_sql_command;
                                v_log_status := 'EXECUTED';
                            ELSE
                                v_log_status := 'DRY_RUN';
                            END IF;
                            INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                            VALUES ('GRANT_EXISTING_FUNC', v_target_role_for_privs, fn.routine_schema || '.' || fn.routine_name || '(' || fn.arglist || ')', v_log_status, v_sql_command, v_message);
                            v_return_message := v_return_message || E'\n  - ' || v_log_status || ': Granted ' || v_func_privs_str || ' on function ' || fn.routine_name || '.';

                        EXCEPTION
                            WHEN OTHERS THEN
                                v_log_status := 'ERROR';
                                v_message := format('Skipped function %I.%I(%s) due to error: %s.', fn.routine_schema, fn.routine_name, fn.arglist, SQLERRM);
                                RAISE NOTICE 'Skipped function %I.%I(%s) due to error: %s', fn.routine_schema, fn.routine_name, fn.arglist, SQLERRM;
                                INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                                VALUES ('GRANT_EXISTING_FUNC', v_target_role_for_privs, fn.routine_schema || '.' || fn.routine_name || '(' || fn.arglist || ')', v_log_status, v_sql_command, v_message);
                                v_return_message := v_return_message || E'\n  - ERROR: Skipped function ' || fn.routine_name || ' due to error.';
                        END;
                    END LOOP;
                END IF;
            END LOOP; -- End schema loop for privilege application
        END LOOP; -- End target role loop for privilege application
    END IF;

    IF NOT v_action_performed THEN
        v_return_message := 'No roles or users specified for creation/modification or privilege application parameters.';
        RAISE NOTICE '%', v_return_message;
    ELSIF v_return_message = '' THEN
        v_return_message := 'All specified roles/users already exist or grants already applied (potentially due to dry-run mode).';
        RAISE NOTICE '%', v_return_message;
    END IF;

    RETURN v_return_message;
END;
$$;