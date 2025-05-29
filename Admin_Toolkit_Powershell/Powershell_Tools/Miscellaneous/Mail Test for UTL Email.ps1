


Invoke-SQLcmd -QueryTimeout 0 -Server 'UTL-SQL-01'

            'EXEC msdb.dbo.sp_send_dbmail 
			@Subject= ''Daily UTL Rematch Report'',
			@profile_name = ''Unitrac-prod'',
			@body = ''test'',
			@body_format =''HTML'',			
@recipients = ''joseph.russell@alliedsolutions.net''';
