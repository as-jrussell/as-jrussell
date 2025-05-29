USE ROLE <role_name>;
USE WAREHOUSE <warehouse_name>;
USE DATABASE <database_name>;

-- Begin modifying script

USE SCHEMA <schema_name>;

BEGIN
	CASE WHEN (SELECT COUNT(*)
	FROM INFORMATION_SCHEMA.VIEWS
	WHERE TABLE_NAME   = 'view_name'
      ) = 0
	THEN
create  view view_name
(
	column1,
	column2,
	column3 .....
) 
as 
(
<insert script here>

);

ELSE 
create or replace view view_name
(
	column1,
	column2,
	column3 .....
) 
as 
(
<insert script here>

);

	END;
    
END;

-- End of script

-- Wait for 5 minutes before executing next script
CALL SYSTEM$WAIT(5, 'MINUTES');

-- Display all changes made by the script
CALL DBA.TABLESMODIFIED('');
