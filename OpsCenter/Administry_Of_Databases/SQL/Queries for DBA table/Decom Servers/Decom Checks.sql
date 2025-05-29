

---Audit Logins
		select CASE WHEN MAX(TimeStampUTC) is null THEN 'Never been access' ELSE
		CAST(MAX(TimeStampUTC)AS nvarchar(255)) END [Last time DB access], D.name,  CAST(create_date AS nvarchar(255)) [Database Creation]
		--select D.Name, A.*
		from sys.databases D 
		LEFt JOIN dba.info.AuditLogin A on D.name = A.DatabaseName
		where database_id > 4 AND name not in ('DBA', 'Perfstats', 'HDTStorage') 
		--AND name not in (select name from sys.databases where create_date  >= DateAdd(HOUR, -36, getdate()))
		GROUP BY D.name , CAST(create_date AS nvarchar(255))
		ORDER BY MAX(TimeStampUTC) desc 

--Table Usage

		SELECT * FROM [DBA].[info].[TableUsage] 
		WHERE DatabaseName not in ('DBA', 'Perfstats', 'HDTStorage', 'msdb','master', 'tempdb', 'model')

		
---Stored Proc Usage
			SELECT * FROM [DBA].[info].[ProcedureUsage] 
		WHERE DatabaseName not in ('DBA', 'Perfstats', 'HDTStorage', 'msdb','master', 'tempdb', 'model')
		and LastExecDate is not null 
		order by LastExecDate DESC 