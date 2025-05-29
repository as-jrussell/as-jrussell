USE [master]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbMSGEXTHuntStaging]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbMSGDEFStaging]
GO


ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbMSGEXTSantStaging]

GO


--ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbMSGEDIIDRStaging]

--GO

--ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbMSGEXTUSDStaging]

--GO

--ALTER SERVER ROLE [sysadmin] ADD MEMBER [UTdbMSGEXTVUTStaging]

--GO




USE [UniTrac]
GO

select *
from UniTrac..users
where user_name_tx = 'admin'

update UniTrac..users
set password_tx = 'OOo2uY6cqEVRVagK2TRCCg=='
where user_name_tx = 'admin'

