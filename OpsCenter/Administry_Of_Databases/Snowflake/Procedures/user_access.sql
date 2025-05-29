
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE PROCEDURE DBA.DEPLOY.USER_ACCESS("USER_ACESS" VARCHAR(16777216), "EMPLOYEE" VARCHAR(16777216))
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS OWNER
AS

/*
---For DBAs
CALL DBA.DEPLOY.USER_ACCESS('USERNAME', 'DBA');
---For Employees in Data Management Team
CALL DBA.DEPLOY.USER_ACCESS('USERNAME', 'Allied');
---For Contractor
CALL DBA.DEPLOY.USER_ACCESS('USERNAME', 'Contractor');
---For OffShore
CALL DBA.DEPLOY.USER_ACCESS('USERNAME', 'OffShore');
*/


/*

---To make an user ACTIVE

CALL DBA.DEPLOY.USER_ACCESS('USERNAME', 'ENABLED');


---To make an user INACTIVE
CALL DBA.DEPLOY.USER_ACCESS('USERNAME', 'DISABLED');
*/

'



BEGIN
 IF (EMPLOYEE IN (''DISABLED'',''Disabled'', ''disabled'', ''DisAbled'') ) THEN
declare
user_access varchar default USER_ACESS;

begin
      ALTER USER IDENTIFIER(:USER_ACESS) SET DISABLED = TRUE;
end;
    RETURN ''User '' || :USER_ACESS || '' has been disabled''; 
 ELSEIF (EMPLOYEE IN (''ENABLED'',''Enabled'', ''enabled'')) THEN
declare
user_access varchar default USER_ACESS;

begin
      ALTER USER IDENTIFIER(:USER_ACESS) SET DISABLED = FALSE;
end;
    RETURN ''User '' || :USER_ACESS || '' has been enabled'';     
  ELSEIF (EMPLOYEE = ''DigitalSolutions'') THEN
declare
user_access varchar default USER_ACESS;
begin
 execute immediate ''grant role EDW_BI_READER to user '' || :USER_ACCESS;
 execute immediate ''ALTER USER IDENTIFIER ( '''''' || :USER_ACESS ||'''''') set DEFAULT_ROLE = ''''EDW_BI_READER'''' DEFAULT_WAREHOUSE = ''''DATASCIENCE'''''';
end;
    RETURN ''USER '' || :USER_ACESS || '' ADDED TO EDW_BI_READER ROLE(s)'';
    ELSEIF (EMPLOYEE = ''Allied'') THEN
declare
user_access varchar default USER_ACESS;
begin
 execute immediate ''grant role EDW_ALLIED_EMPLOYEES to user '' || :USER_ACCESS;
 execute immediate ''ALTER USER IDENTIFIER ( '''''' || :USER_ACESS ||'''''') set DEFAULT_ROLE = ''''EDW_ALLIED_EMPLOYEES'''' DEFAULT_WAREHOUSE = ''''EDW_DEV_INFA_WH'''''';
end;
    RETURN ''USER '' || :USER_ACESS || '' ADDED TO EDW_ALLIED_EMPLOYEES  ROLE(s)'';
    ELSEIF (EMPLOYEE = ''Contractor'') THEN
     declare
user_access varchar default USER_ACESS;

begin
    execute immediate ''grant role EDW_CONTRACTORS to user '' || :USER_ACCESS;
    execute immediate ''grant role EDW_PROD_CONTRACTORS to user '' || :USER_ACCESS;
    
    execute immediate ''ALTER USER IDENTIFIER ( '''''' || :USER_ACESS ||'''''') set DEFAULT_ROLE = ''''EDW_CONTRACTORS'''' DEFAULT_WAREHOUSE = ''''EDW_DEV_INFA_WH'''''';
end;
    RETURN ''USER ADDED TO EDW_CONTRACTORS AND EDW_PROD_CONTRACTORS ROLE(s)'';
   ELSEIF (EMPLOYEE = ''Offshore'') THEN
      	declare
user_access varchar default USER_ACESS;

begin
    execute immediate ''grant role EDW_OFF_SHORE_CONTRACTORS to user '' || :USER_ACCESS;
    
    execute immediate ''ALTER USER IDENTIFIER ( '''''' || :USER_ACESS ||'''''') set DEFAULT_ROLE = ''''EDW_OFF_SHORE_CONTRACTORS'''' DEFAULT_WAREHOUSE = ''''EDW_DEV_INFA_WH'''''';
end;
    RETURN ''USER '' || :USER_ACESS || '' ADDED TO EDW_CONTRACTORS ROLE ONLY'';
  ELSEIF (EMPLOYEE = ''DATASCIENCE'') THEN
declare
user_access varchar default USER_ACESS;

begin
    execute immediate ''grant role EDW_ALLIED_EMPLOYEES to user '' || :USER_ACCESS;
    execute immediate ''grant role DATASCIENCE to user '' || :USER_ACCESS;
    execute immediate ''ALTER USER IDENTIFIER ( '''''' || :USER_ACESS ||'''''') set DEFAULT_ROLE = ''''DATASCIENCE'''' DEFAULT_WAREHOUSE = ''''DATASCIENCE'''''';

end;
    RETURN ''USER '' || :USER_ACESS || '' ADDED TO EDW_ALLIED_EMPLOYEES,  DATASCIENCE ROLE(s)'';
      ELSEIF (EMPLOYEE = ''SA'') THEN
declare
user_access varchar default USER_ACESS;

begin
    execute immediate ''grant role EDW_ALLIED_EMPLOYEES to user '' || :USER_ACCESS;
    execute immediate ''grant role SYSADMIN to user '' || :USER_ACCESS;    
    execute immediate ''ALTER USER IDENTIFIER ( '''''' || :USER_ACESS ||'''''') set DEFAULT_ROLE = ''''SYSADMIN'''' DEFAULT_WAREHOUSE = ''''EDW_STAGE_MED_WH'''''';
end;
    RETURN ''USER '' || :USER_ACESS || '' ADDED TO EDW_ALLIED_EMPLOYEES, SYSADMIN ROLE(s)'';
  ELSEIF (EMPLOYEE = ''DBA'') THEN
declare
user_access varchar default USER_ACESS;

begin
    execute immediate ''grant role EDW_ALLIED_EMPLOYEES to user '' || :USER_ACCESS;
    execute immediate ''grant role ACCOUNTADMIN to user '' || :USER_ACCESS;
    execute immediate ''grant role SYSADMIN to user '' || :USER_ACCESS;
    execute immediate ''grant role ORGADMIN to user '' || :USER_ACCESS;
    execute immediate ''ALTER USER IDENTIFIER ( '''''' || :USER_ACESS ||'''''') set DEFAULT_ROLE = ''''ACCOUNTADMIN'''' DEFAULT_WAREHOUSE = ''''EDW_STAGE_MED_WH'''''';
end;
        RETURN ''USER '' || :USER_ACESS || '' ADDED TO EDW_ALLIED_EMPLOYEES, ACCOUNTADMIN, SYSADMIN, ORGADMIN ROLE(s)'';
     ELSE
     declare
user_access varchar default USER_ACESS;
EMPLOYEE varchar default EMPLOYEE;

begin
     execute immediate ''grant role '' || EMPLOYEE || '' to user '' || :USER_ACESS;     
    execute immediate ''ALTER USER IDENTIFIER ( '''''' || :USER_ACESS ||'''''') set DEFAULT_ROLE = ''''''  || :EMPLOYEE || '''''' DEFAULT_WAREHOUSE = ''''EDW_DEV_INFA_WH'''''';
     end;
      RETURN ''USER '' || :USER_ACESS || '' ADDED TO Unique Group'';
     END IF;
END;';