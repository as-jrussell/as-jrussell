---------------------- REF_CODE Updates YEAH -------------------
USE UniTrac

--SELECT * FROM dbo.REF_CODE WHERE DOMAIN_CD IN ('SSRSCONFIGINFO','system')
Update REF_CODE Set Meaning_TX = 'http://UNITRAC-PREPROD/UniTracServer/Help/Help.htm' 
where CODE_CD = 'HelpFileURL' and DOMAIN_CD = 'System' 

Update REF_CODE Set Meaning_TX = 'flNVdN5QdgKa6ZTJkXPz2Qcpaqlgap1OMgJnN4nTvxwXXly+OogMLQ==' 
where CODE_CD = 'Password' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'http://unitrac-preprod/ReportServer_SQLSERVER' 
where CODE_CD = 'ServerUrl' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'UniTracAppUser' 
where CODE_CD = 'UserId' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'http://unitrac-preprod/ReportServer_SQLSERVER/ReportExecution2014.asmx' 
where CODE_CD = 'ReportExecutionServiceUrl' and DOMAIN_CD = 'SSRSConfigInfo'

Update REF_CODE Set Meaning_TX = 'http://unitrac-preprod/ReportServer_SQLSERVER/ReportExecution2014.asmx' 
where CODE_CD = 'ReportServiceUrl' and DOMAIN_CD = 'SSRSConfigInfo'

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

----- Reset admin account password to be the same between UT-QA and UT-PROD -----------
update users set PASSWORD_TX = 'OOo2uY6cqEVRVagK2TRCCg==' where USER_NAME_TX = 'admin'

update users set PASSWORD_TX = 'OOo2uY6cqEVRVagK2TRCCg==' where USER_NAME_TX = 'MsgSrvr'

update users set PASSWORD_TX = 'kbi6PwjuYdDFYxAp2Y5JWw==' where USER_NAME_TX = 'LDHSrvr'

----------- CONNECTION DESCRIPTORS OY!!! -------------------------------
select * from UniTrac..CONNECTION_DESCRIPTOR

USE [UniTrac]
GO
UPDATE CONNECTION_DESCRIPTOR
SET SERVER_TX = 'UT-PREPROD-1'
WHERE NAME_TX = 'UniTracDW'

UPDATE CONNECTION_DESCRIPTOR
SET SERVER_TX = 'TIMMAY'
WHERE NAME_TX = 'VUT_Agency'



UPDATE CONNECTION_DESCRIPTOR
SET SERVER_TX = 'UTSTAGE01',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA=='
WHERE NAME_TX = 'Scan'

UPDATE CONNECTION_DESCRIPTOR
SET SERVER_TX = 'UT-PREPROD-1'
WHERE NAME_TX = 'PERFLOG'

UPDATE CONNECTION_DESCRIPTOR
SET SERVER_TX = 'UTSTAGE01'
WHERE NAME_TX = 'UniTracArchive'

UPDATE CONNECTION_DESCRIPTOR
SET SERVER_TX = 'UTSTAGE01'
WHERE NAME_TX IN ('NADA-VehicleUC','NADA-VehicleCT')

DELETE 
--SELECT *
FROM [UniTrac].[dbo].[CONNECTION_DESCRIPTOR]
WHERE ID IN (5,7,8,21,22,23,25,26,27,28,30,314, 6, 24, 32, 33, 34, 38, 39)


-- double check the servers for each region to be sure they haven't been moved around
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'Scan',SERVER_TX = 'UTSTAGE01',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 29
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'AGENCY',SERVER_TX = 'VUTSTAGE01',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 4
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'CST',SERVER_TX = 'VUTSTAGE02',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 5
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'PST',SERVER_TX = 'VUTSTAGE03',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 6
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'CML',SERVER_TX = 'VUTSTAGE04',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 7
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'MID',SERVER_TX = 'VUTSTAGE05',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 8
 
 --OUTPUT_DEVICE table update:
UPDATE OUTPUT_DEVICE
SET UNC_PATH_TX = 'c:\outputbatchfiles\UniTracHOVQA'
--SELECT * FROM dbo.OUTPUT_DEVICE
WHERE NAME_TX LIKE 'HOV%'


DELETE 
--SELECT *
FROM CONNECTION_DESCRIPTOR
WHERE ID not IN (1,3,29,35,36,37, 40, 41)

--SELECT * FROM dbo.CONNECTION_DESCRIPTOR





--*****PURGES EMAIL & FAX OUTPUT CONFIGS****
UPDATE OUTPUT_CONFIGURATION
SET PURGE_DT = GETDATE(), UPDATE_USER_TX = 'PreProdRefresh',LOCK_ID = LOCK_ID + 1
--SELECT * FROM [UniTrac].[dbo].[OUTPUT_CONFIGURATION]
WHERE OUTPUT_TYPE_CD IN ('Email') 

--Re-enable just that for Agency, but with blank XMLs
UPDATE OUTPUT_CONFIGURATION
SET PURGE_DT = NULL, UPDATE_USER_TX = 'PreProdRefresh',LOCK_ID = LOCK_ID + 1,
XML_CONTAINER = '<OutputConfigurationSettings>
  <EmailFromAddress />
  <EmailSubject />
</OutputConfigurationSettings>'
--SELECT * FROM [UniTrac].[dbo].[OUTPUT_CONFIGURATION]
WHERE OUTPUT_TYPE_CD IN ('Email') AND RELATE_ID = 1

--UPDATE FAX OUTPUT DEVICE TO PREVENT ANY FROM SENDING
UPDATE OUTPUT_DEVICE
SET UNC_PATH_TX = 'http://etherfaxtest//webservices//wfapi.asmx',XML_CONTAINER = '<OutputDeviceSettings>
  <UserName></UserName>
  <Password></Password>
</OutputDeviceSettings>',LOCK_ID = LOCK_ID + 1
--SELECT * FROM [UniTrac].[dbo].[OUTPUT_DEVICE]
WHERE ID = 60
--**************************************** 


