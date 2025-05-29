USE ROLE accountadmin;

use warehouse edw_stage_med_wh;

use database dba;


--Eliminated users whom had both default role and default warehouse

create temporary table temp_demo_data_ROLES as
        select DISTINCT  
            GRANTEE_NAME, ROLE,
            DEFAULT_ROLE, DEFAULT_WAREHOUSE
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS GU
     join snowflake.account_usage.users U on GU.GRANTEE_NAME = U.NAME 
        where   GU.deleted_on is null
        and U.deleted_on is nulL
        
        AND GRANTEE_NAME NOT IN (      select DISTINCT  
            GRANTEE_NAME
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS GU
     join snowflake.account_usage.users U on GU.GRANTEE_NAME = U.NAME 
        where (DEFAULT_ROLE IS NOT NULL and DEFAULT_WAREHOUSE IS NOT NULL));



--Shows all users, first, last login, role used and how many times

create temporary table temp_demo_data_lASTLOGIN as
   SELECT DISTINCT WAREHOUSE_NAME, USER_NAME, ROLE_NAME,MIN(START_TIME) AS FIRST_LOGIN,MAX(END_TIME) AS LAST_LOGIN,COUNT(*) AS LOGINS
FROM "SNOWFLAKE"."ACCOUNT_USAGE"."QUERY_HISTORY"
GROUP BY USER_NAME, ROLE_NAME, WAREHOUSE_NAME      
   ORDER BY MAX(END_TIME) DESC, COUNT(*) DESC;       



---Shows all the users that need to have default warehouse/roles added. If users did not use a warehouse by chance it was default to dev warehouse and webfocus was moved to datascience (x-small)
create temporary table temp_demo_data_DEFUALTS as

 select GRANTEE_NAME, CASE WHEN MAX(LL.WAREHOUSE_NAME) = 'WEBFOCUS' THEN 'DATASCIENCE' WHEN MAX(LL.WAREHOUSE_NAME) IS NOT NULL THEN MAX(LL.WAREHOUSE_NAME)ELSE 'EDW_DEV_BI_WH' END  AS WAREHOUSE_NAME, 
 MAX(LL.ROLE_NAME) AS ROLE_NAME, MAX(LOGINs) AS COUNT
   from temp_demo_data_ROLES R
   join temp_demo_data_lASTLOGIN LL on R.GRANTEE_NAME =LL.USER_NAME anD R.ROLE = LL.ROLE_NAME
   group BY R.GRANTEE_NAME
ORDER BY MAX(LOGINs) DESC;


----Script out the users (removed DBA team; JC already had defaults at the time of this work)
SELECT DISTINCT 'alter USER IDENTIFIER(''"' || GRANTEE_NAME || '"'')   set DEFAULT_ROLE = ''' ||ROLE_NAME || ''' DEFAULT_WAREHOUSE = ''' || WAREHOUSE_NAME || ''';'
FROM temp_demo_data_DEFUALTS
where GRANTEE_NAME not in ('SMORAN','HBROTHERTON', 'LRENSBERGER','MBREITSCH','VAZAMBU')

