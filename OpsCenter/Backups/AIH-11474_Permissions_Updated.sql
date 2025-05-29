--DECLARE @tableupdate varchar(MAX) 
DECLARE @sqlpermissions varchar(MAX) 
DECLARE @AccountRoot varchar(100) = 'svc_idpm_qa01'
DECLARE @TargetDB varchar(100) ='?'
DECLARE @DryRun INT = 1




IF @DryRun = 0
BEGIN 

SET @sqlpermissions = 'USE [master]

IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE LOGIN ['+  @AccountRoot + '] WITH PASSWORD= '''+  @AccountRoot + ''' MUST_CHANGE, DEFAULT_DATABASE=[tempdb], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
		PRINT ''SUCCESS: LOGIN CREATED''
END
	ELSE 
BEGIN
		PRINT ''WARNING: USER ALREADY EXISTS''
END

USE '+ @TargetDB +'; EXEC sp_MSforeachtable @command1 ="
IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''+ @AccountRoot +''')
BEGIN
		CREATE USER ['+  @AccountRoot + '] FOR LOGIN ['+  @AccountRoot + '] 
		ALTER ROLE [db_datareader] ADD MEMBER ['+  @AccountRoot + '] 
		GRANT VIEW DEFINITION TO ['+  @AccountRoot + '] 

		PRINT ''SUCCESS: USER CREATED'';
END
	ELSE 
BEGIN
		PRINT ''WARNING: USER ALREADY EXISTS''
END"'
		EXEC sp_msforeachdb  @command1 =@sqlpermissions
	END
ELSE
	BEGIN 
		PRINT  @sqlpermissions
	END

	--303


	/*
	select CONCAT('USE [',name,'] DROP USER [svc_idpm_qa01]' )
	from sys.databases 
	where database_id <= '4'
	OR name in ('DBA', 'Perfstats')

*/