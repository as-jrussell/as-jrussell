use role ACCOUNTADMIN;

CREATE OR REPLACE PROCEDURE DBA.DEPLOY.USER_ACCESS("USER_ACESS" VARCHAR(16777216), "EMPLOYEE" VARCHAR(16777216))
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



BEGIN
    IF (EMPLOYEE = ''Allied'') THEN
declare
user_access varchar default USER_ACESS;
begin


 execute immediate ''grant role EDW_ALLIED_EMPLOYEES to user '' || :USER_ACCESS;
end;
    RETURN ''USER ADDED TO EDW_ALLIED_EMPLOYEES ROLE(s)'';
    ELSEIF (EMPLOYEE = ''Contractor'') THEN
     declare
user_access varchar default USER_ACESS;

begin
    execute immediate ''grant role EDW_CONTRACTORS to user '' || :USER_ACCESS;
    execute immediate ''grant role EDW_PROD_CONTRACTORS to user '' || :USER_ACCESS;
end;
    RETURN ''USER ADDED TO EDW_CONTRACTORS AND EDW_PROD_CONTRACTORS ROLE(s)'';
   ELSEIF (EMPLOYEE = ''Offshore'') THEN
      	declare
user_access varchar default USER_ACESS;

begin
    execute immediate ''grant role EDW_CONTRACTORS to user '' || :USER_ACCESS;
end;
    RETURN ''USER ADDED TO EDW_CONTRACTORS ROLE ONLY'';
  ELSEIF (EMPLOYEE = ''DATASCIENCE'') THEN
declare
user_access varchar default USER_ACESS;

begin
    execute immediate ''grant role EDW_ALLIED_EMPLOYEES to user '' || :USER_ACCESS;
    execute immediate ''grant role DATASCIENCE to user '' || :USER_ACCESS;
    execute immediate ''grant role EDW_BI_READER to user '' || :USER_ACCESS;
end;
    RETURN ''USER ADDED TO EDW_ALLIED_EMPLOYEES, EDW_BI_READER, DATASCIENCE ROLE(s)'';
      ELSEIF (EMPLOYEE = ''SA'') THEN
declare
user_access varchar default USER_ACESS;

begin
    execute immediate ''grant role EDW_ALLIED_EMPLOYEES to user '' || :USER_ACCESS;
    execute immediate ''grant role SYSADMIN to user '' || :USER_ACCESS;
end;
    RETURN ''USER ADDED TO EDW_ALLIED_EMPLOYEES, SYSADMIN ROLE(s)'';
  ELSEIF (EMPLOYEE = ''DBA'') THEN
declare
user_access varchar default USER_ACESS;

begin
    execute immediate ''grant role EDW_ALLIED_EMPLOYEES to user '' || :USER_ACCESS;
    execute immediate ''grant role ACCOUNTADMIN to user '' || :USER_ACCESS;
    execute immediate ''grant role SYSADMIN to user '' || :USER_ACCESS;
    execute immediate ''grant role ORGADMIN to user '' || :USER_ACCESS;
end;
    RETURN ''USER ADDED TO EDW_ALLIED_EMPLOYEES, ACCOUNTADMIN, SYSADMIN, ORGADMIN ROLE(s)'';
     ELSE
     declare
user_access varchar default USER_ACESS;
EMPLOYEE varchar default EMPLOYEE;

begin
     execute immediate ''grant role '' || EMPLOYEE || '' to user '' || :USER_ACESS;
     end;
      RETURN ''USER ADDED TO Unique Group'';
     END IF;
END;';