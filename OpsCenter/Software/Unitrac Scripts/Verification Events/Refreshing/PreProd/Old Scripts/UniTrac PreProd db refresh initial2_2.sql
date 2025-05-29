USE [UniTrac]
SELECT * FROM [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] 
WHERE ID IN (5,7,8,21,22,23,25,26,27,28,30,31)
GO
 
 --verify connections note: ProdRO is ok to point to unitrac-db01
 SELECT * FROM dbo.CONNECTION_DESCRIPTOR

Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'UniTracDW',SERVER_TX = 'UNITRAC-PREPROD\SQLSERVER', 
USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=', 
PASSWORD_TX = 'flNVdN5QdgKa6ZTJkXPz2Qcpaqlgap1OMgJnN4nTvxwXXly+OogMLQ==' where ID = 1
 
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'VUT_Agency',SERVER_TX = 'VUTSTAGE01', 
USERNAME_TX = 'ykGX/FdKYchEg5OZ0B7PIA==', 
PASSWORD_TX = 'ykGX/FdKYchEg5OZ0B7PIA==' where ID = 3

 
Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'PERFLOG',SERVER_TX = 'UNITRAC-PREPROD\SQLSERVER', 
USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=', 
PASSWORD_TX = 'flNVdN5QdgKa6ZTJkXPz2Qcpaqlgap1OMgJnN4nTvxwXXly+OogMLQ==' where ID = 35

Update [UniTrac].[dbo].[CONNECTION_DESCRIPTOR] Set NAME_TX = 'UniTracArchive',SERVER_TX = 'UTQA-SQL-14', 
USERNAME_TX = 'nClZlXE2ktrN5UdonQgfWMV9leEPNo96CTTKyO0zp8c=', 
PASSWORD_TX = 'flNVdN5QdgKa6ZTJkXPz2Qcpaqlgap1OMgJnN4nTvxwXXly+OogMLQ==' where ID = 37
 
--I think we can start expanding the DELETE statement here while VUT servers are being removed from some environments
--I'd delete the extra rows (only 4 regions in most non-Prod environment) and then update the remaining rows to match the regions that were being restored. 
--Since regions were being swapped out pretty regularly, this always changed.
DELETE FROM [UniTrac].[dbo].[CONNECTION_DESCRIPTOR]
--WHERE ID IN (9,10,11,12)
WHERE ID IN (5,7,8,21,22,23,25,26,27,28,30,31)

DELETE FROM dbo.CONNECTION_DESCRIPTOR
WHERE id IN (4, 6, 24, 32, 33, 34, 38, 39)
 
 
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