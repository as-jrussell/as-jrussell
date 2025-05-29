use master



SELECT
loginame as LoginName, hostname, program_name, cmd,  login_time, last_batch, open_tran, status, blocked, waittime, lastwaittype, spid
  FROM sys.sysprocesses

WHERE 
cmd != 'AWAITING COMMAND' and spid not between 1 and 50
order by spid asc