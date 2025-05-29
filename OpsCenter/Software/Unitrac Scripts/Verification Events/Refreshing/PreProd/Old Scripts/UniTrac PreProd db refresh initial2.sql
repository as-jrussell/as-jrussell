USE [UniTrac]
SELECT * FROM [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] 
WHERE ID IN (5,7,8,21,22,23,25,26,27,28,30,31)
GO
 
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'UniTracDW',SERVER_TX = 'Unitrac-PreProd', 
USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=', 
PASSWORD_TX = 'flNVdN5QdgKa6ZTJkXPz2Qcpaqlgap1OMgJnN4nTvxwXXly+OogMLQ==' 
--SELECT * FROM [UniTrac].[dbo].[CONNECTION_DESCRIPTOR]
WHERE ID = 1
 
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'VUT_Agency',SERVER_TX = 'VUTSTAGE01', 
USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==', 
PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA=='
--SELECT * FROM [UniTrac].[dbo].[CONNECTION_DESCRIPTOR]
 where ID = 3
 
--I think we can start expanding the DELETE statement here while VUT servers are being removed from some environments
--I'd delete the extra rows (only 4 regions in most non-Prod environment) and then update the remaining rows to match the regions that were being restored. 
--Since regions were being swapped out pretty regularly, this always changed.
DELETE FROM [UniTrac].[dbo].[CONNECTION_DESCRIPTOR]
--WHERE ID IN (9,10,11,12)
--SELECT * FROM [UniTrac].[dbo].[CONNECTION_DESCRIPTOR]
WHERE ID IN (5,7,8,21,22,23,25,26,27,28,30,31)
 
 
-- double check the servers for each region to be sure they haven't been moved around
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'Scan',SERVER_TX = 'UTSTAGE01',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' 
--SELECT * FROM [UniTrac].[dbo].[CONNECTION_DESCRIPTOR]
WHERE ID = 29
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'AGENCY',SERVER_TX = 'VUTSTAGE01',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 4
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'CST',SERVER_TX = 'VUTSTAGE02',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 5
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'PST',SERVER_TX = 'VUTSTAGE03',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 6
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'CML',SERVER_TX = 'VUTSTAGE04',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 7
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'MID',SERVER_TX = 'VUTSTAGE05',USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==',PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 8
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'UniTracArchive',SERVER_TX = 'UTSTAGE01',USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=',PASSWORD_TX = 'flNVdN5QdgKa6ZTJkXPz2Qcpaqlgap1OMgJnN4nTvxwXXly+OogMLQ==' where ID = 37
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'NADA-VehicleUC',SERVER_TX = 'UTSTAGE01',USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=',PASSWORD_TX = 'flNVdN5QdgKa6ZTJkXPz2Qcpaqlgap1OMgJnN4nTvxwXXly+OogMLQ==' where ID = 40
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'NADA-VehicleCT',SERVER_TX = 'UTSTAGE01',USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=',PASSWORD_TX = 'flNVdN5QdgKa6ZTJkXPz2Qcpaqlgap1OMgJnN4nTvxwXXly+OogMLQ==' where ID = 41


 OUTPUT_DEVICE table update:
UPDATE OUTPUT_DEVICE
SET UNC_PATH_TX = 'c:\outputbatchfiles\UniTracHOVQA'
--SELECT * FROM dbo.OUTPUT_DEVICE
WHERE NAME_TX LIKE 'HOV%'


--*****PURGES EMAIL & FAX OUTPUT CONFIGS****
UPDATE OUTPUT_CONFIGURATION
SET PURGE_DT = GETDATE(), UPDATE_USER_TX = 'StagingRefresh',LOCK_ID = LOCK_ID + 1

--SELECT * FROM [UniTrac].[dbo].[OUTPUT_CONFIGURATION]
WHERE OUTPUT_TYPE_CD IN ('Email') 

--Re-enable just that for Agency, but with blank XMLs
UPDATE OUTPUT_CONFIGURATION
SET PURGE_DT = NULL, UPDATE_USER_TX = 'StagingRefresh',LOCK_ID = LOCK_ID + 1,
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