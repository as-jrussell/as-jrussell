USE [Premacc3]
GO

DROP USER [svcPIMStest]
CREATE USER [svcPIMStest] FOR LOGIN [svcPIMStest]
GO
USE [Premacc3]
GO
ALTER USER [svcPIMStest] WITH DEFAULT_SCHEMA=[dbo]
GO
USE [Premacc3]
GO
ALTER ROLE [db_datareader] ADD MEMBER [svcPIMStest]
GO
USE [Premacc3]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [svcPIMStest]
GO


grant execute to [svcPIMStest]




DROP USER [fims]
CREATE USER [fims] FOR LOGIN [fims]
GO
USE [Premacc3]
GO
ALTER USER [fims] WITH DEFAULT_SCHEMA=[dbo]
GO
USE [Premacc3]
GO
ALTER ROLE [db_datareader] ADD MEMBER [fims]
GO
USE [Premacc3]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [fims]
GO



USE [Premacc3]
GO
grant execute to [fims]
