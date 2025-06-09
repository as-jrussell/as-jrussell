


BEGIN
	CASE WHEN  (select count(*) FROM information_schema.DATABASES where DATABASE_NAME = 'DBA_jcr')  = 0
	THEN

CREATE DATABASE DBA_jcr;
RETURN 'SUCCESS: Database created';
ELSE 

RETURN 'WARNING: Database exists';



	END;
    
END;



BEGIN
	CASE WHEN (select count(*) from information_schema.schemata  where CATALOG_NAME = 'DBA'AND SCHEMA_NAME = 'DEPLOY' ) = 0
	THEN

CREATE SCHEMA DEPLOY;
RETURN 'SUCCESS: Schema created';

ELSE 

RETURN 'WARNING: Schema exists';

	END;
    
END;



BEGIN
	CASE WHEN (select count(*) from information_schema.schemata  where CATALOG_NAME = 'DBA'AND SCHEMA_NAME = 'INFO' ) = 0
	THEN

CREATE SCHEMA INFO;
RETURN 'SUCCESS: Schema created';

ELSE 

RETURN 'WARNING: Schema exists';

	END;
    
END;




BEGIN
	CASE WHEN (select count(*) from information_schema.schemata  where CATALOG_NAME = 'DBA'AND SCHEMA_NAME = 'DBA' ) = 0
	THEN

CREATE SCHEMA DBA;
RETURN 'SUCCESS: Schema created';

ELSE 

RETURN 'WARNING: Schema exists';

	END;
    
END;

USE ROLE ACCOUNTADMIN;

GRANT OWNERSHIP ON DATABASE DBA TO ROLE dba_team REVOKE CURRENT GRANTS;
GRANT OWNERSHIP ON SCHEMA DEPLOY TO ROLE dba_team REVOKE CURRENT GRANTS;
GRANT OWNERSHIP ON SCHEMA INFO TO ROLE dba_team REVOKE CURRENT GRANTS;
GRANT OWNERSHIP ON SCHEMA DBA TO ROLE dba_team REVOKE CURRENT GRANTS;


GRANT USAGE ON FUTURE PROCEDURES IN DATABASE DBA TO dba_team;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE DBA TO dba_team;

GRANT SELECT ON FUTURE TABLES IN SCHEMA INFO TO dba_team;
GRANT SELECT ON FUTURE TABLES IN SCHEMA DEPLOY TO dba_team;
GRANT SELECT ON FUTURE TABLES IN SCHEMA DBA TO dba_team;

GRANT INSERT ON FUTURE TABLES IN SCHEMA INFO TO dba_team;
GRANT INSERT ON FUTURE TABLES IN SCHEMA DEPLOY TO dba_team;
GRANT INSERT ON FUTURE TABLES IN SCHEMA DBA TO dba_team;

GRANT UPDATE ON FUTURE TABLES IN SCHEMA INFO TO dba_team;
GRANT UPDATE ON FUTURE TABLES IN SCHEMA DEPLOY TO dba_team;
GRANT UPDATE ON FUTURE TABLES IN SCHEMA DBA TO dba_team;

GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA INFO TO ROLE dba_team;
GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA DEPLOY TO ROLE dba_team;
GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA DBA TO ROLE dba_team;

GRANT SELECT ON FUTURE VIEWS IN SCHEMA INFO TO dba_team;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA DEPLOY TO dba_team;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA DBA TO dba_team;



---Users added to Snowflake in last 30 days

CREATE or replace procedure info.GetLastloginCreated ()
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




---roles users are in and last time they logged into specific role [AuditLogin]




CREATE or replace procedure INFO.GetUserRolesLastLogin ( USER_GROUPS VARCHAR)
returns TABLE (WAREHOUSE_NAME VARCHAR,USER_NAME VARCHAR, ROLE_NAME VARCHAR,  FIRST_LOGIN TIMESTAMP_LTZ(6), LAST_LOGIN TIMESTAMP_LTZ(6), LOGINS integer )
LANGUAGE SQL
AS '
BEGIN
IF (USER_GROUPS IN (select name from snowflake.account_usage.roles)) THEN 
DECLARE
  res resultset default (
  
  
 SELECT DISTINCT WAREHOUSE_NAME, USER_NAME, ROLE_NAME,MIN(START_TIME) AS FIRST_LOGIN,MAX(END_TIME) AS LAST_LOGIN,COUNT(*) AS LOGINS
FROM "SNOWFLAKE"."ACCOUNT_USAGE"."QUERY_HISTORY"
WHERE  ROLE_NAME = :USER_GROUPS
GROUP BY USER_NAME, ROLE_NAME, WAREHOUSE_NAME      
   ORDER BY MAX(END_TIME) DESC, COUNT(*) DESC 
   )
    ;
BEGIN
RETURN TABLE(RES);
END;
ELSEIF (USER_GROUPS IN (SELECT GU.NAME FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES GU WHERE granted_on = ''WAREHOUSE'')) THEN
DECLARE 
  res resultset default (


  SELECT DISTINCT WAREHOUSE_NAME,USER_NAME, ROLE_NAME,MIN(START_TIME) AS FIRST_LOGIN,MAX(END_TIME) AS LAST_LOGIN,COUNT(*) AS LOGINS
FROM "SNOWFLAKE"."ACCOUNT_USAGE"."QUERY_HISTORY"
WHERE WAREHOUSE_NAME = :USER_GROUPS
GROUP BY WAREHOUSE_NAME, USER_NAME,ROLE_NAME       
   ORDER BY WAREHOUSE_NAME, MAX(END_TIME) DESC, COUNT(*) DESC 

      )
    ;
BEGIN
RETURN TABLE(RES);
END;

ELSEIF (USER_GROUPS IN (select name from snowflake.account_usage.users)) THEN 
DECLARE
  res resultset default (
  
  
 SELECT DISTINCT WAREHOUSE_NAME, USER_NAME, ROLE_NAME,MIN(START_TIME) AS FIRST_LOGIN,MAX(END_TIME) AS LAST_LOGIN,COUNT(*) AS LOGINS
FROM "SNOWFLAKE"."ACCOUNT_USAGE"."QUERY_HISTORY"
WHERE  USER_NAME = :USER_GROUPS
GROUP BY USER_NAME, ROLE_NAME, WAREHOUSE_NAME      
   ORDER BY MAX(END_TIME) DESC, COUNT(*) DESC 
    )
    ;
BEGIN
RETURN TABLE(RES);
END;
ELSE
DECLARE
  res resultset default (
  
  
 SELECT DISTINCT WAREHOUSE_NAME, USER_NAME, ROLE_NAME,MIN(START_TIME) AS FIRST_LOGIN,MAX(END_TIME) AS LAST_LOGIN,COUNT(*) AS LOGINS
FROM "SNOWFLAKE"."ACCOUNT_USAGE"."QUERY_HISTORY"
WHERE ROLE_NAME <> ''PUBLIC''
GROUP BY USER_NAME, ROLE_NAME , WAREHOUSE_NAME     
   ORDER BY USER_NAME, MAX(END_TIME) DESC, COUNT(*) DESC 
    )
    ;
BEGIN
RETURN TABLE(RES);
END;

END IF;
END;
';




CREATE OR REPLACE PROCEDURE INFO.GetWareHouseRoles("WAREHOUSE" VARCHAR(16777216))
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





CREATE OR REPLACE PROCEDURE INFO.GetRolePermissions("ROLE" VARCHAR(16777216), "PERMISSION" VARCHAR(16777216))
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





CREATE OR REPLACE PROCEDURE INFO.GetTableUsage(SCHEMA_NAME  TEXT )
RETURNS TABLE (
  "DATABASE_NAME" TEXT,
  "TABLE_SCHEMA" TEXT,
  "TABLE_NAME" TEXT,
  "TABLE_TYPE" TEXT,
  "first_Used_datetime" timestamp_ltz,
   "last_Used_DateTime" timestamp_ltz 
)
LANGUAGE SQL
EXECUTE AS OWNER
AS 
'BEGIN
IF (SCHEMA_NAME IN (select SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA)) THEN 
    DECLARE RES RESULTSET DEFAULT (
    select DISTINCT DATABASE_NAME, TABLE_SCHEMA, table_Name, TABLE_TYPE, CAST(MIN(end_TIME) AS timestamp_ltz)  , CAST(MAX(end_TIME) AS timestamp_ltz)
  
  
from

(select * from "SNOWFLAKE"."ACCOUNT_USAGE"."QUERY_HISTORY" q 

where SCHEMA_NAME= :SCHEMA_NAME
and DATABASE_NAME =(SELECT CURRENT_DATABASE())
) q

inner join "SNOWFLAKE"."ACCOUNT_USAGE"."TABLES" t 

where contains(q.query_text,t.table_name)

and TABLE_SCHEMA = :SCHEMA_NAME

group by  DATABASE_NAME, TABLE_SCHEMA, table_Name,TABLE_TYPE, 1
     
    );
    BEGIN
      RETURN TABLE(RES);
    END;
ELSEIF (SCHEMA_NAME = '''')THEN 
    DECLARE RES RESULTSET DEFAULT (
    select DISTINCT DATABASE_NAME, TABLE_SCHEMA, table_Name, TABLE_TYPE,MIN(end_TIME) , MAX(end_TIME) 
from

(select * from "SNOWFLAKE"."ACCOUNT_USAGE"."QUERY_HISTORY" q 

where  DATABASE_NAME =(SELECT CURRENT_DATABASE())
) q

inner join "SNOWFLAKE"."ACCOUNT_USAGE"."TABLES" t 

where contains(q.query_text,t.table_name)

group by  DATABASE_NAME, TABLE_SCHEMA, table_Name,TABLE_TYPE, 1

   );
    BEGIN
      RETURN TABLE(RES);
    END;
    END IF;
END
';



CREATE OR REPLACE PROCEDURE INFO.TABLESMODIFIED(
  WHATIF VARCHAR(16777216) 
)
RETURNS TABLE (
  "DATABASE_NAME" VARCHAR(16777216),
  "TABLE_SCHEMA" VARCHAR(16777216),
  "TABLE_NAME" VARCHAR(16777216),
  "USER_NAME" VARCHAR(16777216),
  "ROLE_NAME" VARCHAR(16777216),
  "QUERY_TYPE" VARCHAR(16777216),
  "EXECUTION_STATUS" VARCHAR(16777216)
)
LANGUAGE SQL
EXECUTE AS OWNER
AS
'
BEGIN
  IF (WHATIF = ''ADMIN'') THEN 
    DECLARE RES RESULTSET DEFAULT (
      SELECT DISTINCT h.database_name,
        h.schema_name,
        t.table_name,
        h.user_name,
        h.role_name,
        h.query_type,
        h.execution_status
      FROM snowflake.account_usage.query_history h
      LEFT JOIN snowflake.account_usage.users u ON u.name = h.user_name AND u.disabled = FALSE AND u.deleted_on IS NULL
      LEFT OUTER JOIN information_schema.tables t ON t.created = h.start_time
      WHERE execution_status = ''SUCCESS''
        AND CAST(h.start_time AS DATE) = CAST(current_date() AS DATE)
        AND QUERY_TYPE IN (
          ''REVOKE'',
          ''CREATE_VIEW'',
          ''UPDATE'',
          ''RENAME_TABLE'',
          ''CREATE_CONSTRAINT'',
          ''INSERT'',
          ''ALTER_TABLE_ADD_COLUMN'',
          ''RENAME_COLUMN'',
          ''BEGIN_TRANSACTION'',
          ''MERGE'',
          ''RESTORE'',
          ''DELETE'',
          ''ALTER_SESSION'',
          ''COMMIT'',
          ''RENAME_VIEW'',
          ''CREATE_TABLE'',
          ''ALTER_NETWORK_POLICY'',
          ''ALTER_TABLE_MODIFY_COLUMN'',
          ''TRUNCATE_TABLE'',
          ''DROP'',
          ''ALTER_TABLE_DROP_COLUMN'',
          ''REMOVE_FILES'',
          ''CREATE_TABLE_AS_SELECT'',
          ''CREATE'',
          ''CREATE_SEQUENCE''
        )
    );
    BEGIN
      RETURN TABLE(RES);
    END;
ELSEIF (WHATIF IN (SELECT DATABASE_NAME FROM SNOWFLAKE.ACCOUNT_USAGE.DATABASES )) THEN 
    DECLARE
    WHATIF varchar default WHATIF;

    RES RESULTSET DEFAULT (
      SELECT DISTINCT h.database_name,
        h.schema_name,
        t.table_name,
        h.user_name,
        h.role_name,
        h.query_type,
        h.execution_status
      FROM snowflake.account_usage.query_history h
      LEFT JOIN snowflake.account_usage.users u ON u.name = h.user_name AND u.disabled = FALSE AND u.deleted_on IS NULL
      LEFT OUTER JOIN information_schema.tables t ON t.created = h.start_time
      WHERE execution_status = ''SUCCESS''
        AND CAST(h.start_time AS DATE) = CAST(current_date() AS DATE)
        AND QUERY_TYPE IN (
          ''REVOKE'',
          ''CREATE_VIEW'',
          ''UPDATE'',
          ''RENAME_TABLE'',
          ''CREATE_CONSTRAINT'',
          ''INSERT'',
          ''ALTER_TABLE_ADD_COLUMN'',
          ''RENAME_COLUMN'',
          ''BEGIN_TRANSACTION'',
          ''MERGE'',
          ''RESTORE'',
          ''DELETE'',
          ''ALTER_SESSION'',
          ''COMMIT'',
          ''RENAME_VIEW'',
          ''CREATE_TABLE'',
          ''ALTER_NETWORK_POLICY'',
          ''ALTER_TABLE_MODIFY_COLUMN'',
          ''TRUNCATE_TABLE'',
          ''DROP'',
          ''ALTER_TABLE_DROP_COLUMN'',
          ''REMOVE_FILES'',
          ''CREATE_TABLE_AS_SELECT'',
          ''CREATE'',
          ''CREATE_SEQUENCE''
        )
        AND h.database_name =   :WHATIF 
    );
    BEGIN
      RETURN TABLE(RES);
    END;
ELSEIF (WHATIF IN (SELECT LOGIN_NAME FROM SNOWFLAKE.ACCOUNT_USAGE.USERS) ) THEN 
    DECLARE
    WHATIF varchar default WHATIF;

    RES RESULTSET DEFAULT (
      SELECT DISTINCT h.database_name,
        h.schema_name,
        t.table_name,
        h.user_name,
        h.role_name,
        h.query_type,
        h.execution_status
      FROM snowflake.account_usage.query_history h
      LEFT JOIN snowflake.account_usage.users u ON u.name = h.user_name AND u.disabled = FALSE AND u.deleted_on IS NULL
      LEFT OUTER JOIN information_schema.tables t ON t.created = h.start_time
      WHERE execution_status = ''SUCCESS''
        AND CAST(h.start_time AS DATE) = CAST(current_date() AS DATE)
        AND QUERY_TYPE IN (
          ''REVOKE'',
          ''CREATE_VIEW'',
          ''UPDATE'',
          ''RENAME_TABLE'',
          ''CREATE_CONSTRAINT'',
          ''INSERT'',
          ''ALTER_TABLE_ADD_COLUMN'',
          ''RENAME_COLUMN'',
          ''BEGIN_TRANSACTION'',
          ''MERGE'',
          ''RESTORE'',
          ''DELETE'',
          ''ALTER_SESSION'',
          ''COMMIT'',
          ''RENAME_VIEW'',
          ''CREATE_TABLE'',
          ''ALTER_NETWORK_POLICY'',
          ''ALTER_TABLE_MODIFY_COLUMN'',
          ''TRUNCATE_TABLE'',
          ''DROP'',
          ''ALTER_TABLE_DROP_COLUMN'',
          ''REMOVE_FILES'',
          ''CREATE_TABLE_AS_SELECT'',
          ''CREATE'',
          ''CREATE_SEQUENCE''
        )
        AND  USER_NAME =   :WHATIF 
    );
    BEGIN
      RETURN TABLE(RES);
    END;
     ELSE  
     DECLARE
  res resultset default (
  
SELECT DISTINCT h.database_name,
h.SCHEMA_NAME,
       t.table_name,
       h.user_name,
       h.role_name,h.QUERY_TYPE, 
       h.EXECUTION_STATUS
  FROM snowflake.account_usage.query_history h 
  LEFT JOIN snowflake.account_usage.users u
    ON u.name = h.user_name 
   AND u.disabled = FALSE 
   AND u.deleted_on IS NULL
   LEFT OUTER JOIN information_schema.tables t
    ON t.created = h.start_time
 WHERE execution_status = ''SUCCESS'' 
   AND Cast(h.start_time AS DATE) = Cast(current_date() AS DATE) 
AND QUERY_TYPE in (''REVOKE'',''CREATE_VIEW'',
''UPDATE'',''RENAME_TABLE'',''CREATE_CONSTRAINT'',
''INSERT'',''ALTER_TABLE_ADD_COLUMN'',''RENAME_COLUMN'',
''BEGIN_TRANSACTION'',''MERGE'',''RESTORE'',''DELETE'',
''ALTER_SESSION'',''COMMIT'',''RENAME_VIEW'',''CREATE_TABLE'',
''ALTER_NETWORK_POLICY'',''ALTER_TABLE_MODIFY_COLUMN'',
''TRUNCATE_TABLE'',''DROP'',''ALTER_TABLE_DROP_COLUMN'',
''REMOVE_FILES'',''CREATE_TABLE_AS_SELECT'',''CREATE'',
''CREATE_SEQUENCE'')
AND USER_NAME = (select current_user)
AND h.database_name = (select current_database() )
)
    ;
BEGIN
RETURN TABLE(RES);
END;
  END IF;
END;
'
;

