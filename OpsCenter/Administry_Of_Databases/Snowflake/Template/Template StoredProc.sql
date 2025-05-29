.
USE ROLE <role_name>;
USE WAREHOUSE <warehouse_name>;
USE DATABASE <database_name>;

-- Begin modifying script

USE SCHEMA <schema_name>;

BEGIN
	CASE WHEN (SELECT COUNT(*)
	FROM INFORMATION_SCHEMA.procedures
	WHERE PROCEDURE_NAME   = 'proc_name'
      ) = 0
	THEN
create procedure proc_name
--repeatable work
;

ELSE 
create or replace procedure proc_name
--repeatable work
;

	END;
    
END;

-- End of script

-- Wait for 5 minutes before executing next script
CALL SYSTEM$WAIT(5, 'MINUTES');

-- Display all changes made by the script
CALL DBA.TABLESMODIFIED('');
