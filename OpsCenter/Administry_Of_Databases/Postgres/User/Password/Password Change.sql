DO
$$
DECLARE
    new_password TEXT := 'NewSecurePassword123!';
    execute_flag BOOLEAN := false;  -- FALSE = DRY RUN, TRUE = EXECUTE
    current_user_exists BOOLEAN;
BEGIN
    RAISE NOTICE 'Execution mode is %', CASE WHEN execute_flag THEN 'ON (password will be changed)' ELSE 'OFF (dry-run only)' END;

    -- Check if CURRENT_USER exists in pg_roles (it should unless something's broken)
    SELECT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = CURRENT_USER) INTO current_user_exists;

    IF current_user_exists THEN
        RAISE NOTICE 'Current user "%", exists and is eligible to change their own password.', CURRENT_USER;

        RAISE NOTICE '[%] Would run: ALTER USER CURRENT_USER WITH PASSWORD ''*****''',
                     CASE WHEN execute_flag THEN 'EXECUTE' ELSE 'DRY-RUN' END;

        IF execute_flag THEN
            EXECUTE format('ALTER USER CURRENT_USER WITH PASSWORD %L', new_password);
        END IF;
    ELSE
        RAISE NOTICE 'Somehow, CURRENT_USER % does not exist in pg_roles. This is unexpected.', CURRENT_USER;
    END IF;
END
$$ LANGUAGE plpgsql;
