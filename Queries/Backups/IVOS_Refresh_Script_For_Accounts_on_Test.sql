
USE [IVOS]
GO
ALTER ROLE [SAIL_APP_ACCESS] DROP MEMBER [ELDREDGE_A\svc_idnw_ivos_prd01]
ALTER ROLE [db_datareader] DROP MEMBER [ELDREDGE_A\svc_idnw_ivos_prd01]
ALTER ROLE [db_datawriter] DROP MEMBER [ELDREDGE_A\svc_idnw_ivos_prd01]
GO


USE [IVOS]
GO

/****** Object:  User [ELDREDGE_A\svc_idnw_ivos_prd01]    Script Date: 2/22/2023 2:22:34 PM ******/
DROP USER [ELDREDGE_A\svc_idnw_ivos_prd01]
GO

CREATE USER [ELDREDGE_A\svc_SAIL_TST01] FOR LOGIN [ELDREDGE_A\svc_SAIL_TST01] WITH DEFAULT_SCHEMA=[dbo]
ALTER ROLE [SAIL_APP_ACCESS] ADD MEMBER [ELDREDGE_A\svc_SAIL_TST01]
ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\svc_SAIL_TST01]
ALTER ROLE [db_datawriter] ADD MEMBER [ELDREDGE_A\svc_SAIL_TST01]



USE [IVOS]
GO
CREATE USER [IVOSAuditTest] FOR LOGIN [IVOSAuditTest] WITH DEFAULT_SCHEMA=[dbo]
GO
USE [IVOS]
GO
ALTER ROLE [SAIL_APP_ACCESS] ADD MEMBER [IVOSAuditTest]
ALTER ROLE [db_datareader] ADD MEMBER [IVOSAuditTest]
ALTER ROLE [db_datawriter] ADD MEMBER [IVOSAuditTest]
GO



USE [IVOS]
GO
CREATE USER [IVOSdbIVOSAppTest] FOR LOGIN [IVOSdbIVOSAppTest] WITH DEFAULT_SCHEMA=[dbo]
ALTER ROLE [db_datawriter] ADD MEMBER [IVOSdbIVOSAppTest]
ALTER ROLE [db_datareader] ADD MEMBER [IVOSdbIVOSAppTest]
ALTER ROLE [db_execute] DROP  MEMBER [IVOSdbIVOSAppTest]

GO




USE [IVOS]
GO
CREATE USER [IVOSdbLinkedDSSQLTEST14_IVOSTEST] FOR LOGIN [IVOSdbLinkedDSSQLTEST14_IVOSTEST] WITH DEFAULT_SCHEMA=[dbo]
ALTER ROLE [db_datareader] ADD MEMBER [IVOSdbLinkedDSSQLTEST14_IVOSTEST]
GO



USE [IVOS]
GO
CREATE USER [IVOSdbIVOSRptTest] FOR LOGIN [IVOSdbIVOSRptTest] WITH DEFAULT_SCHEMA=[dbo]
ALTER ROLE [db_owner] ADD MEMBER [IVOSdbIVOSRptTest] 
GO



USE [Jasper]
GO
CREATE USER [IVOSdbIVOSRptTest] FOR LOGIN [IVOSdbIVOSRptTest] WITH DEFAULT_SCHEMA=[dbo]
ALTER ROLE [db_owner] ADD MEMBER [IVOSdbIVOSRptTest] 
GO