
IF (SELECT COUNT (*)  FROM [DBA].[info].[AgentJob]
WHERE JobName in ('DBA-BackupDatabases-FULL', 'DBA-BackupDatabases-LOG')
AND StatusDesc  = 'Failed' ) >= 1
BEGIN 

			update  D  
			SET D.confvalue ='ON-DD9300-01'-- 'DBK-DD9300-01'   --ON-DD9300-01
				--SELECT *
			FROM [DBA].[info].[databaseConfig] D
			WHERE confkey = 'Host'
			PRINT 'Host has been reverted to original'
END
	ELSE
BEGIN
			PRINT 'Host not touched at all!'
END
