/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [JobName]
      ,[TableName]
      ,[TableRetention]
      ,[BatchSize]
      ,[Enabled]
  FROM [RPA].[UIPath].[AgentJobTableRetention]


   use uipath
select concat('DELETE top (',[BatchSize],') from ',[TableName],' WHERE DateDiff(day, CreationTime, GetDate()) >  ',[TableRetention])
  FROM [RPA].[UIPath].[AgentJobTableRetention]
  where [TableName] in ('Jobs', 'QueueItems', 'Ledger')

select top 1000 * from Ledger WHERE DateDiff(day, CreationTime, GetDate()) >  45
select top 1000 * from LedgerDeliveries WHERE DateDiff(day, CreatedTime, GetDate()) >  45
select top 10000 * from QueueItems WHERE DateDiff(day, CreationTime, GetDate()) >  60
select top 1000 * from Logs WHERE DateDiff(day, TimeStamp, GetDate()) >  60
select top 1000 * from AuditLogs WHERE DateDiff(day, ExecutionTime, GetDate()) >  60
select top 1000 * from jobs WHERE DateDiff(day, CreationTime, GetDate()) >  60
select top 1000 * from TenantNotifications WHERE DateDiff(day, CreationTime, GetDate()) >  60
select top 1000 * from  rpa.uipath.TableCleanupHistory WHERE DateDiff(day, RunDate, GetDate()) >  180

select 'Ledger', count(*) from Ledger  WHERE DateDiff(day, CreationTime, GetDate()) >  45 -- 93,408,344
select 'LedgerDeliveries', count(*) from LedgerDeliveries WHERE DateDiff(day, CreatedTime, GetDate()) >  45 --0
select 'QueueItems', count(*) from QueueItems WHERE DateDiff(day, CreationTime, GetDate()) >  60 --41,056,590
select 'Logs', count(*) from Logs WHERE DateDiff(day, TimeStamp, GetDate()) >  60 --0
select 'AuditLogs', count(*) from AuditLogs WHERE DateDiff(day, ExecutionTime, GetDate()) >  60 --0
select 'jobs', count(*) from jobs WHERE DateDiff(day, CreationTime, GetDate()) >  60--610,182
select 'TenantNotifications', count(*) from TenantNotifications WHERE DateDiff(day, CreationTime, GetDate()) >  60 --0
select 'TableCleanupHistory', count(*) from rpa.uipath.TableCleanupHistory WHERE DateDiff(day, RunDate, GetDate()) >  180 --0






