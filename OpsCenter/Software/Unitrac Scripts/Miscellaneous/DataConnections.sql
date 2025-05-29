use unitrac

--=============================================
--Database Connections Using DMVs
--=============================================

SELECT DB_NAME(eS.database_id) AS the_database
	, eS.is_user_process
	, COUNT(eS.session_id) AS total_database_connections
FROM sys.dm_exec_sessions eS 
GROUP BY DB_NAME(eS.database_id)
	, eS.is_user_process
ORDER BY 1, 2;



--=============================================
--Database Connections Using sys.sysprocesses
--=============================================
SELECT DB_NAME(sP.dbid) AS the_database
	, COUNT(sP.spid) AS total_database_connections
FROM sys.sysprocesses sP
GROUP BY DB_NAME(sP.dbid)
ORDER BY 1;



--=============================================
--Database Connections Using DMVs Pre-SQL 2014
--=============================================
SELECT DB_NAME(ST.dbid) AS the_database
	, COUNT(eC.connection_id) AS total_database_connections
FROM sys.dm_exec_connections eC 
	CROSS APPLY sys.dm_exec_sql_text (eC.most_recent_sql_handle) ST
	LEFT JOIN sys.dm_exec_sessions eS 
		ON eC.most_recent_session_id = eS.session_id
GROUP BY DB_NAME(ST.dbid)
ORDER BY 1;



--=====================================================
--Database Connections Using dm_os_performance_counters
--=====================================================
SELECT oPC.cntr_value AS connection_count
FROM sys.dm_os_performance_counters oPC
WHERE 
	(
		oPC.[object_name] = 'SQLServer:General Statistics'
			AND oPC.counter_name = 'User Connections'
	)
ORDER BY 1;


GRANT VIEW SERVER STATE TO UTdbLinkedUTDB01_UTLSQL

VIEW SERVER STATE permission was denied on object 'server', database 'master'.

SELECT DB_NAME(dbid) as "Database", COUNT(dbid) as "Number Of Open Connections",

loginame as LoginName

FROM sys.sysprocesses

WHERE dbid > 0

GROUP BY dbid, loginame
order by COUNT(dbid) DESC




SELECT
loginame as LoginName, hostname, program_name, cmd,  login_time, last_batch, open_tran, status, blocked, waittime, lastwaittype
  FROM sys.sysprocesses

WHERE 
hostname = 'UNITRAC-APP02'  
and loginame = 'UTdbLDHSvcProd'  


SELECT COUNT(loginame)
  FROM sys.sysprocesses
WHERE  
hostname = 'UNITRAC-APP02'  
and loginame = 'UTdbLDHSvcProd'  and status = 'sleeping' AND 
login_time >= DateAdd(MINUTE, -120, getdate())


IF (SELECT COUNT(*)

FROM sys.dm_exec_sessions dec

WHERE dec.program_name LIKE 'LDHServiceUSD'

AND DEC.login_name LIKE 'UTdbLDHSvcProd'

AND DATEDIFF(MINUTE, dec.last_request_start_time, GETDATE()) >= 5) >= 100

BEGIN

       RAISERROR ('LDH Service stuck', 16, 1)

END

 



SELECT
loginame as LoginName, hostname, program_name, count(*)
  FROM sys.sysprocesses
WHERE 
hostname = 'UNITRAC-APP02'  
and loginame = 'UTdbLDHSvcProd'  and status = 'sleeping' 
group by loginame, hostname, program_name                                                                                                    
having count(*) > '50'

select *
  FROM sys.sysprocesses
WHERE  
hostname = 'UNITRAC-APP02'  
and loginame = 'UTdbLDHSvcProd'  and status = 'sleeping' AND 
login_time >= DateAdd(MINUTE, -60, getdate())



SELECT
CPU = SUM(cpu_time)
,WaitTime = SUM(total_scheduled_time)
,ElapsedTime	= SUM(total_elapsed_time)
,Reads = SUM(num_reads)
,Writes = SUM(num_writes)
,Connections	= COUNT(1)
,Program = program_name
FROM sys.dm_exec_connections con
LEFT JOIN sys.dm_exec_sessions ses
ON ses.session_id = con.session_id
GROUP BY program_name
ORDER BY cpu DESC



select @@spid;
select SERVERPROPERTY('ProductLevel');
SELECT
CPU = SUM(cpu_time)
,WaitTime = SUM(total_scheduled_time)
,ElapsedTime	= SUM(total_elapsed_time)
,Reads = SUM(num_reads)
,Writes = SUM(num_writes)
,Connections	= COUNT(1)
,[login] = original_login_name
from sys.dm_exec_connections con
LEFT JOIN sys.dm_exec_sessions ses
ON ses.session_id = con.session_id
GROUP BY original_login_name
order by COUNT(1) DESC  



SELECT st.text, r.session_id, r.status, r.command, r.cpu_time, r.total_elapsed_time
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS st



