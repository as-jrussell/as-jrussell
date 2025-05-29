USE DATABASE <database_name>;
USE WAREHOUSE <warehouse_name>;
USE ROLE <role_name>;

-- Begin modifying script

USE SCHEMA <schema_name>;

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

-- End of script

-- Wait for 5 minutes before executing next script
CALL SYSTEM$WAIT(5, 'MINUTES');

-- Display all changes made by the script
CALL CDW.TABLESMODIFIED();
