
USE ROLE ACCOUNTADMIN;
use warehouse EDW_STAGE_MED_WH;
USE DATABASE DBA; 


BEGIN
	CASE WHEN (select count(*) from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
     where privilege = 'EXECUTE TASK' and grantee_name = 'DS_ANALYST_ENGINEER') = 0
	THEN
GRANT EXECUTE TASK ON ACCOUNT TO ROLE  DS_ANALYST_ENGINEER;
RETURN 'SUCCESS: DS_ANALYST_ENGINEER role given permissions';

ELSE 
RETURN 'WARNING: DS_ANALYST_ENGINEER role not given permissions';
	END;
 END;   
    

SELECT * FROM table(RESULT_SCAN(LAST_QUERY_ID()));




USE ROLE ACCOUNTADMIN;
use warehouse EDW_STAGE_MED_WH;
USE DATABASE DBA; 


BEGIN
	CASE WHEN (select count(*) from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
     where privilege = 'EXECUTE TASK' and grantee_name = 'DATASCIENCE') = 0
	THEN
GRANT EXECUTE TASK ON ACCOUNT TO ROLE  DATASCIENCE;
RETURN 'SUCCESS: DATASCIENCE role given permissions';


ELSE 

RETURN 'WARNING: DATASCIENCE role not given permissions';
	END;
 END;   
    

SELECT * FROM table(RESULT_SCAN(LAST_QUERY_ID()));