DO
$$
DECLARE
    target_user TEXT := 'bob';  -- Replace with actual user
    new_password TEXT := 'NewSecurePassword123!';
    execute_flag BOOLEAN := false;  -- FALSE = DRY RUN, TRUE = EXECUTE
BEGIN
    RAISE NOTICE 'Execution mode is %', CASE WHEN execute_flag THEN 'ON (password will be changed)' ELSE 'OFF (dry-run only)' END;

    -- Step 1: Verify target user exists
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = target_user) THEN
        RAISE NOTICE '% user exists and is ready for password update.', target_user;

        RAISE NOTICE '[%] Would run: ALTER ROLE %s WITH PASSWORD ''*****''', 
                     CASE WHEN execute_flag THEN 'EXECUTE' ELSE 'DRY-RUN' END, target_user;

        IF execute_flag THEN
            EXECUTE format('ALTER ROLE %I WITH PASSWORD %L', target_user, new_password);
        END IF;
    ELSE
        RAISE NOTICE 'User % does not exist. Skipping password change.', target_user;
    END IF;
END
$$ LANGUAGE plpgsql;
