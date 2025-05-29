SELECT TOP (1000) [deployID],
                  [deployVersion],
                  [TargetDB],
                  [ServerCount],
                  [DeployTarget],
                  [RepoRoot],
                  [RepoFolder],
                  [RepoVersion],
                  [ScriptsPath],
                  [TargetInvServer],
                  [TargetInvDB],
                  [FileFilter],
                  [DryRun],
                  [Configure],
                  [Force],
                  [Comments],
                  [StartDateTime],
                  [EndDateTime],
                  [StartedBy]
FROM   [InventoryDWH].[Info].[DeployHistory]
WHERE  Cast(EndDateTime AS DATE) >= Cast(Getdate() AS DATE)
ORDER  BY EndDateTime DESC

SELECT TOP (1000) [DeployID],
                  [DeployVersion],
                  [SQLServerName],
                  [Function],
                  [Command],
                  [ErrorMessage],
                  [Daterun]
FROM   [InventoryDWH].[Info].[DeployFailures]
WHERE  Cast(Daterun AS DATE) >= Cast(Getdate() AS DATE)
ORDER  BY Daterun DESC

SELECT TOP (1000) [HarvestID],
                  [SQLServerName],
                  [Function],
                  [command],
                  [ErrorMessage],
                  [Daterun]
FROM   [InventoryDWH].[Info].[HarvestFailures]
WHERE  Cast(Daterun AS DATE) >= Cast(Getdate() AS DATE)
ORDER  BY Daterun DESC

SELECT TOP (1000) [HarvestID]
      ,[TargetCMS]
      ,[CMSGroup]
      ,[TargetInvServer]
      ,[TargetInvDB]
      ,[ProcessInfo]
      ,[DryRun]
      ,[Comments]
      ,[StartDateTime]
      ,[EndDateTime]
      ,[StartedBy]
  FROM [InventoryDWH].[Info].[HarvestHistory]
    WHERE Cast(EndDateTime AS DATE) >= Cast(Getdate() AS DATE)
      ORDER BY EndDateTime DESC

