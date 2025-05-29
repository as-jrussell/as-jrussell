USE master
EXEC usp_killDBConnections 'UniTrac'
GO

---- Multiple Backup File Restore for SQL2012 Setup (Use This!)
--RESTORE DATABASE [UniTrac] FROM  
--DISK = N'\\usd\usd_storage\TEST_Backups\Unitrac-Full-1.bak',
--DISK = N'\\usd\usd_storage\TEST_Backups\Unitrac-Full-2.bak',
--DISK = N'\\usd\usd_storage\TEST_Backups\Unitrac-Full-3.bak',
--DISK = N'\\usd\usd_storage\TEST_Backups\Unitrac-Full-4.bak',
--DISK = N'\\usd\usd_storage\TEST_Backups\Unitrac-Full-5.bak',
--DISK = N'\\usd\usd_storage\TEST_Backups\Unitrac-Full-6.bak',
--DISK = N'\\usd\usd_storage\TEST_Backups\Unitrac-Full-7.bak',
--DISK = N'\\usd\usd_storage\TEST_Backups\Unitrac-Full-8.bak'
--WITH  FILE = 1,  
--MOVE N'UniTrac' TO N'E:\MSSQL\Data\UniTrac.mdf',  
--MOVE N'UniTrac2' TO N'F:\MSSQL\Data\UniTrac2.ndf',
--MOVE N'UniTrac3' TO N'G:\MSSQL\Data\UniTrac3.ndf',  
--MOVE N'UniTrac_log' TO N'G:\MSSQL\Data\UniTrac_log.ldf',  
--NOUNLOAD,  REPLACE,  STATS = 10
--GO


---- Alternate Restore Direct From DB01
--RESTORE DATABASE [UniTrac] FROM  
--DISK = N'\\\\unitrac-db01\f$\SQLBackups\Unitrac-Full-1.bak',
--DISK = N'\\\\unitrac-db01\f$\SQLBackups\Unitrac-Full-2.bak', 
--DISK = N'\\\\unitrac-db01\f$\SQLBackups\Unitrac-Full-3.bak',
--DISK = N'\\\\unitrac-db01\f$\SQLBackups\Unitrac-Full-4.bak',
--DISK = N'\\\\unitrac-db01\f$\SQLBackups\Unitrac-Full-5.bak',
--DISK = N'\\\\unitrac-db01\f$\SQLBackups\Unitrac-Full-6.bak', 
--DISK = N'\\\\unitrac-db01\f$\SQLBackups\Unitrac-Full-7.bak',
--DISK = N'\\\\unitrac-db01\f$\SQLBackups\Unitrac-Full-8.bak' 
--WITH  FILE = 1,  
--MOVE N'UniTrac' TO N'E:\MSSQL\DATA\UniTrac.mdf',  
--MOVE N'UniTrac2' TO N'F:\MSSQL\DATA\UniTrac2.ndf',
--MOVE N'UniTrac3' TO N'G:\MSSQL\DATA\UniTrac3.ndf',  
--MOVE N'UniTrac_log' TO N'G:\UniTrac_log.ldf',  
--NOUNLOAD,  REPLACE,  STATS = 10
--GO

------------------ Alternate Restore From Single Backup File
--RESTORE DATABASE [UniTrac] FROM  
--DISK = N'\\usd\usd_storage\TEST_Backups\UniTrac_PreProd.bak'  
--WITH  FILE = 1,  
--MOVE N'UniTrac' TO N'E:\MSSQL\DATA\UniTrac.mdf',  
--MOVE N'UniTrac2' TO N'F:\MSSQL\DATA\UniTrac2.ndf',
--MOVE N'UniTrac3' TO N'G:\MSSQL\DATA\UniTrac3.ndf',  
--MOVE N'UniTrac_log' TO N'G:\MSSQL\DATA\UniTrac_log.ldf',  
--NOUNLOAD,  REPLACE,  STATS = 10
--GO


---- Restore UniTrac_DW (currently on G drive, including log file)
--USE master
--EXEC usp_killDBConnections 'UniTrac_DW'
--GO

--RESTORE DATABASE [UniTrac_DW] FROM  DISK = N'\\usd\usd_storage\TEST_Backups\UniTrac_DW_PreProd.bak' WITH  FILE = 1,
--MOVE N'UniTrac_DW' TO N'G:\MSSQL\Data\UniTrac_DW.mdf',  
--MOVE N'UniTrac_DW_log' TO N'G:\MSSQL\Data\UniTrac_DW_log.ldf',
--  NOUNLOAD,  REPLACE,  STATS = 10
--GO

---- Restore VUT (currently on E drive, including log file)
--USE master
--EXEC usp_killDBConnections 'VUT'
--GO

--RESTORE DATABASE [VUT] FROM  DISK = N'\\usd\usd_storage\TEST_Backups\VUT.bak' WITH  FILE = 1,
--MOVE N'VUT_Data' TO N'E:\MSSQL\Data\VUT.mdf',  
--MOVE N'VUT_log' TO N'E:\MSSQL\Data\VUT_log.ldf',
--  NOUNLOAD,  REPLACE,  STATS = 10
--GO