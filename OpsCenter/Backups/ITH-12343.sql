use [PremAcc3]
GO
REVOKE EXECUTE ON [dbo].[BSS_Log_Tran] TO [PIMSAppServiceTest] AS [dbo]
GO
use [PremAcc3]
GO
GRANT EXECUTE ON [dbo].[BSS_Log_Tran] TO [svcPIMStest]
GO



USE [PremAcc3]
GO
/****** Object:  User [PIMSAppServiceTest]    Script Date: 10/18/2021 9:20:15 AM ******/
DROP USER [PIMSAppServiceTest]
GO


SELECT USER_NAME(grantee_principal_id),OBJECT_NAME(major_id),
* FROM sys.database_permissions
where USER_NAME(grantee_principal_id) = 'PIMSAppServiceTest'


SELECT USER_NAME(grantee_principal_id),OBJECT_NAME(major_id),
* FROM sys.database_permissions
where USER_NAME(grantee_principal_id) = 'svcPIMSTest'


