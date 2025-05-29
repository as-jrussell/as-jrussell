USE ROLE ACCOUNTADMIN;



CREATE OR REPLACE PROCEDURE DBA.INFO.GetUserRoles("USER_ROLES" VARCHAR(16777216))
RETURNS TABLE ("ROLE" VARCHAR(16777216), "GRANTEE_NAME" VARCHAR(16777216),"DEFAULT_ROLE" VARCHAR(16777216), "DEFAULT_WAREHOUSE" VARCHAR(16777216)
)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
BEGIN
IF (USER_ROLES IN (select name from snowflake.account_usage.roles)) THEN 
DECLARE
  res resultset default (
  
  
        select DISTINCT  ROLE,
            GRANTEE_NAME,
            DEFAULT_ROLE, DEFAULT_WAREHOUSE
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS GU
     join snowflake.account_usage.users U on GU.GRANTEE_NAME = U.NAME 
        where   ROLE = :USER_ROLES
        and GU.deleted_on is null
        and U.deleted_on is null
   )
    ;
BEGIN
RETURN TABLE(RES);
END;
ELSEIF (USER_ROLES IN (SELECT GU.NAME FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES GU WHERE granted_on = ''WAREHOUSE'')) THEN
DECLARE 
  res resultset default (
  
           select  DISTINCT  ''NULL'',
            GRANTEE_NAME,
             DEFAULT_ROLE, DEFAULT_WAREHOUSE
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS GU
     join snowflake.account_usage.users U on GU.GRANTEE_NAME = U.NAME 
        where   DEFAULT_WAREHOUSE = :USER_ROLES
        and GU.deleted_on is null
        and U.deleted_on is null

  )
    ;
BEGIN
RETURN TABLE(RES);
END;
ELSEIF (USER_ROLES = ''NoRole'') THEN 
DECLARE
  res resultset default (
  
            select  DISTINCT  ''NULL'',
            GRANTEE_NAME,
           DEFAULT_ROLE, DEFAULT_WAREHOUSE
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS GU
     join snowflake.account_usage.users U on GU.GRANTEE_NAME = U.NAME 
       where DEFAULT_ROLE IS NULL
        and GU.deleted_on is null
        and U.deleted_on is null

      
   )
    ;
BEGIN
RETURN TABLE(RES);
END;

ELSEIF (USER_ROLES = ''NoWarehouse'') THEN 
DECLARE
  res resultset default (
  
             select  DISTINCT  ''NULL'',
            GRANTEE_NAME,
            DEFAULT_ROLE, DEFAULT_WAREHOUSE
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS GU
     join snowflake.account_usage.users U on GU.GRANTEE_NAME = U.NAME 
       where DEFAULT_WAREHOUSE IS NULL
        and GU.deleted_on is null
        and U.deleted_on is null

   )
    ;
BEGIN
RETURN TABLE(RES);
END;
ELSE
DECLARE
  res resultset default (
  
  
        select DISTINCT  ROLE,
            GRANTEE_NAME,
             DEFAULT_ROLE, DEFAULT_WAREHOUSE
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS GU
     join snowflake.account_usage.users U on GU.GRANTEE_NAME = U.NAME 
          where grantee_name = :USER_ROLES
        and GU.deleted_on is null
        and U.deleted_on is null
    )
    ;
BEGIN
RETURN TABLE(RES);
END;
END IF;
END;
';

