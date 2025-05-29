DECLARE @sqluser1 varchar(MAX)
DECLARE @AccountRoot1 varchar(100) = 'pims-readonly-prod'
DECLARE @DryRun INT = 0 




select @sqluser1 ='
USE [master]

IF EXISTS ( SELECT * FROM sys.server_principals where name ='''+ @AccountRoot1 + ''')
	BEGIN
		ALTER LOGIN ['+  @AccountRoot1 + '] WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
		ALTER LOGIN ['+  @AccountRoot1 + ']  WITH PASSWORD= '''+  'PasswordinCyberArk' +'''

		PRINT ''The new password for the account has been updated and placed in CyberArk.''
	END 
'





IF @DryRun = 0
	BEGIN 
		EXEC ( @sqluser1)
	END
ELSE
	BEGIN 
		PRINT ( @sqluser1)
	END

