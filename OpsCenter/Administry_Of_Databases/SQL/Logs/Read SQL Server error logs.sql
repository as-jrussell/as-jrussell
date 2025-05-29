
/*https://www.sqlshack.com/read-sql-server-error-logs-using-the-xp_readerrorlog-command/ */


EXEC xp_readerrorlog 
    0, 
    1, 
    N'', 
    N'', 
    N'2022-03-01 08:21:44.410',
    N'2023-01-01 00:00:01.000', 
    N'desc'







-----SQL Agent Server log recycle
--EXEC msdb.dbo.sp_cycle_agent_errorlog
--GO

-----SQL Server log recycle
--EXEC sp_cycle_errorlog

--EXEC xp_ReadErrorLog 0, 1, N'sql2000'


--exec xp_enumerrorlogs 


----Location of Error logs
--SELECT SERVERPROPERTY('ErrorLogFileName')  AS 'Error log location'