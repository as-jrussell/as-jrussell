DO
$$
DECLARE
    usernames TEXT[] := ARRAY['jruffles', 'user1', 'user2', 'user3', 'user4'];  -- <-- UPDATE THIS ARRAY
    user_name TEXT;
    dryrun BOOLEAN := FALSE;  -- FALSE = DRY RUN, TRUE = EXECUTE
BEGIN
    FOREACH user_name IN ARRAY usernames
    LOOP
        -- Check if user exists and is a login role
        IF EXISTS (
            SELECT 1 FROM pg_roles WHERE rolname = user_name AND rolcanlogin = true
        ) THEN
            -- Check for dependencies
            IF EXISTS (
                SELECT 1
                FROM pg_shdepend d
                JOIN pg_roles r ON r.oid = d.refobjid
                WHERE r.rolname = user_name
            ) THEN
                RAISE NOTICE 'Cannot drop user %: dependencies exist (owns objects or has grants)', user_name;
            ELSE
                IF dryrun THEN
                    RAISE NOTICE 'Dropping user: %', user_name;
                    EXECUTE format('DROP ROLE %I', user_name);
                ELSE
                    RAISE NOTICE '[DRY RUN] Would drop user: %', user_name;
                END IF;
            END IF;
        ELSE
            RAISE NOTICE 'User % does not exist or is not a login role', user_name;
        END IF;
    END LOOP;
END
$$ LANGUAGE plpgsql;
