

DO $$
DECLARE
    rec RECORD;
BEGIN
    -- Loop through each user and drop if exists
    FOR rec IN 
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
        IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = rec.username) THEN
            RAISE NOTICE 'Dropping user: %', rec.username;
            EXECUTE format('DROP ROLE %I', rec.username);
        ELSE
            RAISE NOTICE 'User % does not exist, skipping.', rec.username;
        END IF;
    END LOOP;
END $$;



-- Then, drop the group roles
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'limited_group') THEN
        RAISE NOTICE 'Dropping role: limited_group';
        EXECUTE 'DROP ROLE limited_group';
    END IF;

    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'creator_group') THEN
        RAISE NOTICE 'Dropping role: creator_group';
        EXECUTE 'DROP ROLE creator_group';
    END IF;

    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'super_group') THEN
        RAISE NOTICE 'Dropping role: super_group';
        EXECUTE 'DROP ROLE super_group';
    END IF;
END $$;