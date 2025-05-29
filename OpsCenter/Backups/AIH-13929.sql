use master

IF EXISTS (select 1 from sys.databases where name = 'OperationalDashboard') 
BEGIN 

		ALTER DATABASE [OperationalDashboard] MODIFY FILE ( NAME = N'OperationalDashboard', MAXSIZE = 50GB )

END




IF EXISTS (select 1 from sys.databases where name = 'OspreyDashboard') 
BEGIN 
		ALTER DATABASE [OspreyDashboard] MODIFY FILE ( NAME = N'OspreyDashboard', MAXSIZE = 50GB )
END