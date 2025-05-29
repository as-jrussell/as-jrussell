

/*https://www.mssqltips.com/sqlservertip/6962/snowflake-streams-change-data-capture/ */

USE DATABASE EDW_DEV;
USE SCHEMA STG ;
USE WAREHOUSE EDW_PROD_INFA_WH;


SELECT * FROM INFORMATION_SCHEMA.Tables

CREATE OR REPLACE STREAM STG.MyStream
ON TABLE STG.STG_UT_WORKFLOW_USER_ASSIGNMENT_RULE_H;

SELECT * FROM 
 STG.STG_UT_WORKFLOW_USER_ASSIGNMENT_RULE_H;
 
 
 
--Show streams that are active (The only last a month at a time) 
--Has to have Name and Schema and the database is helpful ex (database.schema.name) all can be found after running this
Show streams


--Tells if there are any updates (True for Yes and False for No) 
--Has to have Name and Schema and the database is helpful ex (database.schema.streamname)
SELECT SYSTEM$STREAM_HAS_DATA('EDW_DEV.STG.MyStream');


--Query 
--Has to have Name and Schema and the database is helpful ex (database.schema.streamname)
SELECT *
FROM EDW_DEV.STG.MyStream;