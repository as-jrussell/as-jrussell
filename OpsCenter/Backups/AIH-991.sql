Connect to: https://ss53963.east-us-2.azure.snowflakecomputing.com/
 
In Worksheets change context to 
Role: EDW_PROD_OWNER
Warehouse: INFORMATICA
Database: EDW_PROD
Schema: STG


Please execute the following statement. 



use edw_prod;

update stg.stg_ut_interaction_historyset REASON_CODE=GET(XMLGET(SPECIAL_HANDLING_XML,'REASON_CODE'),'$'):: varchar(2048), WEB_VERIFICATION=GET(XMLGET(SPECIAL_HANDLING_XML,'WEB_VERIFICATION'),'$'):: varchar(2048);