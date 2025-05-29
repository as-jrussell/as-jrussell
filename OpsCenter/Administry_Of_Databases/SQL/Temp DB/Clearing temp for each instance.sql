USE [tempdb]
GO
 USE master
 /*

 https://sqlsunday.com/2013/08/11/shrinking-tempdb-without-restarting-sql-server/

 */


 sp_helpdb 'TempDB'

 use tempdb

	SELECT CONCAT('IF EXISTS (SELECT 1 FROM [tempdb].SYS.database_files WHERE NAME = ''',NAME,''')
	BEGIN
	USE [tempdb]
	DBCC SHRINKFILE(''',NAME,''',0)
	END')
	--SELECT *
	FROM SYS.database_files





