USE ROLE ACCOUNTADMIN;
USE WAREHOUSE EDW_PROD_INFA_WH;
USE DATABASE EDW_TEST;


--Last 5 users created     
    select top 5 *
     from SNOWFLAKE.ACCOUNT_USAGE.USERS
      ORDER BY CREATED_ON DESC

  --By user login must be in capital letters to find the username 
    select top 5 *
     from SNOWFLAKE.ACCOUNT_USAGE.USERS
    where login_name = 'JRUSSELL'
      ORDER BY CREATED_ON DESC
    
    --users and their groupa
    select  ROLE,
            GRANTEE_NAME,
            GRANTED_BY,*
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS
    ORDER BY CREATED_ON DESC

--By grantee name must be in capital letters to find the username 
select  ROLE,
            GRANTEE_NAME,
            GRANTED_BY,*
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS
        where grantee_name = 'JRUSSELL'
    ORDER BY CREATED_ON DESC


--Show what access users has 
SHOW GRANTS TO USER identifier('"SVC_SNOW_STG01"');

--Show what access users has 
SHOW GRANTS TO USER identifier('"INFATOSNOWFLAKEPROD"');


---Show Grants to warehouse
SHOW GRANTS ON WAREHOUSE bond_test_infa_wh

---Show Grants to user
show grants to user ACONDE; 

--Shows Permissions 
SHOW GRANTS TO ROLE EDW_CONTRACTORS;
 
--Show users 
SHOW GRANTS OF EDW_CONTRACTORS;

 
--Show users 
SHOW GRANTS OF EDW_BI_READER;
SHOW GRANTS OF EDW_PROD_SUPPORT;
SHOW GRANTS OF DATASCIENCE;
SHOW GRANTS OF OWNER_EDW_PROD;

--Show users 
SHOW GRANTS OF EDW_BI_READER;

--Show access by database
SHOW FUTURE GRANTS IN DATABASE SNOWFLAKE ;

--Show access by warehouse
SHOW GRANTS ON  STG_UT_FINANCIAL_TXN ;

--Show access by schema (database.schema)
show future grants in schema STG.delim_lkp;

--Show access by table (schema.table)
show grants on table EDW_TEST.STG.STG_UT_INTERACTION_HISTORY_ARCHIVE;

--Show Warehouse
show warehouses like 'webfocus%';



/*

--Fult Time Employee Generic
--GRANT ROLE "EDW_ALLIED_EMPLOYEES" TO USER "JRUSSELL";
--GRANT ROLE "EDW_PROD_SUPPORT" TO USER "JRUSSELL";

--OnShore Contractor
--GRANT ROLE "EDW_CONTRACTORS" to USER "JRUSSELL";
--GRANT ROLE "EDW_PROD_CONTRACTORS" TO USER "JRUSSELL";

--Off Shore Contractors
--GRANT ROLE "EDW_CONTRACTORS" to USER "JRUSSELL";


--Other areas that get users may request

--GRANT ROLE "EDW_BI_READER" to USER "JRUSSELL";
--GRANT ROLE "BOND_ALLIED_EMPLOYEES" TO USER "JRUSSELL";
--GRANT ROLE DATASCIENCE to USER JRUSSELL  ;
--GRANT ROLE "BOND_ALLIED_EMPLOYEES" TO USER "JRUSSELL";

--Revoke roles from users  (These are commented out in the event this gets accidentally fully ran )
--REVOKE ROLE "EDW_ALLIED_EMPLOYEES"  FROM USER "JRUSSELL";
--REVOKE ROLE "BOND_ALLIED_EMPLOYEES"  FROM USER "JRUSSELL"
--REVOKE ROLE DATASCIENCE to USER JRUSSELL  ;
--REVOKE ROLE EDW_BI_READER FROM USER JRUSSELL ; 
--REVOKE ROLE EDW_PROD_SUPPORT FROM  USER JRUSSELL  ;



----Grant import users to shared database  
(https://community.snowflake.com/s/article/Error-Granting-individual-privileges-on-imported-database-is-not-allowed-Use-GRANT-IMPORTED-PRIVILEGES-instead)
--grant IMPORTED PRIVILEGES on database SNOWFLAKE to role OWNER_EDW_DEV; 
--revoke IMPORTED PRIVILEGES on database SNOWFLAKE FROM EDW_CONTRACTORS



grant usage on database EDW_TEST to role OWNER_EDW_PROD;
GRANT SELECT ON FUTURE TABLES IN SCHEMA "EDW_TEST"."STG" TO ROLE "OWNER_EDW_PROD";
grant select on future tables in database EDW_TEST to role OWNER_EDW_PROD;

*/

/*
Last time user logged in: 

select *
from table(information_schema.login_history_by_user('jrussell', result_limit=>1000))
order by event_timestamp;


select *
from table(information_schema.login_history(dateadd('hours',-3,current_timestamp()),current_timestamp()))
order by event_timestamp desc;


select *
from table(information_schema.login_history(dateadd('hours',-48,current_timestamp()),current_timestamp()))
WHERE REPORTED_CLIENT_TYPE = 'SNOWFLAKE_UI'
order by event_timestamp desc;




select *
from table(information_schema.login_history(dateadd('day',-6,current_timestamp()),current_timestamp()))
WHERE ERROR_MESSAGE is not null
order by event_timestamp desc;

select *
from table(information_schema.login_history(dateadd('hours',-3,current_timestamp()),current_timestamp()))
WHERE REPORTED_CLIENT_TYPE != 'SNOWFLAKE_UI'
order by event_timestamp desc;

https://community.snowflake.com/s/article/How-to-grant-select-on-all-future-tables-in-a-schema-and-database-level

1. Schema level:
 
use role accountadmin;
create database MY_DB;
grant usage on database MY_DB to role TEST_ROLE;
grant usage on schema MY_DB.MY_SCHEMA to role TEST_ROLE;
grant select on future tables in schema MY_DB.MY_SCHEMA to role TEST_ROLE;


 2. Database Level:  (assuming the privileges are granted from scratch)
 
use role accountadmin;
create database MY_DB;
grant usage on database MY_DB to role TEST_ROLE;
grant usage on future schemas in database MY_DB to role TEST_ROLE;
grant select on future tables in database MY_DB to role TEST_ROLE;



SELECT system$generate_scim_access_token('GENERIC_SCIM_PROVISIONING'); 


 SELECT  ROLE_NAME FROM SNOWFLAKE.INFORMATION_SCHEMA.APPLICABLE_ROLES
     START WITH GRANTEE in(select distinct ROLE from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS GTU 
    join  SNOWFLAKE.ACCOUNT_USAGE.USERS u on u.name = GTU.grantee_name
        where GTU.DELETED_ON is NULL AND not U.DISABLED AND not
 U.SNOWFLAKE_LOCK and U.DELETED_ON is null and U.LOGIN_NAME ='USER' ) 
    CONNECT BY GRANTEE = PRIOR ROLE_NAME

*/







