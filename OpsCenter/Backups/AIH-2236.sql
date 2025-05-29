USE [msdb]
GO

/****** Object:  User [ELDREDGE_A\tchappell]    Script Date: 4/26/2021 4:18:42 PM ******/
CREATE USER [ELDREDGE_A\tchappell] FOR LOGIN [ELDREDGE_A\tchappell] WITH DEFAULT_SCHEMA=[dbo]
GO


ALTER ROLE [SQLAgentUserRole] ADD MEMBER [ELDREDGE_A\tchappell]
GO
