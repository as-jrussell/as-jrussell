DECLARE @DATE DATE = '2021-12-01'


	SELECT  [DatabaseName]
		,[TableName]
		,CONVERT (DATE, [maxUserSeek])[maxUserSeek]
		,CONVERT (DATE, [maxUserScan]) [maxUserScan]
		,CONVERT (DATE, [maxUserLookup])[maxUserLookup]
		,CONVERT (DATE, [maxUserUpdate])[maxUserUpdate]
			FROM [DBA].[info].[TableUsage] T 
			JOIN sys.databases D on T.DatabaseName  = D.name
				WHERE (database_id >=5 AND  name NOT IN ('DBA', 'PERFSTATS')) 
				GROUP BY  [DatabaseName],[TableName],  CONVERT (DATE, [maxUserSeek])
					,CONVERT (DATE, [maxUserScan])
					,CONVERT (DATE, [maxUserLookup])
					,CONVERT (DATE, [maxUserUpdate])
				HAVING (CONVERT (DATE, [maxUserSeek]) >= @DATE
					OR CONVERT (DATE, [maxUserScan]) >= @DATE
					OR CONVERT (DATE, [maxUserLookup]) >= @DATE
					OR CONVERT (DATE, [maxUserUpdate]) >= @DATE)

