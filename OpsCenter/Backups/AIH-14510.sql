USE [PremAcc3]
GO
ALTER ROLE [BOND_MGMT_APP_ACCESS] DROP MEMBER [ELDREDGE_A\SQL_Bond_Mgmt_NP_svc]
GO
USE [PremAcc3]
GO
ALTER ROLE [BOND_MGMT_APP_ACCESS] DROP MEMBER [ELDREDGE_A\svc_bond_mgmt_STG01]
GO



USE [PremAcc3]
GO
ALTER ROLE [CP_MGMT_APP_ACCESS] DROP MEMBER [ELDREDGE_A\SQL_Bond_Mgmt_NP_svc]
GO
USE [PremAcc3]
GO
ALTER ROLE [CP_MGMT_APP_ACCESS] DROP MEMBER [ELDREDGE_A\svc_bond_mgmt_STG01]
GO


USE [PremAcc3]
GO

/****** Object:  User [ELDREDGE_A\SQL_Bond_Mgmt_NP_svc]    Script Date: 8/11/2022 10:47:43 AM ******/
DROP USER [ELDREDGE_A\SQL_Bond_Mgmt_NP_svc]
GO


USE [PremAcc3]
GO

/****** Object:  User [ELDREDGE_A\SQL_Bond_Mgmt_NP_svc]    Script Date: 8/11/2022 10:47:43 AM ******/
DROP USER [ELDREDGE_A\svc_bond_mgmt_STG01]
GO



USE [master]
GO

/****** Object:  Login [ELDREDGE_A\SQL_Bond_Mgmt_NP_svc]    Script Date: 8/11/2022 10:48:35 AM ******/
DROP LOGIN [ELDREDGE_A\SQL_Bond_Mgmt_NP_svc]
GO



/****** Object:  Login [ELDREDGE_A\SQL_Bond_Mgmt_NP_svc]    Script Date: 8/11/2022 10:48:35 AM ******/
DROP LOGIN [ELDREDGE_A\svc_bond_mgmt_STG01]
GO


