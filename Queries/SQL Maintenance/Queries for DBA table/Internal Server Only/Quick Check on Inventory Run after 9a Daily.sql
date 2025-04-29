--IF (SELECT DISTINCT 1
--    --SELECT *
--    FROM   msdb.dbo.sysjobs sj
--          LEFT JOIN msdb.dbo.sysjobhistory sh
--             ON sh.job_id = sj.job_id
--    WHERE  sj.name = 'InventoryDWH-HarvestDaily'
--           AND run_date IN (SELECT Cast(Cast(Datepart(year, Getdate()) AS VARCHAR)
--                                        + RIGHT('0' + Cast (Datepart(month, Getdate()) AS VARCHAR), 2)
--                                        + RIGHT('0' + Cast (Datepart(day, Getdate()) AS VARCHAR), 2) AS NUMERIC(10, 0)))) = 1
--  BEGIN
--      PRINT 'Why are you looking here when you have work to do on the other tab!'
SELECT Count(*) [Failed Linked Servers]
--SELECT [MachineName],Name [SRV_NAME],[Data_source],[Provider_string],[Remote_name],LNK.[Status]
FROM   [InventoryDWH].[inv].[LinkedServer] LNK
       JOIN [InventoryDWH].[inv].[instance] AS INST
         ON ( LNK.InstanceID = INST.ID )
WHERE  Cast(LNK.HarvestDate AS DATE) >= Cast(Getdate() AS DATE)
       AND LNK.[Status] <> 'Valid'
       AND inst.MachineName <> 'DBA-SQLPRD-01'
       AND ( [Data_source] != 'SQLSDEVVMDB01'
             AND MachineName != 'DS-SQLDEV-14' )

SELECT Count(*) [Count of owners no SA]
--select ServerType, INST.SQLSERVERNAME,[Owner] , * 
FROM   [InventoryDWH].[inv].[Database] AS DB
       LEFT JOIN [InventoryDWH].[inv].[instance] AS INST
              ON ( db.InstanceID = INST.ID )
WHERE  Inst.ServerEnvironment NOT IN ( 'prd', 'Admin', 'ADM' )
       AND ( ServerLocation IN ( 'ON-PREM', 'AWS-EC2', '' )
              OR ServerLocation IS NULL )
       AND [Owner] NOT IN ( 'ELDREDGE_A\MBreitsch', 'ELDREDGE_A\smoran', 'ELDREDGE_A\lrensberger', 'ELDREDGE_A\hbrotherton', 'SA' )
       AND Cast(DB.HarvestDate AS DATE) >= Cast(Getdate() AS DATE)
       AND inst.SQLServerName NOT IN ( 'GP-SQLTST-01\I01', 'GP-SQLTST-01\I02', 'DBA-SQLQA-01\I01' )
       AND ServerType = 'StandAlone'

SELECT Count(*) [Count of database not in SIMPLE recovery]
--select INST.SQLSERVERNAME,  Inst.ServerEnvironment, DB.*, INST.*
FROM   [InventoryDWH].[inv].[Database] AS DB
       LEFT JOIN [InventoryDWH].[inv].[instance] AS INST
              ON ( db.InstanceID = INST.ID )
WHERE  Inst.ServerEnvironment NOT IN ( 'prd', 'prod', 'Admin', 'ADM' )
       AND ( ServerLocation IN ( 'ON-PREM', 'AWS-EC2', '' )
              OR ServerLocation IS NULL )
       AND RecoveryModel != 'Simple'
       AND [Owner] NOT IN ( 'ELDREDGE_A\MBreitsch', 'ELDREDGE_A\lrensberger' )
       AND Inst.SQLServerName NOT LIKE ( 'OCR-SQL%' )
       AND Inst.SQLServerName NOT LIKE ( 'cp-SQL%' )
       AND Inst.SQLServerName NOT LIKE ( 'SQLS%AWEC0%' )
       AND Inst.ServerStatus != 'DOWN'
       AND Cast(DB.HarvestDate AS DATE) >= Cast(Getdate() AS DATE)
       AND ServerType = 'StandAlone'

SELECT DISTINCT Count(*) [Local Drive under 15%]
--select distinct ApplicationName,I.SQLSERVERNAME,ServerLocation,  ServerEnvironment, I.Local_Net_Address,	D.*
FROM   [InventoryDWH].[inv].[Instance] I
       JOIN [InventoryDWH].[inv].[DriveUsage] D
         ON I.ID = D.InstanceID
       LEFT JOIN [InventoryDWH].[inv].AppDatabase A
              ON A.InstanceID = I.ID
       LEFT JOIN [InventoryDWH].[inv].Application APP
              ON APP.ApplicationID = A.ApplicationID
WHERE  FreePct < '3'
       AND ServerEnvironment <> '_DCOM'
       AND Path LIKE 'C%'
       AND Cast(D.HarvestDate AS DATE) >= Cast(Getdate() AS DATE)

SELECT Count(DISTINCT D.InstanceID) AS [TempDB under 15%]
--select DISTINCT ApplicationName, I.SQLSERVERNAME,ServerLocation,  ServerEnvironment, I.Local_Net_Address, FreePct
FROM   InventoryDWH.inv.[Database] D
       JOIN InventoryDWH.inv.[Instance] I
         ON I.ID = D.InstanceID
       JOIN [InventoryDWH].[inv].[DriveUsage] DR
         ON I.ID = DR.InstanceID
       JOIN [InventoryDWH].[inv].AppDatabase A
         ON A.InstanceID = I.ID
       JOIN [InventoryDWH].[inv].Application APP
         ON APP.ApplicationID = A.ApplicationID
WHERE  ServerEnvironment <> '_DCOM'
       AND Path LIKE '%TEMPDB%'
       AND DBID = 2
       AND FreePct <= '15'

SELECT DISTINCT  Count(DISTINCT D.InstanceID) [Logs under 15%]
--select distinct ApplicationName, I.SQLSERVERNAME,ServerLocation,  ServerEnvironment, I.Local_Net_Address,	D.*
FROM   [InventoryDWH].[inv].[Instance] I
       JOIN [InventoryDWH].[inv].[DriveUsage] D
         ON I.ID = D.InstanceID
       LEFT JOIN [InventoryDWH].[inv].AppDatabase A
              ON A.InstanceID = I.ID
       LEFT JOIN [InventoryDWH].[inv].Application APP
              ON APP.ApplicationID = A.ApplicationID
WHERE  Path LIKE '%Logs'
       AND FreePct <= CASE
                        WHEN MachineName IN ( 'INFOR-SQL01' )
                             AND Path = 'F:\TRANSLOGS' THEN '3'
                        WHEN ServerEnvironment NOT IN ( '_DCOM', 'PRD', 'ADMIN' ) THEN '17'
                        ELSE '15'
                      END

SELECT DISTINCT  Count(DISTINCT D.InstanceID) [Other Drives under 15%]
--select   I.SQLSERVERNAME,ServerLocation,  ServerEnvironment, I.Local_Net_Address,	D.*
FROM   [InventoryDWH].[inv].[Instance] I
       JOIN [InventoryDWH].[inv].[DriveUsage] D
         ON I.ID = D.InstanceID
WHERE  Path NOT LIKE 'C%'
       AND Path NOT LIKE '%TEMPDB%'
       AND Path NOT LIKE '%Logs%'
       AND Path NOT LIKE '%PageFile%'
       AND ServerEnvironment <> '_DCOM'
       AND Cast(D.HarvestDate AS DATE) >= Cast(Getdate() AS DATE)
       AND FreePct <= CASE
                        WHEN Path LIKE '%:\SQL\Data0%\Data0%'
                             AND ServerEnvironment NOT IN ( '_DCOM', 'PRD', 'ADMIN' ) THEN '5'
                        WHEN Path LIKE '%:\SQL\Data0%\Data0%' THEN '7'
                        WHEN MachineName IN ( 'WWW-DB-01\WWWSITECOREPROD' ) THEN '10'
                        WHEN MachineName IN ( 'APP-DEPLOY' )
                             AND Path = 'E:\Data' THEN '3'
                        WHEN MachineName IN ( 'POS-SQL-14' )
                             AND Path = 'E:\Data' THEN '10'
                        WHEN MachineName IN ( 'UTL-SQL-01' )
                             AND Path = 'E:\Data' THEN '10'
                        WHEN Path = 'I:\GP_Backups' THEN '3'
                        WHEN ServerEnvironment NOT IN ( '_DCOM', 'PRD', 'ADMIN' ) THEN '10'
                        ELSE '15'
                      END

SELECT DISTINCT Count(*) [Failed Emails]
--select DISTINCT I.SQLSERVERNAME,ServerLocation,  E.ServerEnvironment, I.Local_Net_Address,	E.EmailTestStatus, e.EmailTestSendDate
FROM   [InventoryDWH].[Info].[vw_Email] E
       JOIN [InventoryDWH].[inv].Instance I
         ON I.SQLSERVERNAME = E.SQLServerName
WHERE  E.serverenvironment != '_DCOM'
       AND EmailTestStatus = 'FAILED'
       AND Cast(I.HarvestDate AS DATE) >= Cast(Getdate() AS DATE)

--   ----UIPA-TST-DB1  will be removed once we determines whom controls the storage.
--   SELECT SQLServerName [Offending Server],
--          ServerLocation,
--          Concat('Start-DbaAgentJob -SqlInstance ', SQLServerName, ' -Job DBA-HarvestDaily'),
--          Concat('C:\GitHub\DBA-PowerShell\DBA-Tools\DBA_Tools\Harvest-Inventory.ps1 -TargetHost ', SQLServerName, ' -targetInvServer "DBA-SQLPRD-01.colo.as.local\I01" -targetInvDB "InventoryDWH" -Force 1 -dryRun 0')
--   --select *
--   FROM   [InventoryDWH].[inv].[Instance] I
--   WHERE  
--Cast(HarvestDate AS DATE) != Cast(Getdate() AS DATE)
--          AND ServerEnvironment <> '_DCOM'
--          AND ( ServerLocation IN ( 'ON-PREM', 'AWS-EC2', '' )
--                 OR ServerLocation IS NULL )
--IF Object_id(N'tempdb..#GetDatabaseNoApplication') IS NOT NULL
--  DROP TABLE #GetDatabaseNoApplication
--CREATE TABLE #GetDatabaseNoApplication
--  (
--     [InstanceName]    NVARCHAR(100),
--     [DatabaseName]    NVARCHAR(100),
--     [InstanceID]      VARCHAR(3),
--     [DatabaseID]      VARCHAR(3),
--     [ApplicationID]   VARCHAR(3),
--     [PossibleAppName] NVARCHAR(250),
--     [Score]           INT,
--     [Action]          NVARCHAR(max)
--  );
--INSERT INTO #GetDatabaseNoApplication
--EXEC InventoryDWH.amp.Getdatabasenoapplication
--SELECT *
--FROM   #GetDatabaseNoApplication
--WHERE  Score >= '2'
--UNION
--SELECT *
--FROM   #GetDatabaseNoApplication
--WHERE  PossibleAppName <> ''
SELECT Concat('UPDATE [InventoryDWH].[inv].[Instance] SET ServerStatus = ''DOWN'' , ServerEnvironment = ''_DCOM'', Comments = ''DCOM-', Comments, ''' WHERE Comments = ''', Comments, '''')
--select *
FROM   [InventoryDWH].[inv].[Instance]
WHERE  [Comments] IS NOT NULL
       AND [Comments] <> ''
       AND Comments NOT LIKE '%DCOM%'
-- END
--ELSE
--  BEGIN
--DECLARE @NextRunTime DATETIME = 
--    CASE 
--        WHEN GETDATE() <= CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 07:30' AS DATETIME) THEN
--            CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 07:30' AS DATETIME)
--        ELSE
--            DATEADD(DAY, 1, CAST(CONVERT(VARCHAR, GETDATE(), 101) + ' 07:30' AS DATETIME))
--    END;
--DECLARE @TimeDifference INT = DATEDIFF(MINUTE, GETDATE(), @NextRunTime);
--IF GETDATE() <= @NextRunTime
--    PRINT 'Harvester has not run today yet; please come back after it starts at 7:30 AM CT that is in ' + CAST(@TimeDifference AS VARCHAR) + ' minutes.'
--ELSE
--    PRINT 'Harvester has not run today yet; please come back after it starts at 7:30 AM CT that is in ' + CAST(@TimeDifference AS VARCHAR) + ' minutes.'
--    END 
