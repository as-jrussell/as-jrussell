USE [master]
GO


IF EXISTS(SELECT * FROM sys.server_principals WHERE name = 'Pingfed_DB_SVC' and is_disabled =0)
BEGIN

			DENY CONNECT SQL TO [Pingfed_DB_SVC]
			ALTER LOGIN [Pingfed_DB_SVC] DISABLE

			USE [Pingfederate]
			DROP USER [Pingfed_DB_SVC]
			PRINT 'SUCCESS: User has been removed and disabled'
END

	ELSE

BEGIN
			PRINT 'FAIL: Please validate user existence!'
END