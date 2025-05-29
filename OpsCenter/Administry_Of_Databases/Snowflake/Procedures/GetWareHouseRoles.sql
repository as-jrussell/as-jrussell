USE ROLE ACCOUNTADMIN;



CREATE OR REPLACE PROCEDURE DBA.INFO.GetWareHouseRoles("WAREHOUSE" VARCHAR(16777216))
RETURNS TABLE ("WAREHOUSE" VARCHAR(16777216), "ROLES" VARCHAR(16777216), "PRIVILEGE" VARCHAR(16777216),"DESCRIPTION" VARCHAR(16777216))
LANGUAGE SQL
EXECUTE AS OWNER
AS '

BEGIN 
IF (WAREHOUSE IN (SELECT GU.NAME FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES GU WHERE granted_on = ''WAREHOUSE'')) THEN
DECLARE 
  res resultset default (
  SELECT
GU.NAME,GU.GRANTEE_NAME, GU.PRIVILEGE,
case when GU.PRIVILEGE = ''MONITOR'' then ''Enables viewing current and past queries executed on a warehouse as well as usage statistics on that warehouse.''
when GU.PRIVILEGE = ''MODIFY'' THEN ''Enables altering any properties of a warehouse, including changing its size.''
when GU.PRIVILEGE = ''OPERATE'' THEN ''Enables changing the state of a warehouse (stop, start, suspend, resume). In addition, enables viewing current and past queries executed on a warehouse and aborting any executing queries.''
when GU.PRIVILEGE = ''USAGE'' THEN ''Enables using a virtual warehouse and, as a result, executing queries on the warehouse. If the warehouse is configured to auto-resume when a SQL statement (e.g. query) is submitted to it, the warehouse resumes automatically and executes the statement.''
when GU.PRIVILEGE = ''OWNERSHIP'' THEN ''Grants full control over a user/role. Only a single role can hold this privilege on a specific object at a time.''
END as DESCRIPTION
FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES GU
WHERE granted_on = ''WAREHOUSE'' and deleted_on is null  
AND NAME = :WAREHOUSE
ORDER BY NAME ASC
   )
    ;
BEGIN
RETURN TABLE(RES);
END;

ELSE
DECLARE
  res resultset default (
  
  SELECT
GU.NAME,GU.GRANTEE_NAME, GU.PRIVILEGE,
case when GU.PRIVILEGE = ''MONITOR'' then ''Enables viewing current and past queries executed on a warehouse as well as usage statistics on that warehouse.''
when GU.PRIVILEGE = ''MODIFY'' THEN ''Enables altering any properties of a warehouse, including changing its size.''
when GU.PRIVILEGE = ''OPERATE'' THEN ''Enables changing the state of a warehouse (stop, start, suspend, resume). In addition, enables viewing current and past queries executed on a warehouse and aborting any executing queries.''
when GU.PRIVILEGE = ''USAGE'' THEN ''Enables using a virtual warehouse and, as a result, executing queries on the warehouse. If the warehouse is configured to auto-resume when a SQL statement (e.g. query) is submitted to it, the warehouse resumes automatically and executes the statement.''
when GU.PRIVILEGE = ''OWNERSHIP'' THEN ''Grants full control over a user/role. Only a single role can hold this privilege on a specific object at a time.''
END as DESCRIPTION
FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES GU
WHERE granted_on = ''WAREHOUSE'' and deleted_on is null  
ORDER BY NAME ASC


    )
    ;
BEGIN
RETURN TABLE(RES);
END;
END IF;
END;
';