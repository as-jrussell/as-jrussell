USE ROLE OWNER_EDW_DEV;
USE WAREHOUSE EDW_DEV_INFA_WH;
USE DATABASE EDW_DEV;

create schema DBA; 


use role ACCOUNTADMIN;


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
