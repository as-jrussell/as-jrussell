DECLARE @sqluser varchar(MAX)
DECLARE @AccountRoot varchar(100) = 'UTdbInternalDashWinServiceQA'
DECLARE @DryRun INT = 0



select @sqluser ='
USE [master]

CREATE LOGIN ['+  @AccountRoot + '] WITH PASSWORD= '''+  'NewPassword1234!!' +''' MUST_CHANGE, DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON

PRINT ''The new password is NewPassword1234!! Once you login you will be requested to reset it.''
'



IF @DryRun = 0 
BEGIN 
	EXEC ( @sqluser)
END

	ELSE
BEGIN 
	PRINT ( @sqluser)
END



