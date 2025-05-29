use limc


select count(*) from log
--31,380,552
--11,632,037 2019-06-12


select top 1 * from lender
order by [time] desc


select * from scanbatch
where batchdate >= '2019-06-26'


select * from unitrac..connection_descriptor


UnitracAppUser

select * from loan
where number_tx = '1030402001'



select *from log
where   Workstation ='LIMC-APP-01' AND UserID = 'LIMCEmailExporter'
AND TIME >= '2020-03-01 09:37:57.390' AND TIME <= '2020-03-21 10:37:57.390'
order by Time desc 


Connected to Email Server: fmq.alliedsolutions.net

select TOP 5* from limc..
where userid ='LIMCEmailExporter'
and Time >= DateAdd(minute, -5, getdate())
order by Time desc 

USE UniTrac

DECLARE @filenames varchar(max)
DECLARE @file1 VARCHAR(MAX) = 'C:\Reports\Completed.csv'
DECLARE @file2 VARCHAR(MAX) = ';C:\Reports\Pending.csv' 
DECLARE @file3 VARCHAR(MAX) = ';C:\Reports\LongRunningProcesses.csv'
DECLARE @file4 VARCHAR(MAX) = ';C:\Reports\ProcessBreakdown.csv' 


-- Optional new attachments

-- Create list from optional files
SELECT @filenames = @file1 + @file2 +@file3 +@file4

              EXEC msdb.dbo.sp_send_dbmail 
			@Subject= 'UniTrac Escrow Web Report',
			@profile_name = 'Unitrac-prod',
			@body = 'Please see attached report that is attached',
			@body_format ='HTML',			
            @recipients = 'joseph.russell@alliedsolutions.net',
  @file_attachments = @filenames;

select * from log
where Workstation = 'LIMC-APP-01'
and Time >= DateAdd(minute, -15, getdate())
and userid <> 'LIMCEmailExporter'
order by Time desc 

select * from log
where Workstation = 'unitrac-wh012'
and Time >= DateAdd(minute, -15, getdate())
order by Time desc 





SELECT * FROM users 
WHERE USER_NAME_TX = 'TestAPI'


SELECT * FROM dbo.OUTPUT_BATCH
WHERE id IN (3379902 )