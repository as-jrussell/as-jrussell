Connect to: https://ss53963.east-us-2.azure.snowflakecomputing.com/
 
In Worksheets change context to 
Role: EDW_PROD_OWNER
Warehouse: INFORMATICA
Database: EDW_PROD
Schema: CDW
 
alter table edw_prod.CDW.D_Interaction_History_Archive rename column RESULTION_CODE to RESOLUTION_CODE;

alter table edw_prod.STG.D_Interaction_History_TEMP_Archive rename column RESULTION_CODE to RESOLUTION_CODE;