
  use master

  select COUNT(*) from PremAcc3_Restore.sys.tables
  where type = 'U' AND name = 'Report_Parameters'
 -- order by modify_date desc

  
   

  select *from PremAcc3.sys.objects
  where name = 'ReportParameters'

  select *
   --select CONCAT('TRUNCATE TABLE [PremAcc3_Restore].[dbo].[', b.NAME,']')  
 -- select CONCAT('SELECT count(*) FROM [PremAcc3_Restore].[dbo].[', A.NAME,']')  
  from PremAcc3.sys.tables A
  left join PremAcc3_Restore.sys.tables B on A.name = B.name
  where A.type = 'U'
  and
  A.name in ('Big_Parameters',
'BSS_TranLog',
'BSS_TranLog_IO',
'Field_Tracking',
'Import_List',
'ImportParameters',
'ImportParametersHistory',
'Parameters',
'Report_List',
'ReportParameters',
'ReportParametersHIstory',
'ScheduleParameters',
'Service_Statistics')


SELECT count(*) FROM [PremAcc3_Restore].[dbo].[Big_Parameters]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[BSS_TranLog]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[BSS_TranLog_IO]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[Field_Tracking]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[Import_List]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[ImportParameters]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[ImportParametersHistory]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[Parameters]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[Report_List]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[ReportParameters]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[ReportParametersHistory]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[ScheduleParameters]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[Service_Statistics]


SELECT top 5 * FROM [PremAcc3_Restore].[dbo].[BSS_TranLog]
order by id desc


SELECT count(*) FROM [PremAcc3_Restore].[dbo].[Big_Parameters]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[BSS_TranLog]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[BSS_TranLog_IO]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[Field_Tracking]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[Import_List]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[ImportParameters]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[ImportParametersHistory]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[Parameters]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[Report_List]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[ReportParametersHistory]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[ScheduleParameters]
SELECT count(*) FROM [PremAcc3_Restore].[dbo].[Service_Statistics]