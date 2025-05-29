DECLARE @sqluser1 varchar(MAX)
DECLARE @sqluser2 varchar(MAX)
DECLARE @sqluser3 varchar(MAX)
DECLARE @AccountRoot1 varchar(100) = 'INFA_DOM'
DECLARE @AccountRoot2 varchar(100) = 'INFA_REP' 
DECLARE @AccountRoot3 varchar(100) =  'INFA_DX'




select @sqluser1 ='
USE [master]

ALTER LOGIN ['+  @AccountRoot1 + '] WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
ALTER LOGIN ['+  @AccountRoot1 + ']  WITH PASSWORD= '''+  'NewPassword1234!!' +''' MUST_CHANGE

PRINT ''The new password is NewPassword1234!! Once you login you will be requested to reset it.''
'


select @sqluser2 ='
USE [master]

ALTER LOGIN ['+  @AccountRoot2 + '] WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
ALTER LOGIN ['+  @AccountRoot2 + ']  WITH PASSWORD= '''+  'NewPassword1234!!' +''' MUST_CHANGE

PRINT ''The new password is NewPassword1234!! Once you login you will be requested to reset it.''
'



select @sqluser3 ='
USE [master]

ALTER LOGIN ['+  @AccountRoot3 + '] WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
ALTER LOGIN ['+  @AccountRoot3 + ']  WITH PASSWORD= '''+  'NewPassword1234!!' +''' MUST_CHANGE

PRINT ''The new password is NewPassword1234!! Once you login you will be requested to reset it.''
'


EXEC (@SQLUSER1)
EXEC (@SQLUSER2)
EXEC (@SQLUSER3)

