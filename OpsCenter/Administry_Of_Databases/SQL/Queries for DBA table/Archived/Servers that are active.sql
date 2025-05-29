SELECT TOP (1000) [ID]
      ,[SQLServerName]
      ,[MachineName]
      ,[InstanceName]
      ,[DomainName]
      ,[Local_Net_Address]
      ,[Port]
      ,[DACPort]
      ,[ProductName]
      ,[ProductVersion]
      ,[ProductLevel]
      ,[ProductUpdateLevel]
      ,[Edition]
      ,[EngineEdition]
      ,[MIN_SIZE_SERVER_MEMORY_MB]
      ,[MAX_SIZE_SERVER_MEMORY_MB]
      ,[CTFP]
      ,[MDOP]
      ,[IsAdHocEnabled]
      ,[IsDBMailEnabled]
      ,[IsAgentXPsEnabled]
      ,[IsHadrEnabled]
      ,[HadrManagerStatus]
      ,[InSingleUser]
      ,[IsClustered]
      ,[ServerEnvironment]
      ,[ServerStatus]
      ,[HarvestDate]
      ,[Comments]
      ,[CREATE_DT]
      ,[UPDATE_DT]
      ,[UPDATE_USER]
  FROM [InventoryDWH].[inv].[Instance]
  where ServerEnvironment <> '_DCOM' and ProductName <> 'Microsoft SQL Azure'
  and MachineName not in ('RFPL-SQL-PROD',
  'RFPL-SQL-PREPROD',
  'RFPL-SQL-DEVTEST',
  'GP-DBQA-ESCROW',
'AZ-DEVOPS-01',
'IQQ-SQLTEST-01',
'GP-DB-ESCROW',
'GP-DB-01',
'UT-PREPROD-1',
'IQQ-SQLTEST-02',
'INFA-SQLQA-01',
'INFA-SQLSTAGE-01',
'GP-DBQA-01')
and ServerEnvironment <> 'PROD'

  /*

  RFPL-SQL-PROD
  RFPL-SQL-PREPROD
  RFPL-SQL-DEVTEST
  GP-DBQA-ESCROW
AZ-DEVOPS-01
IQQ-SQLTEST-01
GP-DB-ESCROW
GP-DB-01
UT-PREPROD-1
IQQ-SQLTEST-02
INFA-SQLQA-01
INFA-SQLSTAGE-01
GP-DBQA-01
*/

