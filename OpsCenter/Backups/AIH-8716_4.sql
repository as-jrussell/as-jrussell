--On on-sqlclstprd-1
USE [master]
GO

CREATE LOGIN [AlliedSolutions_LSRO_Reporting] WITH PASSWORD=N'CyberArk', DEFAULT_DATABASE=[tempdb], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO



USE [IND_AlliedSolutions_157GIC109]
GO
CREATE USER [AlliedSolutions_LSRO_Reporting] FOR LOGIN [AlliedSolutions_LSRO_Reporting] 
GO
USE [IND_AlliedSolutions_157GIC109]
GO
ALTER ROLE [db_datareader] ADD MEMBER [AlliedSolutions_LSRO_Reporting] 
GO

--On on-sqlclstprd-2 & DB-SQLCLST-01-1

SELECT N'CREATE LOGIN ['+sp.[name]+'] WITH PASSWORD=0x'+
    CONVERT(nvarchar(max), l.password_hash, 2)+N' HASHED, '+
    N'SID=0x'+CONVERT(nvarchar(max), sp.[sid], 2)+N';'
FROM master.sys.server_principals AS sp
INNER JOIN master.sys.sql_logins AS l ON sp.[sid]=l.[sid]
WHERE sp.name='AlliedSolutions_LSRO_Reporting'



--Run on PS


Sync-DbaLoginPermission -Destination DB-SQLCLST-01-1 -Source on-sqlclstprd-1 -Login AlliedSolutions_LSRO_Reporting
Sync-DbaLoginPermission -Destination on-sqlclstprd-2 -Source on-sqlclstprd-1 -Login AlliedSolutions_LSRO_Reporting