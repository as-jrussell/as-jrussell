SET ANSI_WARNINGS OFF

GO

DECLARE @SQLCMD VARCHAR(1000);
DECLARE @DryRun INT =1;

SELECT @SQLCMD = 'ALTER DATABASE [' + Db_name(database_id)
                 + '] SET HADR RESUME;'
FROM   sys.dm_hadr_database_replica_states drs
       JOIN sys.availability_replicas ar
         ON ar.replica_id = drs.replica_id
WHERE  ar.replica_server_name = @@SERVERNAME
       AND drs.is_suspended = 1;



DECLARE @count INT = (SELECT Count(@SQLCMD));

IF @count >= 1
  BEGIN
      IF @DryRun = 0
        BEGIN
            EXEC ( @SQLcmd)

            PRINT 'SUCCESS: DATBASE HAS BEEN RESUMED'
        END
      ELSE
        BEGIN
            PRINT ( @SQLcmd )
        END
  END
ELSE
  BEGIN
      PRINT 'SUCCESS: All databases are actively being synced'
  END 
