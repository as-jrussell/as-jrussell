USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbDirWatchOutPreProd]    Script Date: 3/10/2016 8:54:33 AM ******/
CREATE LOGIN [UTdbDirWatchOutPreProd] WITH PASSWORD=N'ClOf+XoBIQpwdnrfQ5XO0kdzEVhbUBs/aPz+XDGvRMk=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbDirWatchOutPreProd] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbDirWatchOutPreProd]
GO




/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbDirWatchInPreProd]    Script Date: 3/10/2016 8:54:09 AM ******/
CREATE LOGIN [UTdbDirWatchInPreProd] WITH PASSWORD=N'7j8V8iZW3WrXJGJCDMvQ1G7Jmjn1RBSJL5llC9NTHvg=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbDirWatchInPreProd] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbDirWatchInPreProd]
GO


USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbLDHSvcVUTPreProd]    Script Date: 3/10/2016 9:07:16 AM ******/
CREATE LOGIN [UTdbLDHSvcVUTPreProd] WITH PASSWORD=N'vqFWDcMXSZHvX7dA09ayeAbiB5RH681xRzJnC3NjPn0=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbLDHSvcVUTPreProd] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbLDHSvcVUTPreProd]
GO


USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbLDHSvcUSDPreProd]    Script Date: 3/10/2016 9:07:05 AM ******/
CREATE LOGIN [UTdbLDHSvcUSDPreProd] WITH PASSWORD=N'4mdgklvQ/v6TnBWd28zn8jflqqtDomG2SWdHHhA7RhQ=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbLDHSvcUSDPreProd] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbLDHSvcUSDPreProd]
GO


USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbLDHSvc_PreProd]    Script Date: 3/10/2016 9:06:59 AM ******/
CREATE LOGIN [UTdbLDHSvc_PreProd] WITH PASSWORD=N'rbQcYebaDDVJGa50XcBlawm1ZOqI+bmJBJWB31BBSDw=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbLDHSvc_PreProd] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbLDHSvc_PreProd]
GO


USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbUBSRPTPreProd]    Script Date: 3/10/2016 9:08:42 AM ******/
CREATE LOGIN [UTdbUBSRPTPreProd] WITH PASSWORD=N'11cUlyGhSK2NRK6VDcPSa23+io1sW6FDaDh5ZmPevbw=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbUBSRPTPreProd] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbUBSRPTPreProd]
GO


USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbUBSPRTPreProd]    Script Date: 3/10/2016 9:08:37 AM ******/
CREATE LOGIN [UTdbUBSPRTPreProd] WITH PASSWORD=N'NWpZ2W4gTm1QS0IOvUyy11ti7KQ9mc7rpH2NXp7rNwk=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbUBSPRTPreProd] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbUBSPRTPreProd]
GO


USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbUBSServerPreProd]    Script Date: 3/10/2016 9:08:53 AM ******/
CREATE LOGIN [UTdbUBSServerPreProd] WITH PASSWORD=N'x65h/VPK4+AnK7USykh4w1Dy0iT9F3TT21srRhFyqPk=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbUBSServerPreProd] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbUBSServerPreProd]
GO


USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbMSGBSSPreProd]    Script Date: 3/10/2016 9:11:22 AM ******/
CREATE LOGIN [UTdbMSGBSSPreProd] WITH PASSWORD=N'/7zgmPn+B3kwQSLzikGhz1Dtz7ToL/dFOI8sSdy0SX4=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbMSGBSSPreProd] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbMSGBSSPreProd]
GO


USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbMSGEXTVUTPreProd]    Script Date: 3/10/2016 9:11:51 AM ******/
CREATE LOGIN [UTdbMSGEXTVUTPreProd] WITH PASSWORD=N'+A4yoYMjPFK39oBmgU2y3V1rUvZ27V2HN34pbRZFfY0=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbMSGEXTVUTPreProd] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbMSGEXTVUTPreProd]
GO


USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbMSGEXTUSDPreProd]    Script Date: 3/10/2016 9:11:45 AM ******/
CREATE LOGIN [UTdbMSGEXTUSDPreProd] WITH PASSWORD=N'YEWilMnjLa2wDRH0WaauiVfF1tmc698WyriaxSrh/TA=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbMSGEXTUSDPreProd] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbMSGEXTUSDPreProd]
GO


USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbMSGEXTHuntPreProd]    Script Date: 3/10/2016 9:11:38 AM ******/
CREATE LOGIN [UTdbMSGEXTHuntPreProd] WITH PASSWORD=N'mzY08/GIwztetQSt774GprCeCPH5H85xINA17g5Jp+w=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbMSGEXTHuntPreProd] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbMSGEXTHuntPreProd]
GO


USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbMSGEDIIDRPreProd]    Script Date: 3/10/2016 9:11:32 AM ******/
CREATE LOGIN [UTdbMSGEDIIDRPreProd] WITH PASSWORD=N'dOkSxhsDH3/LTCpmvYLlx03KjqaduMmQ1DMXavAzQBQ=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbMSGEDIIDRPreProd] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbMSGEDIIDRPreProd]
GO


USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbMSGDEFPreProd]    Script Date: 3/10/2016 9:11:28 AM ******/
CREATE LOGIN [UTdbMSGDEFPreProd] WITH PASSWORD=N'dDwqEU3rwaJsF7fLFaIDBYgkyZONNtVTbIipBN9B2PU=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbMSGDEFPreProd] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbMSGDEFPreProd]
GO


USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbUBSCycleStaging]    Script Date: 3/10/2016 9:15:10 AM ******/
CREATE LOGIN [UTdbUBSCycleStaging] WITH PASSWORD=N'jdYMlJEhEjKaklNZnJjEHkE0HaeyV9S7T7nILs3xLrM=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbUBSCycleStaging] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbUBSCycleStaging]
GO


USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbUBSMatchOutStaging]    Script Date: 3/10/2016 9:14:50 AM ******/
CREATE LOGIN [UTdbUBSMatchOutStaging] WITH PASSWORD=N'sVm1Lr7lWOq8MVJTF/OPWpC9KhlSDNfSzSO53guP09k=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbUBSMatchOutStaging] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbUBSMatchOutStaging]
GO


USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [UTdbUBSMatchInStaging]    Script Date: 3/10/2016 9:14:38 AM ******/
CREATE LOGIN [UTdbUBSMatchInStaging] WITH PASSWORD=N'5YD5xYJnEr07escdT8VQpP4F9ugfFc5Xv8v6qqw/c0A=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [UTdbUBSMatchInStaging] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbUBSMatchInStaging]
GO


