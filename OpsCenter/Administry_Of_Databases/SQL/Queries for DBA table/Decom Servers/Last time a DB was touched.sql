
		select CASE WHEN MAX(TimeStampUTC) is null THEN 'Never been access' ELSE
		CAST(MAX(TimeStampUTC)AS nvarchar(255)) END [Last time DB access], D.name [Database Name],  CAST(d.create_date AS nvarchar(255)) [Database Create Date]
		--select *
		from sys.databases D 
		LEFt JOIN dba.info.AuditLogin A on D.name = A.DatabaseName
		where database_id > 4 AND name not in ('DBA', 'Perfstats', 'HDTStorage')
		AND name not in (select name from sys.databases where create_date  >= DateAdd(HOUR, -36, getdate()))
		GROUP BY D.name , CAST(create_date AS nvarchar(255))
		ORDER BY MAX(TimeStampUTC) desc 


		--select CAST(GETDATE() AS nvarchar(255)) 