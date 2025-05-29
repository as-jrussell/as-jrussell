USE [master]
GO

IF EXISTS (select * from sys.databases where name = 'tempdb')
BEGIN 
		ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev', FILENAME = N'G:\TEMPDB\tempdev.ndf' , SIZE = 15360000KB , FILEGROWTH = 10240KB )

		ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev2', FILENAME = N'G:\TEMPDB\tempdev2.ndf' , SIZE = 15360000KB , FILEGROWTH = 10240KB )

		ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev3', FILENAME = N'G:\TEMPDB\tempdev3.ndf' , SIZE = 15360000KB , FILEGROWTH = 10240KB )

		ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev4', FILENAME = N'G:\TEMPDB\tempdev4.ndf' , SIZE = 15360000KB , FILEGROWTH = 10240KB )

		ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'templog', SIZE = 20480000KB )
		
		PRINT 'SUCCESS: TEMPDB has been shrunk to 20 GB and new files have been created. LOG also grew out to 10 GB
		YOU WILL NEED TO RESTART THE AGENT SERVICE FOR THE ORIGINAL TEMP FILE TO TAKE THE NEW SIZE'

END

ELSE 

BEGIN 

		PRINT 'WARNING: TEMPDB has not been modified please research'

END






