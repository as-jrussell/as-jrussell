USE [master]; 
GO 
 


IF EXISTS (select * from sys.databases where name = 'tempdb')
BEGIN 

		ALTER DATABASE tempdb MODIFY FILE (NAME='tempdev', SIZE=10GB, FILEGROWTH = 10%);
 
		/* Adding three additional files */
		ALTER DATABASE [tempdb] ADD FILE 
			(NAME = N'tempdev2', FILENAME = N'G:\TEMPDB\tempdev2.ndf' , SIZE = 10GB , FILEGROWTH = 10%);

		ALTER DATABASE [tempdb] ADD FILE 
			(NAME = N'tempdev3', FILENAME = N'G:\TEMPDB\tempdev3.ndf' , SIZE = 10GB , FILEGROWTH = 10%);

		ALTER DATABASE [tempdb] ADD FILE 
			(NAME = N'tempdev4', FILENAME = N'G:\TEMPDB\tempdev4.ndf' , SIZE = 10GB , FILEGROWTH = 10%);

		ALTER DATABASE [tempdb] ADD FILE 
			(NAME = N'tempdev5', FILENAME = N'G:\TEMPDB\tempdev5.ndf' , SIZE = 10GB , FILEGROWTH = 10%);

		ALTER DATABASE [tempdb] ADD FILE 
			(NAME = N'tempdev6', FILENAME = N'G:\TEMPDB\tempdev6.ndf' , SIZE = 10GB , FILEGROWTH = 10%);

		ALTER DATABASE [tempdb] ADD FILE 
			(NAME = N'tempdev7', FILENAME = N'G:\TEMPDB\tempdev7.ndf' , SIZE = 10GB , FILEGROWTH = 10%);
			
		ALTER DATABASE [tempdb] ADD FILE 
			(NAME = N'tempdev8', FILENAME = N'G:\TEMPDB\tempdev8.ndf' , SIZE = 10GB , FILEGROWTH = 10%);

		ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'templog', SIZE = 10485760KB )
		
		PRINT 'SUCCESS: TEMPDB has been shrunk to 10 GB and new files have been created. LOG also grew out to 10 GB
		YOU WILL NEED TO RESTART THE AGENT SERVICE FOR THE ORIGINAL TEMP FILE TO TAKE THE NEW SIZE'
END 

	ELSE 

BEGIN 

			PRINT 'WARNING: TEMPDB has not been modified please research'

END
