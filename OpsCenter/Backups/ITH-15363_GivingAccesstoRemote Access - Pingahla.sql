USE [master]
GO
ALTER LOGIN [ELDREDGE_A\Remote Access - Pingahla] WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english]
GO
USE [DPM_DOC]
GO
CREATE USER [ELDREDGE_A\Remote Access - Pingahla] FOR LOGIN [ELDREDGE_A\Remote Access - Pingahla]
GO
USE [DPM_DOC]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\Remote Access - Pingahla]
GO
USE [DPM_DOM]
GO
CREATE USER [ELDREDGE_A\Remote Access - Pingahla] FOR LOGIN [ELDREDGE_A\Remote Access - Pingahla]
GO
USE [DPM_DOM]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\Remote Access - Pingahla]
GO
USE [DPM_DPR]
GO
CREATE USER [ELDREDGE_A\Remote Access - Pingahla] FOR LOGIN [ELDREDGE_A\Remote Access - Pingahla]
GO
USE [DPM_DPR]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\Remote Access - Pingahla]
GO
USE [DPM_DWH]
GO
CREATE USER [ELDREDGE_A\Remote Access - Pingahla] FOR LOGIN [ELDREDGE_A\Remote Access - Pingahla]
GO
USE [DPM_DWH]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\Remote Access - Pingahla]
GO
USE [DPM_MOR]
GO
CREATE USER [ELDREDGE_A\Remote Access - Pingahla] FOR LOGIN [ELDREDGE_A\Remote Access - Pingahla]
GO
USE [DPM_MOR]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\Remote Access - Pingahla]
GO
USE [DPM_PWH]
GO
CREATE USER [ELDREDGE_A\Remote Access - Pingahla] FOR LOGIN [ELDREDGE_A\Remote Access - Pingahla]
GO
USE [DPM_PWH]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\Remote Access - Pingahla]
GO
USE [DPM_WFR]
GO
CREATE USER [ELDREDGE_A\Remote Access - Pingahla] FOR LOGIN [ELDREDGE_A\Remote Access - Pingahla]
GO
USE [DPM_WFR]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ELDREDGE_A\Remote Access - Pingahla]
GO
