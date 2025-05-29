

sys.sp_lock 



SELECT * FROM sys.dm_tran_locks 

select cmd,* from sys.sysprocesses
where blocked > 0