USE master

--Displays the last statement sent from a client to an instance of Microsoft SQL Server
DECLARE @sqltext VARBINARY(max)
DECLARE @spid2 smallint = 140 

SELECT @sqltext = sql_handle
FROM sys.sysprocesses
WHERE spid = @spid2;
SELECT TEXT
FROM sys.dm_exec_sql_text(@sqltext)

SELECT *   
FROM sys.dm_exec_requests   
WHERE session_id = @spid2;



DBCC INPUTBUFFER (@spid2) WITH NO_INFOMSGS  
