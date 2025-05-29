USE ROLE <role_name>;
USE WAREHOUSE <warehouse_name>;
USE DATABASE <database_name>;

-- Begin modifying script

USE SCHEMA <schema_name>;

BEGIN
	CASE WHEN (select count(*) from information_schema.tables  where table_name ='table_name' AND TABLE_SCHEMA = 'schema_name') = 1
	THEN

--update, insert, or rename
RETURN 'SUCCESS';


ELSE 

RETURN 'FAIL';

	END;
    
END;





-- Wait for 5 minutes before executing next script (takes about 3 - 5 minutes for Snowflake to catch-up with changes completed) 
CALL SYSTEM$WAIT(5, 'MINUTES');

-- Display all changes made by the script
CALL DBA.TABLESMODIFIED('');

-- End of script


