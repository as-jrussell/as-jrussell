use role accountadmin;
DESC NETWORK POLICY DEFAULT;



SELECT   h.start_time, *   
FROM snowflake.account_usage.query_history h   
LEFT JOIN snowflake.account_usage.users u     ON u.name = h.user_name    AND u.disabled = FALSE    AND u.deleted_on IS NULL    
LEFT OUTER JOIN information_schema.tables t     ON t.created = h.start_time 
WHERE h.query_text like '%221.122.91.0%'
ORDER BY h.START_TIME ASC 



USE DATABASE EDW_PROD;




SELECT DISTINCT h.database_name,
h.SCHEMA_NAME,
       t.table_name,
       h.user_name,
       h.role_name,h.QUERY_TYPE, 
       h.EXECUTION_STATUS, H.QUERY_TEXT
  FROM snowflake.account_usage.query_history h 
  LEFT JOIN snowflake.account_usage.users u
    ON u.name = h.user_name 
   AND u.disabled = FALSE 
   AND u.deleted_on IS NULL
   LEFT OUTER JOIN information_schema.tables t
    ON t.created = h.start_time
 WHERE execution_status = 'SUCCESS' 
   AND H.START_TIME >= '2024-02-08 10:30:29.929 -0800'
AND QUERY_TYPE in ('REVOKE','CREATE_VIEW',
'UPDATE','RENAME_TABLE','CREATE_CONSTRAINT',
'INSERT','ALTER_TABLE_ADD_COLUMN','RENAME_COLUMN',
'BEGIN_TRANSACTION','MERGE','RESTORE','DELETE',
'ALTER_SESSION','COMMIT','RENAME_VIEW','CREATE_TABLE',
'ALTER_NETWORK_POLICY','ALTER_TABLE_MODIFY_COLUMN',
'TRUNCATE_TABLE','DROP','ALTER_TABLE_DROP_COLUMN',
'REMOVE_FILES','CREATE_TABLE_AS_SELECT','CREATE',
'CREATE_SEQUENCE')
AND USER_NAME = (select current_user)
AND h.database_name = (select current_database() )


SHOW INTEGRATIONS



WITH QueryInfo AS (
                    SELECT 
                        TO_DATE(MAX(start_time)) AS create_date
                    FROM
                        snowflake.account_usage.query_history
                    WHERE
                        execution_status = 'SUCCESS'
                        AND query_text ILIKE 'select system$generate_scim_access_token%'
                    )
                    SELECT
                        create_date AS "Create Date",
                        DATEADD('months', 6, create_date) AS "Expire Date",
                        CASE
                            WHEN create_date <= DATEADD('MONTH', -6, CURRENT_DATE()) THEN 'Expired'
                            ELSE 'Not Expired'
                        END AS "Status"
                    FROM
                        QueryInfo;


SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.SCHEMATA
WHERE SCHEMA_NAME = 'IDP_STG'

show roles

select EVENT_TIMESTAMP, EVENT_TYPE, USER_NAME, CLIENT_IP, FIRST_AUTHENTICATION_FACTOR, SECOND_AUTHENTICATION_FACTOR, IS_SUCCESS, ERROR_MESSAGE, ERROR_MESSAGE,*
from snowflake.account_usage.login_history
where event_timestamp >= '2024-05-21'
AND IS_SUCCESS <> 'YES'

----all roles users are in 
call dba.info.GetUSERROLES('ALCLARK');
OWNER_EDW_STGSUPPORT
READ_EDW_STGSUPPORT
READWRITE_EDW_STGSUPPORT

SHOW SECURITY INTEGRATIONS 
--SELECT system$generate_scim_access_token('GENERIC_SCIM_PROVISIONING')


SELECT JSON_EXTRACT_PATH_TEXT(SYSTEM$GET_LOGIN_FAILURE_DETAILS('0ce9eb56-821d-4ca9-a774-04ae89a0cf5a'), 'errorCode');

SELECT SYSTEM$VERIFY_EXTERNAL_OAUTH_TOKEN('GENERIC_SCIM_PROVISIONING');

SELECT SYSTEM$FINISH_OAUTH_FLOW
SELECT SYSTEM$TYPEOF('oauth');

+-----------------------------------------------------------------------------------------------+
| Token Validation finished.{"Validation Result":"Passed","Issuer":"<URL>","User":"<username>"} |
+-----------------------------------------------------------------------------------------------+

select SYSTEM$SHOW_OAUTH_CLIENT_SECRETS;

SHOW INTEGRATIONS
select system$show_oauth_client_secrets('SCIM - GENERIC');

DESC INTEGRATION 'EXTERNAL_OAUTH_PF_1';
EXTERNAL_OAUTH_PF_1
GENERIC_SCIM_PROVISIONING
SELECT SYSTEM$VERIFY_EXTERNAL_OAUTH_TOKEN('');

+-----------------------------------------------------------------------------------------------+
| Token Validation finished.{"Validation Result":"Passed","Issuer":"<URL>","User":"<username>"} |
+-----------------------------------------------------------------------------------------------+
--JCALVERT
SELECT
  *
FROM
  show_parameters_in_account
WHERE
  "key" = 'STATEMENT_TIMEOUT_IN_SECONDS'
  AND (
    "value" < 21600
    OR "value" >= 172800
  );




select  privilege, granted_on, grantee_name,table_catalog, table_schema
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
     where granted_on = 'DATABASE'
	    and deleted_on is null 
     order by granted_on, name asc

---documentwritten
CALL DBA.DBA.TABLESMODIFIED('JRUSSELL')
/*
--per databases updates for the day
CALL DBA.DBA.TABLESMODIFIED('JIRA_EXPORTS_PROD')

--per user updates for the day
CALL DBA.DBA.TABLESMODIFIED('RELLIS')

--per admin level entire updates for the day
CALL DBA.DBA.TABLESMODIFIED('ADMIN')

--per databases, per user updates for the day
CALL DBA.DBA.TABLESMODIFIED('')

*/
show /* JDBC:DatabaseMetaData.getColumns() */ columns in table "DBA"."INFORMATION_SCHEMA"."tables"

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'INFORMATION_SCHEMA'
AND COLUMN_NAME IN ('LAST_ALTERED','CREATED')

---Access Add document written
/*
---For DBAs
CALL DBA.DEPLOY.SetUserAccess('ACUMMINS', 'DBA');
---For Employees in Data Management Team
CALL DBA.DEPLOY.SetUserAccess('MBATCHELOR', 'DS_ANALYST_READ');
CALL DBA.DEPLOY.SetUserAccess('SMYERS', 'DS_ANALYST_READ');
---For Contractor
CALL DBA.DEPLOY.SetUserAccess('SVC_PWBI_PRD01', 'BOND_ALLIED_EMPLOYEES');
---For OffShore
CALL DBA.DEPLOY.SetUserAccess('LJIRGAL', 'DS_ANALYST_EDIT');
CALL DBA.DEPLOY.SetUserAccess('LJIRGAL', 'EDW_BI_READER');



---To make an user ACTIVE

CALL DBA.DEPLOY.SetUserAccess('JRUSSELL', 'ENABLED');


---To make an user INACTIVE



CALL DBA.DEPLOY.SetUserAccess('LUJIRGAL2', 'DISABLED');
*/

call DBA.info.GetSCIMToken()
--document needed  for all the stored proc below
CALL DBA.INFO.GETWAREHOUSEROLES('')


show parameters like 'SAML_IDENTITY_PROVIDER' in account
SHOW SECURITY INTEGRATIONS 

select top 100 * 
from account_usage.query_history 
where QUERY_TEXT like '%select system$generate_scim_access_token%'
order by start_time desc;



   SELECT *
                    FROM
                        snowflake.account_usage.query_history
                    WHERE
                    start_time >= '2023-01-01'
                     AND  execution_status = 'SUCCESS'
                        AND query_text ILIKE 'select system$%token%'
                        




WITH QueryInfo AS (
                    SELECT 
                        TO_DATE(MAX(start_time)) AS create_date
                    FROM
                        snowflake.account_usage.query_history
                    WHERE
                        execution_status = 'SUCCESS'
                        AND query_text ILIKE 'select system$%'
                    )
                    SELECT
                        create_date AS "Create Date",
                        DATEADD('months', 6, create_date) AS "Expire Date",
                        CASE
                            WHEN create_date <= DATEADD('MONTH', -6, CURRENT_DATE()) THEN 'Expired'
                            ELSE 'Not Expired'
                        END AS "Status"
                    FROM
                        QueryInfo;
SHOW SCHEMAS

 select  count(*), table_type from information_schema.tables  
group by table_type


select * from information_schema.tables  
where table_type ='BASE TABLE'
order by table_name asc

--- CONVERT_TIMEZONE('America/Los_Angeles', 'America/Indianapolis', START_TIME) AS timestamp

CALL SYSTEM$WAIT(1,'MILLISECONDS');


 SHOW PARAMETERS LIKE '%DATA_RETENTION_TIME_IN_DAYS%' IN DATABASE;


 select  * from information_schema.tables 
 where  --table_catalog = (select current_database() ) and table_schema not in ('INFORMATION_SCHEMA') and table_owner <> 'OWNER_EDW_PROD'
--table_name like ('%IVOS%') AND TABLE_TYPE = 'BASE TABLE' AND CREATED >= '2023-12-06'
table_name = 'LSPD_AIPP_REPORT'
--last_ddl_by = 'INFATOSNOWFLAKEPROD'


SELECT *
from snowflake.account_usage.login_history
where USER_NAME ='INFATOSNOWFLAKEPROD' and Cast(EVENT_TIMESTAMP AS DATE) >= Cast(current_date()-3 AS DATE)
ORDER BY EVENT_TIMESTAMP DESC 


 SELECT h.database_name,
h.SCHEMA_NAME,
       h.user_name,
       h.role_name, QUERY_TEXT,query_type,
       h.EXECUTION_STATUS, CONVERT_TIMEZONE('America/Los_Angeles', 'America/Indianapolis', START_TIME) AS timestamp
  FROM snowflake.account_usage.query_history h 
  LEFT JOIN snowflake.account_usage.users u
    ON u.name = h.user_name 
   AND u.disabled = FALSE 
   AND u.deleted_on IS NULL
   LEFT OUTER JOIN information_schema.tables t
    ON t.created = h.start_time
 WHERE-- QUERY_TEXT like '%UNDROP%'  AND
 START_TIME BETWEEN '2023-11-21' AND '2023-11-22'-- AND query_type not in ('SELECT', 'SHOW' ,'DESCRIBE','UNKNOWN', 'INSERT','REMOVE_FILES','COPY','PUT_FILES','CREATE_VIEW','CREATE_TABLE_AS_SELECT')
and USER_NAME IN ('JRUSSELL')
AND ROLE_NAME = 'ACCOUNTADMIN'
--AND EXECUTION_STATUS = 'SUCCESS'
 ORDER BY START_TIME DESC 

use schema cdw;
 DESCRIBE table LSPD_AIPP_Report; 

SHOW TABLES LSPD_AIPP_Report


 SELECT query_type, CONVERT_TIMEZONE('America/Los_Angeles', 'America/Indianapolis', START_TIME) AS timestamp, *
  FROM snowflake.account_usage.query_history h 
 WHERE QUERY_TEXT like '%LSPD_AIPP_REPORT%'-- AND DATABASE_NAME = 'EDW_PROD'
 
 AND  START_TIME BETWEEN '2023-12-08 12:00' AND '2023-12-08 17:00'


--AND EXECUTION_STATUS = 'SUCCESS'
 ORDER BY START_TIME DESC 


select * from snowflake.account_usage.databases 

select 
COUNT(*),table_type ObjectName, table_catalog DatabaseName
from snowflake.account_usage.tables
WHERE TABLE_CATALOG IN ('EDW_TEST', 'EDW_PROD')
AND DELETED IS NULL
GROUP BY   table_type, table_catalog

UNION 
select 
COUNT(*),'procedures' ObjectName, procedures_catalog DatabaseName
from snowflake.account_usage.proceduress
WHERE procedures_catalog IN ('EDW_TEST', 'EDW_PROD')
AND DELETED IS NULL
GROUP BY   procedures_catalog
union
select COUNT(*),'StoredProcs' ObjectName, procedure_catalog DatabaseName
from snowflake.account_usage.procedures
WHERE procedure_catalog IN ('EDW_TEST', 'EDW_PROD')
AND DELETED IS NULL
GROUP BY   procedure_catalog
ORDER BY DatabaseName asc 





SELECT CONCAt(p.table_catalog,'.', p.table_schema,'.',  p.table_name) ObjectName,P.TABLE_TYPE ObjectType, S.table_OWNER
FROM EDW_PROD.INFORMATION_SCHEMA.TABLES P
LEFT JOIN  EDW_TEST.INFORMATION_SCHEMA.TABLES S ON S.TABLE_NAME = P.TABLE_NAME AND S.TABLE_SCHEMA = P.TABLE_SCHEMA
WHERE  S.TABLE_NAME IS NULL  OR S.table_OWNER <> 'OWNER_EDW_TEST' AND S.table_schema <> 'DBA'
UNION
SELECT CONCAt(p.function_catalog,'.', p.function_schema,'.',  p.function_name) ObjectName,'FUNCTION' ObjectType,  S.function_OWNER
FROM EDW_PROD.INFORMATION_SCHEMA.functions P
LEFT JOIN  EDW_TEST.INFORMATION_SCHEMA.functions  S ON S.function_name = P.function_name AND S.function_schema = P.function_schema
WHERE  S.function_name IS NULL  OR S.function_OWNER <> 'OWNER_EDW_TEST' AND S.function_schema <> 'DBA'
UNION
SELECT CONCAt(p.procedure_catalog,'.', p.procedure_schema,'.',  p.procedure_name) ObjectName,'PROCEDURE' ObjectType,  S.procedure_owneR
FROM EDW_PROD.INFORMATION_SCHEMA.procedures P
LEFT JOIN  EDW_TEST.INFORMATION_SCHEMA.procedures  S ON S.procedure_name = P.procedure_name AND S.procedure_schema = P.procedure_schema
WHERE  S.procedure_name IS NULL  OR S.procedure_owner <> 'OWNER_EDW_TEST' AND S.procedure_schema <> 'DBA'
UNION
SELECT CONCAt(p.SEQUENCE_CATALOG,'.', p.SEQUENCE_SCHEMA,'.',  p.SEQUENCE_NAME) ObjectName,'SEQUENCE' ObjectType, S.SEQUENCE_OWNER
FROM EDW_PROD.INFORMATION_SCHEMA.sequences P
LEFT JOIN  EDW_TEST.INFORMATION_SCHEMA.sequences  S ON S.SEQUENCE_NAME = P.SEQUENCE_NAME AND S.SEQUENCE_SCHEMA = P.SEQUENCE_SCHEMA
WHERE  S.SEQUENCE_NAME IS NULL OR S.SEQUENCE_OWNER <> 'OWNER_EDW_TEST' AND S.sequence_schema <> 'DBA'






select  privilege, granted_on, name,table_catalog, table_schema, grantee_name from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
   where deleted_on is null AND TABLE_CATALOG = 'EDW_STAGE'AND privilege <> 'OWNERSHIP' AND
  
--SELECT TABLE_TYPE, cOUNT(*)
--FROM INFORMATION_SCHEMA.TABLES
 CONCAT(table_schema, '.',name) IN  ('CDW.AIPP_REPORT_VIEW',
'CDW.COLLATERAL_CHANGE_DATA',
'CDW.COLLATERAL_CHANGE_DATA_DATE',
'CDW.COLLATERAL_CHANGE_DATA_FINAL',
'CDW.COLLATERAL_HISTORY_DIMENSION',
'CDW.D_ADDRESS_ORGANIZATION_RELATE',
'CDW.D_AMPLIFYDIRECT_NEWLOAN',
'CDW.D_BATCHES',
'CDW.D_BRANCH',
'CDW.D_BUSINESS_RULE_BASE',
'CDW.D_C2P_OPEN_CERTIFICATE',
'CDW.D_CAPS_CLAIMS_POLICY_NUMBERS',
'CDW.D_CAPS_PRODUCTS',
'CDW.D_CLAIM',
'CDW.D_CLAIM_POLICY',
'CDW.D_CLAIM_VEHICLE',
'CDW.D_CLAIMANT',
'CDW.D_CLIENTS',
'CDW.D_COLLATERAL_EXT_BUILD',
'CDW.D_COLLATERAL_PROPERTY',
'CDW.D_COLLATERAL_PROPERTY_EXT',
'CDW.D_COMMISSIONS',
'CDW.D_DATE',
'CDW.D_DIARY',
'CDW.D_FEES',
'CDW.D_IMPAIRMENT_WAIVE_TRACK',
'CDW.D_INSURANCE_TYPE',
'CDW.D_INSURED',
'CDW.D_IQQ_ADDRESS',
'CDW.D_IQQ_LENDER',
'CDW.D_IQQ_REF_CODE',
'CDW.D_IQQ_VEHICLE',
'CDW.D_ISSUE_PROCEDURE',
'CDW.D_IVOS_CLAIM_STATUS',
'CDW.D_IVOS_CLAIMANT_STATUS',
'CDW.D_IVOS_CLAIMANT_TYPE',
'CDW.D_IVOS_EMPLOYMENT',
'CDW.D_IVOS_EXAMINER',
'CDW.D_IVOS_FILE_LOC',
'CDW.D_IVOS_INSURED_NAME_TYPE',
'CDW.D_IVOS_INSURER',
'CDW.D_IVOS_JURISDICTION',
'CDW.D_IVOS_MULTIPLE_POLICY_CLAIM',
'CDW.D_IVOS_POLICY',
'CDW.D_LENDER_PAYEE_CODE',
'CDW.D_LOAN_EXT_BUILD',
'CDW.D_MASTER_POLICY_ASSIGNMENT',
'CDW.D_NOTEPAD',
'CDW.D_OPEN_CERTIFICATE',
'CDW.D_OPTIONAL_SURCHARGE',
'CDW.D_ORGANIZATION',
'CDW.D_ORGANIZATION_PRODUCT_RELATE',
'CDW.D_ORGANIZATION_USER_RELATE',
'CDW.D_PARAMETERS',
'CDW.D_PAYMENT',
'CDW.D_PAYMENT_TRANSACTION',
'CDW.D_PERSON',
'CDW.D_PIMS_CURRENT_PRODUCTS',
'CDW.D_PIMS_PRE_SKIP_DATA',
'CDW.D_PIMS_PREMIUM_HISTORY',
'CDW.D_PIMS_RECOVERY_DATA',
'CDW.D_PIMS_REGIONS',
'CDW.D_PIMS_REPRESENTATIVES',
'CDW.D_PIMS_UNDERWRITERS',
'CDW.D_PIMS_UNITRAC_LOAN_PORTFOLIO',
'CDW.D_PIMS_VUT_LOAN_PORTFOLIO',
'CDW.D_PROCESS_LOG_ITEM_WORK_ITEM',
'CDW.D_PRODUCT',
'CDW.D_PRODUCT_GROUP_PRODUCT_RELATE',
'CDW.D_PRODUCTS',
'CDW.D_PROPERTY',
'CDW.D_QUOTE',
'CDW.D_QUOTE_PLAN',
'CDW.D_QUOTE_TERM',
'CDW.D_QUOTE_WORKSHEET',
'CDW.D_REFERRAL',
'CDW.D_RELATIONSHIP_ALLOCATION',
'CDW.D_RELATIONSHIP_STATUS',
'CDW.D_RELATIONSHIPS',
'CDW.D_REMIT_BATCH',
'CDW.D_REPORT_CONFIG',
'CDW.D_REPORT_HISTORY',
'CDW.D_REQUIRED_COVERAGE',
'CDW.D_RESERVE_TRANSACTION',
'CDW.D_SALES',
'CDW.D_TAX',
'CDW.D_TRADING_PARTNER',
'CDW.D_UDF_CAPTIONS',
'CDW.D_USERS',
'CDW.D_UT_AGENCY',
'CDW.D_UT_CARRIER',
'CDW.D_UT_COLLATERAL_CODE',
'CDW.D_UT_COMMISSION',
'CDW.D_UT_COMMISSION_RATE',
'CDW.D_UT_CPI_ACTIVITY',
'CDW.D_UT_CPI_QUOTE',
'CDW.D_UT_DELIVERY_INFO',
'CDW.D_UT_DOCUMENT',
'CDW.D_UT_ESCROW_REQUIRED_COVERAGE_RELATE',
'CDW.D_UT_FINANCIAL_TXN_DETAIL',
'CDW.D_UT_FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE',
'CDW.D_UT_FORCE_PLACED_CERTIFICATE',
'CDW.D_UT_IMPAIRMENT',
'CDW.D_UT_INTERACTION_HISTORY',
'CDW.D_UT_LENDER_COLLATERAL_GROUP_COVERAGE_TYPE',
'CDW.D_UT_MESSAGE',
'CDW.D_UT_UTL_MATCH_RESULT',
'CDW.D_UT_WORK_QUEUE',
'CDW.D_VEHICLE_RECOVERY',
'CDW.D_VEHICLE_RECOVERY_ALLOCATION',
'CDW.D_WORK_ITEM_ACTION',
'CDW.DIM_DATE',
'CDW.F_CLAIM',
'CDW.F_COMMISSION_DETAIL',
'CDW.F_CPI_ACTIVITY',
'CDW.F_ENROLLMENTS',
'CDW.F_ESCROW',
'CDW.F_FEE_DETAIL',
'CDW.F_FINANCIAL_TXN',
'CDW.F_INTERACTION_HISTORY',
'CDW.F_LOAN_STATUS',
'CDW.F_NOTICE',
'CDW.F_PREMIUM_HISTORY',
'CDW.F_QUOTE',
'CDW.F_RELATIONSHIPS',
'CDW.F_SALES',
'CDW.F_VEHICLE_RECOVERY',
'CDW.F_WORK_ITEM',
'CDW.LOAN_CHANGE_DATA',
'CDW.LOAN_CHANGE_DATA_DATE',
'CDW.LOAN_CHANGE_DATA_FINAL',
'CDW.LOAN_HISTORY_DIMENSION',
'CDW.LSPD_ELIGIBLE_COVERAGE_AND_PEN_RATE',
'CDW.LSPD_ELIGIBLE_COVERAGE_AND_PEN_RATE_C',
'CDW.LSPD_ELIGIBLE_COVERAGE_AND_PEN_RATE_M',
'CDW.LSPD_FALSE_PLACEMENT_COUNTS',
'CDW.LSPD_GROSS_AGENCY_COMMISSION',
'CDW.LSPD_INSURANCE_UPDATE_COUNTS',
'CDW.LSPD_INSURANCE_VERIFICATION_COUNTS',
'CDW.LSPD_IVOS_CLAIMS_PAID_COUNT',
'CDW.LSPD_LOAN_ESCROW_DATES',
'CDW.LSPD_LOANS_BY_ORIGINATION_COUNT',
'CDW.LSPD_NET_REVENUE_REPORT',
'CDW.LSPD_NET_REVENUE_REPORT_CDW',
'CDW.LSPD_NOTICE_COUNTS',
'CDW.LSPD_PAST_DUE_PREMIUM',
'CDW.LSPD_PAST_DUE_PREMIUM_C',
'CDW.LSPD_PAST_DUE_PREMIUM_M',
'CDW.LSPD_REQUIRED_COVERAGE_ESCROW_DATES',
'CDW.LSPD_RSHINY_BASECERT',
'CDW.LSPD_RSHINY_BASETXN',
'CDW.LSPD_TRACKED_COVERAGE_COUNT',
'CDW.LSPD_TRACKED_COVERAGE_COUNT_C',
'CDW.LSPD_TRACKED_COVERAGE_COUNT_M',
'CDW.LSPDFPCCNT',
'CDW.PROPERTY_CHANGE_DATA',
'CDW.PROPERTY_CHANGE_DATA_DATE',
'CDW.PROPERTY_CHANGE_DATA_FINAL',
'CDW.PROPERTY_HISTORY_DIMENSION',
'CDW.REQUIRED_COVERAGE_CHANGE_DATA',
'CDW.REQUIRED_COVERAGE_CHANGE_DATA_DATE',
'CDW.REQUIRED_COVERAGE_CHANGE_DATA_FINAL',
'CDW.REQUIRED_COVERAGE_HISTORY_DIMENSION',
'CDW.REQUIRED_ESCROW_CHANGE_DATA',
'CDW.REQUIRED_ESCROW_CHANGE_DATA_DATE',
'CDW.REQUIRED_ESCROW_CHANGE_DATA_FINAL',
'CDW.RMO_CERTIFICATE_DIM_VW',
'CDW.RMO_D_AGENCY',
'CDW.RMO_D_CLAIM_TYPE',
'CDW.RMO_D_DATE',
'CDW.RMO_D_LENDER',
'CDW.RMO_D_LENDER_DETAIL_VW',
'CDW.RMO_D_PROTECT_TIER',
'CDW.RMO_D_REGION',
'CDW.RMO_F_AIPP_REPORT',
'CDW.RMO_F_ELIGIBLE_COVERAGE_AND_PEN_RATE_M',
'CDW.RMO_F_FALSE_PLACEMENT_COUNTS',
'CDW.RMO_F_FPCCNT',
'CDW.RMO_F_GROSS_AGENCY_COMMISSION',
'CDW.RMO_F_INSURANCE_UPDATE_COUNTS',
'CDW.RMO_F_INSURANCE_VERIFICATION_COUNTS',
'CDW.RMO_F_IVOS_CLAIMS_PAID_COUNT',
'CDW.RMO_F_LOANS_BY_ORIGINATION_COUNT',
'CDW.RMO_F_NET_REVENUE_REPORT',
'CDW.RMO_F_NEW_LOANS_ONBOARDED',
'CDW.RMO_F_NOTICE_COUNTS',
'CDW.RMO_F_PAST_DUE_PREMIUM_M',
'CDW.RMO_F_RSHINY_BASECERT',
'CDW.RMO_F_TRACKED_COVERAGE_COUNT_M',
'CDW.RMO_F_UNMATCHED_LOAN_COUNT',
'CDW.RMO_LLM_COVERAGE_STATUS',
'CDW.VERISK_LENDER',
'CDW.VERISK_REF_CODE',
'CDW.VW_DIM_DATE_7YRS',
'CDW.VWLSPD_COVERAGE_COMPONENT_FILTERS',
'CDW.VWLSPD_COVERAGE_LEVEL_FILTERS',
'CDW.VWLSPD_COVERAGE_LOAN_FILT_CALC',
'CDW.VWLSPD_COVERAGE_POLICY_COMPONENT_FILTERS_DETAIL',
'CDW.VWLSPD_LOAN_CATEGORY_FILTER',
'CDW.VWLSPD_PORTAL_LENDER_FILTERS',
'CLAIMS.CLAIMS_REC_EZ_CLAIMS_SCORECARD_CLEANED',
'CLAIMS.CLAIMS_REC_EZ_CLAIMS_SCORECARD_INSPECT',
'CLAIMS.CLAIMS_REC_EZ_CLAIMS_SCORECARD_RAW',
'CLAIMS.CLAIMS_REC_EZ_CLAIMS_SCORECARD_REMOVED',
'CLAIMS.CLAIMS_REC_EZ_CLAIMS_SCORECARD_VW',
'EDW.CD1_CALENDAR',
'EDW.FS_LENDER_DAILY_SUMMARY',
'LNDINS.D_LI_LENDER',
'LNDINS.D_LI_LOAN_AUTO',
'LNDINS.D_LI_LOAN_BUSINESS',
'LNDINS.D_LI_LOAN_FILE_IMPORT',
'LNDINS.D_LI_LOAN_MORTGAGE',
'LNDINS.D_LI_LOAN_REVOLVING',
'LNDINS.D_LI_LOAN_STUDENT',
'LNDINS.D_LI_LOAN_TYPE',
'LNDINS_STG.D_LI_LENDER_TEMP',
'LNDINS_STG.D_LI_LOAN_AUTO_TEMP',
'LNDINS_STG.D_LI_LOAN_BUSINESS_TEMP',
'LNDINS_STG.D_LI_LOAN_FILE_IMPORT_TEMP',
'LNDINS_STG.D_LI_LOAN_MORTGAGE_TEMP',
'LNDINS_STG.D_LI_LOAN_REVOLVING_TEMP',
'LNDINS_STG.D_LI_LOAN_STUDENT_TEMP',
'LNDINS_STG.D_LI_LOAN_TYPE_TEMP',
'LNDINS_STG.ETL_BATCH',
'LNDINS_STG.ETL_COUNT',
'LNDINS_STG.ETL_PROCESS_CONTROL',
'LNDINS_STG.ETL_RUNTIME_AUDIT',
'LNDINS_STG.ETL_RUNTIME_ERROR',
'LNDINS_STG.LND_LI_LENDER',
'LNDINS_STG.LND_LI_LOAN_AUTO',
'LNDINS_STG.LND_LI_LOAN_BUSINESS',
'LNDINS_STG.LND_LI_LOAN_FILE_IMPORT',
'LNDINS_STG.LND_LI_LOAN_MORTGAGE',
'LNDINS_STG.LND_LI_LOAN_REVOLVING',
'LNDINS_STG.LND_LI_LOAN_STUDENT',
'LNDINS_STG.LND_LI_LOAN_TYPE',
'LNDINS_STG.STG_LI_LENDER',
'LNDINS_STG.STG_LI_LENDER_H',
'LNDINS_STG.STG_LI_LOAN_AUTO',
'LNDINS_STG.STG_LI_LOAN_AUTO_H',
'LNDINS_STG.STG_LI_LOAN_BUSINESS',
'LNDINS_STG.STG_LI_LOAN_BUSINESS_H',
'LNDINS_STG.STG_LI_LOAN_FILE_IMPORT',
'LNDINS_STG.STG_LI_LOAN_FILE_IMPORT_H',
'LNDINS_STG.STG_LI_LOAN_MORTGAGE',
'LNDINS_STG.STG_LI_LOAN_MORTGAGE_H',
'LNDINS_STG.STG_LI_LOAN_REVOLVING',
'LNDINS_STG.STG_LI_LOAN_REVOLVING_H',
'LNDINS_STG.STG_LI_LOAN_STUDENT',
'LNDINS_STG.STG_LI_LOAN_STUDENT_H',
'LNDINS_STG.STG_LI_LOAN_TYPE',
'LNDINS_STG.STG_LI_LOAN_TYPE_H',
'STG.AUDIT_AMPLIFYDIRECT',
'STG.BAD_PROP_ID',
'STG.BAD_RC_ID',
'STG.CLAIMS_IDS_INSPECT',
'STG.CLAIMS_IDS_KEEP',
'STG.CLAIMS_IDS_REMOVE',
'STG.COLLATERAL_TEMP',
'STG.COLLATERAL_TEMP_DELTA',
'STG.COUNT_TEST',
'STG.CPI_ACTIVITY_AMT',
'STG.CPI_ACTIVITY_AMT_DELTA',
'STG.CPIPRODUCT_WITH_DATE',
'STG.CPIPRODUCTS',
'STG.D_ADDRESS_ORGANIZATION_RELATE_TEMP',
'STG.D_AGENCY_USER_RELATE',
'STG.D_ALTERNATE_MATCH',
'STG.D_AMPLIFYDIRECT_NEWLOAN_TEMP',
'STG.D_BATCHES_TEMP',
'STG.D_BRANCH_TEMP',
'STG.D_CAPS_CLAIMS_POLICY_NUMBERS_TEMP',
'STG.D_CAPS_PRODUCTS_TEMP',
'STG.D_CLAIM_POLICY_TEMP',
'STG.D_CLAIM_TEMP',
'STG.D_CLAIM_VEHICLE_TEMP',
'STG.D_CLAIMANT_TEMP',
'STG.D_CLIENTS_TEMP',
'STG.D_COLLATERAL_EXT_TEMP',
'STG.D_COLLATERAL_PROPERTY_TEMP',
'STG.D_COMMISSIONS_TEMP',
'STG.D_DIARY_TEMP',
'STG.D_FEES_TEMP',
'STG.D_IMPAIRMENT_WAIVE_TRACK_TEMP',
'STG.D_INSURANCE_TYPE_TEMP',
'STG.D_INSURED_NAME_TYPE_TEMP',
'STG.D_INSURED_TEMP',
'STG.D_INTERACTION_HISTORY_TEMP_ARCHIVE',
'STG.D_IQQ_ADDRESS_TEMP',
'STG.D_IQQ_LENDER_TEMP',
'STG.D_IQQ_REF_CODE_TEMP',
'STG.D_IQQ_VEHICLE_TEMP',
'STG.D_ISSUE_PROCEDURE_TEMP',
'STG.D_IVOS_CLAIM_STATUS_TEMP',
'STG.D_IVOS_CLAIMANT_STATUS_TEMP',
'STG.D_IVOS_CLAIMANT_TYPE_TEMP',
'STG.D_IVOS_EMPLOYMENT_TEMP',
'STG.D_IVOS_EXAMINER_TEMP',
'STG.D_IVOS_FILE_LOC_TEMP',
'STG.D_IVOS_INSURER_TEMP',
'STG.D_IVOS_JURISDICTION_TEMP',
'STG.D_IVOS_MULTIPLE_POLICY_CLAIM_TEMP',
'STG.D_IVOS_POLICY_TEMP',
'STG.D_LENDER_PAYEE_CODE_TEMP',
'STG.D_LENDER_TEMP',
'STG.D_LOAN_EXT_TEMP',
'STG.D_MASTER_POLICY_ASSIGNMENT_TEMP',
'STG.D_NOTEPAD_TEMP',
'STG.D_OPEN_CERTIFICATE_TEMP',
'STG.D_OPTIONAL_SURCHARGE_TEMP',
'STG.D_ORGANIZATION_PRODUCT_RELATE_TEMP',
'STG.D_ORGANIZATION_TEMP',
'STG.D_ORGANIZATION_USER_RELATE_TEMP',
'STG.D_PARAMETERS_TEMP',
'STG.D_PAYMENT_TEMP',
'STG.D_PAYMENT_TRANSACTION_TEMP',
'STG.D_PERSON_TEMP',
'STG.D_PIMS_CURRENT_PRODUCTS_TEMP',
'STG.D_PIMS_PRE_SKIP_DATA_TEMP',
'STG.D_PIMS_PREMIUM_HISTORY_TEMP',
'STG.D_PIMS_RECOVERY_DATA_TEMP',
'STG.D_PIMS_REGIONS_TEMP',
'STG.D_PIMS_REPRESENTATIVES_TEMP',
'STG.D_PIMS_UNDERWRITERS_TEMP',
'STG.D_PIMS_UNITRAC_LOAN_PORTFOLIO_TEMP',
'STG.D_PIMS_VUT_LOAN_PORTFOLIO_TEMP',
'STG.D_PROCESS_LOG_ITEM_WORK_ITEM_TEMP',
'STG.D_PRODUCT_GROUP_PRODUCT_RELATE_TEMP',
'STG.D_PRODUCT_TEMP',
'STG.D_PRODUCTS_TEMP',
'STG.D_PROPERTY_EXT_TEMP',
'STG.D_PROPERTY_TEMP',
'STG.D_QUOTE_PLAN_TEMP',
'STG.D_QUOTE_TEMP',
'STG.D_QUOTE_TERM_TEMP',
'STG.D_QUOTE_WORKSHEET_TEMP',
'STG.D_REF_CODE_ATTRIBUTE_TEMP',
'STG.D_REF_CODE_TEMP',
'STG.D_REFERRAL_TEMP',
'STG.D_RELATIONSHIP_ALLOCATION_TEMP',
'STG.D_RELATIONSHIP_STATUS_TEMP',
'STG.D_RELATIONSHIPS_TEMP',
'STG.D_REMIT_BATCH_TEMP',
'STG.D_REPORT_CONFIG_TEMP',
'STG.D_REPORT_HISTORY_TEMP',
'STG.D_REQUIRED_COVERAGE_EXT_TEMP',
'STG.D_REQUIRED_COVERAGE_TEMP',
'STG.D_REQUIRED_ESCROW_EXT_TEMP',
'STG.D_RESERVE_TRANSACTION_TEMP',
'STG.D_SALES_TEMP',
'STG.D_TAX_TEMP',
'STG.D_TRADING_PARTNER_TEMP',
'STG.D_UDF_CAPTIONS_TEMP',
'STG.D_USERS_TEMP',
'STG.D_UT_AGENCY_TEMP',
'STG.D_UT_CARRIER_TEMP',
'STG.D_UT_COLLATERAL_CODE_TEMP',
'STG.D_UT_COMMISSION_RATE_TEMP',
'STG.D_UT_COMMISSION_TEMP',
'STG.D_UT_CPI_ACTIVITY_TEMP',
'STG.D_UT_CPI_QUOTE_TEMP',
'STG.D_UT_DELIVERY_INFO_TEMP',
'STG.D_UT_DOCUMENT_TEMP',
'STG.D_UT_ESCROW_REQUIRED_COVERAGE_RELATE_TEMP',
'STG.D_UT_FINANCIAL_TXN_DETAIL_TEMP',
'STG.D_UT_FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE_TEMP',
'STG.D_UT_FORCE_PLACED_CERTIFICATE_TEMP',
'STG.D_UT_IMPAIRMENT_TEMP',
'STG.D_UT_INTERACTION_HISTORY_TEMP',
'STG.D_UT_LENDER_COLLATERAL_GROUP_COVERAGE_TYPE_TEMP',
'STG.D_UT_MESSAGE_TEMP',
'STG.D_UT_UTL_MATCH_RESULT_TEMP',
'STG.D_UT_WORK_QUEUE_TEMP',
'STG.D_VEHICLE_RECOVERY_ALLOCATION_TEMP',
'STG.D_VEHICLE_RECOVERY_TEMP',
'STG.D_WORK_ITEM_ACTION_TEMP',
'STG.D_WORK_ITEM_TEMP',
'STG.DATA',
'STG.DATA_DELTA',
'STG.DATA_TC_STG_WD',
'STG.DATE_LIST',
'STG.DELIM_LKP',
'STG.ERROR_AMPLIFYDIRECT',
'STG.ETL_BATCH_AMPLIFY',
'STG.ETL_BATCH_BK',
'STG.ETL_PROCESS_CONTROL_AMPLIFY',
'STG.ETL_PROCESS_CONTROL_BK',
'STG.EXAMINER_FILTER_ALL',
'STG.EZ_CLAIMS_TEMP',
'STG.F_CLAIM_TEMP',
'STG.F_COMMISSION_DETAIL_TEMP',
'STG.F_CPI_ACTIVITY_TEMP',
'STG.F_ENROLLMENTS_TEMP',
'STG.F_ESCROW_TEMP',
'STG.F_FEE_DETAIL_TEMP',
'STG.F_FINANCIAL_TXN_TEMP',
'STG.F_INTERACTION_HISTORY_ARCHIVE_TEMP',
'STG.F_INTERACTION_HISTORY_TEMP',
'STG.F_LOAN_STATUS_TEMP',
'STG.F_NOTICE_TEMP',
'STG.F_PREMIUM_HISTORY_TEMP',
'STG.F_QUOTE_TEMP',
'STG.F_RELATIONSHIPS_TEMP',
'STG.F_SALES_TEMP',
'STG.F_VEHICLE_RECOVERY_TEMP',
'STG.F_WORK_ITEM_TEMP',
'STG.FINANCIAL_TXN_TEMP_DELTA',
'STG.FNGETCERTIFICATEFINANCIALS',
'STG.FPCRCR_SRC',
'STG.HOLIDAY_COUNT',
'STG.IH_DATA_UPDATE',
'STG.IH_SRC',
'STG.INTERACTION_HISTORY_ID_SET',
'STG.KPI_PIMS_CLIENTS',
'STG.KPI_PIMS_REGIONS',
'STG.LENDER_FILTER',
'STG.LND_AMPLIFYDIRECT_NEWLOAN',
'STG.LND_IQQ_ADDRESS_ORGANIZATION_RELATE',
'STG.LND_IQQ_AGENCY',
'STG.LND_IQQ_ORGANIZATION',
'STG.LND_IQQ_VEHICLE_MAKE',
'STG.LND_IQQ_VEHICLE_MODEL',
'STG.LND_IVOS_CLAIM',
'STG.LND_IVOS_CLAIM_STATUS',
'STG.LND_IVOS_CLAIMANT',
'STG.LND_IVOS_CLAIMANT_STATUS',
'STG.LND_IVOS_CLAIMANT_TYPE',
'STG.LND_IVOS_DIARY',
'STG.LND_IVOS_EMPLOYMENT',
'STG.LND_IVOS_INSURANCE_TYPE',
'STG.LND_IVOS_INSURED',
'STG.LND_IVOS_INSURED_NAME_TYPE',
'STG.LND_IVOS_JURISDICTION',
'STG.LND_IVOS_MULTIPLE_POLICY_CLAIM',
'STG.LND_IVOS_NOTEPAD',
'STG.LND_IVOS_PAYEE',
'STG.LND_IVOS_PAYMENT',
'STG.LND_IVOS_POLICY',
'STG.LND_IVOS_VEHICLE',
'STG.LND_IVOS_VEHICLE_MODEL',
'STG.LND_IVOS_VEHICLE_RECOVERY',
'STG.LND_IVOS_VEHICLE_RECOVERY_ALLOCATION',
'STG.LND_IVOS_VEHICLE_RECOVERY_STATUS',
'STG.LND_PIMS_ALLOCATION_TYPES',
'STG.LND_PIMS_BATCHES',
'STG.LND_PIMS_CAPS_CLAIMS_POLICY_NUMBERS',
'STG.LND_PIMS_CAPS_INSTITUTIONS',
'STG.LND_PIMS_CAPS_PRODUCTS',
'STG.LND_PIMS_CAPS_RECOGNITION',
'STG.LND_PIMS_CLIENT_STATUS',
'STG.LND_PIMS_CLIENT_TYPES',
'STG.LND_PIMS_CLIENTS',
'STG.LND_PIMS_COMMISSION_DETAIL',
'STG.LND_PIMS_COMMISSIONS',
'STG.LND_PIMS_COVERAGE_TYPES',
'STG.LND_PIMS_CURRENT_PRODUCTS',
'STG.LND_PIMS_ENROLLMENTS',
'STG.LND_PIMS_FDIC_INSTITUTIONS',
'STG.LND_PIMS_FEE_DETAIL',
'STG.LND_PIMS_FEES',
'STG.LND_PIMS_MPP_PRODUCT_GROUPS',
'STG.LND_PIMS_NCUA_INSTITUTIONS',
'STG.LND_PIMS_PARAMETERS',
'STG.LND_PIMS_PRE_SKIP_DATA',
'STG.LND_PIMS_PREMIUM_HISTORY',
'STG.LND_PIMS_PRODUCT',
'STG.LND_PIMS_PRODUCT_GROUPS',
'STG.LND_PIMS_PRODUCTS',
'STG.LND_PIMS_RECOVERY_DATA',
'STG.LND_PIMS_REGIONS',
'STG.LND_PIMS_RELATIONSHIP_ALLOCATIONS',
'STG.LND_PIMS_RELATIONSHIP_STATUS',
'STG.LND_PIMS_RELATIONSHIPS',
'STG.LND_PIMS_REPRESENTATIVE_TYPES',
'STG.LND_PIMS_REPRESENTATIVES',
'STG.LND_PIMS_STATE_CODES',
'STG.LND_PIMS_UDF_CAPTIONS',
'STG.LND_PIMS_UNDERWRITERS',
'STG.LND_PIMS_UNITRAC_LOAN_PORTFOLIO',
'STG.LND_PIMS_VUT_LOAN_PORTFOLIO',
'STG.LND_UT_INTERACTION_HISTORY_ARCHIVE',
'STG.LND_UT_INTERACTION_HISTORY_ARCHIVE_INTRM',
'STG.LND_UT_INTERACTION_HISTORY_BKP221002',
'STG.LND_UT_INTERACTION_HISTORY_RC_ARCHIVE',
'STG.LND_UT_INTERACTION_HISTORY_RC_ARCHIVE_INTRM',
'STG.LND_UT_OPEN_CERTIFICATE',
'STG.LND_UT_TABLE_CHANGE_ARCHIVE',
'STG.LND_UT_UTL_MATCH_RESULT',
'STG.LND_UT_VUT_SCANBATCH',
'STG.LND_UT_VUT_TBLCENTER',
'STG.LND_UT_VUT_TBLCONTRACTHISTORY',
'STG.LND_UT_VUT_TBLCONTRACTTYPE',
'STG.LND_UT_VUT_TBLIMAGEQUEUE',
'STG.LND_UT_VUT_TBLLENDER',
'STG.LND_UT_WORK_QUEUE',
'STG.LOAN_FILTER',
'STG.LOAN_ID_SET_UPDATE',
'STG.LSPD_PAST_DUE_PREMIUM_DISTINCT',
'STG.OPEN_CERT_NEW',
'STG.PROP_ID_SET_UPDATE',
'STG.PROP_SRC',
'STG.RAWDATA_DELTA',
'STG.RC_SET_UPDATE',
'STG.RC_SRC',
'STG.RUNTIME_AUDIT',
'STG.RUNTIME_AUDIT_AMPLIFY',
'STG.RUNTIME_ERROR',
'STG.RUNTIME_ERROR_AMPLIFY',
'STG.STG_AMPLIFYDIRECT_NEWLOAN',
'STG.STG_IH_ARCHIVE_TEMP',
'STG.STG_IH_TEMP',
'STG.STG_IQQ_ADDRESS_H',
'STG.STG_IQQ_ADDRESS_ORGANIZATION_RELATE',
'STG.STG_IQQ_ADDRESS_ORGANIZATION_RELATE_H',
'STG.STG_IQQ_AGENCY',
'STG.STG_IQQ_AGENCY_H',
'STG.STG_IQQ_BRANCH_H',
'STG.STG_IQQ_DPW_PRODUCT_H',
'STG.STG_IQQ_GAP_PRODUCT_H',
'STG.STG_IQQ_LENDER_H',
'STG.STG_IQQ_MBP_PRODUCT_H',
'STG.STG_IQQ_OPTIONAL_SURCHARGE_H',
'STG.STG_IQQ_ORGANIZATION',
'STG.STG_IQQ_ORGANIZATION_H',
'STG.STG_IQQ_ORGANIZATION_PRODUCT_RELATE_H',
'STG.STG_IQQ_ORGANIZATION_USER_RELATE_H',
'STG.STG_IQQ_PERSON_H',
'STG.STG_IQQ_PRODUCT_GROUP_H',
'STG.STG_IQQ_PRODUCT_GROUP_PRODUCT_RELATE_H',
'STG.STG_IQQ_PRODUCT_H',
'STG.STG_IQQ_PROVIDER_H',
'STG.STG_IQQ_QUOTE_COLLECTION_H',
'STG.STG_IQQ_QUOTE_PLAN_H',
'STG.STG_IQQ_QUOTE_TERM_DETAIL_H',
'STG.STG_IQQ_QUOTE_TERM_H',
'STG.STG_IQQ_QUOTE_WORKSHEET_H',
'STG.STG_IQQ_QUOTE_WORKSHEET_INPUT_H',
'STG.STG_IQQ_REF_CODE_H',
'STG.STG_IQQ_RELATE_CLASS_H',
'STG.STG_IQQ_REMIT_BATCH_H',
'STG.STG_IQQ_REMIT_BATCH_SALE_RELATE_H',
'STG.STG_IQQ_SALE_H',
'STG.STG_IQQ_TAX_H',
'STG.STG_IQQ_USER_RELATE_H',
'STG.STG_IQQ_USERS_H',
'STG.STG_IQQ_VEHICLE_MAKE',
'STG.STG_IQQ_VEHICLE_MAKE_H',
'STG.STG_IQQ_VEHICLE_MODEL',
'STG.STG_IQQ_VEHICLE_MODEL_H',
'STG.STG_IQQ_VENDOR_OFFERING_H',
'STG.STG_IVOS_CLAIM',
'STG.STG_IVOS_CLAIM_H',
'STG.STG_IVOS_CLAIM_STATUS',
'STG.STG_IVOS_CLAIM_STATUS_H',
'STG.STG_IVOS_CLAIMANT',
'STG.STG_IVOS_CLAIMANT_H',
'STG.STG_IVOS_CLAIMANT_STATUS',
'STG.STG_IVOS_CLAIMANT_STATUS_H',
'STG.STG_IVOS_CLAIMANT_TYPE',
'STG.STG_IVOS_CLAIMANT_TYPE_H',
'STG.STG_IVOS_DIARY',
'STG.STG_IVOS_DIARY_H',
'STG.STG_IVOS_DIARY_PRIORITY_H',
'STG.STG_IVOS_DIARY_TYPE_H',
'STG.STG_IVOS_EMPLOYMENT',
'STG.STG_IVOS_EMPLOYMENT_H',
'STG.STG_IVOS_EXAMINER_H',
'STG.STG_IVOS_FILE_LOC_H',
'STG.STG_IVOS_INSURANCE_TYPE',
'STG.STG_IVOS_INSURED',
'STG.STG_IVOS_INSURED_H',
'STG.STG_IVOS_INSURED_NAME_TYPE',
'STG.STG_IVOS_INSURED_NAME_TYPE_H',
'STG.STG_IVOS_INSURER_H',
'STG.STG_IVOS_JURISDICTION',
'STG.STG_IVOS_JURISDICTION_H',
'STG.STG_IVOS_MULTIPLE_POLICY_CLAIM',
'STG.STG_IVOS_MULTIPLE_POLICY_CLAIM_H',
'STG.STG_IVOS_NOTEPAD',
'STG.STG_IVOS_NOTEPAD_H',
'STG.STG_IVOS_NOTEPAD_TYPE_H',
'STG.STG_IVOS_PAYEE',
'STG.STG_IVOS_PAYMENT',
'STG.STG_IVOS_PAYMENT_H',
'STG.STG_IVOS_PAYMENT_TRANSACTION_H',
'STG.STG_IVOS_POLICY',
'STG.STG_IVOS_POLICY_H',
'STG.STG_IVOS_REFERRAL_H',
'STG.STG_IVOS_REFERRAL_TYPE_H',
'STG.STG_IVOS_RESERVE_TRANSACTION_H',
'STG.STG_IVOS_VEHICLE',
'STG.STG_IVOS_VEHICLE_H',
'STG.STG_IVOS_VEHICLE_MAKE_H',
'STG.STG_IVOS_VEHICLE_MODEL',
'STG.STG_IVOS_VEHICLE_MODEL_H',
'STG.STG_IVOS_VEHICLE_RECOVERY',
'STG.STG_IVOS_VEHICLE_RECOVERY_ALLOCATION',
'STG.STG_IVOS_VEHICLE_RECOVERY_ALLOCATION_H',
'STG.STG_IVOS_VEHICLE_RECOVERY_CLOSING_H',
'STG.STG_IVOS_VEHICLE_RECOVERY_METHOD_H',
'STG.STG_IVOS_VEHICLE_RECOVERY_STATUS',
'STG.STG_IVOS_VEHICLE_RECOVERY_STATUS_H',
'STG.STG_OPEN_CERTIFICATE',
'STG.STG_OPEN_CERTIFICATE_INTRM',
'STG.STG_PIMS_ALLOCATION_TYPES',
'STG.STG_PIMS_ALLOCATION_TYPES_H',
'STG.STG_PIMS_BATCHES',
'STG.STG_PIMS_BATCHES_H',
'STG.STG_PIMS_CAPS_CLAIMS_POLICY_NUMBERS',
'STG.STG_PIMS_CAPS_CLAIMS_POLICY_NUMBERS_H',
'STG.STG_PIMS_CAPS_INSTITUTIONS',
'STG.STG_PIMS_CAPS_PRODUCTS',
'STG.STG_PIMS_CAPS_PRODUCTS_H',
'STG.STG_PIMS_CAPS_RECOGNITION',
'STG.STG_PIMS_CLIENT_STATUS',
'STG.STG_PIMS_CLIENT_STATUS_H',
'STG.STG_PIMS_CLIENT_TYPES',
'STG.STG_PIMS_CLIENT_TYPES_H',
'STG.STG_PIMS_CLIENTS',
'STG.STG_PIMS_CLIENTS_H',
'STG.STG_PIMS_COMMISSION_DETAIL',
'STG.STG_PIMS_COMMISSION_DETAIL_H',
'STG.STG_PIMS_COMMISSIONS',
'STG.STG_PIMS_COMMISSIONS_H',
'STG.STG_PIMS_COVERAGE_TYPES',
'STG.STG_PIMS_COVERAGE_TYPES_H',
'STG.STG_PIMS_CURRENT_PRODUCTS',
'STG.STG_PIMS_CURRENT_PRODUCTS_H',
'STG.STG_PIMS_ENROLLMENTS',
'STG.STG_PIMS_ENROLLMENTS_H',
'STG.STG_PIMS_FDIC_INSTITUTIONS',
'STG.STG_PIMS_FEE_DETAIL',
'STG.STG_PIMS_FEE_DETAIL_H',
'STG.STG_PIMS_FEES',
'STG.STG_PIMS_FEES_H',
'STG.STG_PIMS_MPP_PRODUCT_GROUPS',
'STG.STG_PIMS_MPP_PRODUCT_GROUPS_H',
'STG.STG_PIMS_NCUA_INSTITUTIONS',
'STG.STG_PIMS_PARAMETERS',
'STG.STG_PIMS_PARAMETERS_H',
'STG.STG_PIMS_PRE_SKIP_DATA',
'STG.STG_PIMS_PRE_SKIP_DATA_H',
'STG.STG_PIMS_PREMIUM_HISTORY',
'STG.STG_PIMS_PREMIUM_HISTORY_H',
'STG.STG_PIMS_PRODUCT',
'STG.STG_PIMS_PRODUCT_GROUPS',
'STG.STG_PIMS_PRODUCT_GROUPS_H',
'STG.STG_PIMS_PRODUCT_H',
'STG.STG_PIMS_PRODUCTS',
'STG.STG_PIMS_PRODUCTS_H',
'STG.STG_PIMS_RECOVERY_DATA',
'STG.STG_PIMS_RECOVERY_DATA_H',
'STG.STG_PIMS_REGIONS',
'STG.STG_PIMS_REGIONS_H',
'STG.STG_PIMS_RELATIONSHIP_ALLOCATIONS',
'STG.STG_PIMS_RELATIONSHIP_ALLOCATIONS_H',
'STG.STG_PIMS_RELATIONSHIP_STATUS',
'STG.STG_PIMS_RELATIONSHIP_STATUS_H',
'STG.STG_PIMS_RELATIONSHIPS',
'STG.STG_PIMS_RELATIONSHIPS_H',
'STG.STG_PIMS_REPRESENTATIVE_TYPES',
'STG.STG_PIMS_REPRESENTATIVE_TYPES_H',
'STG.STG_PIMS_REPRESENTATIVES',
'STG.STG_PIMS_REPRESENTATIVES_H',
'STG.STG_PIMS_STATE_CODES',
'STG.STG_PIMS_UDF_CAPTIONS',
'STG.STG_PIMS_UDF_CAPTIONS_H',
'STG.STG_PIMS_UNDERWRITERS',
'STG.STG_PIMS_UNDERWRITERS_H',
'STG.STG_PIMS_UNITRAC_LOAN_PORTFOLIO',
'STG.STG_PIMS_UNITRAC_LOAN_PORTFOLIO_H',
'STG.STG_PIMS_VUT_LOAN_PORTFOLIO',
'STG.STG_PIMS_VUT_LOAN_PORTFOLIO_H',
'STG.STG_UT_ACCOUNTING_PERIOD_H',
'STG.STG_UT_ADDRESS_H',
'STG.STG_UT_AGENCY_H',
'STG.STG_UT_AGENCY_REMITTANCE_H',
'STG.STG_UT_AGENCY_REPORT_CONFIG_H',
'STG.STG_UT_AGENCY_USER_RELATE_H',
'STG.STG_UT_ALTERNATE_MATCH_H',
'STG.STG_UT_BIA_H',
'STG.STG_UT_BIC_H',
'STG.STG_UT_BILLING_GROUP_H',
'STG.STG_UT_BUSINESS_OPTION_GROUP_H',
'STG.STG_UT_BUSINESS_OPTION_H',
'STG.STG_UT_CANCEL_PROCEDURE_H',
'STG.STG_UT_CANCEL_RULE_CALC_H',
'STG.STG_UT_CARRIER_H',
'STG.STG_UT_CERTIFICATE_DETAIL_H',
'STG.STG_UT_COLLATERAL_CODE_H',
'STG.STG_UT_COLLATERAL_H',
'STG.STG_UT_COMMISSION_H',
'STG.STG_UT_COMMISSION_RATE_H',
'STG.STG_UT_CPI_ACTIVITY_H',
'STG.STG_UT_CPI_DETAIL_TEMP',
'STG.STG_UT_CPI_QUOTE_H',
'STG.STG_UT_DELIVERY_INFO_H',
'STG.STG_UT_DOCUMENT_CONTAINER_H',
'STG.STG_UT_DOCUMENT_H',
'STG.STG_UT_DW_OPEN_CERTIFICATE',
'STG.STG_UT_DW_WEEKLY_DIM',
'STG.STG_UT_ESCROW_H',
'STG.STG_UT_ESCROW_REQUIRED_COVERAGE_RELATE_H',
'STG.STG_UT_EVALUATION_EVENT_H',
'STG.STG_UT_EVENT_SEQ_CONTAINER_H',
'STG.STG_UT_EVENT_SEQUENCE_H',
'STG.STG_UT_FINANCIAL_REPORT_TXN_H',
'STG.STG_UT_FINANCIAL_TXN_APPLY_H',
'STG.STG_UT_FINANCIAL_TXN_DETAIL_H',
'STG.STG_UT_FINANCIAL_TXN_H',
'STG.STG_UT_FINANCIAL_TXN_PAYMENT_TERM_DISTRIBUTION_H',
'STG.STG_UT_FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE_H',
'STG.STG_UT_FORCE_PLACED_CERTIFICATE_H',
'STG.STG_UT_IMPAIRMENT_H',
'STG.STG_UT_INTERACTION_HISTORY_ARCHIVE',
'STG.STG_UT_INTERACTION_HISTORY_H',
'STG.STG_UT_INTERACTION_HISTORY_RC_ARCHIVE',
'STG.STG_UT_INTERACTION_HISTORY_RC_ARCHIVE_INTRM',
'STG.STG_UT_INTERACTION_HISTORY_RC_H',
'STG.STG_UT_ISSUE_PROCEDURE',
'STG.STG_UT_ISSUE_PROCEDURE_H',
'STG.STG_UT_LENDER_COLLATERAL_GROUP_COVERAGE_TYPE_H',
'STG.STG_UT_LENDER_H',
'STG.STG_UT_LENDER_ORGANIZATION_H',
'STG.STG_UT_LENDER_PAYEE_CODE_FILE_H',
'STG.STG_UT_LENDER_PAYEE_CODE_MATCH_H',
'STG.STG_UT_LENDER_PRODUCT_H',
'STG.STG_UT_LENDER_REPORT_CONFIG_H',
'STG.STG_UT_LOAN_H',
'STG.STG_UT_MASTER_POLICY_ASSIGNMENT',
'STG.STG_UT_MASTER_POLICY_ASSIGNMENT_H',
'STG.STG_UT_MASTER_POLICY_H',
'STG.STG_UT_MASTER_POLICY_LENDER_PRODUCT_RELATE_H',
'STG.STG_UT_MESSAGE_H',
'STG.STG_UT_NOTICE_BK',
'STG.STG_UT_NOTICE_H',
'STG.STG_UT_NOTICE_REQUIRED_COVERAGE_RELATE_H',
'STG.STG_UT_OPEN_CERTIFICATE',
'STG.STG_UT_OPEN_CERTIFICATE_H',
'STG.STG_UT_OWNER_ADDRESS_H',
'STG.STG_UT_OWNER_H',
'STG.STG_UT_OWNER_LOAN_RELATE_H',
'STG.STG_UT_PROPERTY_TYPE',
'STG.STG_UT_TABLE_CHANGE_ARCHIVE',
'STG.STG_UT_UTL_MATCH_RESULT',
'STG.STG_UT_UTL_MATCH_RESULT_H',
'STG.STG_UT_VUT_SCANBATCH',
'STG.STG_UT_VUT_SCANBATCH_H',
'STG.STG_UT_VUT_TBLCENTER',
'STG.STG_UT_VUT_TBLCENTER_H',
'STG.STG_UT_VUT_TBLCONTRACTHISTORY',
'STG.STG_UT_VUT_TBLCONTRACTHISTORY_H',
'STG.STG_UT_VUT_TBLCONTRACTTYPE',
'STG.STG_UT_VUT_TBLCONTRACTTYPE_H',
'STG.STG_UT_VUT_TBLIMAGEQUEUE',
'STG.STG_UT_VUT_TBLIMAGEQUEUE_H',
'STG.STG_UT_VUT_TBLLENDER',
'STG.STG_UT_VUT_TBLLENDER_H',
'STG.STG_UT_WORK_QUEUE',
'STG.STG_UT_WORK_QUEUE_H',
'STG.TEMP_OPEN_CERTIFICATE',
'STG.VW_PBI_AVERAGE_BATCH_RUN_TIME',
'STG.VW_PBI_AVERAGE_TASKFLOW_RUN_TIME',
'STG.VW_PBI_COUNT_PERCENTAGE',
'STG.VW_PBI_CURRENT_EXECUTION_LIST',
'STG.VW_PBI_LONGEST_RUNNING_JOBS_REVIEW',
'STG.VW_PBI_PERCENTAGE_COMPLETE_RUNNING_TASKFLOW',
'STG.VW_PBI_TIME_BASED_PERCENTAGE',
'STG.VW_PBI_TOTAL_TASKFLOW_COUNT',
'STG.VW_PBI_TOTAL_TASKFLOW_COUNT_SOURCE_SYSTEM',
'STG.WIA_SRC')
--GROUP BY TABLE_TYPE




GRANT USAGE ON ALL FUNCTIONS IN SCHEMA BOND_STAGE.BOND	to ROLE read_bond_stage;
GRANT USAGE ON ALL FUNCTIONS IN SCHEMA BOND_STAGE.STG	to ROLE read_bond_stage;
GRANT USAGE ON ALL FUNCTIONS IN SCHEMA BOND_STAGE.TEMP	to ROLE read_bond_stage;
GRANT USAGE ON ALL FUNCTIONS IN SCHEMA BOND_STAGE.LND	to ROLE read_bond_stage;
GRANT USAGE ON ALL PROCEDURES IN SCHEMA BOND_STAGE.BOND	to ROLE read_bond_stage;
GRANT USAGE ON ALL PROCEDURES IN SCHEMA BOND_STAGE.STG	to ROLE read_bond_stage;
GRANT USAGE ON ALL PROCEDURES IN SCHEMA BOND_STAGE.TEMP	to ROLE read_bond_stage;
GRANT USAGE ON ALL PROCEDURES IN SCHEMA BOND_STAGE.LND	to ROLE read_bond_stage;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA BOND_STAGE.BOND	to ROLE read_bond_stage;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA BOND_STAGE.STG	to ROLE read_bond_stage;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA BOND_STAGE.TEMP	to ROLE read_bond_stage;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA BOND_STAGE.LND	to ROLE read_bond_stage;
		
GRANT USAGE ON ALL FUNCTIONS IN SCHEMA BOND_STAGE.BOND	to ROLE READWRITE_BOND_STAGE;
GRANT USAGE ON ALL FUNCTIONS IN SCHEMA BOND_STAGE.STG	to ROLE READWRITE_BOND_STAGE;
GRANT USAGE ON ALL FUNCTIONS IN SCHEMA BOND_STAGE.TEMP	to ROLE READWRITE_BOND_STAGE;
GRANT USAGE ON ALL FUNCTIONS IN SCHEMA BOND_STAGE.LND	to ROLE READWRITE_BOND_STAGE;
GRANT USAGE ON ALL PROCEDURES IN SCHEMA BOND_STAGE.BOND	to ROLE READWRITE_BOND_STAGE;
GRANT USAGE ON ALL PROCEDURES IN SCHEMA BOND_STAGE.STG	to ROLE READWRITE_BOND_STAGE;
GRANT USAGE ON ALL PROCEDURES IN SCHEMA BOND_STAGE.TEMP	to ROLE READWRITE_BOND_STAGE;
GRANT USAGE ON ALL PROCEDURES IN SCHEMA BOND_STAGE.LND	to ROLE READWRITE_BOND_STAGE;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA BOND_STAGE.BOND	to ROLE READWRITE_BOND_STAGE;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA BOND_STAGE.STG	to ROLE READWRITE_BOND_STAGE;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA BOND_STAGE.TEMP	to ROLE READWRITE_BOND_STAGE;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA BOND_STAGE.LND	to ROLE READWRITE_BOND_STAGE;
		
GRANT SELECT  ON ALL TABLES IN SCHEMA BOND_STAGE.BOND	to ROLE read_bond_stage;
GRANT SELECT  ON ALL TABLES IN SCHEMA BOND_STAGE.STG	to ROLE read_bond_stage;
GRANT SELECT  ON ALL TABLES IN SCHEMA BOND_STAGE.TEMP	to ROLE read_bond_stage;
GRANT SELECT  ON ALL TABLES IN SCHEMA BOND_STAGE.LND	to ROLE read_bond_stage;
		
GRANT SELECT  ON ALL TABLES IN SCHEMA BOND_STAGE.BOND	to ROLE READWRITE_BOND_STAGE;
GRANT SELECT  ON ALL TABLES IN SCHEMA BOND_STAGE.STG	to ROLE READWRITE_BOND_STAGE;
GRANT SELECT  ON ALL TABLES IN SCHEMA BOND_STAGE.TEMP	to ROLE READWRITE_BOND_STAGE;
GRANT SELECT  ON ALL TABLES IN SCHEMA BOND_STAGE.LND	to ROLE READWRITE_BOND_STAGE;
		
GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA BOND_STAGE.BOND	to ROLE READWRITE_BOND_STAGE;
GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA BOND_STAGE.STG	to ROLE READWRITE_BOND_STAGE;
GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA BOND_STAGE.TEMP	to ROLE READWRITE_BOND_STAGE;
GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA BOND_STAGE.LND	to ROLE READWRITE_BOND_STAGE;






