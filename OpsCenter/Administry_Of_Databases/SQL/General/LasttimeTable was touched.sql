		DECLARE @selectSQL varchar(max),
		@TargetDB varchar(100) = '?',
	    @WhatIf BIT = 0

	
	IF OBJECT_ID('tempdb..#Tables') IS NOT NULL
				DROP TABLE #Tables;
			CREATE TABLE #Tables (	
				DatabaseName varchar(150), 
				SchemaName varchar(100),
				TableName varchar(100),
				CreateDate DateTime,
				ModifyDate DateTime,
				maxUserSeek DateTime,
				maxUserScan DateTime,
				maxUserLookup DateTime,
				maxUserUpdate DateTime,
				DiscoverDate DateTime,
				HarvestDate DateTime
			) 
	SET @selectSQL = 'USE ['+ @TargetDB +'];
	SELECT '''+ @TargetDB +''',	SCHEMA_NAME(schema_ID),	T.name, T.create_date, T.modify_date,  
					max(last_user_seek), max(last_user_scan), max(last_user_lookup), Max(last_user_update), getDate(), getDate()
				FROM sys.tables as T 
				LEFT JOIN sys.dm_db_index_usage_stats AS IUS 
					ON (T.object_id = IUS.object_id)
				GROUP BY SCHEMA_NAME(schema_ID), T.Name, T.Create_date, T.modify_date'

IF @WhatIf = 0
BEGIN 
	IF @TargetDB = '?'
BEGIN
	INSERT INTO #Tables
				EXEC sp_MSforeachdb  @selectSQL
		SELECT * FROM #Tables
END
ELSE
		BEGIN
	INSERT INTO #Tables
			EXEC(@selectSQL)
		SELECT * FROM #Tables
		END
END
ELSE 
BEGIN
	PRINT (@selectSQL)
END
