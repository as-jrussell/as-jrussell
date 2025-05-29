DECLARE @retVal INT,
        @Time   INT ='900';

IF Object_id(N'tempdb..#AGCheck') IS NOT NULL
  DROP TABLE #AGCheck

CREATE TABLE #AGCheck
  (
     [seconds behind]                   INT,
     [ServerName]                       VARCHAR(250),
     [DatabaseName - secondary_replica] VARCHAR(250),
     [group_name]                       VARCHAR(100)
  );

;
WITH AG_Stats
     AS (SELECT AR.replica_server_name,
                AG.name                  AS AGName,
                HARS.role_desc,
                Db_name(DRS.database_id) [DBName],
                DRS.last_commit_time
         FROM   sys.dm_hadr_database_replica_states DRS
                INNER JOIN sys.availability_replicas AR
                        ON DRS.replica_id = AR.replica_id
                INNER JOIN sys.dm_hadr_availability_replica_states HARS
                        ON AR.group_id = HARS.group_id
                           AND AR.replica_id = HARS.replica_id
                INNER JOIN [sys].[availability_groups] AG
                        ON AG.group_id = AR.group_id),
     Pri_CommitTime
     AS (SELECT replica_server_name,
                AGNAME,
                DBName,
                last_commit_time
         FROM   AG_Stats
         WHERE  role_desc = 'PRIMARY'),
     Sec_CommitTime
     AS (SELECT replica_server_name,
                AGNAME,
                DBName,
                last_commit_time
         FROM   AG_Stats
         WHERE  role_desc = 'SECONDARY')
INSERT INTO #AGCheck
SELECT Datediff(ss, s.last_commit_time, p.last_commit_time) AS [Seconds Behind],
       @@SERVERNAME,
       p.[DBName] + ' - ' + s.replica_server_name           AS [DatabaseName - secondary_replica],
       p.AGNAME
FROM   Pri_CommitTime p
       LEFT JOIN Sec_CommitTime s
              ON [s].[DBName] = [p].[DBName]
                 AND s.AGNAME = p.AGNAME
WHERE  Datediff(ss, s.last_commit_time, p.last_commit_time) >= @Time

IF Object_id(N'tempdb..#SpaceDrive') IS NOT NULL
  DROP TABLE #SpaceDrive

CREATE TABLE #SpaceDrive
  (
     volume_mount_point   NVARCHAR(1000),
     file_system_type     VARCHAR(10),
     logical_volume_name  VARCHAR(100),
     [Total Size (GB)]    NVARCHAR(1000),
     [Available Size (GB)]NVARCHAR(1000),
     [Free Space %]       INT
  );

INSERT INTO #SpaceDrive
SELECT DISTINCT vs.volume_mount_point,
                vs.file_system_type,
                vs.logical_volume_name,
                CONVERT(DECIMAL(18, 2), vs.total_bytes / 1073741824.0)                   AS [Total Size (GB)],
                CONVERT(DECIMAL(18, 2), vs.available_bytes / 1073741824.0)               AS [Available Size (GB)],
                CONVERT(DECIMAL(18, 2), vs.available_bytes * 1. / vs.total_bytes * 100.) AS [Space Free %]
FROM   sys.master_files AS f WITH (NOLOCK)
       CROSS APPLY sys.Dm_os_volume_stats(f.database_id, f.[file_id]) AS vs
WHERE  CONVERT(DECIMAL(18, 2), vs.available_bytes * 1. / vs.total_bytes * 100.) < '15'
ORDER  BY vs.volume_mount_point
OPTION (RECOMPILE);

DECLARE @SQLcmd VARCHAR(MAX)
DECLARE @size VARCHAR(3) = '15'

SELECT @SQLcmd = '
 USE [?]
SELECT @@servername as ServerName,[Database_Name] = DB_NAME()
		 ,[Logical_Name] = name
		 ,[Path] = physical_name 
		,[TYPE] = A.TYPE_DESC
		  ,  [FileGrowth]    = CASE growth / 128
                              WHEN 0 THEN ''By %''
                              ELSE ''By '' + Cast(growth/128 AS VARCHAR(10))
                                   + '' MB''
                            END
	 
,[AutoGrowth]  =CASE WHEN growth = 0 THEN ''Autogrowth is off'' ELSE CASE WHEN (max_size = -1  OR growth >0) THEN ''Enabled'' ELSE ''Disabled'' END END
,[Max Grow MB] =CASE WHEN growth = 0 THEN ''Autogrowth is off'' ELSE CASE WHEN max_size = -1 THEN ''Unlimited'' WHEN growth= 0 THEN ''Unlimited'' WHEN max_size = 268435456 THEN ''2 TB''  ELSE CAST(max_size/128 AS VARCHAR(10))    + '' MB'' END END 
		, [CurrentSizeMB ] =  size/128.0
		,  [SpaceUsedMB] =CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0
		,[FreeSpaceMB] =  CASE WHEN (max_size = -1  OR growth >0) THEN size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0 ELSE max_size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0 END
		, [Free Space %] = CASE WHEN (max_size = -1  OR growth >0) THEN CONVERT(INT,ABS(CONVERT(DECIMAL (10,2), CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0)/ CONVERT(DECIMAL (10,2), size/128.0)*100 -100)) ELSE CONVERT(INT,ABS(CONVERT(DECIMAL (10,2), CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0)/ CONVERT(DECIMAL (10,2), max_size/128.0)*100 -100)) END
		FROM sys.database_files A 
	  order by [SpaceUsedMB] desc'

IF Object_id(N'tempdb..#DatafileSize') IS NOT NULL
  DROP TABLE #DatafileSize

CREATE TABLE #DatafileSize
  (
     [ServerName]    NVARCHAR(100),
     [DatabaseName]  NVARCHAR(250),
     [Logical_Name]  VARCHAR(250),
     [File_Path]     VARCHAR(250),
     [TYPE]          NVARCHAR(10),
     [FileGrowth]    NVARCHAR(1000),
     [Max]           VARCHAR(100),
     [MAX Growth MB] VARCHAR(100),
     [CurrentSizeMB] VARCHAR(15),
     [SpaceUsedMB]   VARCHAR(15),
     [FreeSpaceMB]   VARCHAR(15),
     [Free Space %]  INT
  );

INSERT INTO #DatafileSize
EXEC Sp_msforeachdb
  @SQLcmd



IF Object_id(N'tempdb..#LRT') IS NOT NULL
  DROP TABLE #LRT

CREATE TABLE #LRT
  (
     [ServerName]         NVARCHAR(100),
     [DatabaseName]       NVARCHAR(100),
     session_id           INT,
     start_time           TIME,
     TotalElapsedTime_min NVARCHAR(100),
     status               NVARCHAR(100),
     command              NVARCHAR(100)
  )

INSERT INTO #LRT
SELECT [ServerName]         =@@SERVERNAME,
       DatabaseName         = Db_name(r.database_id),
       r.session_id,
       r.start_time,
       TotalElapsedTime_min = r.total_elapsed_time / 1000 / 60,
       r.[status],
       r.command
FROM   sys.dm_exec_requests r
       CROSS APPLY sys.Dm_exec_sql_text(r.sql_handle) AS t
       CROSS APPLY sys.Dm_exec_query_plan(r.plan_handle) AS p
WHERE  wait_type != 'XE_LIVE_TARGET_TVF'
ORDER  BY r.total_elapsed_time DESC

SELECT ServerEnvironment, *
FROM   [DBA].[info].[AgentJob] A
cross apply [DBA].[info].[Instance] I 
WHERE 
JobEnabled = 1
       AND JobStatus = 0
       AND RunDateTime >= Dateadd(HOUR, -4, Getdate())
	   AND ServerEnvironment IN ('PRD','PROD') 
       AND JobName NOT LIKE 'DBA%'
       AND JobName NOT LIKE 'OLA%'
       AND JobName NOT IN ( 'IQQ Month End iQQ Report', 'Script: Impaired Expired Cleanup', 'Email Blank Tempest ID', 'PerfMon: Gather PerfStats',
                            'Temporary: TFS Bug 37520 Reliable Credit Branch Update', 'Tasks: LetterLibrary', 'Alert: Informatica Message Server Error', 'Script: OceanBankZeroOut',
                            'PerfStats-CaptureLongTranInfo', 'Perfstats - TempDataFilesCheck', 'Correct Permissions', 'CTPT-ArchiveCP_EmailVerificationCodes',
                            'CTPT-ArchiveCP_Sessions', 'CTPT-purgeAppLogTable', 'SURF-DemoDataRollForward', 'Unitrac-Revert_from_Impairment_Pending',
                            'Unitrac-Impaired_Expired_Cleanup', 'Escrow Process Checks', 'Unitrac-Revert_from_Impairment_Pending', 'Unitrac-Impaired_Expired_Cleanup',
                            'Escrow Process Checks', 'SURF-DemoDataRollForward', 'Performance Test Data Load', 'SURF-DemoDataRollForward',
                            'SURF-DemoDataRollForward', 'Perfstats - TempDataFilesCheck', 'SURF-DemoDataRollForward', 'IQQ Month End iQQ Report',
                            'RPA-VowRecordsCleanup', 'ArchiveCP_Sessions', 'ArchiveCP_EmailVerificationCodes', 'CTPT-ArchiveCP_EmailVerificationCodes',
                            'CTPT-ArchiveCP_Sessions', 'Import Call Data', 'PerfMon: Gather PerfStats', 'CTPT-ArchiveCP_EmailVerificationCodes',
                            'CTPT-ArchiveCP_Sessions', 'WebLogImport_Prod', 'Tasks: LetterLibrary', 'OCR-DailyCounts_Report', 'Clear cache and recompile SP''s', 
							'Purge Duplicate AI One Main','Script: Change OperationalDashboard','Email LIMC Errors','LIMCArchive','Unitrac-ArchivePropertyChange Stop_Archive'
							,'MissingStaticDocuments','IQQ ALERT: ADR Sales\Cancellations waiting','Report: PFS 1105 Weekly Report','Report: UniTrac Escrow Report') 


  


  
select * 
  FROM [DBA].[info].[Database]
  where state NOT IN ('ONLINE', 'MISSING', 'RESTORING')

SELECT *
FROM   #AGCheck

SELECT *
FROM   #SpaceDrive
where [Free Space %] <= 5

  SELECT  * 
FROM   #DatafileSize
WHERE [MAX Growth MB]  NOT IN ('Unlimited', '2 TB')
AND CASE WHEN TYPE NOT IN ('LOG', 'ROWS') THEN (CAST (REPLACE([MAX Growth MB], 'MB','') AS INT)+1) ELSE CAST (REPLACE([MAX Growth MB], 'MB','') AS INT) END<= CONVERT(INT,ABS([CurrentSizeMB])) 
AND DatabaseName <> 'tempdb'
AND TYPE in ('ROWS','LOG')
UNION
SELECT * 
FROM   #DatafileSize
WHERE [MAX Growth MB]  NOT IN ('Unlimited', '2 TB')
AND CASE WHEN TYPE NOT IN ('LOG', 'ROWS') THEN (CAST (REPLACE([MAX Growth MB], 'MB','') AS INT)+1) ELSE CAST (REPLACE([MAX Growth MB], 'MB','') AS INT) END<= CONVERT(INT,ABS([CurrentSizeMB]))
AND  [Free Space %] <= 5
AND TYPE in ('ROWS','LOG')
ORDER  BY [MAX Growth MB] ASC,
          [Free Space %] ASC 
		  
		  
select * from #LRT L
join [DBA].[info].[Instance] I on I.SQLServerName=L.ServerName
where TotalElapsedTime_min > 120  AND ServerEnvironment IN ('PRD','PROD') 





--EXEC [DBA].[Backup].[BackupReport] @BackupType = 'FULL', @DryRun = 1
--EXEC [DBA].[Backup].[BackupReport] @BackupType = 'LOG', @DryRun = 1


EXEC DBA.DBO.SP_WHOISACTIVE  --@get_task_info =2,@get_plans =2 ,  @get_avg_time=1;
