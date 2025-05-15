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
DO $$ 
BEGIN
    -- Super Group Privileges
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'super_group' AND rolsuper = true) THEN
        RAISE NOTICE 'Granting SUPERUSER, INHERIT, LOGIN to super_group_
