USE [UniTrac]
GO
CREATE USER [UTdbInfraClientTest] FOR LOGIN [UTdbInfraClientTest]
GO
USE [UniTrac]
GO
ALTER ROLE [db_datareader] ADD MEMBER [UTdbInfraClientTest]
GO
USE [UniTrac]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [UTdbInfraClientTest]
GO
