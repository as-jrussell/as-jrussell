use role accountadmin; 


CREATE OR REPLACE PROCEDURE DBA.INFO.GetRolePermissions("ROLE" VARCHAR(16777216), "PERMISSION" VARCHAR(16777216))
RETURNS TABLE ("PRIVILEGE" VARCHAR(16777216), "GRANTED_ON" VARCHAR(16777216),"NAME" VARCHAR(16777216), "TABLE_CATALOG" VARCHAR(16777216), "TABLE_SCHEMA" VARCHAR(16777216)
)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
BEGIN 
IF (PERMISSION = ''SELECT'') THEN
DECLARE
  res resultset default (
select  privilege, granted_on, name,table_catalog, table_schema
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
     where grantee_name = :ROLE
     and privilege in (''SELECT'')
	    and deleted_on is null 
     order by granted_on, name asc
   );
BEGIN
RETURN TABLE(RES);
END;
ELSEIF (PERMISSION = '''') THEN
DECLARE
  res resultset default (
select  privilege, granted_on, name,table_catalog, table_schema
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
     where grantee_name = :ROLE
     and privilege NOT in (''USAGE'', ''MONITOR'',''OPERATE'', ''SELECT'')
	    and deleted_on is null 
     order by granted_on, name asc
  );
BEGIN
RETURN TABLE(RES);
END;
ELSEIF (PERMISSION = ''USAGE'') THEN 
DECLARE
  res resultset default (
select  privilege, granted_on, name,table_catalog, table_schema
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
     where grantee_name = :ROLE
     and privilege in (''USAGE'', ''MONITOR'',''OPERATE'')
	    and deleted_on is null 
     order by granted_on, name asc
  );
BEGIN
RETURN TABLE(RES);
END;
ELSEIF (PERMISSION IN (select database_name from snowflake.account_usage.databases) AND ROLE <>'''') THEN 
DECLARE
  res resultset default (
select  privilege, granted_on, name,table_catalog, table_schema
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
     where grantee_name = :ROLE
	 and table_catalog = :PERMISSION
	    and deleted_on is null 
     order by granted_on, name asc
  );
BEGIN
RETURN TABLE(RES);
END;
ELSEIF (PERMISSION IN (select database_name from snowflake.account_usage.databases) AND ROLE ='''') THEN 
DECLARE
  res resultset default (
select  privilege, granted_on, grantee_name,table_catalog, table_schema
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
     where granted_on = ''DATABASE''
	 and table_catalog = :PERMISSION
	    and deleted_on is null 
     order by granted_on, name asc
  );
BEGIN
RETURN TABLE(RES);
END;
ELSEIF (PERMISSION = ''ALL'' and ROLE = '''') THEN
DECLARE
  res resultset default (
SELECT grantee_name||'' has ''||privilege, granted_on, ''null'' ,table_catalog, table_schema
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES

UNION 
SELECT grantee_name||'' has ''||privilege, granted_on, ''null'' ,table_catalog, table_schema
     from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
     where GRANTED_ON IN (''ROLE'')
   order by  TABLE_CATALOG asc  
     );
BEGIN
RETURN TABLE(RES);
END;
END IF;
END;'
;