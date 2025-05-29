use role accountadmin; 
USE DATABASE EDW_PROD; 

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







CREATE OR REPLACE PROCEDURE DBA.SetPermission("USER_ACCESS" VARCHAR(16777216), "SCH" VARCHAR(16777216), "OBJ" VARCHAR(16777216))
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS OWNER
AS

/*

CALL DBA.DEPLOY.SetPermission('USERNAME', 'SCHEMA','OBJECT');

*/


'
BEGIN
 IF (USER_ACCESS IN (''OWNER_EDW_DEV'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA EDW_DEV.''|| :SCH || '' to ROLE READWRITE_EDW_DEV'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA EDW_DEV.''|| :SCH || '' to ROLE READ_EDW_DEV'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA EDW_DEV.''|| :SCH || '' to ROLE READWRITE_EDW_DEV'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA EDW_DEV.''|| :SCH || '' to ROLE READ_EDW_DEV'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 

ELSEIF (USER_ACCESS IN (''OWNER_BOND_DEV'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA BOND_DEV.''|| :SCH || '' to ROLE READWRITE_BOND_DEV'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA BOND_DEV.''|| :SCH || '' to ROLE READ_BOND_DEV'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA BOND_DEV.''|| :SCH || '' to ROLE READWRITE_BOND_DEV'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA BOND_DEV.''|| :SCH || '' to ROLE READ_BOND_DEV'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 

ELSEIF (USER_ACCESS IN (''OWNER_BOND_TEST'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA BOND_TEST.''|| :SCH || '' to ROLE READWRITE_BOND_TEST'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA BOND_TEST.''|| :SCH || '' to ROLE READ_BOND_TEST'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA BOND_TEST.''|| :SCH || '' to ROLE READWRITE_BOND_TEST'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA BOND_TEST.''|| :SCH || '' to ROLE READ_BOND_TEST'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 

ELSEIF (USER_ACCESS IN (''OWNER_EDW_TEST'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA EDW_TEST.''|| :SCH || '' to ROLE READWRITE_EDW_TEST'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA EDW_TEST.''|| :SCH || '' to ROLE READ_EDW_TEST'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA EDW_TEST.''|| :SCH || '' to ROLE READWRITE_EDW_TEST'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA EDW_TEST.''|| :SCH || '' to ROLE READ_EDW_TEST'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 


ELSEIF (USER_ACCESS IN (''OWNER_BOND_STAGE'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA BOND_STAGE.''|| :SCH || '' to ROLE READWRITE_BOND_STAGE'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA BOND_STAGE.''|| :SCH || '' to ROLE READ_BOND_STAGE'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA BOND_STAGE.''|| :SCH || '' to ROLE READWRITE_BOND_STAGE'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA BOND_STAGE.''|| :SCH || '' to ROLE READ_BOND_STAGE'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 


ELSEIF (USER_ACCESS IN (''OWNER_EDW_STGSUPPORT'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA EDW_STAGE.''|| :SCH || '' to ROLE READWRITE_EDW_STAGE'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA EDW_STAGE.''|| :SCH || '' to ROLE READ_EDW_STAGE'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA EDW_STAGE.''|| :SCH || '' to ROLE READWRITE_EDW_STAGE'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA EDW_STAGE.''|| :SCH || '' to ROLE READ_EDW_STAGE'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 


ELSEIF (USER_ACCESS IN (''OWNER_BOND_PROD'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA BOND_PROD.''|| :SCH || '' to ROLE READWRITE_BOND_PROD'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA BOND_PROD.''|| :SCH || '' to ROLE READ_BOND_PROD'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA BOND_PROD.''|| :SCH || '' to ROLE READWRITE_BOND_PROD'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA BOND_PROD.''|| :SCH || '' to ROLE READ_BOND_PROD'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 

ELSEIF (USER_ACCESS IN (''OWNER_EDW_PROD'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READWRITE_OWNER_EDW'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READ_OWNER_EDW'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READWRITE_OWNER_EDW'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READ_OWNER_EDW'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 


ELSEIF (USER_ACCESS IN (''OWNER_EDW_PRODSUPPORT'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READWRITE_EDW_PRODSUPPORT'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READ_EDW_PRODSUPPORT'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READWRITE_EDW_PRODSUPPORT'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READ_EDW_PRODSUPPORT'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 
    
     END IF;
END;';




grant usage on procedure DBA.GetPermissionMismatch() to role OWNER_EDW_PROD;
grant usage on procedure DBA.SetPermission(VARCHAR, VARCHAR, VARCHAR) to role OWNER_EDW_PROD;


use role accountadmin; 
USE DATABASE EDW_PRODSUPPORT; 

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







CREATE OR REPLACE PROCEDURE DBA.SetPermission("USER_ACCESS" VARCHAR(16777216), "SCH" VARCHAR(16777216), "OBJ" VARCHAR(16777216))
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS OWNER
AS

/*

CALL DBA.DEPLOY.SetPermission('USERNAME', 'SCHEMA','OBJECT');

*/


'
BEGIN
 IF (USER_ACCESS IN (''OWNER_EDW_DEV'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA EDW_DEV.''|| :SCH || '' to ROLE READWRITE_EDW_DEV'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA EDW_DEV.''|| :SCH || '' to ROLE READ_EDW_DEV'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA EDW_DEV.''|| :SCH || '' to ROLE READWRITE_EDW_DEV'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA EDW_DEV.''|| :SCH || '' to ROLE READ_EDW_DEV'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 

ELSEIF (USER_ACCESS IN (''OWNER_BOND_DEV'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA BOND_DEV.''|| :SCH || '' to ROLE READWRITE_BOND_DEV'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA BOND_DEV.''|| :SCH || '' to ROLE READ_BOND_DEV'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA BOND_DEV.''|| :SCH || '' to ROLE READWRITE_BOND_DEV'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA BOND_DEV.''|| :SCH || '' to ROLE READ_BOND_DEV'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 

ELSEIF (USER_ACCESS IN (''OWNER_BOND_TEST'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA BOND_TEST.''|| :SCH || '' to ROLE READWRITE_BOND_TEST'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA BOND_TEST.''|| :SCH || '' to ROLE READ_BOND_TEST'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA BOND_TEST.''|| :SCH || '' to ROLE READWRITE_BOND_TEST'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA BOND_TEST.''|| :SCH || '' to ROLE READ_BOND_TEST'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 

ELSEIF (USER_ACCESS IN (''OWNER_EDW_TEST'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA EDW_TEST.''|| :SCH || '' to ROLE READWRITE_EDW_TEST'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA EDW_TEST.''|| :SCH || '' to ROLE READ_EDW_TEST'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA EDW_TEST.''|| :SCH || '' to ROLE READWRITE_EDW_TEST'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA EDW_TEST.''|| :SCH || '' to ROLE READ_EDW_TEST'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 


ELSEIF (USER_ACCESS IN (''OWNER_BOND_STAGE'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA BOND_STAGE.''|| :SCH || '' to ROLE READWRITE_BOND_STAGE'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA BOND_STAGE.''|| :SCH || '' to ROLE READ_BOND_STAGE'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA BOND_STAGE.''|| :SCH || '' to ROLE READWRITE_BOND_STAGE'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA BOND_STAGE.''|| :SCH || '' to ROLE READ_BOND_STAGE'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 


ELSEIF (USER_ACCESS IN (''OWNER_EDW_STGSUPPORT'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA EDW_STAGE.''|| :SCH || '' to ROLE READWRITE_EDW_STAGE'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA EDW_STAGE.''|| :SCH || '' to ROLE READ_EDW_STAGE'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA EDW_STAGE.''|| :SCH || '' to ROLE READWRITE_EDW_STAGE'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA EDW_STAGE.''|| :SCH || '' to ROLE READ_EDW_STAGE'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 


ELSEIF (USER_ACCESS IN (''OWNER_BOND_PROD'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA BOND_PROD.''|| :SCH || '' to ROLE READWRITE_BOND_PROD'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA BOND_PROD.''|| :SCH || '' to ROLE READ_BOND_PROD'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA BOND_PROD.''|| :SCH || '' to ROLE READWRITE_BOND_PROD'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA BOND_PROD.''|| :SCH || '' to ROLE READ_BOND_PROD'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 

ELSEIF (USER_ACCESS IN (''OWNER_EDW_PROD'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READWRITE_OWNER_EDW'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READ_OWNER_EDW'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READWRITE_OWNER_EDW'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READ_OWNER_EDW'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 


ELSEIF (USER_ACCESS IN (''OWNER_EDW_PRODSUPPORT'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READWRITE_EDW_PRODSUPPORT'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READ_EDW_PRODSUPPORT'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READWRITE_EDW_PRODSUPPORT'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READ_EDW_PRODSUPPORT'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 
    
     END IF;
END;';




grant usage on procedure DBA.GetPermissionMismatch() to role OWNER_EDW_PRODSUPPORT;
grant usage on procedure DBA.SetPermission(VARCHAR, VARCHAR, VARCHAR) to role OWNER_EDW_PRODSUPPORT;



use role accountadmin; 
USE DATABASE BOND_PROD; 

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







CREATE OR REPLACE PROCEDURE DBA.SetPermission("USER_ACCESS" VARCHAR(16777216), "SCH" VARCHAR(16777216), "OBJ" VARCHAR(16777216))
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS OWNER
AS

/*

CALL DBA.DEPLOY.SetPermission('USERNAME', 'SCHEMA','OBJECT');

*/


'
BEGIN
 IF (USER_ACCESS IN (''OWNER_EDW_DEV'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA EDW_DEV.''|| :SCH || '' to ROLE READWRITE_EDW_DEV'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA EDW_DEV.''|| :SCH || '' to ROLE READ_EDW_DEV'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA EDW_DEV.''|| :SCH || '' to ROLE READWRITE_EDW_DEV'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA EDW_DEV.''|| :SCH || '' to ROLE READ_EDW_DEV'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 

ELSEIF (USER_ACCESS IN (''OWNER_BOND_DEV'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA BOND_DEV.''|| :SCH || '' to ROLE READWRITE_BOND_DEV'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA BOND_DEV.''|| :SCH || '' to ROLE READ_BOND_DEV'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA BOND_DEV.''|| :SCH || '' to ROLE READWRITE_BOND_DEV'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA BOND_DEV.''|| :SCH || '' to ROLE READ_BOND_DEV'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 

ELSEIF (USER_ACCESS IN (''OWNER_BOND_TEST'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA BOND_TEST.''|| :SCH || '' to ROLE READWRITE_BOND_TEST'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA BOND_TEST.''|| :SCH || '' to ROLE READ_BOND_TEST'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA BOND_TEST.''|| :SCH || '' to ROLE READWRITE_BOND_TEST'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA BOND_TEST.''|| :SCH || '' to ROLE READ_BOND_TEST'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 

ELSEIF (USER_ACCESS IN (''OWNER_EDW_TEST'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA EDW_TEST.''|| :SCH || '' to ROLE READWRITE_EDW_TEST'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA EDW_TEST.''|| :SCH || '' to ROLE READ_EDW_TEST'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA EDW_TEST.''|| :SCH || '' to ROLE READWRITE_EDW_TEST'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA EDW_TEST.''|| :SCH || '' to ROLE READ_EDW_TEST'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 


ELSEIF (USER_ACCESS IN (''OWNER_BOND_STAGE'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA BOND_STAGE.''|| :SCH || '' to ROLE READWRITE_BOND_STAGE'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA BOND_STAGE.''|| :SCH || '' to ROLE READ_BOND_STAGE'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA BOND_STAGE.''|| :SCH || '' to ROLE READWRITE_BOND_STAGE'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA BOND_STAGE.''|| :SCH || '' to ROLE READ_BOND_STAGE'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 


ELSEIF (USER_ACCESS IN (''OWNER_EDW_STGSUPPORT'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA EDW_STAGE.''|| :SCH || '' to ROLE READWRITE_EDW_STAGE'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA EDW_STAGE.''|| :SCH || '' to ROLE READ_EDW_STAGE'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA EDW_STAGE.''|| :SCH || '' to ROLE READWRITE_EDW_STAGE'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA EDW_STAGE.''|| :SCH || '' to ROLE READ_EDW_STAGE'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 


ELSEIF (USER_ACCESS IN (''OWNER_BOND_PROD'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA BOND_PROD.''|| :SCH || '' to ROLE READWRITE_BOND_PROD'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA BOND_PROD.''|| :SCH || '' to ROLE READ_BOND_PROD'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA BOND_PROD.''|| :SCH || '' to ROLE READWRITE_BOND_PROD'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA BOND_PROD.''|| :SCH || '' to ROLE READ_BOND_PROD'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 

ELSEIF (USER_ACCESS IN (''OWNER_EDW_PROD'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READWRITE_OWNER_EDW'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READ_OWNER_EDW'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READWRITE_OWNER_EDW'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READ_OWNER_EDW'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 


ELSEIF (USER_ACCESS IN (''OWNER_EDW_PRODSUPPORT'') ) THEN
declare
user_access varchar default USER_ACCESS;
SCH varchar default SCH;
OBJ varchar default OBJ;


begin
    execute immediate ''GRANT OWNERSHIP ON TABLE '' || :SCH || ''.''  || :OBJ || '' TO ROLE '' || :USER_ACCESS || '' REVOKE CURRENT GRANTS'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READWRITE_EDW_PRODSUPPORT'';
    execute immediate ''GRANT SELECT ON ALL TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READ_EDW_PRODSUPPORT'';
    execute immediate ''GRANT SELECT,INSERT,UPDATE ON FUTURE TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READWRITE_EDW_PRODSUPPORT'';
    execute immediate ''GRANT SELECT ON FUTURE TABLES IN SCHEMA OWNER_EDW.''|| :SCH || '' to ROLE READ_EDW_PRODSUPPORT'';

end;
    RETURN ''Role '' || :USER_ACCESS || '' now owns '' || :SCH || ''.''  || :OBJ || '' and permissions has been restored;  '' ; 
    
     END IF;
END;';




grant usage on procedure DBA.GetPermissionMismatch() to role OWNER_BOND_PROD;
grant usage on procedure DBA.SetPermission(VARCHAR, VARCHAR, VARCHAR) to role OWNER_BOND_PROD;










SELECT  * FROM BOND_PROD.INFORMATION_SCHEMA.PROCEDURES
WHERE PROCEDURE_SCHEMA = 'DBA' AND CREATED >= '2024-03-14'
UNION
SELECT  * FROM EDW_PRODSUPPORT.INFORMATION_SCHEMA.PROCEDURES
WHERE PROCEDURE_SCHEMA = 'DBA' AND CREATED >= '2024-03-14'
UNION
SELECT  * FROM  EDW_PROD.INFORMATION_SCHEMA.PROCEDURES
WHERE PROCEDURE_SCHEMA = 'DBA' AND CREATED >= '2024-03-14'; 