 SET ROLE 'db_owner';

DO $$
DECLARE
    schema_list TEXT[] := ARRAY['customerhub'];
    grantee_list TEXT[] := ARRAY['db_datareader', 'db_datawriter','db_ddladmin' ];
    owner_role TEXT := 'db_owner';
    dry_run BOOLEAN := FALSE;  -- Flip this to FALSE to execute for real

    s TEXT;
    g TEXT;
BEGIN
    RAISE NOTICE '--- BEGIN SCHEMA SETUP ---';
    FOREACH s IN ARRAY schema_list LOOP
        -- Create schema with owner
        IF dry_run THEN
            RAISE NOTICE '[DRY RUN] CREATE SCHEMA IF NOT EXISTS % AUTHORIZATION %', s, owner_role;
        ELSE
            EXECUTE format('CREATE SCHEMA IF NOT EXISTS %I AUTHORIZATION %I', s, owner_role);
        END IF;

        -- Lock down PUBLIC
        IF dry_run THEN
            RAISE NOTICE '[DRY RUN] REVOKE ALL ON SCHEMA % FROM PUBLIC', s;
        ELSE
            EXECUTE format('REVOKE ALL ON SCHEMA %I FROM PUBLIC', s);
        END IF;

        FOREACH g IN ARRAY grantee_list LOOP
            -- Grant schema-level access
            IF dry_run THEN
                RAISE NOTICE '[DRY RUN] GRANT USAGE, CREATE ON SCHEMA % TO %', s, g;
                RAISE NOTICE '[DRY RUN] GRANT RW ON ALL TABLES, EXECUTE ON ALL FUNCTIONS IN SCHEMA % TO %', s, g;
                RAISE NOTICE '[DRY RUN] ALTER DEFAULT PRIVILEGES IN SCHEMA % FOR FUTURE TABLES/FUNCTIONS TO %', s, g;
            ELSE
                EXECUTE format('GRANT USAGE, CREATE ON SCHEMA %I TO %I', s, g);
                EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA %I TO %I', s, g);
                EXECUTE format('GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA %I TO %I', s, g);
                EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO %I', s, g);
                EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT EXECUTE ON FUNCTIONS TO %I', s, g);
            END IF;
        END LOOP;
    END LOOP;
    RAISE NOTICE '--- SCHEMA SETUP COMPLETE ---';
END
$$ LANGUAGE plpgsql;
