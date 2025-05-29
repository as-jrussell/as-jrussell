
USE ROLE SYSADMIN;
USE WAREHOUSE EDW_PROD_INFA_WH;
USE DATABASE EDW_PROD;



Select last_altered, *
from Information_schema.Tables
where table_name = 'STG_IQQ_PRODUCT'
last_altered >= '2022-09-17 06:00'


SELECT 'GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE ' || Table_Catalog || '.' || Table_Schema || '.' || Table_Name || ' TO ROLE READWRITE_EDW_PROD;'
FROM INFORMATION_SCHEMA.Tables
where CREATED > '2022-10-22 09:00'

SELECT 'GRANT SELECT ON TABLE ' || Table_Catalog || '.' || Table_Schema || '.' || Table_Name || ' TO ROLE READ_EDW_PROD;'
FROM INFORMATION_SCHEMA.Tables
where CREATED >  '2022-10-22 09:00'


SELECT 'TABLE ' || Table_Catalog || '.' || Table_Schema || '.' || Table_Name || ' CREATED SUCCESSFULLY AND PERMISSIONS HAVE BEEN UPDATED;'
FROM INFORMATION_SCHEMA.Tables
where CREATED > '2022-10-22 09:00'
