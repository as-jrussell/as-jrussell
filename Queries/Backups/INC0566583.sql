---ADD ROLE

USE [BSSMessageQueue]
GO
CREATE USER [DevSA] FOR LOGIN [DevSA]
GO
USE [BSSMessageQueue]
GO
ALTER ROLE [db_datareader] ADD MEMBER [DevSA]
GO
USE [BSSMessageQueue]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [DevSA]
GO



---DROP ROLE

USE [BSSMessageQueue]
GO
/****** Object:  User [DevSA]    Script Date: 1/7/2021 5:35:13 PM ******/
DROP USER [DevSA]
GO
