USE ROLE SYSADMIN;
USE WAREHOUSE EDW_PROD_INFA_WH;
USE DATABASE EDW_TEST;
USE SCHEMA STG;


create temporary table temp_demo_data as -- <---That's all there is to it!
SELECT * 
FROM INFORMATION_SCHEMA.TABLE_PRIVILEGES P 
WHERE PRIVILEGE_TYPE = 'SELECT'


create temporary table temp_demo_data_OWNER_EDW_PROD as -- <---That's all there is to it!
SELECT * 
FROM INFORMATION_SCHEMA.TABLE_PRIVILEGES P 
WHERE PRIVILEGE_TYPE = 'SELECT'
AND GRANTEE IN ('OWNER_EDW_PROD')



create temporary table temp_demo_data_giveaccess as -- <---That's all there is to it!
SELECT P.*
FROM temp_demo_data P
LEFT OUTER JOIN temp_demo_data_OWNER_EDW_PROD T on (P.TABLE_NAME = T.TABLE_NAME)
WHERE T.GRANTEE  IS NULL



SELECT DISTINCT 'GRANT SELECT ON TABLE ' || T.Table_Catalog || '.' || T.Table_Schema || '.' || T.Table_Name || ' TO ROLE OWNER_EDW_PROD;'
FROM INFORMATION_SCHEMA.Tables T
JOIN temp_demo_data_giveaccess P on (P.TABLE_NAME = T.TABLE_NAME)




SELECT *
FROM temp_demo_data P
LEFT OUTER JOIN temp_demo_data_OWNER_EDW_PROD T on (P.TABLE_NAME = T.TABLE_NAME)
WHERE T.GRANTEE  IS NULL

show tables like 'temp_demo%';


drop table TEMP_DEMO_DATA;
drop table TEMP_DEMO_DATA_GIVEACCESS;
drop table TEMP_DEMO_DATA_OWNER_EDW_PROD;