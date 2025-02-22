USE [PerfStats];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[dbo].[CaptureAGLagStats]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [dbo].[CaptureAGLagStats] AS RETURN 0;';
  END;

GO

ALTER PROCEDURE [dbo].[Captureaglagstats] (@DryRun  BIT = 1,
                                           @Verbose BIT = 0)
AS
  -- EXEC [dbo].[CaptureAGLagStats]  @DryRun = 0
  -- EXEC [dbo].[CaptureAGLagStats] @Verbose = 1
  -- EXEC [dbo].[CaptureAGLagStats] @DryRun = 0, @Verbose = 1
  -- EXEC [dbo].[CaptureAGLagStats] @DryRun = 0 --Job step
  BEGIN
      DECLARE @query NVARCHAR(max)
      DECLARE @query2 NVARCHAR(max)

      SET @query = ' ;WITH 
        AG_Stats AS 
                (
                SELECT  AR.replica_server_name, AG.name as AGName, HARS.role_desc, Db_name(DRS.database_id) [DBName], DRS.last_commit_time
                FROM   sys.dm_hadr_database_replica_states DRS 
                INNER JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id 
                INNER JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id AND AR.replica_id = HARS.replica_id 
                INNER JOIN [sys].[availability_groups] AG on AG.group_id = AR.group_id
                ),
        Pri_CommitTime AS 
                (
                SELECT  replica_server_name, AGNAME, DBName, last_commit_time
                FROM    AG_Stats
                WHERE   role_desc = ''PRIMARY''
                ),
        Sec_CommitTime AS 
                (
                SELECT  replica_server_name, AGNAME, DBName, last_commit_time
                FROM    AG_Stats
                WHERE   role_desc = ''SECONDARY''
                )

SELECT  DATEDIFF(ss,s.last_commit_time,p.last_commit_time) AS [Lag in Seconds],
p.[DBName] +''-''' + ' +  s.replica_server_name AS [DatabaseName_secondary_replica]  
FROM Pri_CommitTime p
    LEFT JOIN Sec_CommitTime s ON [s].[DBName] = [p].[DBName] and  s.AGNAME = p.AGNAME
				;'
      SET @query2 = ' ;WITH 
        AG_Stats AS 
                (
                SELECT  AR.replica_server_name, AG.name as AGName, HARS.role_desc, Db_name(DRS.database_id) [DBName], DRS.last_commit_time
                FROM   sys.dm_hadr_database_replica_states DRS 
                INNER JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id 
                INNER JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id AND AR.replica_id = HARS.replica_id 
                INNER JOIN [sys].[availability_groups] AG on AG.group_id = AR.group_id
                ),
        Pri_CommitTime AS 
                (
                SELECT  replica_server_name, AGNAME, DBName, last_commit_time
                FROM    AG_Stats
                WHERE   role_desc = ''PRIMARY''
                ),
        Sec_CommitTime AS 
                (
                SELECT  replica_server_name, AGNAME, DBName, last_commit_time
                FROM    AG_Stats
                WHERE   role_desc = ''SECONDARY''
                )

SELECT  DATEDIFF(ss,s.last_commit_time,p.last_commit_time) AS [Seconds Behind],
p.AGNAME,
p.[DBName] +''-''' + ' +  s.replica_server_name AS [DatabaseName_secondary_replica] ,  GETDATE()
FROM Pri_CommitTime p
    LEFT JOIN Sec_CommitTime s ON [s].[DBName] = [p].[DBName] and  s.AGNAME = p.AGNAME
				;'

      IF( @Verbose = 1 )
        BEGIN
            PRINT ( @query )
        END;

      IF( @dryrun = 0 )
        BEGIN
            INSERT PerfStats.dbo.AGLagStats
            EXEC (@query2)
        END
      ELSE
        BEGIN
            EXEC (@query)
        END
  /*--BODY OF EMAIL - Edit for your environment
  SET @body ='<html><H1>Tempdb Large Query</H1>
  <body bgcolor=white>The query below with the <u>highest task allocation 
  and high task deallocation</u> is most likely growing the tempdb. NOTE: Please <b>do not kill system tasks</b> 
  that may be showing up in the table below.
  <U>Only kill the query that is being run by a user and has the highest task allocation/deallocation.</U><BR> 
  <BR>
  To stop the query from running, do the following:<BR>
  <BR>
  1. Open <b>SQL Server Management Studio</b><BR>
  2. <b>Connect to database engine using Windows Authentication</b><BR>
  3. Click on <b>"New Query"</b><BR>
  4. Type <b>KILL [type session_id number from table below];</b> - It should look something like this:  KILL 537; <BR>
  5. Hit the <b>F5</b> button to run the query<BR>
  <BR>
  This should kill the session/query that is growing the large query.  It will also kick the individual out of the application.<BR>
  You have just stopped the growth of the tempdb, without having to restart SQL Services, and have the large-running query available for your review.
  <BR>
  <BR>
  <table border = 2><tr><th>Session_ID</th><th>Login_Name</th><th>Command</th><th>Task_Alloc</th><th>Task_Dealloc</th><th>Query_Text</th></tr>' 
  SET @body = @body + @xml +'</table></body></html>'
  --Send email to recipients:
  EXEC msdb.dbo.sp_send_dbmail
  @recipients =N'dba@domain.com', --Insert the TO: email Address here
  @copy_recipients ='dba_Manager@domain.com', --Insert the CC: Address here; If multiple addresses, separate them by a comma (,)
  @body = @body,@body_format ='HTML',
  @importance ='High',
  @subject ='THIS IS A TEST', --Provide a subject for the email
  @profile_name = 'DatabaseMailProfile' --Database Mail profile here*/
  END 
