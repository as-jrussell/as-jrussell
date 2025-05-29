--On on-sqlclstprd-1
BACKUP DATABASE [IND_AlliedSolutions_157GIC109] TO  DISK = '\\IGNITE-SQL14\Restores\jrussell\IND_AlliedSolutions_157GIC109.Bak'  WITH INIT , NOUNLOAD , NAME = 'Backup', NOSKIP , STATS = 10, COMPRESSION, NOFORMAT
BACKUP LOG [IND_AlliedSolutions_157GIC109] TO  DISK = '\\IGNITE-SQL14\Restores\jrussell\IND_AlliedSolutions_157GIC109.LOG'


--On on-sqlclstprd-2 & DB-SQLCLST-01-1
RESTORE DATABASE [IND_AlliedSolutions_157GIC109] FROM  DISK = N'\\IGNITE-SQL14\Restores\jrussell\IND_AlliedSolutions_157GIC109.Bak' WITH  FILE = 1, 
MOVE N'IND_AlliedSolutions_157GIC109_Data' TO N'E:\SQL\Data03\IND_AlliedSolutions_157GIC109_Log.mdf', 
MOVE N'IND_AlliedSolutions_157GIC109_Log' TO N'E:\SQL\SQLLogs\IND_AlliedSolutions_157GIC109_Log.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5

