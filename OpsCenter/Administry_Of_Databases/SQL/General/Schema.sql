

--EXEC [HDTStorage].[deploy].[CreateDatabaseSchema] @DryRun = 0



declare @cmd1 varchar(500)


set @cmd1= 'use [?] select * from sys.schemas where name = DB_NAME()'


exec sp_MSforeachdb @cmd1 