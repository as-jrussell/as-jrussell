IF Object_id(N'tempdb..#email') IS NOT NULL
  DROP TABLE #email

CREATE TABLE #email (name nvarchar(max) );

INSERT INTO #email 
SELECT [name]
  FROM [msdb].[dbo].[sysmail_account]
  where name like 'no-reply%'


  select *
  from #email