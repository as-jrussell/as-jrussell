		 EXEC msdb.dbo.sp_send_dbmail @profile_name = 'sqlsdevawec01',
						@recipients = 'alain.cataga@alliedsolutions.net',
						@subject = 'Email',
						@body = 'Test'