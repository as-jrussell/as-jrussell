---Option 1 (not show the nulls)


	DECLARE @bType NVARCHAR(1)  = 'L'
	DECLARE @alertThreshold INT -- hours

	--DROP TABLE #databases
CREATE TABLE #databases (ID INT NOT NULL IDENTITY(1,1), DBName VARCHAR(100), LastBackupDate DATETIME);

	WITH LastFullBackup
	AS (SELECT [BS].[database_name],
				MAX([BS].[backup_finish_date]) AS BackupDate
		FROM [msdb].[dbo].[backupset] AS BS
		WHERE [BS].[type] = @bType 
		GROUP BY [BS].[database_name])

	INSERT INTO #databases (DBName,LastBackupDate)
	SELECT [name],
			CONVERT(VARCHAR(50), ISNULL(llb.BackupDate, '1/1/1900'), 120)
	FROM sys.databases AS sd
		LEFT JOIN LastFullBackup llb
			ON sd.[name] = llb.[database_name]
	WHERE sd.[recovery_model] IN ( 1, 2, 3 )
			AND sd.is_read_only = 0
			AND sd.[state] = 0
			AND sd.[name] NOT IN ('tempdb')
			AND databasePropertyEx(sd.[name], 'Updateability') = 'READ_WRITE'
			AND llb.BackupDate is not null 
			
SELECT * FROM #databases



---Option 2 (give the nulls an arbitatry date) 


	DECLARE @bType NVARCHAR(1)  = 'L'
	DECLARE @alertThreshold INT -- hours

	--DROP TABLE #databases
CREATE TABLE #databases (ID INT NOT NULL IDENTITY(1,1), DBName VARCHAR(100), LastBackupDate DATETIME);

	WITH LastFullBackup
	AS (SELECT [BS].[database_name],
				MAX([BS].[backup_finish_date]) AS BackupDate
		FROM [msdb].[dbo].[backupset] AS BS
		WHERE [BS].[type] = @bType 
		GROUP BY [BS].[database_name])

	INSERT INTO #databases (DBName,LastBackupDate)
	SELECT [name], CASE WHEN llb.BackupDate is not null then llb.BackupDate
	ELSE GETDATE() -7  END [llb.BackupDate]
	FROM sys.databases AS sd
		LEFT JOIN LastFullBackup llb
			ON sd.[name] = llb.[database_name]
	WHERE sd.[recovery_model] IN ( 1, 2, 3 )
			AND sd.is_read_only = 0
			AND sd.[state] = 0
			AND sd.[name] NOT IN ('tempdb')
			AND databasePropertyEx(sd.[name], 'Updateability') = 'READ_WRITE'		
			
SELECT * FROM #databases


