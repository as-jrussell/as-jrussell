DO
$$
DECLARE
    role_name TEXT := 'dba_team';  -- Role to ensure exists
    user_list TEXT[] := ARRAY['hbrotherton', 'acummins', 'lrensberger', 'mbreitsch', 'jrussell'];  -- Add users here
    user_name TEXT;
    execute_flag BOOLEAN := TRUE;  -- FALSE = DRY RUN, TRUE = EXECUTE
BEGIN
    RAISE NOTICE 'Execution mode is %', CASE WHEN execute_flag THEN 'ON (changes will be applied)' ELSE 'OFF (dry-run only)' END;

    -- Step 1: Ensure the main role exists
    IF NOT EXISTS (
        SELECT 1 FROM pg_roles WHERE rolname = role_name
    ) THEN
        RAISE NOTICE '[DRY-RUN] Would create role: %', role_name;
        IF execute_flag THEN
            EXECUTE format('CREATE ROLE %I CREATEROLE CREATEDB NOLOGIN', role_name);
        END IF;
    ELSE
        RAISE NOTICE 'Role % already exists', role_name;
    END IF;

    -- Step 2: Loop through each user
    FOREACH user_name IN ARRAY user_list
    LOOP
        -- Create user if missing
        IF NOT EXISTS (
            SELECT 1 FROM pg_roles WHERE rolname = user_name
        ) THEN
            RAISE NOTICE '[DRY-RUN] Would create user: %', user_name;
            IF execute_flag THEN
                EXECUTE format('CREATE ROLE %I WITH LOGIN PASSWORD %L', user_name, user_name || 'Pass123!');
            END IF;
        ELSE
            RAISE NOTICE 'User % already exists', user_name;
        END IF;

        -- Grant role if not already a member
        IF NOT EXISTS (
            SELECT 1
            FROM pg_auth_members m
            JOIN pg_roles r1 ON m.roleid = r1.oid
            JOIN pg_roles r2 ON m.member = r2.oid
            WHERE r1.rolname = role_name AND r2.rolname = user_name
        ) THEN
            RAISE NOTICE '[DRY-RUN] Would grant % to %', role_name, user_name;
            IF execute_flag THEN
                EXECUTE format('GRANT %I TO %I', role_name, user_name);
            END IF;
        ELSE
            RAISE NOTICE 'User % is already a member of %', user_name, role_name;
        END IF;
    END LOOP;
END
$$ LANGUAGE plpgsql;


GRANT dbadmin TO dba_team;
