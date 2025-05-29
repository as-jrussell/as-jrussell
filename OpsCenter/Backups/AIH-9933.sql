USE [master]; 
GO 
 
 
/* Adding three additional files */
 IF EXISTS (SELECT 1 FROM [tempdb].[sys].[database_files] WHERE NAME='tempdev9')
	BEGIN 
		PRINT 'WARNING: Tempdev9 already there!'
	END
ELSE
	BEGIN 
		ALTER DATABASE [tempdb] ADD FILE 
			(NAME = N'tempdev9', FILENAME = N'E:\SQL\TempDB\tempdev9.ndf' , SIZE = 25GB , FILEGROWTH = 10%);
END

 IF EXISTS (SELECT 1 FROM [tempdb].[sys].[database_files] WHERE NAME='tempdev10')
	BEGIN 
		PRINT 'WARNING: Tempdev10 already there!'
	END
ELSE
	BEGIN 
		ALTER DATABASE [tempdb] ADD FILE 
			(NAME = N'tempdev10', FILENAME = N'E:\SQL\TempDB\tempdev10.ndf' , SIZE = 25GB , FILEGROWTH = 10%);
END

 IF EXISTS (SELECT 1 FROM [tempdb].[sys].[database_files] WHERE NAME='tempdev11')
	BEGIN 
		PRINT 'WARNING: Tempdev11 already there!'
	END
ELSE
	BEGIN 
		ALTER DATABASE [tempdb] ADD FILE 
			(NAME = N'tempdev11', FILENAME = N'E:\SQL\TempDB\tempdev11.ndf' , SIZE = 25GB , FILEGROWTH = 10%);
END


 IF EXISTS (SELECT 1 FROM [tempdb].[sys].[database_files] WHERE NAME='tempdev12')
	BEGIN 
		PRINT 'WARNING: Tempdev12 already there!'
	END
ELSE
	BEGIN 
		ALTER DATABASE [tempdb] ADD FILE 
			(NAME = N'tempdev12', FILENAME = N'E:\SQL\TempDB\tempdev12.ndf' , SIZE = 25GB , FILEGROWTH = 10%);
END



