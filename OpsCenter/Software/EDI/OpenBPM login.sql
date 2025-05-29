USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [openbpm]    Script Date: 9/2/2021 3:29:57 PM ******/
CREATE LOGIN [openbpm] WITH PASSWORD=N'dMvFNO7HIT5yl84w/BTRia68iz/RgiLjoP7JcdDJQsw=', DEFAULT_DATABASE=[archiveEDI], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [archiveEDI]
GO
CREATE USER [openbpm] FOR LOGIN [openbpm]
GO
ALTER ROLE [db_owner] ADD MEMBER [openbpm]
GO


USE [EDI]
GO
CREATE USER [openbpm] FOR LOGIN [openbpm]
GO
ALTER ROLE [db_owner] ADD MEMBER [openbpm]
GO



