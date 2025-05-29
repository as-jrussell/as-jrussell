DECLARE @sqluser1 varchar(MAX)
DECLARE @sqluser2 varchar(MAX)
DECLARE @sqluser3 varchar(MAX)
DECLARE @AccountRoot1 varchar(100) = 'RFPLdbDeployer-QA'
DECLARE @AccountRoot2 varchar(100) = 'RFPLdbWebApp-QA' 
DECLARE @AccountRoot3 varchar(100) =  'RFPLdbWinSvcs-QA'
DECLARE @DryRun INT = 1 




select @sqluser1 ='
USE [master]

ALTER LOGIN ['+  @AccountRoot1 + '] WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
ALTER LOGIN ['+  @AccountRoot1 + ']  WITH PASSWORD= '''+  'NewPassword1234!!' +'

PRINT ''The new password for ['+  @AccountRoot1 + '] is NewPassword1234!!''
'


select @sqluser2 ='
USE [master]

ALTER LOGIN ['+  @AccountRoot2 + '] WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
ALTER LOGIN ['+  @AccountRoot2 + ']  WITH PASSWORD= '''+  'NewPassword1234!!' +'

PRINT ''The new password for ['+  @AccountRoot2 + '] is NewPassword1234!!''
'




select @sqluser3 ='
USE [master]

ALTER LOGIN ['+  @AccountRoot3 + '] WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
ALTER LOGIN ['+  @AccountRoot3 + ']  WITH PASSWORD= '''+  'NewPassword1234!!' +'

PRINT ''The new password for ['+  @AccountRoot3 + '] is NewPassword1234!!''
'



IF @DryRun = 0
	BEGIN 
		EXEC ( @sqluser1)
		EXEC ( @sqluser2)
		EXEC ( @sqluser3)
	END
ELSE
	BEGIN 
		PRINT ( @sqluser1)
		PRINT ( @sqluser2)
		PRINT ( @sqluser3)
	END


