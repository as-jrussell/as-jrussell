

--on-sqlclstprd-1

USE [master]
RESTORE DATABASE [IND_AlliedSolutions_157GIC109] FROM  DISK = N'E:\SQL\Data03\Alain\IND_AlliedSolutions_157GIC109_10302021.bak' WITH  FILE = 1,  
MOVE N'IND_AlliedSolutions_157GIC109_Data' TO N'E:\SQL\Data03\IND_AlliedSolutions_157GIC109_Data.mdf',  MOVE N'IND_AlliedSolutions_157GIC109_Log' TO N'E:\SQL\SQLLogs\IND_AlliedSolutions_157GIC109_Log.ldf',  NOUNLOAD,  STATS = 5

GO


