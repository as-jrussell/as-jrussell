USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbSSRS_Unitrac_Reports]    Script Date: 3/17/2017 9:53:12 AM ******/
CREATE LOGIN [UTdbSSRS_Unitrac_Reports] WITH PASSWORD=N'XVjMHe+B3YeDvV4Hxto30ecIxvnL5zuFOdfbDNGQoUw=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbSSRS_Unitrac_Reports] DISABLE
GO

