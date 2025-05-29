-- list jobs and schedule info with daily and weekly schedules

-- jobs with a daily schedule
select
 sysjobs.name job_name
,sysjobs.enabled job_enabled
,sysschedules.name schedule_name
,sysschedules.freq_recurrence_factor
,case
 when freq_type = 4 then 'Daily'
end frequency
,
'every ' + cast (freq_interval as varchar(3)) + ' day(s)'  Days
,
case
 when freq_subday_type = 2 then ' every ' + cast(freq_subday_interval as varchar(7)) 
 + ' seconds' + ' starting at '
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
 when freq_subday_type = 4 then ' every ' + cast(freq_subday_interval as varchar(7)) 
 + ' minutes' + ' starting at '
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
 when freq_subday_type = 8 then ' every ' + cast(freq_subday_interval as varchar(7)) 
 + ' hours'   + ' starting at '
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
 else ' starting at ' 
 +stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
end time
from msdb.dbo.sysjobs
inner join msdb.dbo.sysjobschedules on sysjobs.job_id = sysjobschedules.job_id
inner join msdb.dbo.sysschedules on sysjobschedules.schedule_id = sysschedules.schedule_id
where freq_type = 4

union

-- jobs with a weekly schedule
select
 sysjobs.name job_name
,sysjobs.enabled job_enabled
,sysschedules.name schedule_name
,sysschedules.freq_recurrence_factor
,case
 when freq_type = 8 then 'Weekly'
end frequency
,
replace
(
 CASE WHEN freq_interval&1 = 1 THEN 'Sunday, ' ELSE '' END
+CASE WHEN freq_interval&2 = 2 THEN 'Monday, ' ELSE '' END
+CASE WHEN freq_interval&4 = 4 THEN 'Tuesday, ' ELSE '' END
+CASE WHEN freq_interval&8 = 8 THEN 'Wednesday, ' ELSE '' END
+CASE WHEN freq_interval&16 = 16 THEN 'Thursday, ' ELSE '' END
+CASE WHEN freq_interval&32 = 32 THEN 'Friday, ' ELSE '' END
+CASE WHEN freq_interval&64 = 64 THEN 'Saturday, ' ELSE '' END
,', '
,''
) Days
,
case
 when freq_subday_type = 2 then ' every ' + cast(freq_subday_interval as varchar(7)) 
 + ' seconds' + ' starting at '
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':') 
 when freq_subday_type = 4 then ' every ' + cast(freq_subday_interval as varchar(7)) 
 + ' minutes' + ' starting at '
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
 when freq_subday_type = 8 then ' every ' + cast(freq_subday_interval as varchar(7)) 
 + ' hours'   + ' starting at '
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
 else ' starting at ' 
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
end time
from msdb.dbo.sysjobs
inner join msdb.dbo.sysjobschedules on sysjobs.job_id = sysjobschedules.job_id
inner join msdb.dbo.sysschedules on sysjobschedules.schedule_id = sysschedules.schedule_id
where freq_type = 8
order by job_enabled desc

-- run code to assign two monthly schedules to one job

-- detach Weekly on Saturday Morning at 1 AM schedule
-- for Insert into JobRunLog table with a schedule job
exec msdb.dbo.sp_detach_schedule  
    @job_name = 'Insert into JobRunLog table with a schedule',  
    @schedule_name = 'Weekly on Saturday Morning at 1 AM' ;  
GO 

-- add a schedule to run last second of last day of each month
-- and attach it to the Insert into JobRunLog table with a schedule job
declare @ReturnCode int
if exists (select name from msdb.dbo.sysschedules WHERE name = N'Run last second of last day each month')
delete from msdb.dbo.sysschedules where name=N'Run last second of last day each month'

exec @ReturnCode = msdb.dbo.sp_add_schedule  
        @schedule_name = N'Run last second of last day each month',
  @enabled=1, 
  @freq_type=32,              -- means monthly relative
  @freq_interval=8,           -- means day for monthly relative
  @freq_subday_type=1, 
  @freq_subday_interval=0, 
  @freq_relative_interval=16, -- means last for freq_interval with monthly relative
  @freq_recurrence_factor=1, 
  @active_start_date=20170809, 
  @active_end_date=99991231, 
  @active_start_time=235958,  -- must schedule at least 1 second before last second of day
  @active_end_time=235959

exec @ReturnCode = msdb.dbo.sp_attach_schedule  
   @job_name = N'Insert into JobRunLog table with a schedule',  
   @schedule_name = N'Run last second of last day each month' 

GO

-- add a schedule to run last second of 15th day of each month
-- and also attach it to the Insert into JobRunLog table with a schedule job
declare @ReturnCode int
if exists (select name from msdb.dbo.sysschedules WHERE name=N'Run last second of 15th day of the month')
delete from msdb.dbo.sysschedules where name=N'Run last second of 15th day of the month'

exec @ReturnCode = msdb.dbo.sp_add_schedule  
        @schedule_name = N'Run last second of 15th day of the month',
  @enabled=1, 
  @freq_type=16,              -- means monthly
  @freq_interval=15,          -- means 15 day of month
  @freq_subday_type=1, 
  @freq_subday_interval=0, 
  @freq_relative_interval=0, 
  @freq_recurrence_factor=1, 
  @active_start_date=20170809, 
  @active_end_date=99991231, 
  @active_start_time=235958,  -- must schedule at least 1 second before last second of day
  @active_end_time=235959

exec @ReturnCode = msdb.dbo.sp_attach_schedule  
   @job_name = N'Insert into JobRunLog table with a schedule',  
   @schedule_name = N'Run last second of 15th day of the month'



   -- jobs with a monthly schedule
select
 sysjobs.name job_name
,sysjobs.enabled job_enabled
,sysschedules.name schedule_name
,sysschedules.freq_recurrence_factor
,case
 when freq_type = 4 then 'Daily'
 when freq_type = 8 then 'Weekly'
 when freq_type = 16 then 'Monthly'
 when freq_type = 32 then 'Monthly'
end frequency
,
case 
when freq_type = 32 then
(
 case
  when freq_relative_interval = 1 then 'First '
  when freq_relative_interval = 2 then 'Second '
  when freq_relative_interval = 4 then 'Third '
  when freq_relative_interval = 8 then 'Fourth '
  when freq_relative_interval = 16 then 'Last '
 end 
 +
 replace
 (
  case when freq_interval = 1 THEN 'Sunday, ' ELSE '' END
 +case when freq_interval = 2 THEN 'Monday, ' ELSE '' END
 +case when freq_interval = 3 THEN 'Tuesday, ' ELSE '' END
 +case when freq_interval = 4 THEN 'Wednesday, ' ELSE '' END
 +case when freq_interval = 5 THEN 'Thursday, ' ELSE '' END
 +case when freq_interval = 6 THEN 'Friday, ' ELSE '' END
 +case when freq_interval = 7 THEN 'Saturday, ' ELSE '' END
 +case when freq_interval = 8 THEN 'Day of Month, ' ELSE '' END
 +case when freq_interval = 9 THEN 'Weekday, ' ELSE '' END
 +case when freq_interval = 10 THEN 'Weekend day, ' ELSE '' END

 ,', '
 ,''
 )
)
else cast(freq_interval as varchar(3)) END Days
,
case
 when freq_subday_type = 2 then ' every ' + cast(freq_subday_interval as varchar(7)) 
 + ' seconds' + ' starting at '
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':') 
 when freq_subday_type = 4 then ' every ' + cast(freq_subday_interval as varchar(7)) 
 + ' minutes' + ' starting at '
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
 when freq_subday_type = 8 then ' every ' + cast(freq_subday_interval as varchar(7)) 
 + ' hours'   + ' starting at '
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
 else ' starting at ' 
 + stuff(stuff(RIGHT(replicate('0', 6) +  cast(active_start_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')
end time
from msdb.dbo.sysjobs
inner join msdb.dbo.sysjobschedules on sysjobs.job_id = sysjobschedules.job_id
inner join msdb.dbo.sysschedules on sysjobschedules.schedule_id = sysschedules.schedule_id
where freq_type in (16, 32)