/*  
	Script Title:	Update QA2 after restore from Production
    Created by:		Steve Moran
	Date/Time:		2010-07-13 13:14:25.837
	Description:	Run this script after a restore has been done
					on the Allied-UT-PROD server against the UniTrac datbase
*/
USE UniTrac

SELECT * FROM dbo.REF_CODE WHERE DOMAIN_CD IN ('SSRSCONFIGINFO','system')

Update REF_CODE Set Meaning_TX = 'http://utqa2-app1/UniTracServer/Help/Help.htm' 
where CODE_CD = 'HelpFileURL' and DOMAIN_CD = 'System' 

Update REF_CODE Set Meaning_TX = '9JISp5ZNyrAcNw+dns3LhNPpHr8Io6FVLNZICwpDK4sArB/JxLs2KgU+3D4wGd4h' 
where CODE_CD = 'Password' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'http://utqa-sql/reportserver' 
where CODE_CD = 'ServerUrl' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'ReportUser' 
where CODE_CD = 'UserId' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'http://utqa-sql/ReportServer/ReportExecution2005.asmx' 
where CODE_CD = 'ReportExecutionServiceUrl' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'http://utqa-sql/ReportServer/ReportService2005.asmx' 
where CODE_CD = 'ReportServiceUrl' and DOMAIN_CD = 'SSRSConfigInfo'

SELECT * FROM UniTrac_Old..CONNECTION_DESCRIPTOR

------- If Needed!
--Update CONNECTION_DESCRIPTOR Set SERVER_TX = 'utqa-sql', 
--USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=', 
--PASSWORD_TX = 'tROKIsmSZCRZ6em+1WCiTeY6nsRwNtfq+H9SqTZoXfPQ6zNuXI6CYGEmb1Jrzp8v' where ID = 100000041

--Update CONNECTION_DESCRIPTOR Set SERVER_TX = 'VUTQA01', 
--USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==', 
--PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 100000042

------------------------ validate ----------------------------
SELECT * FROM UniTrac..REF_CODE
WHERE CODE_CD = 'PASSWORD' AND DOMAIN_CD = 'SSRSConfigInfo'

SELECT * FROM UniTrac..REF_CODE
WHERE CODE_CD = 'ServerUrl' AND DOMAIN_CD = 'SSRSConfigInfo'

SELECT * FROM  UniTrac..REF_CODE 
where CODE_CD = 'UserId' and DOMAIN_CD = 'SSRSConfigInfo'

SELECT * FROM UniTrac..USERS where USER_NAME_TX = 'admin'

SELECT * FROM UniTrac..USERS where USER_NAME_TX = 'MsgSrvr'

SELECT * FROM UniTrac..USERS where USER_NAME_TX = 'LDHSrvr'

SELECT * FROM UniTrac..USERS WHERE USER_NAME_TX = 'WFSrvr'

SELECT * FROM UniTrac..USERS WHERE	USER_NAME_TX = 'UniTracUtilitySrvc'

SELECT * FROM UniTrac..USERS
WHERE FAMILY_NAME_TX = 'server'

------------------------- validate -----------------------------------


----- Reset admin account password to be the same between UT-QA and UT-PROD -----------
update users set PASSWORD_TX = 'OOo2uY6cqEVRVagK2TRCCg==' where USER_NAME_TX = 'admin'

update users set PASSWORD_TX = 'OOo2uY6cqEVRVagK2TRCCg==' where USER_NAME_TX = 'MsgSrvr'

update users set PASSWORD_TX = 'kbi6PwjuYdDFYxAp2Y5JWw==' where USER_NAME_TX = 'LDHSrvr'

update users set PASSWORD_TX = 'OOo2uY6cqEVRVagK2TRCCg==' where USER_NAME_TX = 'WFSrvr'


----------- STEVE'S PROCESS DEFINITION UPDATE METHOD ---------------------
SELECT * FROM UniTrac_Old..PROCESS_DEFINITION WHERE PROCESS_TYPE_CD LIKE '%sync%' or PROCESS_TYPE_CD LIKE '%MSG%'

SELECT * FROM UniTrac..PROCESS_DEFINITION

SELECT  *
FROM    UniTrac_Old..PROCESS_DEFINITION
WHERE   ACTIVE_IN = 'Y'

SELECT DISTINCT process_type_cd FROM UniTrac_Old..PROCESS_DEFINITION
WHERE ACTIVE_IN = 'Y'

SELECT * FROM UniTrac..PROCESS_DEFINITION

UPDATE UniTrac..PROCESS_DEFINITION SET ACTIVE_IN = 'N', ONHOLD_IN = 'Y',STATUS_CD = 'Complete'

SELECT * FROM UniTrac..PROCESS_DEFINITION

SELECT * FROM UniTrac..PROCESS_DEFINITION WHERE ACTIVE_IN = 'N'

UPDATE dbo.PROCESS_DEFINITION SET ACTIVE_IN = 'N'

INSERT  INTO UniTrac..PROCESS_DEFINITION
        ( NAME_TX ,
          DESCRIPTION_TX ,
          EXECUTION_FREQ_CD ,
          PROCESS_TYPE_CD ,
          PRIORITY_NO ,
          ACTIVE_IN ,
          CREATE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID ,
          SETTINGS_XML_IM ,
          INCLUDE_WEEKENDS_IN ,
          INCLUDE_HOLIDAYS_IN ,
          DAYS_OF_WEEK_XML ,
          LAST_SCHEDULED_DT ,
          OVERRIDE_DT ,
          SCHEDULE_GROUP ,
          STATUS_CD ,
          ONHOLD_IN ,
          FREQ_MULTIPLIER_NO ,
          CHECKED_OUT_OWNER_ID ,
          CHECKED_OUT_DT
  
        )
        SELECT  NAME_TX ,
                DESCRIPTION_TX ,
                EXECUTION_FREQ_CD ,
                PROCESS_TYPE_CD ,
                PRIORITY_NO ,
                ACTIVE_IN ,
                CREATE_DT ,
                UPDATE_DT ,
                UPDATE_USER_TX ,
                LOCK_ID ,
                SETTINGS_XML_IM ,
                INCLUDE_WEEKENDS_IN ,
                INCLUDE_HOLIDAYS_IN ,
                DAYS_OF_WEEK_XML ,
                LAST_SCHEDULED_DT ,
                OVERRIDE_DT ,
                SCHEDULE_GROUP ,
                STATUS_CD ,
                ONHOLD_IN ,
                FREQ_MULTIPLIER_NO ,
                CHECKED_OUT_OWNER_ID ,
                CHECKED_OUT_DT
        FROM    UniTrac_Old..PROCESS_DEFINITION
        WHERE   PROCESS_TYPE_CD IN ( 'BILLING', 'BSSPA', 'CYCLEPRC',
                                     'DASHCACHE', 'DWINBOUND', 'DWOUTBOUND',
                                     'EOMRPTG', 'ESCROW', 'FFOSSPRC',
                                     'FISERVOBU', 'FULFILLPRC', 'GLBCKFDPA',
                                     'GOODTHRUDT', 'HISTFORM', 'INSDOCPA',
                                     'KEYIMAGE', 'LDAPSYNC', 'LETGEN',
                                     'LOANPRCPA', 'MSGSRV', 'MSGSRVWF',
                                     'PDUNLOCK', 'RPTGEN', 'UTLIBREPRC',
                                     'UTLMTCHIB', 'UTLMTCHOB', 'VUTPA',
                                     'VUTUTSYNC', 'WFEVAL', 'WFUNLCK' )
                             
SELECT * FROM UniTrac..PROCESS_DEFINITION WHERE ACTIVE_IN = 'Y'
--AND PROCESS_TYPE_CD LIKE 'DA%'
ORDER BY UPDATE_DT DESC

***Update LetterGen Service to use UBS instead***
UPDATE PROCESS_DEFINITION 
SET SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/TargetServiceList/TargetService/text())[1] with "UnitracBusinessService"')
, LOCK_ID = LOCK_ID + 1
WHERE PROCESS_TYPE_CD='LETGEN'
and ID IN (6)

----------- CONNECTION DESCRIPTORS OY!!! -------------------------------
select * from UniTrac..CONNECTION_DESCRIPTOR

USE [UniTrac]
GO

Update CONNECTION_DESCRIPTOR Set NAME_TX = 'UniTracDW',SERVER_TX = 'UTQA-SQL', 
USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==', 
PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 1

Update CONNECTION_DESCRIPTOR Set NAME_TX = 'VUT_Agency',SERVER_TX = 'VUTSTAGE01', 
USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==', 
PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 3

DELETE FROM CONNECTION_DESCRIPTOR
WHERE ID IN (5,7,8,9,10,11,12,21,22,23,25,26,27,28,30,31)

Update CONNECTION_DESCRIPTOR Set NAME_TX = 'AGENCY',SERVER_TX = 'VUTSTAGE01',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 4
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'PST',SERVER_TX = 'VUTSTAGE02',DATABASE_NM = 'VUT',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 6
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'PST_HIST',SERVER_TX = 'VUTSTAGE02',DATABASE_NM = 'VUTHISTORY', USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 24
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'Scan',SERVER_TX = 'UTSTAGE01',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 29
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'WTQ',SERVER_TX = '10.10.18.203\Wintraq2',USERNAME_TX = 'O3v12M9Xt9uJw8Z7ZAxqtwbNX1gf9fBZ',PASSWORD_TX = 'vCcp3ukI8dVlSbkFUKc6hyInNpi7JuWS' where ID = 32
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'PERFLOG',SERVER_TX = 'UTSTAGE01',DATABASE_NM = 'UniTrac',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 33
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'OSC',SERVER_TX = 'VUTSTAGE05',DATABASE_NM = 'VUT',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 34
Update CONNECTION_DESCRIPTOR Set NAME_TX = 'OSC_HIST',SERVER_TX = 'VUTSTAGE05',DATABASE_NM = 'VUTHistory',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 35

