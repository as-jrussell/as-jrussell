-- Create or replace the parent function to handle full account setup

set role dba_team; 


CREATE OR REPLACE FUNCTION deploy.SetAccountSetup(
    p_role_names TEXT[] DEFAULT NULL,
    p_usernames TEXT[] DEFAULT NULL,
    p_user_password TEXT DEFAULT NULL,
    p_user_inherit_roles TEXT[] DEFAULT NULL,
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
AS $$
/*
-- ===============================
-- EXAMPLE 1: Only Create Roles
-- ===============================
SELECT deploy.SetAccountSetup(
    p_role_names := ARRAY['app_reader', 'app_writer']
);

-- ===============================
-- EXAMPLE 2: Only Create Users
-- ===============================
SELECT deploy.SetAccountSetup(
    p_usernames := ARRAY['johndoe', 'janedoe'],
    p_user_password := 'SuperSecure123!',
    p_user_inherit_roles := ARRAY['app_reader']
);

-- ===============================
-- EXAMPLE 3: Only Apply Permissions
-- ===============================
SELECT deploy.SetAccountSetup(
    p_apply_schema_privs_to_roles := ARRAY['app_reader'],
    p_table_privileges := ARRAY['SELECT'],
    p_function_privileges := ARRAY['EXECUTE'],
    p_apply_to_existing_tables := TRUE,
    p_set_default_for_future_tables := TRUE,
    p_set_default_for_future_functions := TRUE
);

-- ===============================
-- EXAMPLE 4: Create Roles + Apply Permissions (no user)
-- ===============================
SELECT deploy.SetAccountSetup(
    p_role_names := ARRAY['app_reader'],
    p_user_inherit_roles := ARRAY['base_role'],
    p_apply_schema_privs_to_roles := ARRAY['app_reader'],
    p_table_privileges := ARRAY['SELECT'],
    p_execute_flag := TRUE
);

-- ===============================
-- EXAMPLE 5: Create Roles + Users (no permissions)
-- ===============================
SELECT deploy.SetAccountSetup(
    p_role_names := ARRAY['app_writer'],
    p_usernames := ARRAY['service_account'],
    p_user_password := 'pw123!',
    p_user_inherit_roles := ARRAY['app_writer'],
    p_execute_flag := TRUE
);

-- ===============================
-- EXAMPLE 6: Full Setup (Roles + Permissions + Users)
-- ===============================
SELECT deploy.SetAccountSetup(
    p_role_names := ARRAY['db_datareader'],
    p_usernames := ARRAY['alice'],
    p_user_password := 'alice123!',
    p_user_inherit_roles := ARRAY['db_datareader'],
    p_apply_schema_privs_to_roles := ARRAY['db_datareader'],
    p_table_privileges := ARRAY['SELECT'],
    p_function_privileges := ARRAY['EXECUTE'],
    p_apply_to_existing_tables := TRUE,
    p_set_default_for_future_tables := TRUE,
    p_execute_flag := TRUE
);

-- ===============================
-- EXAMPLE 7: Dry Run Preview (Any of the above)
-- ===============================
SELECT deploy.SetAccountSetup(
    p_usernames := ARRAY['dryrun_user'],
    p_user_password := 'notused',
    p_user_inherit_roles := ARRAY['no_inherit'],
    p_execute_flag := FALSE -- DRY RUN!
);
*/
DECLARE
    v_result TEXT := '';
BEGIN
    -- Step 1: Role Creation
    IF p_role_names IS NOT NULL AND array_length(p_role_names, 1) > 0 THEN
        v_result := v_result || deploy.SetRoleCreation(
            p_role_names := p_role_names,
            p_user_inherit_roles := p_user_inherit_roles,
            p_execute_flag := p_execute_flag
        ) || E'\n';
    END IF;

    -- Step 2: Grant Permissions
    IF p_apply_schema_privs_to_roles IS NOT NULL AND (p_table_privileges IS NOT NULL OR p_function_privileges IS NOT NULL) THEN
        v_result := v_result || deploy.SetRolePermissions(
            p_apply_schema_privs_to_roles := p_apply_schema_privs_to_roles,
            p_table_privileges := p_table_privileges,
            p_function_privileges := p_function_privileges,
            p_apply_to_existing_tables := p_apply_to_existing_tables,
            p_set_default_for_future_tables := p_set_default_for_future_tables,
            p_set_default_for_future_functions := p_set_default_for_future_functions,
            p_revoke_all_first := p_revoke_all_first,
            p_execute_flag := p_execute_flag
        ) || E'\n';
    END IF;

    -- Step 3: Create Users
    IF p_usernames IS NOT NULL AND array_length(p_usernames, 1) > 0 THEN
        v_result := v_result || deploy.SetCreateUser(
            p_usernames := p_usernames,
            p_user_password := p_user_password,
            p_user_inherit_roles := p_user_inherit_roles,
            p_execute_flag := p_execute_flag
        ) || E'\n';
    END IF;

    RETURN v_result;
END;
$$;
