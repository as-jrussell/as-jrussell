-- ✅ PostgreSQL-Compatible Schema Creation Script
-- Filename: 03_Schema_creation.sql

-- ============================================================
-- STEP 1: Create 'info' schema if not exists and grant privileges
-- ============================================================
set role dba_team; 

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = 'info') THEN
        EXECUTE 'CREATE SCHEMA info AUTHORIZATION dba_team';
        RAISE NOTICE 'Schema "info" created.';
    ELSE
        RAISE NOTICE 'Schema "info" already exists.';
    END IF;
END
$$;

-- Grant privileges on the 'info' schema
GRANT USAGE ON SCHEMA info TO db_datareader;
GRANT USAGE ON SCHEMA info TO db_datawriter;
GRANT USAGE ON SCHEMA info TO db_ddladmin;




GRANT SELECT ON ALL TABLES IN SCHEMA info TO db_datareader;
GRANT DELETE, INSERT, SELECT, UPDATE ON ALL TABLES IN SCHEMA info TO db_datawriter;
GRANT ALL ON ALL TABLES IN SCHEMA info TO db_ddladmin;

GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA info TO db_datareader;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA info TO db_datawriter;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA info TO db_ddladmin;

-- ============================================================
-- STEP 2: Create 'deploy' schema if not exists and grant privileges
-- ============================================================

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = 'deploy') THEN
        EXECUTE 'CREATE SCHEMA deploy AUTHORIZATION dba_team';
        RAISE NOTICE 'Schema "deploy" created.';
    ELSE
        RAISE NOTICE 'Schema "deploy" already exists.';
    END IF;
END
$$;

-- Grant privileges on the 'deploy' schema
GRANT USAGE ON SCHEMA deploy TO dba_team;
GRANT INSERT, SELECT, UPDATE ON ALL TABLES IN SCHEMA deploy TO dba_team;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA deploy TO dba_team;
REVOKE ALL ON SCHEMA deploy FROM PUBLIC;




CREATE SCHEMA IF NOT EXISTS admin AUTHORIZATION dba_team;


-- Grant access to expected roles
GRANT USAGE ON SCHEMA admin TO dba_team;
GRANT INSERT, SELECT, UPDATE ON ALL TABLES IN SCHEMA admin TO dba_team;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA admin TO dba_team;
REVOKE ALL ON SCHEMA admin FROM PUBLIC;

