--ONLINE 

IF EXISTS(SELECT * FROM sys.master_files WHERE name = 'OctopusDeploy' and physical_name like 'F:\SQLDATA\%')
	BEGIN 
		ALTER DATABASE [OctopusDeploy] SET ONLINE
	END
ELSE
	BEGIN
		PRINT 'FAILED: Please check your work!'
	END

IF EXISTS(SELECT * FROM sys.master_files WHERE name = 'TeamCity' and physical_name like 'F:\SQLDATA\%')
	BEGIN 
		ALTER DATABASE [TeamCity] SET ONLINE
	END
ELSE
	BEGIN
		PRINT 'FAILED: Please check your work!'
	END

IF EXISTS(SELECT * FROM sys.master_files WHERE name = 'DBA' and physical_name like 'F:\SQLDATA\%')
	BEGIN 
		ALTER DATABASE [DBA] SET ONLINE
	END
ELSE
	BEGIN
		PRINT 'FAILED: Please check your work!'
	END

IF EXISTS(SELECT * FROM sys.master_files WHERE name = 'PerfStats' and physical_name like 'F:\SQLDATA\%')
	BEGIN 
		ALTER DATABASE [PerfStats] SET ONLINE
	END
ELSE
	BEGIN
		PRINT 'FAILED: Please check your work!'
	END

IF EXISTS(SELECT * FROM sys.master_files WHERE name = 'HDTStorage' and physical_name like 'F:\SQLDATA\%')
	BEGIN 
		ALTER DATABASE [HDTStorage] SET ONLINE
	END
ELSE
	BEGIN
		PRINT 'FAILED: Please check your work!'
	END
