select recovery_model_desc,*
    FROM sys.databases
	where recovery_model_desc <> 'SIMPLE'
	AND (database_id >=5 AND  name != 'DBA') 
 
 select   CONCAT('USE MASTER',' ','ALTER DATABASE',' ',[Name],' ', 'SET RECOVERY SIMPLE WITH NO_WAIT')
 --select *
    FROM sys.databases
	where recovery_model_desc <> 'SIMPLE'
	AND (database_id >=5 AND  name != 'DBA') 

