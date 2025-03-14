USE [PerfStats]
GO
/****** Object:  StoredProcedure [dbo].[ResumeDatabase]    Script Date: 1/16/2023 2:10:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ResumeDatabase]') AND type in (N'P', N'PC'))
BEGIN
	/* Create Empty Stored Procedure */
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ResumeDatabase] AS RETURN 0;';
END;
GO

/* Alter Stored Procedure */
ALTER PROCEDURE [dbo].[ResumeDatabase] ( @DryRun BIT = 1 )
AS 
SET ANSI_WARNINGS OFF
DECLARE @permissionadd VARCHAR(max);
DECLARE @accountcount INT;
DECLARE @TargetName VARCHAR(100);
--0 = executes script and 1 shows the script

IF EXISTS (SELECT 1
           FROM   sys.dm_hadr_database_replica_states drs
                  JOIN sys.availability_replicas ar
                    ON ar.replica_id = drs.replica_id
           WHERE  ar.replica_server_name = @@SERVERNAME
                  AND drs.is_suspended = 1)

  SET @accountcount = (SELECT Count(*)
                       FROM   sys.dm_hadr_database_replica_states drs
                              JOIN sys.availability_replicas ar
                                ON ar.replica_id = drs.replica_id
                       WHERE  ar.replica_server_name = @@SERVERNAME
                              AND drs.is_suspended = 1)



DECLARE @count INT = (SELECT Count(@accountcount));

IF @count >= 1
  BEGIN

IF @accountcount <> 0
  WHILE ( @accountcount <> 0 )
    IF @DryRun = 0
      BEGIN
          SET @TargetName = (SELECT TOP 1 Db_name(database_id)
                             FROM   sys.dm_hadr_database_replica_states drs
                                    JOIN sys.availability_replicas ar
                                      ON ar.replica_id = drs.replica_id
                             WHERE  ar.replica_server_name = @@SERVERNAME
                                    AND drs.is_suspended = 1)

          SELECT @permissionadd = 'DECLARE @SQLCMD VARCHAR(1000);

SELECT @SQLCMD = ''use master ALTER DATABASE ['' + Db_name(database_id)
                 + ''] SET HADR RESUME;''
FROM   sys.dm_hadr_database_replica_states drs
       JOIN sys.availability_replicas ar
         ON ar.replica_id = drs.replica_id
WHERE  ar.replica_server_name = '''
                                  + @@SERVERNAME
                                  + '''
       AND drs.is_suspended = 1;

	   EXEC (@SQLCMD)	
	   

	  
	   '

          EXEC (@permissionadd);



          SET @accountcount = @accountcount - 1;

		   PRINT 'SUCCESS: DATBASE HAS BEEN RESUMED'

      END
    ELSE
      BEGIN
          SET @TargetName = (SELECT TOP 1 database_id
                             FROM   sys.dm_hadr_database_replica_states drs
                                    JOIN sys.availability_replicas ar
                                      ON ar.replica_id = drs.replica_id
                             WHERE  ar.replica_server_name = @@SERVERNAME
                                    AND drs.is_suspended = 1)

          SELECT 'use [master] ALTER DATABASE ['
                 + Db_name(database_id) + '] SET HADR RESUME;'
          FROM   sys.dm_hadr_database_replica_states drs
                 JOIN sys.availability_replicas ar
                   ON ar.replica_id = drs.replica_id
          WHERE  ar.replica_server_name = @@SERVERNAME
                 AND drs.is_suspended = 1;

          SET @accountcount = @accountcount - @accountcount;
      END 
	    END
ELSE
  BEGIN
      PRINT 'SUCCESS: All databases are actively being synced'
  END 
