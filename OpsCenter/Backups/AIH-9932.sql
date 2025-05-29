USE [master]; 
GO 
 
IF EXISTS (SELECT 1 FROM [tempdb].[sys].[database_files] WHERE NAME='tempdev')
	 BEGIN 
		ALTER DATABASE tempdb MODIFY FILE (NAME='tempdev', SIZE=20GB, FILEGROWTH = 10%);
	END
ELSE 
	BEGIN 
		PRINT 'FAILED: TEMPDEV not located'
	END

 IF EXISTS (SELECT 1 FROM [tempdb].[sys].[database_files] WHERE NAME='temp3')
	 BEGIN 
		ALTER DATABASE tempdb  MODIFY FILE (NAME='temp3', SIZE=20GB, FILEGROWTH = 10%);
	END
ELSE 
	BEGIN 
		PRINT 'FAILED: TEMP3 not located'
	END

 IF EXISTS (SELECT 1 FROM [tempdb].[sys].[database_files] WHERE NAME='temp2')
	 BEGIN 
		ALTER DATABASE tempdb  MODIFY FILE (NAME='temp2', SIZE=20GB, FILEGROWTH = 10%);
	END
ELSE 
	BEGIN 
		PRINT 'FAILED: TEMP2 not located'
	END

 IF EXISTS (SELECT 1 FROM [tempdb].[sys].[database_files] WHERE NAME='temp4')
	 BEGIN 
		ALTER DATABASE tempdb  MODIFY FILE (NAME='temp4', SIZE=20GB, FILEGROWTH = 10%);
	END
ELSE 
	BEGIN 
		PRINT 'FAILED: TEMP4 not located'
	END

 IF EXISTS (SELECT 1 FROM [tempdb].[sys].[database_files] WHERE NAME='templog')
	 BEGIN 
		ALTER DATABASE tempdb  MODIFY FILE (NAME='templog', SIZE=20GB, FILEGROWTH = 10%);
	END
ELSE 
	BEGIN 
		PRINT 'FAILED: TEMPLOG not located'
	END


 
/* Adding three additional files */
 IF EXISTS (SELECT 1 FROM [tempdb].[sys].[database_files] WHERE NAME='tempdev5')
	BEGIN 
		PRINT 'WARNING: Tempdev5 already there!'
	END
ELSE
	BEGIN 
		ALTER DATABASE [tempdb] ADD FILE 
			(NAME = N'tempdev5', FILENAME = N'G:\TEMPDB\tempdev5.ndf' , SIZE = 20GB , FILEGROWTH = 10%);
END

 IF EXISTS (SELECT 1 FROM [tempdb].[sys].[database_files] WHERE NAME='tempdev6')
	BEGIN 
		PRINT 'WARNING: Tempdev8 already there!'
	END
ELSE
	BEGIN 
		ALTER DATABASE [tempdb] ADD FILE 
			(NAME = N'tempdev6', FILENAME = N'G:\TEMPDB\tempdev6.ndf' , SIZE = 20GB , FILEGROWTH = 10%);
END

 IF EXISTS (SELECT 1 FROM [tempdb].[sys].[database_files] WHERE NAME='tempdev7')
	BEGIN 
		PRINT 'WARNING: Tempdev7 already there!'
	END
ELSE
	BEGIN 
		ALTER DATABASE [tempdb] ADD FILE 
			(NAME = N'tempdev7', FILENAME = N'G:\TEMPDB\tempdev7.ndf' , SIZE = 20GB , FILEGROWTH = 10%);
END


 IF EXISTS (SELECT 1 FROM [tempdb].[sys].[database_files] WHERE NAME='tempdev8')
	BEGIN 
		PRINT 'WARNING: Tempdev8 already there!'
	END
ELSE
	BEGIN 
		ALTER DATABASE [tempdb] ADD FILE 
			(NAME = N'tempdev8', FILENAME = N'G:\TEMPDB\tempdev8.ndf' , SIZE = 20GB , FILEGROWTH = 10%);
END



