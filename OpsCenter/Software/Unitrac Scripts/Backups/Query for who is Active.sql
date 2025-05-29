		SELECT  'SPID=' + CONVERT(VARCHAR, a.session_id)
        + ' has been running the following for '
        + CONVERT(VARCHAR, DATEDIFF(SS, a.start_time, CURRENT_TIMESTAMP))
        + ' seconds: ' + CONVERT(VARCHAR, b.text) ,
        CONVERT(VARCHAR, DATEDIFF(SS, a.start_time, CURRENT_TIMESTAMP))
FROM    sys.dm_exec_requests a
        CROSS APPLY sys.dm_exec_sql_text(a.sql_handle) b
WHERE   a.status <> 'background'
        AND DATEDIFF(MINUTE, a.start_time, CURRENT_TIMESTAMP) > 30



		USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [solarwinds]    Script Date: 5/5/2017 1:36:37 PM ******/
CREATE LOGIN [solarwinds_sql] WITH PASSWORD=N'S0l@rw1nds', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO


--ALTER LOGIN [solarwinds] DISABLE
--GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [solarwinds_sql]

