DECLARE @sqluser1 varchar(MAX)
DECLARE @sqluser2 varchar(MAX)
DECLARE @sqluser3 varchar(MAX)
DECLARE @AccountRoot1 varchar(100) = ''
DECLARE @AccountRoot2 varchar(100) = '' 
DECLARE @AccountRoot3 varchar(100) =  ''
DECLARE @DryRun INT = 0 


select @sqluser1 ='
USE [master]

IF EXISTS ( SELECT * FROM sys.server_principals where name ='''+ @AccountRoot1 + ''')
	BEGIN
		ALTER LOGIN ['+  @AccountRoot1 + '] WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
		ALTER LOGIN ['+  @AccountRoot1 + ']  WITH PASSWORD= '''+  'NewPassword1234!!' +''' MUST_CHANGE

		PRINT ''The new password is NewPassword1234!! Once you login you will be requested to reset it.''
	END
'


select @sqluser2 ='
USE [master]

IF EXISTS ( SELECT * FROM sys.server_principals where name ='''+ @AccountRoot1 + ''')
	BEGIN
		ALTER LOGIN ['+  @AccountRoot2 + '] WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
		ALTER LOGIN ['+  @AccountRoot2 + ']  WITH PASSWORD= '''+  'NewPassword1234!!' +''' MUST_CHANGE

		PRINT ''The new password is NewPassword1234!! Once you login you will be requested to reset it.''
	END
'



select @sqluser3 ='
USE [master]

IF EXISTS ( SELECT * FROM sys.server_principals where name ='''+ @AccountRoot1 + ''')
	BEGIN
		ALTER LOGIN ['+  @AccountRoot3 + '] WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
		ALTER LOGIN ['+  @AccountRoot3 + ']  WITH PASSWORD= '''+  'NewPassword1234!!' +''' MUST_CHANGE

		PRINT ''The new password is NewPassword1234!! Once you login you will be requested to reset it.''
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


