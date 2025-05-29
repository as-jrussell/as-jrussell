USE ROLE ACCOUNTADMIN;

---Users added to Snowflake in last 30 days

CREATE or replace procedure DBA.info.GetLastloginCreated ()
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