-- Create databases if not exists
DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'myveryfirstposgressqldb') THEN
      RAISE NOTICE 'Creating database: MyVeryFirstPosgresSQLDB';
      CREATE DATABASE "MyVeryFirstPosgresSQLDB";
   END IF;

   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'two_trees') THEN
      RAISE NOTICE 'Creating database: two_trees';
      CREATE DATABASE "two_trees";
   END IF;
END $$;

-- Create group roles if not exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'super_group') THEN
        RAISE NOTICE 'Creating role: super_group';
        CREATE ROLE super_group;
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'creator_group') THEN
        RAISE NOTICE 'Creating role: creator_group';
        CREATE ROLE creator_group;
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'limited_group') THEN
        RAISE NOTICE 'Creating role: limited_group';
        CREATE ROLE limited_group;
    END IF;
END $$;

-- Create users and assign to groups
DO $$
DECLARE
    u RECORD;
BEGIN
    FOR u IN 
        SELECT * FROM (VALUES 
            ('alice', 'super_group'),
            ('bruce', 'super_group'),
            ('carla', 'super_group'),
            ('davey', 'super_group'),
            ('ellen', 'super_group'),

            ('fritz', 'creator_group'),
            ('grace', 'creator_group'),
            ('hank', 'creator_group'),
            ('ivy', 'creator_group'),
            ('jules', 'creator_group'),

            ('kenny', 'limited_group'),
            ('louis', 'limited_group'),
            ('marta', 'limited_group'),
            ('nolan', 'limited_group'),
            ('olga', 'limited_group')
        ) AS users(username, groupname)
    LOOP
        IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = u.username) THEN
            RAISE NOTICE 'Creating user: %', u.username;
            EXECUTE format(
                'CREATE ROLE %I WITH LOGIN PASSWORD %L', 
                u.username, 'Hello123!'
            );
        ELSE
            RAISE NOTICE 'User already exists: %', u.username;
        END IF;

        -- Grant group membership
        RAISE NOTICE 'Granting % to %', u.groupname, u.username;
        EXECUTE format('GRANT %I TO %I;', u.groupname, u.username);
    END LOOP;
END $$;

-- Assign privileges to groups
-- Grant DB connect privileges
DO $$
BEGIN
    -- Super Group DB Connect Privileges
    IF NOT has_database_privilege('super_group', 'MyVeryFirstPosgresSQLDB', 'CONNECT') THEN
        RAISE NOTICE 'Granting CONNECT on MyVeryFirstPosgresSQLDB to super_group';
        GRANT CONNECT ON DATABASE "MyVeryFirstPosgresSQLDB" TO super_group;
    ELSE
        RAISE NOTICE 'super_group already has CONNECT on MyVeryFirstPosgresSQLDB';
    END IF;

    IF NOT has_database_privilege('super_group', 'two_trees', 'CONNECT') THEN
        RAISE NOTICE 'Granting CONNECT on two_trees to super_group';
        GRANT CONNECT ON DATABASE "two_trees" TO super_group;
    ELSE
        RAISE NOTICE 'super_group already has CONNECT on two_trees';
    END IF;

    IF NOT has_database_privilege('super_group', 'postgres', 'CONNECT') THEN
        RAISE NOTICE 'Granting CONNECT on postgres to super_group';
        GRANT CONNECT ON DATABASE postgres TO super_group;
    ELSE
        RAISE NOTICE 'super_group already has CONNECT on postgres';
    END IF;

    -- Creator Group DB Connect Privileges
    IF NOT has_database_privilege('creator_group', 'MyVeryFirstPosgresSQLDB', 'CONNECT') THEN
        RAISE NOTICE 'Granting CONNECT on MyVeryFirstPosgresSQLDB to creator_group';
        GRANT CONNECT ON DATABASE "MyVeryFirstPosgresSQLDB" TO creator_group;
    ELSE
        RAISE NOTICE 'creator_group already has CONNECT on MyVeryFirstPosgresSQLDB';
    END IF;

    IF NOT has_database_privilege('creator_group', 'two_trees', 'CONNECT') THEN
        RAISE NOTICE 'Granting CONNECT on two_trees to creator_group';
        GRANT CONNECT ON DATABASE "two_trees" TO creator_group;
    ELSE
        RAISE NOTICE 'creator_group already has CONNECT on two_trees';
    END IF;

    -- Limited Group DB Connect Privileges
    IF NOT has_database_privilege('limited_group', 'two_trees', 'CONNECT') THEN
        RAISE NOTICE 'Granting CONNECT on two_trees to limited_group';
        GRANT CONNECT ON DATABASE "two_trees" TO limited_group;
    ELSE
        RAISE NOTICE 'limited_group already has CONNECT on two_trees';
    END IF;
END $$;
