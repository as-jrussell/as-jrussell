SELECT MAX(login_time) AS [Last Login Time], login_name [Login]
FROM sys.dm_exec_sessions

GROUP BY login_name;

select *
--SELECT MAX(login_time) AS [Last Login Time], login_name [Login]
FROM sys.dm_exec_sessions
where login_name= 'openbpm'

