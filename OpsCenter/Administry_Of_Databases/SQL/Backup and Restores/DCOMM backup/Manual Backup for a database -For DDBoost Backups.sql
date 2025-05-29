select CONCAT('Exec [DBA].[backup].[BackupDatabase]
	@BackupLevel = ''FULL'',
	@SQLDatabaseName = ''',name,''',@DryRun = 0')
FROM sys.databases
where (database_id >=5 AND  name NOT IN ('DBA', 'Perfstats'))







select CONCAT('Exec [DBA].[backup].[BackupDatabase]
	@BackupLevel = ''LOG'',
	@SQLDatabaseName = ''',name,''',@DryRun = 0')
FROM sys.databases
where (database_id >=5 AND  name NOT IN ('DBA', 'Perfstats'))



