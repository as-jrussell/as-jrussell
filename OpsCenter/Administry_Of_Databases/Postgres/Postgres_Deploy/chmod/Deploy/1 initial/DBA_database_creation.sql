
-- ============================================
-- Script: DBA_database_creation.sql
-- Purpose: Create the 'DBA' database using template0
-- ============================================
set role dbadmin;

set role dbadmin;

-- Set default db name.
-- We now set the variable to a string that includes the double quotes.
\if :{?dbname}
    -- User provided a name, assume it's already quoted or correctly capitalized
    -- and we will pass it through.
    \echo Using user-provided database name: :dbname
\else
    -- Default to "DBA" by setting the variable to the quoted string.
    \set dbname '"DBA"'
    \echo Using default database name: :dbname
\endif


-- Confirm variable
\echo Final database name: :dbname

-- Use the variable directly. It already contains the necessary quotes.
CREATE DATABASE :dbname
    WITH OWNER = dbadmin
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    CONNECTION LIMIT = -1;


GRANT TEMPORARY, CONNECT ON DATABASE :dbname TO PUBLIC;

GRANT ALL ON DATABASE :dbname  TO dba_team WITH GRANT OPTION;

GRANT ALL ON DATABASE :dbname TO dbadmin;


GRANT CREATE ON DATABASE :dbname TO dba_team;