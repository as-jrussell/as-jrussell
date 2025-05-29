USE master


IF exists(select 1 from sys.databases where name = 'SQL' and (suser_sname( owner_sid ) = 'ELDREDGE_A\canderson')  )

BEGIN 
		EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'SQL'
		DROP DATABASE [SQL]
		PRINT 'SUCCESS: Database successfully dropped!!!'
END

	ELSE

BEGIN 

		PRINT 'WARNING: No database by that name please check your settings!!!'

END