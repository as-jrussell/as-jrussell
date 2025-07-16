set role dbadmin; 

\echo Creating database :dbname

CREATE DATABASE :"dbname"
    WITH OWNER = dbadmin
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TEMPLATE template0;


-- Optional: grant connect + create to common roles
GRANT CONNECT ON DATABASE :"dbname" TO db_datareader;
GRANT CONNECT ON DATABASE :"dbname" TO db_datawriter;
GRANT CONNECT ON DATABASE :"dbname" TO db_ddladmin;
GRANT CONNECT ON DATABASE :"dbname" TO db_ddladmin_c;

-- Optional: allow schema creation if needed
GRANT CREATE ON DATABASE :"dbname" TO dba_team;
GRANT CREATE ON DATABASE :"dbname" TO db_ddladmin;
GRANT CREATE ON DATABASE :"dbname" TO db_ddladmin_c;


\connect :"dbname"

set role dba_team;

GRANT USAGE ON SCHEMA public TO db_datareader;
-- Connect to the database
GRANT CONNECT ON DATABASE :"dbname" TO db_ddladmin_c,db_datareader, db_datawriter, db_ddladmin;

-- Basic schema access
GRANT USAGE ON SCHEMA public TO db_ddladmin_c,db_datareader, db_datawriter, db_ddladmin;

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
GRANT ALL ON TABLES TO db_ddladmin_c





\echo Creating schema :schemaname

CREATE SCHEMA :"schemaname" AUTHORIZATION db_ddladmin_c;

-- Example grants
GRANT USAGE ON SCHEMA :"schemaname" TO db_datareader, db_datawriter, db_ddladmin_c, db_ddladmin;




GRANT USAGE ON SCHEMA :"schemaname" TO db_datareader;

ALTER DEFAULT PRIVILEGES IN SCHEMA :"schemaname"
GRANT SELECT ON TABLES TO db_datareader;

ALTER DEFAULT PRIVILEGES IN SCHEMA :"schemaname"
GRANT INSERT, UPDATE, DELETE ON TABLES TO db_datawriter;
