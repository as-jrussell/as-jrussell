--Offline 

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'OctopusDeploy')
	BEGIN 
		ALTER DATABASE [OctopusDeploy] SET OFFLINE
	END
ELSE
	BEGIN
		PRINT 'FAILED: Please check your work!'
	END

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'TeamCity')
	BEGIN 
		ALTER DATABASE [TeamCity] SET OFFLINE
	END
ELSE
	BEGIN
		PRINT 'FAILED: Please check your work!'
	END

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'DBA')
	BEGIN 
		ALTER DATABASE [DBA] SET OFFLINE
	END
ELSE
	BEGIN
		PRINT 'FAILED: Please check your work!'
	END

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'PerfStats')
	BEGIN 
		ALTER DATABASE [PerfStats] SET OFFLINE
	END
ELSE
	BEGIN
		PRINT 'FAILED: Please check your work!'
	END

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'HDTStorage')
	BEGIN 
		ALTER DATABASE [HDTStorage] SET OFFLINE
	END
ELSE
	BEGIN
		PRINT 'FAILED: Please check your work!'
	END

--Move Data and Logs

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'OctopusDeploy' AND state = '6')
	BEGIN 
		ALTER DATABASE [OctopusDeploy] MODIFY FILE ( NAME = OctopusDeploy, FILENAME = 'F:\SQLDATA\OctopusDeploy.mdf')
		ALTER DATABASE [OctopusDeploy] MODIFY FILE ( NAME = OctopusDeploy_log, FILENAME = 'G:\SQLLOGS\OctopusDeploy_log.ldf')
	END
ELSE
	BEGIN
		PRINT 'FAILED: Please check your work!'
	END

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'TeamCity' AND state = '6')
	BEGIN 
		ALTER DATABASE [TeamCity] MODIFY FILE ( NAME = TeamCity, FILENAME = 'F:\SQLDATA\TeamCity.mdf')
		ALTER DATABASE [TeamCity] MODIFY FILE ( NAME = TeamCity_log, FILENAME = 'G:\SQLLOGS\TeamCity_log.ldf')
	END
ELSE
	BEGIN
		PRINT 'FAILED: Please check your work!'
	END

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'DBA' AND state = '6')
	BEGIN 
		ALTER DATABASE [DBA] MODIFY FILE ( NAME = DBA, FILENAME = 'F:\SQLDATA\DBA.mdf')
		ALTER DATABASE [DBA] MODIFY FILE ( NAME = DBA_log, FILENAME = 'G:\SQLLOGS\DBA_log.ldf')
	END
ELSE
	BEGIN
		PRINT 'FAILED: Please check your work!'
	END

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'PerfStats' AND state = '6')
	BEGIN 
		ALTER DATABASE [PerfStats] MODIFY FILE ( NAME = PerfStats, FILENAME = 'F:\SQLDATA\PerfStats.mdf')
		ALTER DATABASE [PerfStats] MODIFY FILE ( NAME = PerfStats_log, FILENAME = 'G:\SQLLOGS\PerfStats_log.ldf')
	END
ELSE
	BEGIN
		PRINT 'FAILED: Please check your work!'
	END

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'HDTStorage' AND state = '6')
	BEGIN 
		ALTER DATABASE [HDTStorage] MODIFY FILE ( NAME = HDTStorage, FILENAME = 'F:\SQLDATA\HDTStorage.mdf')
		ALTER DATABASE [HDTStorage] MODIFY FILE ( NAME = HDTStorage_log, FILENAME = 'G:\SQLLOGS\HDTStorage_log.ldf')
	END
ELSE
	BEGIN
		PRINT 'FAILED: Please check your work!'
	END

--Move Temp Files

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'tempdb')
	BEGIN 
		ALTER DATABASE [tempdb] MODIFY FILE ( NAME = tempdev, FILENAME = 'H:\TempDB\tempdev.mdf')
		ALTER DATABASE [tempdb] MODIFY FILE ( NAME = tempdev2, FILENAME = 'H:\TempDB\tempdev2.mdf')
		ALTER DATABASE [tempdb] MODIFY FILE ( NAME = templog, FILENAME = 'H:\TempDB\tempdev_log.ldf')
	END
ELSE
	BEGIN
		PRINT 'FAILED: Uhm, where is the TempDB!'
	END

EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'BackupDirectory', REG_SZ, N'F:\Backup\'
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'DefaultData', REG_SZ, N'F:\SQLDATA\'
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'DefaultLog', REG_SZ, N'G:\SQLLOGS\'


/*

Take this time to move the files over and restarting the Instance services prior proceeding to the next step

*/



