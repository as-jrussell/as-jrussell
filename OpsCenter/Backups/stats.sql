SELECT TOP (1000) [RunID]
      ,[JobName]
      ,[DatabaseName]
      ,[SChemaName]
      ,[TableName]
      ,[RemoveCount]
      ,[RetainCount]
      ,[RunDate]
  FROM [AppLog].[archive].[PurgeHistory]


  
select   (select top 1  RemoveCount  FROM [AppLog].[archive].[PurgeHistory] ORDER BY runid DESC ) - ((select count(*) from  [Applog].[dbo].[Applog]) - (select top 1  RetainCount  FROM [AppLog].[archive].[PurgeHistory] ORDER BY runid DESC ))

86,712,185

exec dba.dbo.sp_whoisactive
select * 
--update P set TableRetention = '180',BatchSize ='2500'
  FROM [AppLog]. [archive].[PurgeConfig] P 



   
SELECT (SELECT count(*) FROM [Applog].[dbo].[Applog] WHERE DateDiff(day, Modified, GetDate()) > 855) / 20000 [Minutes left]



   
SELECT (SELECT count(*) FROM [Applog].[dbo].[Applog] WHERE DateDiff(day, Modified, GetDate()) > 855) / 20000 /60. [Hours left]

--190.200000


select    ((select count(*) from  [Applog].[dbo].[Applog])) -  (select top 1  RemoveCount  FROM [AppLog].[archive].[PurgeHistory] ORDER BY runid DESC ) 

--196,726,004   to go 
--12,4911,877

select   (select top 1  RemoveCount  FROM [AppLog].[archive].[PurgeHistory] ORDER BY runid DESC ) - ((select count(*) from  [Applog].[dbo].[Applog]) - (select top 1  RetainCount  FROM [AppLog].[archive].[PurgeHistory] ORDER BY runid DESC ))

--31,567,622 deleted so far

--9,465,780
--20,212,180

select top 1  RemoveCount  FROM [AppLog].[archive].[PurgeHistory] ORDER BY runid DESC 


65,182,158

--228,280,690 goal





select   (select top 1  RemoveCount  FROM [AppLog].[archive].[PurgeHistory] ORDER BY runid DESC ) - ((select count(*) from  [Applog].[dbo].[Applog]) - (select top 1  RetainCount  FROM [AppLog].[archive].[PurgeHistory] ORDER BY runid DESC ))


--189,167,713 2021-05-12 12:20:59.000


select min(modified) from  [Applog].[dbo].[Applog]

select min(modified) from  [Applog].[dbo].[Applog]



select (GETDATE() -180)



