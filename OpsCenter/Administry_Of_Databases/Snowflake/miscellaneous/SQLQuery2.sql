CREATE OR REPLACE TEMPORARY TABLE current_db (
  current_db_name VARCHAR(64)
);

INSERT INTO current_db (current_db_name)
VALUES (CURRENT_DATABASE());

CREATE OR REPLACE TEMPORARY TABLE RES (
  "DATABASE_NAME" VARCHAR(16777216), 
  "TABLE_SCHEMA" VARCHAR(16777216), 
  "TABLE_NAME" VARCHAR(16777216), 
  "USER_NAME" VARCHAR(16777216), 
  "ROLE_NAME" VARCHAR(16777216), 
  "QUERY_TYPE" VARCHAR(16777216), 
  "EXECUTION_STATUS" VARCHAR(16777216)
);

DECLARE current_name_db VARCHAR(64);

BEGIN
  SELECT current_db_name INTO current_name_db FROM current_db;
 
  IF (current_name_db = 'DBA') THEN
    INSERT INTO RES (
      DATABASE_NAME, TABLE_SCHEMA, TABLE_NAME, USER_NAME, ROLE_NAME, QUERY_TYPE, EXECUTION_STATUS
    )
    SELECT DISTINCT 
      h.database_name,
      h.SCHEMA_NAME,
      t.table_name,
      h.user_name,
      h.role_name,
      h.QUERY_TYPE,
      h.EXECUTION_STATUS
    FROM snowflake.account_usage.query_history h 
    LEFT JOIN snowflake.account_usage.users u
      ON u.name = h.user_name 
      AND u.disabled = FALSE 
      AND u.deleted_on IS NULL
    LEFT OUTER JOIN information_schema.tables t
      ON t.created = h.start_time
    WHERE 
      execution_status = 'SUCCESS' 
      AND CAST(h.start_time AS DATE) = CAST(CURRENT_DATE() AS DATE) 
      AND QUERY_TYPE IN (
        'REVOKE', 'CREATE_VIEW', 'UPDATE', 'RENAME_TABLE', 'CREATE_CONSTRAINT', 'INSERT', 
        'ALTER_TABLE_ADD_COLUMN', 'RENAME_COLUMN', 'BEGIN_TRANSACTION', 'MERGE', 'RESTORE', 
        'DELETE', 'ALTER_SESSION', 'COMMIT', 'RENAME_VIEW', 'CREATE_TABLE', 'ALTER_NETWORK_POLICY', 
        'ALTER_TABLE_MODIFY_COLUMN', 'TRUNCATE_TABLE', 'DROP', 'ALTER_TABLE_DROP_COLUMN', 
        'REMOVE_FILES', 'CREATE_TABLE_AS_SELECT', 'CREATE', 'CREATE_SEQUENCE'
      )
;
  ELSE
     INSERT INTO RES (
      DATABASE_NAME, TABLE_SCHEMA, TABLE_NAME, USER_NAME, ROLE_NAME, QUERY_TYPE, EXECUTION_STATUS
    )
    SELECT DISTINCT 
      h.database_name,
      h.SCHEMA_NAME,
      t.table_name,
      h.user_name,
      h.role_name,
      h.QUERY_TYPE,
      h.EXECUTION_STATUS
    FROM snowflake.account_usage.query_history h 
    LEFT JOIN snowflake.account_usage.users u
      ON u.name = h.user_name 
      AND u.disabled = FALSE 
      AND u.deleted_on IS NULL
    LEFT OUTER JOIN information_schema.tables t
      ON t.created = h.start_time
    WHERE 
      execution_status = 'SUCCESS' 
      AND CAST(h.start_time AS DATE) = CAST(CURRENT_DATE() AS DATE) 
      AND QUERY_TYPE IN (
        'REVOKE', 'CREATE_VIEW', 'UPDATE', 'RENAME_TABLE', 'CREATE_CONSTRAINT', 'INSERT', 
        'ALTER_TABLE_ADD_COLUMN', 'RENAME_COLUMN', 'BEGIN_TRANSACTION', 'MERGE', 'RESTORE', 
        'DELETE', 'ALTER_SESSION', 'COMMIT', 'RENAME_VIEW', 'CREATE_TABLE', 'ALTER_NETWORK_POLICY', 
        'ALTER_TABLE_MODIFY_COLUMN', 'TRUNCATE_TABLE', 'DROP', 'ALTER_TABLE_DROP_COLUMN', 
        'REMOVE_FILES', 'CREATE_TABLE_AS_SELECT', 'CREATE', 'CREATE_SEQUENCE'
      )
      AND USER_NAME = (select current_user)
AND h.database_name = (select current_database());
  END IF;
END;

SELECT * FROM RES;