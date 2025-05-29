	SELECT 
		[Database_Name] = D.name
		,[FILESIZE_GB] = (CONVERT(DECIMAL(10,2),A.SIZE/128.0)/1024)
	FROM sys.master_files A LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id 
	join sys.databases D on D.database_id = A.database_id
    WHERE A.TYPE_DESC = 'ROWS'
    AND  D.name not in ('PerfStats','HDTStorage','master','model','tempdb','msdb', 'DBA','RFPLHDStorage')
		ORDER By (CONVERT(DECIMAL(10,2),A.SIZE/128.0)/1024) DESC
