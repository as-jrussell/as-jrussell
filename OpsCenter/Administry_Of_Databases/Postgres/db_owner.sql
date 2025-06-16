-- STEP 1: Create the Role
CREATE ROLE db_owner;

-- STEP 2: Grant Database-Level Privileges
GRANT CONNECT, TEMPORARY, CREATE ON DATABASE customerdb TO db_owner;



-- STEP 4: Grant Full Access on All Schemas (except system ones)
DO $$
DECLARE
    r TEXT := 'db_owner';
    s TEXT;
BEGIN
    FOR s IN
        SELECT nspname
        FROM pg_namespace
        WHERE nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    LOOP
        EXECUTE format('GRANT USAGE, CREATE ON SCHEMA %I TO %I', s, r);
        EXECUTE format('GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA %I TO %I', s, r);
        EXECUTE format('GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA %I TO %I', s, r);
        EXECUTE format('GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA %I TO %I', s, r);
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT ALL ON TABLES TO %I', s, r);
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT ALL ON SEQUENCES TO %I', s, r);
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT EXECUTE ON FUNCTIONS TO %I', s, r);
    END LOOP;
END
$$ LANGUAGE plpgsql;
