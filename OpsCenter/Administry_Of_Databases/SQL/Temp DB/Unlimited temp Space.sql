IF OBJECT_ID(N'tempdb..#TempTable') IS NOT NULL
DROP TABLE #TempTable
  CREATE TABLE #TempTable ([ServerName] VARCHAR(128),[DBName] VARCHAR(128), [SET Unlimited] VARCHAR(3)) ;

  INSERT INTO #tempTable  ([ServerName],[DBName], [SET Unlimited])
SELECT 
	 @@servername as ServerName, [Database_Name] = D.name,
    CASE WHEN max_size = '-1' THEN 'Yes'
	ELSE 'No'
	END [SET Unlimited]
	
	FROM sys.master_files A LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id 
join sys.databases D on D.database_id = A.database_id
and D.database_id = 2


SELECT * FROM #TempTable
WHERE [SET Unlimited] = 'No'