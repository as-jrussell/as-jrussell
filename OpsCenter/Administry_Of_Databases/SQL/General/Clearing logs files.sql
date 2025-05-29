



select CONCAT('USE',' [', name,'] ','DBCC SHRINKFILE (N''',name,'', '_log'' , 0)')
--select *
FROM sys.databases
where (database_id >=5 AND  name != 'DBA')
and recovery_model_desc = 'FULL'




USE UniTracArchive DBCC SHRINKFILE (N'UniTracArchive_log' , 0)

/*
---Setting a database to SIMPLE
select name,  CONCAT('USE MASTER',' ','ALTER DATABASE',' ',Name,' ', 'SET RECOVERY SIMPLE WITH NO_WAIT')
FROM sys.database_files
where type_desc = 'ROWS'


---Setting a database to FULL
select name,  CONCAT('USE MASTER',' ','ALTER DATABASE',' ',Name,' ', 'SET RECOVERY FULL WITH NO_WAIT')
FROM sys.database_files
where type_desc = 'ROWS'


select CONCAT('Exec [DBA].[backup].[BackupDatabase]
	@BackupLevel = ''FULL'',
	@SQLDatabaseName = ''',name,''',@DryRun = 0')
FROM sys.databases

select CONCAT('Exec [DBA].[backup].[BackupDatabase]
	@BackupLevel = ''LOG'',
	@SQLDatabaseName = ''',name,''',@DryRun = 0')
FROM sys.databases

*/



