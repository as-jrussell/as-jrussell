-- =============================================
-- 01_full_env_setup_inlined.sql (With Validation Notices)
-- PURPOSE: Full setup with PASS/FAIL messages for each step
-- =============================================

-- ðŸ”¹ 01 CreateAccounts (from 1.sql)
-- -------------------------------------------------------------
DO $$
BEGIN
    RAISE NOTICE 'â–¶ STARTING STEP: 01 CreateAccounts';
-- Create role db_ddladmin if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'db_ddladmin') THEN
        CREATE ROLE db_ddladmin 
        WITH NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOLOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
        RAISE NOTICE 'Role "db_ddladmin" created.';
    ELSE
        RAISE NOTICE 'Role "db_ddladmin" already exists.';
    END IF;
END
$$;

-- Create role db_datawriter if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'db_datawriter') THEN
        CREATE ROLE db_datawriter 
        WITH NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOLOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
        RAISE NOTICE 'Role "db_datawriter" created.';
    ELSE
        RAISE NOTICE 'Role "db_datawriter" already exists.';
    END IF;
END
$$;

-- Create role db_datareader if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'db_datareader') THEN
        CREATE ROLE db_datareader 
        WITH NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOLOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
        RAISE NOTICE 'Role "db_datareader" created.';
    ELSE
        RAISE NOTICE 'Role "db_datareader" already exists.';
    END IF;
END
$$;

-- Create role dba_team if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'dba_team') THEN
        CREATE ROLE dba_team 
        WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT NOLOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
        RAISE NOTICE 'Role "dba_team" created.';
    ELSE
        RAISE NOTICE 'Role "dba_team" already exists.';
    END IF;
END
$$;


-- Grant db_datawriter to dba_team if both roles exist and grant not already applied
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'db_datawriter')
       AND EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'dba_team')
       AND NOT EXISTS (
           SELECT 1 
           FROM pg_auth_members 
           WHERE roleid = (SELECT oid FROM pg_roles WHERE rolname = 'db_datawriter')
             AND member = (SELECT oid FROM pg_roles WHERE rolname = 'dba_team')
       ) THEN
        GRANT db_datawriter TO dba_team;
        RAISE NOTICE 'Granted db_datawriter to dba_team.';
    ELSE
        RAISE NOTICE 'Grant db_datawriter to dba_team already exists or roles missing.';
    END IF;
END
$$;

-- Grant db_ddladmin to dba_team
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'db_ddladmin')
       AND EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'dba_team')
       AND NOT EXISTS (
           SELECT 1 
           FROM pg_auth_members 
           WHERE roleid = (SELECT oid FROM pg_roles WHERE rolname = 'db_ddladmin')
             AND member = (SELECT oid FROM pg_roles WHERE rolname = 'dba_team')
       ) THEN
        GRANT db_ddladmin TO dba_team;
        RAISE NOTICE 'Granted db_ddladmin to dba_team.';
    ELSE
        RAISE NOTICE 'Grant db_ddladmin to dba_team already exists or roles missing.';
    END IF;
END
$$;

-- Grant db_datareader to dba_team
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'db_datareader')
       AND EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'dba_team')
       AND NOT EXISTS (
           SELECT 1 
           FROM pg_auth_members 
           WHERE roleid = (SELECT oid FROM pg_roles WHERE rolname = 'db_datareader')
             AND member = (SELECT oid FROM pg_roles WHERE rolname = 'dba_team')
       ) THEN
        GRANT db_datareader TO dba_team;
        RAISE NOTICE 'Granted db_datareader to dba_team.';
    ELSE
        RAISE NOTICE 'Grant db_datareader to dba_team already exists or roles missing.';
    END IF;
END
$$;
    RAISE NOTICE 'âœ… PASS: 01 CreateAccounts';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'âŒ FAIL: 01 CreateAccounts - %', SQLERRM;
END $$;

-- ðŸ”¹ 02 CreateDatabase (from 2.sql)
-- -------------------------------------------------------------
DO $$
BEGIN
    RAISE NOTICE 'â–¶ STARTING STEP: 02 CreateDatabase';
CREATE DATABASE "DBA"
    WITH
    OWNER = dbadmin
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	

GRANT TEMPORARY, CONNECT ON DATABASE "DBA" TO PUBLIC;

GRANT ALL ON DATABASE "DBA" TO dba_team WITH GRANT OPTION;

GRANT ALL ON DATABASE "DBA" TO dbadmin;
    RAISE NOTICE 'âœ… PASS: 02 CreateDatabase';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'âŒ FAIL: 02 CreateDatabase - %', SQLERRM;
END $$;

-- ðŸ”¹ 03 DelegatePermissions (from 3.sql)
-- -------------------------------------------------------------
DO $$
BEGIN
    RAISE NOTICE 'â–¶ STARTING STEP: 03 DelegatePermissions';
DO $$ BEGIN IF NOT EXISTS (SELECT * FROM information_schema.schemata WHERE name = 'info') THEN
    EXEC('CREATE SCHEMA info AUTHORIZATION dba_team');
    RAISE NOTICE 'Schema "info" created.';
END
ELSE
    RAISE NOTICE 'Schema "info" already exists.';
-- Default privileges in T-SQL are typically handled through GRANT statements on schema or objects
-- T-SQL does not support ALTER DEFAULT PRIVILEGES, simulate intent via schema GRANTs

DO $$ BEGIN IF EXISTS (SELECT * FROM pg_roles WHERE name = 'dba_team') THEN
    -- Grant schema-level permissions
    GRANT SELECT ON info TO db_datareader;
    GRANT DELETE, INSERT, SELECT, UPDATE ON info TO db_datawriter;
    GRANT CONTROL ON info TO db_ddladmin;

    -- Sequences: simulated here as T-SQL does not have sequence-level grants per schema
    RAISE NOTICE 'Note: Sequence-level permissions must be handled per object in T-SQL.';
-- Functions
    GRANT EXECUTE ON info TO db_datareader;
    GRANT EXECUTE ON info TO db_datawriter;
    GRANT EXECUTE ON info TO db_ddladmin;
END
ELSE
    RAISE NOTICE 'Role "dba_team" does not exist. Default privileges not applied.';
DO $$ BEGIN IF NOT EXISTS (SELECT * FROM information_schema.schemata WHERE name = 'deploy') THEN
    EXEC('CREATE SCHEMA deploy AUTHORIZATION dba_team');
    RAISE NOTICE 'Schema "deploy" created.';
END
ELSE
    RAISE NOTICE 'Schema "deploy" already exists.';
DO $$ BEGIN IF EXISTS (SELECT * FROM pg_roles WHERE name = 'dba_team') THEN
    GRANT CONTROL ON deploy TO dba_team;
    GRANT INSERT, SELECT, UPDATE ON deploy TO dba_team;
    GRANT EXECUTE ON deploy TO dba_team;
END
ELSE
    RAISE NOTICE 'Role "dba_team" does not exist. Deploy privileges not applied.';
RAISE NOTICE 'âœ… PASS: 03 DelegatePermissions';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'âŒ FAIL: 03 DelegatePermissions - %', SQLERRM;
END $$;

-- ðŸ”¹ 04 CreateTables (from 4.sql)
-- -------------------------------------------------------------
DO $$
BEGIN
    RAISE NOTICE 'â–¶ STARTING STEP: 04 CreateTables';
-- ================================================================
-- Create: info.account_log_history with auto-incrementing log_id
-- ================================================================

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'info' AND table_name = 'account_log_history'
    ) THEN
        EXECUTE '
CREATE SEQUENCE IF NOT EXISTS info.account_log_history_log_id_seq
    START WITH 1
    INCREMENT BY 1;
	

-- Step 2: Create the table with DEFAULT log_id from sequence
CREATE TABLE IF NOT EXISTS info.account_log_history (
    log_id INTEGER NOT NULL DEFAULT nextval(''info.account_log_history_log_id_seq''),
    log_timestamp TIMESTAMPTZ DEFAULT now(),
    action_type TEXT COLLATE pg_catalog."default" NOT NULL,
    target_entity TEXT COLLATE pg_catalog."default" NOT NULL,
    associated_entity TEXT COLLATE pg_catalog."default",
    status TEXT COLLATE pg_catalog."default" NOT NULL,
    sql_command TEXT COLLATE pg_catalog."default",
    message TEXT COLLATE pg_catalog."default",
    CONSTRAINT account_log_history_pkey PRIMARY KEY (log_id)
)
TABLESPACE pg_default;


-- Step 3: Attach sequence ownership to table column
ALTER SEQUENCE info.account_log_history_log_id_seq
OWNED BY info.account_log_history.log_id;


		ALTER TABLE IF EXISTS info.account_log_history
    OWNER to dba_team;
	
GRANT SELECT ON TABLE info.account_log_history TO db_datareader;
GRANT ALL ON TABLE info.account_log_history TO db_ddladmin;
GRANT ALL ON TABLE info.account_log_history TO dba_team;


	
        ';
        RAISE NOTICE 'Table "info.account_log_history" created.';
    ELSE
        RAISE NOTICE 'Table "info.account_log_history" already exists.';
    END IF;
END
$$;


DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'info' AND table_name = 'object_log_history'
    ) THEN
        EXECUTE '
           CREATE TABLE IF NOT EXISTS info.object_log_history (
    log_id SERIAL PRIMARY KEY,
    log_timestamp TIMESTAMPTZ DEFAULT now(),
    action_type TEXT NOT NULL,                  -- e.g., CREATE_DATABASE, GRANT_DB_CONNECT
    target_entity TEXT NOT NULL,                -- The main object being acted on (e.g., db name, role)
    associated_entity TEXT,                     -- Optional: who/what is associated (e.g., role granted, owner)
    status TEXT NOT NULL,                       -- e.g., EXECUTED, DRY_RUN, ALREADY_EXISTS
    sql_command TEXT,                           -- The SQL that was (or would have been) run
    message TEXT                                 -- Human-friendly description of the action
);


		ALTER TABLE IF EXISTS info.object_log_history
    OWNER to dba_team;

GRANT ALL ON TABLE info.object_log_history FROM db_datareader;

GRANT SELECT ON TABLE info.object_log_history TO db_datareader;

GRANT ALL ON TABLE info.object_log_history TO dba_team;
	
        ';
        RAISE NOTICE 'Table "info.object_log_history" created.';
    ELSE
        RAISE NOTICE 'Table "info.object_log_history" already exists.';
    END IF;
END
$$;
    RAISE NOTICE 'âœ… PASS: 04 CreateTables';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'âŒ FAIL: 04 CreateTables - %', SQLERRM;
END $$;

