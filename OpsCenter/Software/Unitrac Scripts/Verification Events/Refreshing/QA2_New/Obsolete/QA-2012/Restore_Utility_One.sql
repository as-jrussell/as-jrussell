SELECT  session_id ,
        start_time ,
        status ,
        command ,
        percent_complete ,
        estimated_completion_time ,
        estimated_completion_time / 60 / 1000 AS estimate_completion_minutes ,
	--(select convert(varchar(5),getdate(),8)),
        DATEADD(n, ( estimated_completion_time / 60 / 1000 ), GETDATE()) AS estimated_completion_time
FROM    sys.dm_exec_requests
WHERE   command = 'BACKUP DATABASE'
        OR command = 'RESTORE DATABASE'
--------------------------------------------------------

DBCC CHECKDB (UniTrac) WITH DATA_PURITY
DBCC CHECKDB (UniTrac_DW) WITH DATA_PURITY
DBCC CHECKDB (VUT) WITH DATA_PURITY

---------- Lone Issue from DBCC CHECKDB
--USE VUT
--GO
--DBCC UPDATEUSAGE (VUT,"tblPolicy")
--GO

----------- Quick Review of Post-Restore Compatibility Level
USE UniTrac
GO
SELECT COMPATIBILITY_LEVEL
FROM sys.databases WHERE name = 'UniTrac'
GO

USE UniTrac_DW
GO
SELECT COMPATIBILITY_LEVEL
FROM sys.databases WHERE name = 'UniTrac_DW'
GO

USE VUT
GO
SELECT COMPATIBILITY_LEVEL
FROM sys.databases WHERE name = 'VUT'
GO

---------- Change Compatibility Level to SQL2012
--ALTER DATABASE UniTrac
--SET COMPATIBILITY_LEVEL = 110

--ALTER DATABASE UniTrac_DW
--SET COMPATIBILITY_LEVEL = 110

--ALTER DATABASE VUT
--SET COMPATIBILITY_LEVEL = 110
