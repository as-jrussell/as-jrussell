#Creates the CSV files


Invoke-SQLcmd -QueryTimeout 0 -Server 'UT-PRD-LISTENER' -Database Unitrac 'EXEC UT_CompletedJob' | Export-Csv -path "C:\Downloads\Morning\Completed.csv"

Invoke-SQLcmd -QueryTimeout 0 -Server 'UT-PRD-LISTENER' -Database Unitrac 'EXEC UT_PendingJob' | Export-Csv -path "C:\Downloads\Morning\Pending.csv"


Invoke-SQLcmd -QueryTimeout 0 -Server 'UT-PRD-LISTENER' -Database Unitrac 'EXEC UT_LongRunningProcesses' | Export-Csv -path "C:\Downloads\Morning\LongRunningProcesses.csv"


Invoke-SQLcmd -QueryTimeout 0 -Server 'UT-PRD-LISTENER' -Database Unitrac 'EXEC UT_ProcessBreakdown' | Export-Csv -path "C:\Downloads\Morning\ProcessBreakdown.csv"


#Converts to XLSX


Move-Item "C:\Downloads\Morning\*" "\\on-sqlclstprd-2\c$\Reports\" -Force 




Invoke-SQLcmd -QueryTimeout 0 -Server 'on-sqlclstprd-2' -Database Unitrac '
DECLARE @filenames varchar(max)
DECLARE @file1 VARCHAR(MAX) = ''C:\Reports\Completed.csv''
DECLARE @file2 VARCHAR(MAX) = '';C:\Reports\Pending.csv'' 
DECLARE @file3 VARCHAR(MAX) = '';C:\Reports\LongRunningProcesses.csv''
DECLARE @file4 VARCHAR(MAX) = '';C:\Reports\ProcessBreakdown.csv''
SELECT @filenames = @file1

-- Optional new attachments

-- Create list from optional files
SELECT @filenames = @file1 + @file2 +@file3 +@file4

              EXEC msdb.dbo.sp_send_dbmail 
			@Subject= ''Process Stats in the morning'',
			@profile_name = ''Unitrac-prod'',
			@body = ''Good Morning all: Here is todays report'',
			@body_format =''HTML'',			
            @recipients = ''joseph.russell@alliedsolutions.net'',
  @file_attachments = @filenames;'
 
