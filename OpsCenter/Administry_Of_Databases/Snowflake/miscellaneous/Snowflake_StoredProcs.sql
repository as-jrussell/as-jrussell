CREATE OR REPLACE PROCEDURE DBA.INFO.USER_ROLES("USER_ROLES" VARCHAR(16777216))
RETURNS TABLE ("ROLE" VARCHAR(16777216), "GRANTEE_NAME" VARCHAR(16777216), "GRANTED_BY" VARCHAR(16777216))
LANGUAGE SQL
EXECUTE AS OWNER
AS '
BEGIN
IF (USER_ROLES NOT IN (''ACCOUNTADMIN'',
''BOND_ALLIED_EMPLOYEES'',
''BOND_CONTRACTORS'',
''DATASCIENCE'',
''EDW_ALLIED_EMPLOYEES'',
''EDW_ANALYSTS'',
''EDW_BI_READER'',
''EDW_CONTRACTORS'',
''EDW_PROD_CONTRACTORS'',
''EDW_PROD_SUPPORT'',
''EDW_SANDBOX_USERS'',
''EDW_STG_CONTRACTORS'',
''GENERIC_SCIM_PROVISIONER'',
''MONITOR_ALL'',
''ORGADMIN'',
''OWNER_BOND_DEV'',
''OWNER_BOND_PROD'',
''OWNER_BOND_TEST'',
''OWNER_EDW_DEV'',
''OWNER_EDW_PROD'',
''OWNER_EDW_PRODSUPPORT'',
''OWNER_EDW_STGSUPPORT'',
''OWNER_EDW_TEST'',
''PUBLIC'',
''READWRITE_BOND_DEV'',
''READWRITE_BOND_PROD'',
''READWRITE_BOND_TEST'',
''READWRITE_EDW_DEV'',
''READWRITE_EDW_PROD'',
''READWRITE_EDW_PRODSUPPORT'',
''READWRITE_EDW_STGSUPPORT'',
''READWRITE_EDW_TEST'',
''READ_ALL'',
''READ_ALL_DEV'',
''READ_ALL_PROD'',
''READ_ALL_TEST'',
''READ_BOND_DEV'',
''READ_BOND_PROD'',
''READ_BOND_TEST'',
''READ_EDW_DEV'',
''READ_EDW_PROD'',
''READ_EDW_PRODSUPPORT'',
''READ_EDW_STGSUPPORT'',
''READ_EDW_TEST'',
''READ_MBP_EDW_DEV'',
''READ_MBP_EDW_PROD'',
''READ_MBP_EDW_TEST'',
''SECURITYADMIN'',
''SYSADMIN'',
''USERADMIN'')) THEN 
DECLARE
  res resultset default (
  
  
        select DISTINCT  ROLE,
            GRANTEE_NAME,
            GRANTED_BY
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS
        where grantee_name = :USER_ROLES
        and deleted_on is null
   )
    ;
BEGIN
RETURN TABLE(RES);
END;
ELSEIF (USER_ROLES IN (''ACCOUNTADMIN'',
''BOND_ALLIED_EMPLOYEES'',
''BOND_CONTRACTORS'',
''DATASCIENCE'',
''EDW_ALLIED_EMPLOYEES'',
''EDW_ANALYSTS'',
''EDW_BI_READER'',
''EDW_CONTRACTORS'',
''EDW_PROD_CONTRACTORS'',
''EDW_PROD_SUPPORT'',
''EDW_SANDBOX_USERS'',
''EDW_STG_CONTRACTORS'',
''GENERIC_SCIM_PROVISIONER'',
''MONITOR_ALL'',
''ORGADMIN'',
''OWNER_BOND_DEV'',
''OWNER_BOND_PROD'',
''OWNER_BOND_TEST'',
''OWNER_EDW_DEV'',
''OWNER_EDW_PROD'',
''OWNER_EDW_PRODSUPPORT'',
''OWNER_EDW_STGSUPPORT'',
''OWNER_EDW_TEST'',
''PUBLIC'',
''READWRITE_BOND_DEV'',
''READWRITE_BOND_PROD'',
''READWRITE_BOND_TEST'',
''READWRITE_EDW_DEV'',
''READWRITE_EDW_PROD'',
''READWRITE_EDW_PRODSUPPORT'',
''READWRITE_EDW_STGSUPPORT'',
''READWRITE_EDW_TEST'',
''READ_ALL'',
''READ_ALL_DEV'',
''READ_ALL_PROD'',
''READ_ALL_TEST'',
''READ_BOND_DEV'',
''READ_BOND_PROD'',
''READ_BOND_TEST'',
''READ_EDW_DEV'',
''READ_EDW_PROD'',
''READ_EDW_PRODSUPPORT'',
''READ_EDW_STGSUPPORT'',
''READ_EDW_TEST'',
''READ_MBP_EDW_DEV'',
''READ_MBP_EDW_PROD'',
''READ_MBP_EDW_TEST'',
''SECURITYADMIN'',
''SYSADMIN'',
''USERADMIN'')) THEN 
DECLARE
  res resultset default (
  
  
        select  DISTINCT ROLE,
            GRANTEE_NAME,
            GRANTED_BY
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS
        where ROLE = :USER_ROLES
        and deleted_on is null
    )
    ;
BEGIN
RETURN TABLE(RES);
END;



END IF;
END;
';

---roles users are in and last time they logged into specific role



use database DBA;
use schema INFO;


CREATE or replace procedure user_roles_lastlogin ( user_groups VARCHAR)
returns TABLE (USER_NAME VARCHAR, ROLE_NAME VARCHAR,  FIRST_LOGIN TIMESTAMP_LTZ(6), LAST_LOGIN TIMESTAMP_LTZ(6), LOGINS integer )
LANGUAGE SQL
AS 
DECLARE
  res resultset default (
  
  
 SELECT DISTINCT USER_NAME, ROLE_NAME,MIN(START_TIME) AS FIRST_LOGIN,MAX(END_TIME) AS LAST_LOGIN,COUNT(*) AS LOGINS
FROM "SNOWFLAKE"."ACCOUNT_USAGE"."QUERY_HISTORY"
WHERE  USER_NAME = :user_groups
GROUP BY USER_NAME, ROLE_NAME       
   ORDER BY MAX(END_TIME) DESC, COUNT(*) DESC      )
    ;
BEGIN
RETURN TABLE(RES);
END;


---Users added to Snowflake in last 30 days
use database DBA;
use schema INFO;


CREATE or replace procedure lastlogin_created ()
returns TABLE (AccountStatus VARCHAR, created_on TIMESTAMP_LTZ(6), login_name VARCHAR, first_name VARCHAR, last_name VARCHAR,display_name VARCHAR, email VARCHAR, LAST_SUCCESS_LOGIN TIMESTAMP_LTZ(6)  )
LANGUAGE SQL
AS 
DECLARE
  res resultset default (
  
     select   CASE WHEN disabled = 'true' THEN 'Account Deactivated' ELSE 'Account Active' END AS AccountStatus, created_on,  login_name, first_name, last_name,display_name, email, LAST_SUCCESS_LOGIN 
     from SNOWFLAKE.ACCOUNT_USAGE.USERS
     where  Cast(created_on AS DATE) >= Cast(current_date()-30 AS DATE)
      ORDER BY CREATED_ON DESC
   )
    ;
BEGIN
RETURN TABLE(RES);
END;

CREATE OR REPLACE PROCEDURE DBA.DEPLOY.USER_ACCESS("USER_ACESS" VARCHAR, "EMPLOYEE" VARCHAR )
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS OWNER

AS 

/*

---For DBAs

CALL DBA.DEPLOY.USER_ACCESS('JRUSSELL', 'DBA');

---For Employees

CALL DBA.DEPLOY.USER_ACCESS('JRUSSELL', 'Allied');

---For Contractor

CALL DBA.DEPLOY.USER_ACCESS('JRUSSELL', 'Contractor');

---For OffShore

CALL DBA.DEPLOY.USER_ACCESS('JRUSSELL', 'OffShore');
*/
'


1BEGIN
    IF (EMPLOYEE = ''Allied'') THEN
declare
user_access varchar default USER_ACESS;
2begin


 execute immediate ''grant role EDW_ALLIED_EMPLOYEES to user '' || :USER_ACCESS;
2end;
    RETURN ''USER ADDED TO EDW_ALLIED_EMPLOYEES ROLE(s)'';
    ELSEIF (EMPLOYEE = ''Contractor'') THEN
     declare
user_access varchar default USER_ACESS;

3begin
    execute immediate ''grant role EDW_CONTRACTORS to user '' || :USER_ACCESS;
    execute immediate ''grant role EDW_PROD_CONTRACTORS to user '' || :USER_ACCESS;
3end;
    RETURN ''USER ADDED TO EDW_CONTRACTORS AND EDW_PROD_CONTRACTORS ROLE(s)'';
   ELSEIF (EMPLOYEE = ''Offshore'') THEN
      	declare
user_access varchar default USER_ACESS;

4begin
    execute immediate ''grant role EDW_CONTRACTORS to user '' || :USER_ACCESS;
4end;
    RETURN ''USER ADDED TO EDW_CONTRACTORS ROLE ONLY'';
  ELSEIF (EMPLOYEE = ''DBA'') THEN
declare
user_access varchar default USER_ACESS;

5begin
    execute immediate ''grant role EDW_ALLIED_EMPLOYEES to user '' || :USER_ACCESS;
    execute immediate ''grant role ACCOUNTADMIN to user '' || :USER_ACCESS;
    execute immediate ''grant role SYSADMIN to user '' || :USER_ACCESS;
    execute immediate ''grant role ORGADMIN to user '' || :USER_ACCESS;
5end;
    RETURN ''USER ADDED TO EDW_ALLIED_EMPLOYEES, ACCOUNTADMIN, SYSADMIN, ORGADMIN ROLE(s)'';
     ELSE
     declare
user_access varchar default USER_ACESS;
EMPLOYEE varchar default EMPLOYEE;

6begin
     execute immediate ''grant role '' || EMPLOYEE || '' to user '' || :USER_ACESS;
     6end;
      RETURN ''USER ADDED TO Unique Group'';
     END IF;
END;'
