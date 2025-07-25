-- Database-level permissions
GRANT TEMPORARY, CONNECT ON DATABASE :"customerdbname" TO PUBLIC;
GRANT CONNECT ON DATABASE :"customerdbname" TO db_datareader;
GRANT CONNECT ON DATABASE :"customerdbname" TO db_datawriter;
GRANT CREATE, CONNECT ON DATABASE :"customerdbname" TO db_ddladmin;
GRANT CREATE, CONNECT ON DATABASE :"customerdbname" TO db_ddladmin_c;
GRANT CREATE, CONNECT ON DATABASE :"customerdbname" TO dba_team;
GRANT ALL ON DATABASE :"customerdbname" TO dbadmin;

-- Schema-level permissions for every non-system schema
DO $$
DECLARE
  schema_record RECORD;
BEGIN
  FOR schema_record IN
    SELECT schema_name
    FROM information_schema.schemata
    WHERE schema_name NOT IN (
      'public', 'information_schema', 'pg_catalog', 'pg_toast','dba'
    )
  LOOP
    RAISE NOTICE 'Applying grants to schema % in database %', schema_record.schema_name, current_database();

    EXECUTE format('GRANT USAGE ON SCHEMA %I TO db_datareader', schema_record.schema_name);
    EXECUTE format('GRANT USAGE ON SCHEMA %I TO db_datawriter', schema_record.schema_name);
    EXECUTE format('GRANT ALL ON SCHEMA %I TO db_ddladmin', schema_record.schema_name);
    EXECUTE format('GRANT ALL ON SCHEMA %I TO db_ddladmin_c', schema_record.schema_name);

    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE dba_team IN SCHEMA %I GRANT SELECT ON TABLES TO db_datareader', schema_record.schema_name);
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE dba_team IN SCHEMA %I GRANT DELETE, INSERT, UPDATE ON TABLES TO db_datawriter', schema_record.schema_name);
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE dba_team IN SCHEMA %I GRANT ALL ON TABLES TO db_ddladmin_c', schema_record.schema_name);
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE dba_team IN SCHEMA %I GRANT EXECUTE ON FUNCTIONS TO db_ddladmin_c', schema_record.schema_name);
  END LOOP;
END
$$;



REVOKE ALL ON SCHEMA dba FROM db_ddladmin_c;
ALTER DEFAULT PRIVILEGES FOR ROLE dba_team IN SCHEMA dba REVOKE INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES FROM db_ddladmin_c;
GRANT USAGE ON SCHEMA dba to db_ddladmin_c;



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