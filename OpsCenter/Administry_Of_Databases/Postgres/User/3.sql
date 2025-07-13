IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'info')
BEGIN
    EXEC('CREATE SCHEMA info AUTHORIZATION dba_team');
    PRINT 'Schema "info" created.';
END
ELSE
    PRINT 'Schema "info" already exists.';



-- Default privileges in T-SQL are typically handled through GRANT statements on schema or objects
-- T-SQL does not support ALTER DEFAULT PRIVILEGES, simulate intent via schema GRANTs

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'dba_team')
BEGIN
    -- Grant schema-level permissions
    GRANT SELECT ON SCHEMA::info TO db_datareader;
    GRANT DELETE, INSERT, SELECT, UPDATE ON SCHEMA::info TO db_datawriter;
    GRANT CONTROL ON SCHEMA::info TO db_ddladmin;

    -- Sequences: simulated here as T-SQL does not have sequence-level grants per schema
    PRINT 'Note: Sequence-level permissions must be handled per object in T-SQL.';

    -- Functions
    GRANT EXECUTE ON SCHEMA::info TO db_datareader;
    GRANT EXECUTE ON SCHEMA::info TO db_datawriter;
    GRANT EXECUTE ON SCHEMA::info TO db_ddladmin;
END
ELSE
    PRINT 'Role "dba_team" does not exist. Default privileges not applied.';



IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'deploy')
BEGIN
    EXEC('CREATE SCHEMA deploy AUTHORIZATION dba_team');
    PRINT 'Schema "deploy" created.';
END
ELSE
    PRINT 'Schema "deploy" already exists.';



IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'dba_team')
BEGIN
    GRANT CONTROL ON SCHEMA::deploy TO dba_team;
    GRANT INSERT, SELECT, UPDATE ON SCHEMA::deploy TO dba_team;
    GRANT EXECUTE ON SCHEMA::deploy TO dba_team;
END
ELSE
    PRINT 'Role "dba_team" does not exist. Deploy privileges not applied.';

