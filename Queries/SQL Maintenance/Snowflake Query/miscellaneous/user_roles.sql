USE ROLE ACCOUNTADMIN;





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