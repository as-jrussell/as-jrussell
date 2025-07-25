set role dbadmin; 

\echo Creating database :set

CREATE DATABASE :"customerdbname"
    WITH OWNER = dbadmin
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TEMPLATE template0;


-- Optional: grant connect + create to common roles
GRANT CONNECT ON DATABASE :"customerdbname" TO db_datareader;
GRANT CONNECT ON DATABASE :"customerdbname" TO db_datawriter;
GRANT CONNECT ON DATABASE :"customerdbname" TO db_ddladmin;
GRANT CONNECT ON DATABASE :"customerdbname" TO db_ddladmin_c;

-- Optional: allow schema creation if needed
GRANT CREATE ON DATABASE :"customerdbname" TO dba_team;
GRANT CREATE ON DATABASE :"customerdbname" TO db_ddladmin;
GRANT CREATE ON DATABASE :"customerdbname" TO db_ddladmin_c;

GRANT ALL ON DATABASE :"customerdbname"  TO dba_team WITH GRANT OPTION;

\connect :"customerdbname"

set role dba_team;

GRANT USAGE ON SCHEMA public TO db_datareader;
-- Connect to the database
GRANT CONNECT ON DATABASE :"customerdbname" TO db_ddladmin_c,db_datareader, db_datawriter, db_ddladmin;

GRANT CREATE ON DATABASE :"customerdbname" TO db_ddladmin_c, db_ddladmin;

-- Basic schema access
GRANT USAGE ON SCHEMA public TO db_ddladmin_c,db_datareader, db_datawriter, db_ddladmin;
GRANT CREATE ON SCHEMA public TO db_ddladmin;

-- Table access
GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_datareader;
GRANT INSERT, UPDATE, DELETE, SELECT ON ALL TABLES IN SCHEMA public TO db_datawriter;
GRANT ALL ON ALL TABLES IN SCHEMA public TO db_ddladmin;

-- Function access (optional)
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_ddladmin_c, db_datareader, db_datawriter, db_ddladmin;

-- For future tables/functions
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO db_datareader;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT INSERT, UPDATE, DELETE, SELECT ON TABLES TO db_datawriter;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL ON TABLES TO db_ddladmin;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL ON TABLES TO db_ddladmin_c;



DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = 'dba') THEN
        EXECUTE 'CREATE SCHEMA dba AUTHORIZATION dba_team';
        RAISE NOTICE 'Schema "dba" created.';
    ELSE
        RAISE NOTICE 'Schema "dba" already exists.';
    END IF;
END
$$;

-- Grant privileges on the 'dba' schema
GRANT USAGE ON SCHEMA dba TO db_datareader;
GRANT SELECT ON ALL TABLES IN SCHEMA dba TO db_datareader;

GRANT USAGE ON SCHEMA dba TO db_ddladmin_c;
GRANT SELECT ON ALL TABLES IN SCHEMA dba TO db_ddladmin_c;

GRANT USAGE ON SCHEMA dba TO db_datawriter;
GRANT SELECT ON ALL TABLES IN SCHEMA dba TO db_datawriter;


GRANT ALL ON ALL TABLES IN SCHEMA dba TO db_ddladmin;

GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA dba TO db_datareader;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA dba TO db_datawriter;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA dba TO db_ddladmin;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA dba TO db_ddladmin_c;


ALTER DEFAULT PRIVILEGES IN SCHEMA dba
GRANT SELECT ON TABLES TO db_datareader;

ALTER DEFAULT PRIVILEGES IN SCHEMA dba
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO db_datawriter;

ALTER DEFAULT PRIVILEGES IN SCHEMA dba
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO db_ddladmin;


SET ROLE db_ddladmin_c;

\echo Creating schema :schemaname

CREATE SCHEMA :"schemaname" AUTHORIZATION db_ddladmin_c;

SET ROLE dba_team;

GRANT USAGE ON SCHEMA :"schemaname" TO db_datareader, db_datawriter, db_ddladmin_c, db_ddladmin;

GRANT CREATE ON SCHEMA  :"schemaname" TO db_ddladmin_c, db_ddladmin;

ALTER DEFAULT PRIVILEGES IN SCHEMA :"schemaname"
GRANT SELECT ON TABLES TO db_datareader;

ALTER DEFAULT PRIVILEGES IN SCHEMA :"schemaname"
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO db_datawriter;

ALTER DEFAULT PRIVILEGES IN SCHEMA :"schemaname"
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO db_ddladmin;

ALTER DEFAULT PRIVILEGES IN SCHEMA :"schemaname"
GRANT SELECT ON TABLES TO db_datareader;
