USE [master]
GO

DECLARE @sqluser1 varchar(MAX)
DECLARE @DryRun INT = 0

select @sqluser1 ='
USE [master]
IF EXISTS(select * from sys.linked_logins where remote_name = ''INFOR-SQL01.COLO.AS.LOCAL'')
	BEGIN

		EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N''INFOR-SQL01.COLO.AS.LOCAL'', @locallogin = NULL , @useself = N''False'', @rmtuser = N''pims-readonly-prod'', @rmtpassword = N''PasswordinCyberArk''
		PRINT ''The new password for the account has been updated and placed in CyberArk.''

	END'



IF @DryRun = 0
	BEGIN 
		EXEC ( @sqluser1)
	END
ELSE
	BEGIN 
		PRINT ( @sqluser1)
	END

