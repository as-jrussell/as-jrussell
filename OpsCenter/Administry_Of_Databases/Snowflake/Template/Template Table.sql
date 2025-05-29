USE ROLE <role_name>;
USE WAREHOUSE <warehouse_name>;
USE DATABASE <database_name>;

-- Begin modifying script

USE SCHEMA <schema_name>;

BEGIN
	CASE WHEN (SELECT COUNT(*)
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME   = 'table_name'
      ) = 0
	THEN
CREATE TABLE table_name (
column1, column2, column3
);
ELSE 
CREATE OR REPLACE TABLE table_name (
column1, column2, column3
);

	END;
    
END;

-- End of script

-- Wait for 5 minutes before executing next script (takes about 3 - 5 minutes for Snowflake to catch-up with changes completed) 
CALL SYSTEM$WAIT(5, 'MINUTES');

-- Display all changes made by the script
CALL DBA.TABLESMODIFIED('');
