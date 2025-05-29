----------------------- Database Restores!
--USE master
--EXEC usp_killDBConnections 'UniTrac'
--GO

-------- Multiple Backup File Restore
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
--MOVE N'UniTrac' TO N'E:\SQLData\UniTrac.mdf',  
--MOVE N'UniTrac2' TO N'F:\SQLData\UniTrac2.ndf',
--MOVE N'UniTrac3' TO N'G:\SQLData\UniTrac3.ndf',  
--MOVE N'UniTrac_log' TO N'H:\SQLLogs\UniTrac_log.ldf',  
--NOUNLOAD,  REPLACE,  STATS = 10
--GO

------ Restore UniTrac_DW (currently on E drive)
--USE master
--EXEC usp_killDBConnections 'UniTrac_DW'
--GO

--RESTORE DATABASE [UniTrac_DW] FROM  DISK = N'\\usd\usd_storage\TEST_Backups\UniTrac_DW_PreProd.bak' WITH  FILE = 1,
--MOVE N'UniTrac_DW' TO N'E:\SQLData\UniTrac_DW.mdf',  
--MOVE N'UniTrac_DW_log' TO N'H:\SQLLogs\UniTrac_DW_log.ldf',
--  NOUNLOAD,  REPLACE,  STATS = 10
--GO

------ Restore VUT (currently on E drive, including log file)
--USE master
--EXEC usp_killDBConnections 'VUT'
--GO

--RESTORE DATABASE [VUT] FROM  DISK = N'\\usd\usd_storage\TEST_Backups\VUT.bak' WITH  FILE = 1,
--MOVE N'VUT_Data' TO N'F:\SQLData\VUT.mdf',  
--MOVE N'VUT_log' TO N'H:\SQLLogs\VUT_log.ldf',
--  NOUNLOAD,  REPLACE,  STATS = 10
--GO

------- If CheckDB To Be Done (Only Needed for VUT)
--DBCC CHECKDB (UniTrac) WITH DATA_PURITY
--DBCC CHECKDB (UniTrac_DW) WITH DATA_PURITY
--DBCC CHECKDB (VUT) WITH DATA_PURITY

---------- Lone Issue from DBCC CHECKDB
--USE VUT
--GO
--DBCC UPDATEUSAGE (VUT,"tblPolicy")
--GO

----------- Quick Review of Post-Restore Compatibility Level
USE UniTrac
GO
SELECT COMPATIBILITY_LEVEL
FROM sys.databases WHERE name = 'UniTrac'
GO

USE UniTrac_DW
GO
SELECT COMPATIBILITY_LEVEL
FROM sys.databases WHERE name = 'UniTrac_DW'
GO

USE VUT
GO
SELECT COMPATIBILITY_LEVEL
FROM sys.databases WHERE name = 'VUT'
GO

---------- Change Compatibility Level to SQL2014
--ALTER DATABASE UniTrac
--SET COMPATIBILITY_LEVEL = 120

--ALTER DATABASE UniTrac_DW
--SET COMPATIBILITY_LEVEL = 120

--ALTER DATABASE VUT
--SET COMPATIBILITY_LEVEL = 120


---Enable Service Broker
USE master;
GO
ALTER DATABASE [Unitrac] SET ENABLE_BROKER with rollback immediate;
GO

