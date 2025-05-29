DECLARE @sqluser1 varchar(MAX)
DECLARE @sqluser2 varchar(MAX)
DECLARE @AccountRoot1 varchar(100) = 'SCRIBE'
DECLARE @AccountRoot2 varchar(100) = 'sysdba'
DECLARE @DryRun INT = 1 




select @sqluser1 ='
USE [master]

IF EXISTS ( SELECT * FROM sys.server_principals where name ='''+ @AccountRoot1 + ''')
	BEGIN
		ALTER LOGIN ['+  @AccountRoot1 + '] WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
		ALTER LOGIN ['+  @AccountRoot1 + ']  WITH PASSWORD= '''+  'NewPassword1234!!' +'''

		PRINT ''The new password for '''+ @AccountRoot1+ ''' has updated and placed in CyberArk.''
	END 
'



select @sqluser2 ='
USE [master]

IF EXISTS ( SELECT * FROM sys.server_principals where name ='''+ @AccountRoot2 + ''')
	BEGIN
		ALTER LOGIN ['+  @AccountRoot2 + '] WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
		ALTER LOGIN ['+  @AccountRoot2 + ']  WITH PASSWORD= '''+  'NewPassword1234!!' +'''

		PRINT ''The new password for '''+ @AccountRoot2+ ''' has updated and placed in CyberArk.''
	END 
'





IF @DryRun = 0
	BEGIN 
		EXEC ( @sqluser1)
		EXEC ( @sqluser2)
	END
ELSE
	BEGIN 
		PRINT ( @sqluser1)
		PRINT ( @sqluser2)
	END


