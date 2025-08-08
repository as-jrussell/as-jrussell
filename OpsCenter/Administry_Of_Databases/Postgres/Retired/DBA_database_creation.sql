
-- ============================================
-- Script: DBA_database_creation.sql
-- Purpose: Create the 'DBA' database using template0
-- ============================================


set role dbadmin;

-- Set default db name (can override with -v dbaname=whatever)
\if :{?dbname}
\else
\set dbname DBA
\endif

\echo Executing:
\echo CREATE DATABASE :dbname
\echo     WITH OWNER = dbadmin
\echo     TEMPLATE = template0
\echo     ENCODING = 'UTF8'
\echo     LC_COLLATE = 'en_US.UTF-8'
\echo     LC_CTYPE = 'en_US.UTF-8'
\echo     CONNECTION LIMIT = -1;

-- Drop if exists (optional)
-- DROP DATABASE IF EXISTS :dbaname;

-- Direct CREATE DATABASE
CREATE DATABASE :dbname
    WITH OWNER =  dbadmin
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    CONNECTION LIMIT = -1;
	

GRANT TEMPORARY, CONNECT ON DATABASE :dbname  TO PUBLIC;

GRANT ALL ON DATABASE :dbname  TO dba_team WITH GRANT OPTION;

GRANT ALL ON DATABASE :dbname TO dbadmin;


GRANT CREATE ON DATABASE :dbname TO dba_team;



