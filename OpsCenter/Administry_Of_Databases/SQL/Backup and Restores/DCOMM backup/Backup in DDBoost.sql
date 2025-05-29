SELECT clienthostname, databasename, count(*),  
               MIN(BackupDate), MAX(BAckupDate)  
FROM DBA.ddbma.SaveSets  
GROUP BY clienthostname, databasename