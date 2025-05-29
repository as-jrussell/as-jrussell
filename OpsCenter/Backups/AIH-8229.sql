USE [master]
GO

IF EXISTS (select * from sys.databases where name = 'tempdb')
BEGIN 
		ALTER DATABASE tempdb
                ADD FILE (
                               FILENAME = 'G:\TEMPDB\tempdb8.ndf',
                               NAME = tempdev8,
                               SIZE = 15000MB,
                               FILEGROWTH = 10240KB)
		ALTER DATABASE tempdb
						ADD FILE (
									   FILENAME = 'G:\TEMPDB\tempdb7.ndf',
									   NAME = tempdev7,
									   SIZE = 15000MB,
									   FILEGROWTH = 10240KB)
		ALTER DATABASE tempdb
						ADD FILE (
									   FILENAME = 'G:\TEMPDB\tempdb6.ndf',
									   NAME = tempdev6,
									   SIZE = 15000MB,
									   FILEGROWTH = 10240KB)
		ALTER DATABASE tempdb
						ADD FILE (
									   FILENAME = 'G:\TEMPDB\tempdb5.ndf',
									   NAME = tempdev5,
									   SIZE = 15000MB,
									   FILEGROWTH = 10240KB)
		
		PRINT 'SUCCESS: Added for new data files there should now be 8 data files to match the 
			   cores suggestion and each are 15 GB each'

END

ELSE 

BEGIN 

		PRINT 'WARNING: TEMPDB has not been modified please research'

END






