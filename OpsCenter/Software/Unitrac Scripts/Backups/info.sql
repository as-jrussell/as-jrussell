USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [Informatica]    Script Date: 10/10/2017 8:10:29 AM ******/
CREATE LOGIN [Informatica] WITH PASSWORD=N'lTYDbBJ9r4d08+u9agJfboRrPjv1eOVhRTGvviuVcbk=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [Informatica] DISABLE
GO

