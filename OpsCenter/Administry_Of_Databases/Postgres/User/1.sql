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
