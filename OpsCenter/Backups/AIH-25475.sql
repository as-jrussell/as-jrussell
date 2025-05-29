USE ROLE ACCOUNTADMIN;
---Create me an role
DECLARE ROLE_NAME varchar default (select count(*) from snowflake.account_usage.roles where NAME = 'JIRA_PROD_USERS'AND DELETED_ON IS NULL) ;
BEGIN 
IF (ROLE_NAME = 0)
THEN 
BEGIN
CREATE ROLE JIRA_PROD_USERS;
GRANT ROLE IDENTIFIER('"JIRA_PROD_USERS"') TO ROLE IDENTIFIER('"SYSADMIN"');
RETURN 'SUCCESS: Role created';
END ;
ELSEIF (ROLE_NAME <> 0)
THEN 
BEGIN 
RETURN 'WARNING: Role exists';
END;
END IF;
END;


USE ROLE ACCOUNTADMIN;
---We need users
create USER IDENTIFIER('"JIRA_EXPORTS_PRD"') COMMENT = '' PASSWORD = '??????????????' MUST_CHANGE_PASSWORD = false LOGIN_NAME = '' 
FIRST_NAME = '' LAST_NAME = '' DISPLAY_NAME = '' EMAIL = '' 
DEFAULT_WAREHOUSE = 'JIRA_EXPORT_XS_WH' DEFAULT_NAMESPACE = '' DEFAULT_ROLE = 'JIRA_PROD_USERS'

GRANT ROLE IDENTIFIER('"JIRA_PROD_USERS"') TO USER IDENTIFIER('"JIRA_EXPORTS_PRD"')




create USER IDENTIFIER('"JIRAEXPORTS_POWERBI_PRD"') COMMENT = '' PASSWORD = '??????????????' MUST_CHANGE_PASSWORD = false LOGIN_NAME = '' 
FIRST_NAME = '' LAST_NAME = '' DISPLAY_NAME = '' EMAIL = '' 
DEFAULT_WAREHOUSE = 'JIRA_EXPORT_XS_WH' DEFAULT_NAMESPACE = '' DEFAULT_ROLE = 'JIRA_PROD_USERS'

GRANT ROLE IDENTIFIER('"JIRA_PROD_USERS"') TO USER IDENTIFIER('"JIRAEXPORTS_POWERBI_PRD"')




---Let's create a Warehouse
USE ROLE SYSADMIN;
DECLARE WAREHOUSE_NAME varchar default (select count(*) FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES GU WHERE name = 'JIRA_EXPORT_XS_WH' and granted_on = 'WAREHOUSE'and deleted_on is null) ;
BEGIN 
IF (WAREHOUSE_NAME = 0)
THEN 
BEGIN
CREATE WAREHOUSE JIRA_EXPORT_XS_WH WAREHOUSE_SIZE=LARGE INITIALLY_SUSPENDED=X-Small;
RETURN 'SUCCESS: Warehouse created';
END ;
ELSEIF (WAREHOUSE_NAME <> 0)
THEN 
BEGIN 
RETURN 'WARNING: Warehouse exists';
END;
END IF;
END;

GRANT USAGE ON WAREHOUSE JIRA_EXPORT_XS_WH  TO ROLE JIRA_PROD_USERS;

--I am going to need a DB
USE ROLE JIRA_PROD_USERS;
DECLARE DATABASE_NAME varchar default (select count(*) from snowflake.account_usage.databases where database_name = 'JIRA_EXPORTS' AND DELETED IS NULL) ;
BEGIN 
IF (DATABASE_NAME = 0)
THEN 
BEGIN
CREATE DATABASE JIRA_EXPORTS;
RETURN 'SUCCESS: Database created';
END ;
ELSEIF (DATABASE_NAME <> 0)
THEN 
BEGIN 
RETURN 'WARNING: Database exists';
END;
END IF;
END;

GRANT USAGE ON DATABASE JIRA_EXPORTS TO ROLE JIRA_PROD_USERS;
GRANT USAGE ON ALL SCHEMA JIRA_EXPORTS TO ROLE JIRA_PROD_USERS;


USE ROLE JIRA_PROD_USERS
USE DATABASE JIRA_EXPORTS;
DECLARE SCHEMA_NAME varchar default (select count(*) from snowflake.account_usage.schemata where CATALOG_NAME = 'JIRA_EXPORTS'AND SCHEMA_NAME = 'DBA' AND DELETED IS NULL) ;
BEGIN 
IF (SCHEMA_NAME = 0)
THEN 
BEGIN
CREATE SCHEMA DBA;
RETURN 'SUCCESS: Schema created';
END ;
ELSEIF (SCHEMA_NAME <> 0)
THEN 
BEGIN 
RETURN 'WARNING: Schema exists';
END;
END IF;
END;




use role JIRA_PROD_USERS;
USE DATABASE JIRA_EXPORTS;

CREATE OR REPLACE PROCEDURE DBA.TABLESMODIFIED(
  WHATIF VARCHAR(16777216) 
)
RETURNS TABLE (
  "DATABASE_NAME" VARCHAR(16777216),
  "TABLE_SCHEMA" VARCHAR(16777216),
  "TABLE_NAME" VARCHAR(16777216),
  "USER_NAME" VARCHAR(16777216),
  "ROLE_NAME" VARCHAR(16777216),
  "QUERY_TYPE" VARCHAR(16777216),
  "EXECUTION_STATUS" VARCHAR(16777216)
)
LANGUAGE SQL
EXECUTE AS OWNER
AS
'
BEGIN
  IF (WHATIF = ''ADMIN'') THEN 
    DECLARE RES RESULTSET DEFAULT (
      SELECT DISTINCT h.database_name,
        h.schema_name,
        t.table_name,
        h.user_name,
        h.role_name,
        h.query_type,
        h.execution_status
      FROM snowflake.account_usage.query_history h
      LEFT JOIN snowflake.account_usage.users u ON u.name = h.user_name AND u.disabled = FALSE AND u.deleted_on IS NULL
      LEFT OUTER JOIN information_schema.tables t ON t.created = h.start_time
      WHERE execution_status = ''SUCCESS''
        AND CAST(h.start_time AS DATE) = CAST(current_date() AS DATE)
        AND QUERY_TYPE IN (
          ''REVOKE'',
          ''CREATE_VIEW'',
          ''UPDATE'',
          ''RENAME_TABLE'',
          ''CREATE_CONSTRAINT'',
          ''INSERT'',
          ''ALTER_TABLE_ADD_COLUMN'',
          ''RENAME_COLUMN'',
          ''BEGIN_TRANSACTION'',
          ''MERGE'',
          ''RESTORE'',
          ''DELETE'',
          ''ALTER_SESSION'',
          ''COMMIT'',
          ''RENAME_VIEW'',
          ''CREATE_TABLE'',
          ''ALTER_NETWORK_POLICY'',
          ''ALTER_TABLE_MODIFY_COLUMN'',
          ''TRUNCATE_TABLE'',
          ''DROP'',
          ''ALTER_TABLE_DROP_COLUMN'',
          ''REMOVE_FILES'',
          ''CREATE_TABLE_AS_SELECT'',
          ''CREATE'',
          ''CREATE_SEQUENCE''
        )
    );
    BEGIN
      RETURN TABLE(RES);
    END;
ELSEIF (WHATIF IN (SELECT DATABASE_NAME FROM SNOWFLAKE.ACCOUNT_USAGE.DATABASES )) THEN 
    DECLARE
    WHATIF varchar default WHATIF;

    RES RESULTSET DEFAULT (
      SELECT DISTINCT h.database_name,
        h.schema_name,
        t.table_name,
        h.user_name,
        h.role_name,
        h.query_type,
        h.execution_status
      FROM snowflake.account_usage.query_history h
      LEFT JOIN snowflake.account_usage.users u ON u.name = h.user_name AND u.disabled = FALSE AND u.deleted_on IS NULL
      LEFT OUTER JOIN information_schema.tables t ON t.created = h.start_time
      WHERE execution_status = ''SUCCESS''
        AND CAST(h.start_time AS DATE) = CAST(current_date() AS DATE)
        AND QUERY_TYPE IN (
          ''REVOKE'',
          ''CREATE_VIEW'',
          ''UPDATE'',
          ''RENAME_TABLE'',
          ''CREATE_CONSTRAINT'',
          ''INSERT'',
          ''ALTER_TABLE_ADD_COLUMN'',
          ''RENAME_COLUMN'',
          ''BEGIN_TRANSACTION'',
          ''MERGE'',
          ''RESTORE'',
          ''DELETE'',
          ''ALTER_SESSION'',
          ''COMMIT'',
          ''RENAME_VIEW'',
          ''CREATE_TABLE'',
          ''ALTER_NETWORK_POLICY'',
          ''ALTER_TABLE_MODIFY_COLUMN'',
          ''TRUNCATE_TABLE'',
          ''DROP'',
          ''ALTER_TABLE_DROP_COLUMN'',
          ''REMOVE_FILES'',
          ''CREATE_TABLE_AS_SELECT'',
          ''CREATE'',
          ''CREATE_SEQUENCE''
        )
        AND h.database_name =   :WHATIF 
    );
    BEGIN
      RETURN TABLE(RES);
    END;
ELSEIF (WHATIF IN (SELECT LOGIN_NAME FROM SNOWFLAKE.ACCOUNT_USAGE.USERS) ) THEN 
    DECLARE
    WHATIF varchar default WHATIF;

    RES RESULTSET DEFAULT (
      SELECT DISTINCT h.database_name,
        h.schema_name,
        t.table_name,
        h.user_name,
        h.role_name,
        h.query_type,
        h.execution_status
      FROM snowflake.account_usage.query_history h
      LEFT JOIN snowflake.account_usage.users u ON u.name = h.user_name AND u.disabled = FALSE AND u.deleted_on IS NULL
      LEFT OUTER JOIN information_schema.tables t ON t.created = h.start_time
      WHERE execution_status = ''SUCCESS''
        AND CAST(h.start_time AS DATE) = CAST(current_date() AS DATE)
        AND QUERY_TYPE IN (
          ''REVOKE'',
          ''CREATE_VIEW'',
          ''UPDATE'',
          ''RENAME_TABLE'',
          ''CREATE_CONSTRAINT'',
          ''INSERT'',
          ''ALTER_TABLE_ADD_COLUMN'',
          ''RENAME_COLUMN'',
          ''BEGIN_TRANSACTION'',
          ''MERGE'',
          ''RESTORE'',
          ''DELETE'',
          ''ALTER_SESSION'',
          ''COMMIT'',
          ''RENAME_VIEW'',
          ''CREATE_TABLE'',
          ''ALTER_NETWORK_POLICY'',
          ''ALTER_TABLE_MODIFY_COLUMN'',
          ''TRUNCATE_TABLE'',
          ''DROP'',
          ''ALTER_TABLE_DROP_COLUMN'',
          ''REMOVE_FILES'',
          ''CREATE_TABLE_AS_SELECT'',
          ''CREATE'',
          ''CREATE_SEQUENCE''
        )
        AND  USER_NAME =   :WHATIF 
    );
    BEGIN
      RETURN TABLE(RES);
    END;
     ELSE  
     DECLARE
  res resultset default (
  
SELECT DISTINCT h.database_name,
h.SCHEMA_NAME,
       t.table_name,
       h.user_name,
       h.role_name,h.QUERY_TYPE, 
       h.EXECUTION_STATUS
  FROM snowflake.account_usage.query_history h 
  LEFT JOIN snowflake.account_usage.users u
    ON u.name = h.user_name 
   AND u.disabled = FALSE 
   AND u.deleted_on IS NULL
   LEFT OUTER JOIN information_schema.tables t
    ON t.created = h.start_time
 WHERE execution_status = ''SUCCESS'' 
   AND Cast(h.start_time AS DATE) = Cast(current_date() AS DATE) 
AND QUERY_TYPE in (''REVOKE'',''CREATE_VIEW'',
''UPDATE'',''RENAME_TABLE'',''CREATE_CONSTRAINT'',
''INSERT'',''ALTER_TABLE_ADD_COLUMN'',''RENAME_COLUMN'',
''BEGIN_TRANSACTION'',''MERGE'',''RESTORE'',''DELETE'',
''ALTER_SESSION'',''COMMIT'',''RENAME_VIEW'',''CREATE_TABLE'',
''ALTER_NETWORK_POLICY'',''ALTER_TABLE_MODIFY_COLUMN'',
''TRUNCATE_TABLE'',''DROP'',''ALTER_TABLE_DROP_COLUMN'',
''REMOVE_FILES'',''CREATE_TABLE_AS_SELECT'',''CREATE'',
''CREATE_SEQUENCE'')
AND USER_NAME = (select current_user)
AND h.database_name = (select current_database() )
)
    ;
BEGIN
RETURN TABLE(RES);
END;
  END IF;
END;
'












CALL SYSTEM$WAIT(10, 'MINUTES');
CALL JIRA_EXPORTS.DBA.TABLESMODIFIED('')
