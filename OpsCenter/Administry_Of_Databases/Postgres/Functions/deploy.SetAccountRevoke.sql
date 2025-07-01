-- Create or replace the parent function to handle full account teardown
CREATE OR REPLACE FUNCTION deploy.SetAccountRevoke(
    p_role_names TEXT[] DEFAULT NULL,
    p_usernames TEXT[] DEFAULT NULL,
    p_apply_schema_privs_to_roles TEXT[] DEFAULT NULL,
    p_table_privileges TEXT[] DEFAULT NULL,
    p_function_privileges TEXT[] DEFAULT NULL,
    p_revoke_all_first BOOLEAN DEFAULT FALSE,
    p_execute_flag BOOLEAN DEFAULT FALSE
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
/*
==========================================================
🚫 deploy.SetAccountRevoke() - Example Use Cases
==========================================================

-- 🧼 CLEAN SLATE: Revoke everything — user, role, and permissions
SELECT deploy.SetAccountRevoke(
    p_usernames := ARRAY['temp_user'],
    p_roles := ARRAY['temp_role'],
    p_access_roles := ARRAY['temp_reader', 'temp_writer'],
    p_access_type := 'SELECT',
    p_execute_flag := TRUE
);

-- 🧑‍🚫 USER ONLY: Drop user and their membership grants
SELECT deploy.SetAccountRevoke(
    p_usernames := ARRAY['no_more_user'],
    p_execute_flag := TRUE
);

-- 🧢 ROLES ONLY: Drop role and any role-level privileges
SELECT deploy.SetAccountRevoke(
    p_roles := ARRAY['old_data_role'],
    p_execute_flag := TRUE
);

-- 📉 REVOKE SELECT ONLY: Keep role but remove SELECT access
SELECT deploy.SetAccountRevoke(
    p_access_roles := ARRAY['db_reader'],
    p_access_type := 'SELECT',
    p_execute_flag := TRUE
);

-- 🤖 DRY-RUN TEST: Simulate full revoke process (nothing executed)
SELECT deploy.SetAccountRevoke(
    p_usernames := ARRAY['user1'],
    p_roles := ARRAY['role1'],
    p_access_roles := ARRAY['role1'],
    p_access_type := 'EXECUTE',
    p_execute_flag := FALSE
);

-- 🔥 FULL WIPE MULTI-TARGET: Blow up multiple users + roles + access
SELECT deploy.SetAccountRevoke(
    p_usernames := ARRAY['user1', 'user2'],
    p_roles := ARRAY['role1', 'role2'],
    p_access_roles := ARRAY['role1', 'role2'],
    p_access_type := 'ALL',
    p_execute_flag := TRUE
);
*/

DECLARE
    v_result TEXT := '';
BEGIN
    -- Step 1: Drop Users
    IF p_usernames IS NOT NULL AND array_length(p_usernames, 1) > 0 THEN
        v_result := v_result || deploy.SetDropUser(
            p_usernames := p_usernames,
            p_execute_flag := p_execute_flag
        ) || E'\n';
    END IF;

    -- Step 2: Revoke Permissions
    IF p_apply_schema_privs_to_roles IS NOT NULL AND (p_table_privileges IS NOT NULL OR p_function_privileges IS NOT NULL) THEN
        v_result := v_result || deploy.SetRevokeRolePermissions(
            p_apply_schema_privs_to_roles := p_apply_schema_privs_to_roles,
            p_table_privileges := p_table_privileges,
            p_function_privileges := p_function_privileges,
            p_revoke_all_first := p_revoke_all_first,
            p_execute_flag := p_execute_flag
        ) || E'\n';
    END IF;

    -- Step 3: Drop Roles
    IF p_role_names IS NOT NULL AND array_length(p_role_names, 1) > 0 THEN
        v_result := v_result || deploy.SetRoleDropper(
            p_role_names := p_role_names,
            p_execute_flag := p_execute_flag
        ) || E'\n';
    END IF;

    RETURN v_result;
END;
$$;
