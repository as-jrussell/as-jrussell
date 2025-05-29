

IF EXISTS(select 1 from sys.databases where name = 'IND_AlliedSolutions_157GIC109')
BEGIN 
	USE [master]
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'IND_AlliedSolutions_157GIC109'
		DROP DATABASE [IND_AlliedSolutions_157GIC109]
		PRINT 'SUCCESS: IND_AlliedSolutions_157GIC109 has been dropped and space should be reclaimed'
END
	ELSE
BEGIN

	PRINT 'WARNING: IND_AlliedSolutions_157GIC109 has been dropped please check your settings'

END