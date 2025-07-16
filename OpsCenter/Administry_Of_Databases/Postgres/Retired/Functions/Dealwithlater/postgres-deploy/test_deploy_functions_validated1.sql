
DO $$
BEGIN
    RAISE NOTICE 'Running test: SetCreateUser';
    BEGIN
        -- 🧪 Test: Create users without role inheritance
SELECT deploy.SetCreateUser(
    p_usernames := ARRAY['test_user1', 'test_user2'],
    p_user_password := 'password123',
    p_user_inherit_roles := NULL,
    p_execute_flag := TRUE
);

-- 🧪 Test: Create users with inheritance from existing roles
SELECT deploy.SetCreateUser(
    p_usernames := ARRAY['test_user3'],
    p_user_password := 'password123',
    p_user_inherit_roles := ARRAY['app_reader'],
    p_execute_flag := TRUE
);
        RAISE NOTICE '✅ PASS: SetCreateUser';
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE '❌ FAIL: SetCreateUser - %', SQLERRM;
    END;
END$$;



DO $$
BEGIN
    RAISE NOTICE 'Running test: SetRevokeUser';
    BEGIN
        -- 🧪 Test: Dry-run revocation
SELECT deploy.SetRevokeUser(
    p_usernames := ARRAY['test_user1'],
    p_execute_flag := FALSE
);

-- 🧪 Test: Actual revocation
SELECT deploy.SetRevokeUser(
    p_usernames := ARRAY['test_user1'],
    p_execute_flag := TRUE
);
        RAISE NOTICE '✅ PASS: SetRevokeUser';
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE '❌ FAIL: SetRevokeUser - %', SQLERRM;
    END;
END$$;



DO $$
BEGIN
    RAISE NOTICE 'Running test: SetRolePermissions';
    BEGIN
        -- 🧪 Test: Basic role creation
SELECT deploy.SetRolePermissions(
    p_role_names := ARRAY['app_reader'],
    p_schema_targets := ARRAY['public'],
    p_table_privileges := ARRAY['SELECT'],
    p_function_privileges := ARRAY['EXECUTE'],
    p_apply_to_existing_tables := TRUE,
    p_set_default_for_future_tables := TRUE,
    p_set_default_for_future_functions := TRUE,
    p_revoke_all_first := FALSE,
    p_execute_flag := TRUE
);
        RAISE NOTICE '✅ PASS: SetRolePermissions';
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE '❌ FAIL: SetRolePermissions - %', SQLERRM;
    END;
END$$;



DO $$
BEGIN
    RAISE NOTICE 'Running test: SetRevokeRolePermissions';
    BEGIN
        -- 🧪 Test: Revoke only privileges
SELECT deploy.SetRevokeRolePermissions(
    p_role_names := ARRAY['app_reader'],
    p_schema_targets := ARRAY['public'],
    p_table_privileges := ARRAY['SELECT'],
    p_function_privileges := ARRAY['EXECUTE'],
    p_execute_flag := TRUE,
    p_drop_roles := FALSE
);

-- 🧪 Test: Revoke privileges and drop role
SELECT deploy.SetRevokeRolePermissions(
    p_role_names := ARRAY['app_reader'],
    p_schema_targets := ARRAY['public'],
    p_table_privileges := ARRAY['SELECT'],
    p_function_privileges := ARRAY['EXECUTE'],
    p_execute_flag := TRUE,
    p_drop_roles := TRUE
);
        RAISE NOTICE '✅ PASS: SetRevokeRolePermissions';
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE '❌ FAIL: SetRevokeRolePermissions - %', SQLERRM;
    END;
END$$;



DO $$
BEGIN
    RAISE NOTICE 'Running test: SetAccountSetup';
    BEGIN
        -- 🧪 Test: Full setup with roles, users, inheritance
SELECT deploy.SetAccountSetup(
    p_role_names := ARRAY['app_reader'],
    p_usernames := ARRAY['test_user10'],
    p_user_password := 'testpass',
    p_user_inherit_roles := ARRAY['app_reader'],
    p_apply_schema_privs_to_roles := ARRAY['public'],
    p_table_privileges := ARRAY['SELECT'],
    p_function_privileges := ARRAY['EXECUTE'],
    p_apply_to_existing_tables := TRUE,
    p_set_default_for_future_tables := TRUE,
    p_set_default_for_future_functions := TRUE,
    p_revoke_all_first := FALSE,
    p_execute_flag := TRUE
);
        RAISE NOTICE '✅ PASS: SetAccountSetup';
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE '❌ FAIL: SetAccountSetup - %', SQLERRM;
    END;
END$$;



DO $$
BEGIN
    RAISE NOTICE 'Running test: SetAccountRevoke';
    BEGIN
        -- 🧪 Test: Revoke user and role with dry-run
SELECT deploy.SetAccountRevoke(
    p_usernames := ARRAY['test_user10'],
    p_role_names := ARRAY['app_reader'],
    p_schema_targets := ARRAY['public'],
    p_table_privileges := ARRAY['SELECT'],
    p_function_privileges := ARRAY['EXECUTE'],
    p_execute_flag := FALSE,
    p_drop_roles := FALSE
);

-- 🧪 Test: Full revoke and drop
SELECT deploy.SetAccountRevoke(
    p_usernames := ARRAY['test_user10'],
    p_role_names := ARRAY['app_reader'],
    p_schema_targets := ARRAY['public'],
    p_table_privileges := ARRAY['SELECT'],
    p_function_privileges := ARRAY['EXECUTE'],
    p_execute_flag := TRUE,
    p_drop_roles := TRUE
);
        RAISE NOTICE '✅ PASS: SetAccountRevoke';
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE '❌ FAIL: SetAccountRevoke - %', SQLERRM;
    END;
END$$;
