 
----************************************************************************************
 
--We need to clear the KeyImage work item data that came over from Production. Apply the script below:
UPDATE WORK_ITEM
SET     PURGE_DT = GETDATE()
SELECT COUNT(*) FROM dbo.WORK_ITEM
WHERE   WORKFLOW_DEFINITION_ID = ( SELECT   ID
                                   FROM     WORKFLOW_DEFINITION
                                   WHERE    NAME_TX = 'KeyImage')  
 
/*************************************************************************************
 TFS $/Unitrac/SourceCode/Unitrac_1.2/3 Upper Business Level/LDH/LDHLib/DB/Scratch/UPDATE_DD_PPD_QA_PATHS.sql
All the refs on the two tables should be pointed to "C:\LenderFiles". That script may be skipped. 
And same thing for the Document Management too. 
The REF_CODE table updates will need to be done next.  It's better to do an update, rather than import.   
*************************************************************************************/
--This checks the rows (current data). You'll see a number of rows with the server name in Meaning_TX.
--Please compare these to what's out on UniTrac_Temp  (below)
--USE UniTrac
SELECT * FROM [REF_CODE] WHERE DOMAIN_CD IN ('SSRSCONFIGINFO','system')   
 
 
--THEN...
UPDATE [REF_CODE] SET Meaning_TX = 'http://UTSTAGE-APP1/UniTracServer/Help/Help.htm'
WHERE CODE_CD = 'HelpFileURL' AND DOMAIN_CD = 'System' 
 
UPDATE [REF_CODE] SET Meaning_TX = 'flNVdN5QdgKa6ZTJkXPz2Qcpaqlgap1OMgJnN4nTvxwXXly+OogMLQ==' 
WHERE CODE_CD = 'Password' AND DOMAIN_CD = 'SSRSConfigInfo'
 
UPDATE [REF_CODE] SET Meaning_TX = 'http://UTSTAGE01/reportserver'
WHERE CODE_CD = 'ServerUrl' AND DOMAIN_CD = 'SSRSConfigInfo'
 
UPDATE [REF_CODE] SET Meaning_TX = 'UniTracAppUser' 
WHERE CODE_CD = 'UserId' AND DOMAIN_CD = 'SSRSConfigInfo'
 
UPDATE [REF_CODE] SET Meaning_TX = 'http://UTSTAGE01/ReportServer/ReportExecution2005.asmx'
WHERE CODE_CD = 'ReportExecutionServiceUrl' AND DOMAIN_CD = 'SSRSConfigInfo'
 
UPDATE [REF_CODE] SET Meaning_TX = 'http://UTSTAGE01/ReportServer/ReportService2005.asmx' 
WHERE CODE_CD = 'ReportServiceUrl' AND DOMAIN_CD = 'SSRSConfigInfo' 
--When the services don't run, we know that there's a mismatch.
 
 
 
/**************************************************************************************
Other things to look at are the CONNECTION_DESCRIPTOR table rows and USERS table.  
The USERS table is no biggie. The configs on the services the (Process User) User IDs and Passwords need to match. 
Here's some of the items that I have.
***************************************************************************************/
USE [UniTrac]
SELECT * FROM [CONNECTION_DESCRIPTOR] 
WHERE ID IN (5,7,8,21,22,23,25,26,27,28,30,31)
GO
 
UPDATE [CONNECTION_DESCRIPTOR] SET NAME_TX = 'UniTracDW',SERVER_TX = 'UTSTAGE01', 
USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=', 
PASSWORD_TX = 'flNVdN5QdgKa6ZTJkXPz2Qcpaqlgap1OMgJnN4nTvxwXXly+OogMLQ==' WHERE ID = 1
 
UPDATE [CONNECTION_DESCRIPTOR] SET NAME_TX = 'VUT_Agency',SERVER_TX = 'VUTSTAGE01', 
USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==', 
PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' WHERE ID = 3
 
--I think we can start expanding the DELETE statement here while VUT servers are being removed from some environments
--I'd delete the extra rows (only 4 regions in most non-Prod environment) and then update the remaining rows to match the regions that were being restored. 
--Since regions were being swapped out pretty regularly, this always changed.

DELETE FROM [CONNECTION_DESCRIPTOR]
--WHERE ID IN (9,10,11,12)
WHERE ID IN (5,7,8,21,22,23,25,26,27,28,30,31)
 
 
-- double check the servers for each region to be sure they haven't been moved around
Update [CONNECTION_DESCRIPTOR] Set NAME_TX = 'Scan',SERVER_TX = 'UTSTAGE01',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 29
Update [CONNECTION_DESCRIPTOR] Set NAME_TX = 'AGENCY',SERVER_TX = 'VUTSTAGE01',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 4
Update [CONNECTION_DESCRIPTOR] Set NAME_TX = 'CST',SERVER_TX = 'VUTSTAGE02',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 5
Update [CONNECTION_DESCRIPTOR] Set NAME_TX = 'PST',SERVER_TX = 'VUTSTAGE03',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 6
Update [CONNECTION_DESCRIPTOR] Set NAME_TX = 'CML',SERVER_TX = 'VUTSTAGE04',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 7
Update [CONNECTION_DESCRIPTOR] Set NAME_TX = 'MID',SERVER_TX = 'VUTSTAGE05',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 8
 
 
 
/*****************************************************************************************************
Re-import process definitions from temp/preserve table to the refreshed table
Be sure to set all process definitions in the refreshed table to ACTIVE_IN='N' before inserting the preserved ones
I leave out the ID column from the list since that's an identity column and will be managed automatically by SQL
*****************************************************************************************************/
INSERT INTO PROCESS_DEFINITION 
(NAME_TX
      ,DESCRIPTION_TX
      ,EXECUTION_FREQ_CD
      ,PROCESS_TYPE_CD
      ,PRIORITY_NO
      ,ACTIVE_IN
      ,CREATE_DT
      ,UPDATE_DT
      ,UPDATE_USER_TX
      ,LOCK_ID
      ,SETTINGS_XML_IM
      ,INCLUDE_WEEKENDS_IN
      ,INCLUDE_HOLIDAYS_IN
      ,DAYS_OF_WEEK_XML
      ,LAST_SCHEDULED_DT
      ,OVERRIDE_DT
      ,SCHEDULE_GROUP
      ,STATUS_CD
      ,ONHOLD_IN
      ,FREQ_MULTIPLIER_NO
      ,CHECKED_OUT_OWNER_ID
      ,CHECKED_OUT_DT
      ,LAST_RUN_DT
      ,USE_LAST_SCHEDULED_DT_IN
      ,PURGE_DT)
  SELECT NAME_TX
      ,DESCRIPTION_TX
      ,EXECUTION_FREQ_CD
      ,PROCESS_TYPE_CD
      ,PRIORITY_NO
      ,ACTIVE_IN
      ,CREATE_DT
      ,UPDATE_DT
      ,UPDATE_USER_TX
      ,LOCK_ID
      ,SETTINGS_XML_IM
      ,INCLUDE_WEEKENDS_IN
      ,INCLUDE_HOLIDAYS_IN
      ,DAYS_OF_WEEK_XML
      ,LAST_SCHEDULED_DT
      ,OVERRIDE_DT
      ,SCHEDULE_GROUP
      ,STATUS_CD
      ,ONHOLD_IN
      ,FREQ_MULTIPLIER_NO
      ,CHECKED_OUT_OWNER_ID
      ,CHECKED_OUT_DT
      ,LAST_RUN_DT
      ,USE_LAST_SCHEDULED_DT_IN
      ,PURGE_DT FROM [UniTrac_DW_TEST].[dbo].[PROCESS_DEFINITION]
 WHERE ACTIVE_IN = 'Y'
 
 
/*********************************************************************************************************/
 
 
--OUTPUT_DEVICE table update:
UPDATE OUTPUT_DEVICE
SET UNC_PATH_TX = 'c:\outputbatchfiles\UniTracHOVQA'
WHERE NAME_TX LIKE 'HOV%'
 
 
/**************************************************************************************************************/