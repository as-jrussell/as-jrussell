USE DBA;

DECLARE @CurrentBackup NVARCHAR(100), @InstanceMemoryMB INT, @OSMemoryMB INT = 4096, @minDataSize NVARCHAR(100), @minTempDBLog  NVARCHAR(100) 

IF OBJECT_ID('tempdb..#DatabaseConfig', 'U') IS NOT NULL
	DROP TABLE #DatabaseConfig
/* Source Table */
CREATE TABLE #DatabaseConfig
(
	[DatabaseName] [varchar](200) not NULL,
    [ConfKey] [varchar](200) not NULL,
	[confValue] [varchar](1024) NULL
    PRIMARY KEY CLUSTERED
    (
		[DatabaseName] ASC,
        [ConfKey] ASC
    )
);

DECLARE @ProductVersion INT, @sql nvarchar(max)
SELECT @ProductVersion = convert(int, LEFT(convert(varchar(100),SERVERPROPERTY('ProductVersion')),charindex('.',convert(varchar(100),SERVERPROPERTY('ProductVersion')))-1 ))

SELECT @minDataSize = Isnull(confvalue, 8192)
FROM   [DBA].[info].[DatabaseConfig]
WHERE  databaseName = 'TEMPDB'
       AND confKey = 'MaxDataSizeMB'

SELECT @minTempDBLog = Isnull(confvalue, 10240)
FROM   [DBA].[info].[DatabaseConfig]
WHERE  databaseName = 'TEMPDB'
       AND confKey = 'MaxLogSizeMB'

/* Insert records into source table */
    IF( '$(targetEnv)' IN ('PROD', 'PRD', 'ADM', 'ADMIN') )
        BEGIN
            PRINT 'Set PROD values'
			INSERT INTO #DatabaseConfig ( [DatabaseName], [ConfKey], [confValue] )
				VALUES
				('ALL', 'MaxLogSizeMB', '1024'),
				('ALL', 'MaxDataSizeMB', '8192'),
              ('TempDB', 'MaxLogSizeMB', @minTempDBLog),
              ('TempDB', 'MaxDataSizeMB', @minDataSize),
        ('DataDomain','Host','ON-DD9300-01'),
        ('DataDomain', 'Retention', '14'),
        ('AWS-EC2','StorageGatewayPath','\\dbbkprdawstgy01.as.local\alss3sqlsprd01'),
        ('AWS-EC2', 'Retention', '336');
        END
    ELSE
        BEGIN
            SELECT @CurrentBackup = confValue FROM [DBA].[info].[DatabaseConfig] WHERE databaseName = 'DataDomain' AND confKey = 'Host'
            PRINT 'Set NonProd values'
            			
            INSERT INTO #DatabaseConfig ( [DatabaseName], [ConfKey], [confValue] )
              VALUES
              ('ALL', 'MaxLogSizeMB', '1024'),
              ('ALL', 'MaxDataSizeMB', '8192'),
              ('TempDB', 'MaxLogSizeMB', @minTempDBLog),
              ('TempDB', 'MaxDataSizeMB', @minDataSize),
              ('DataDomain','Host', @CurrentBackup),
              ('DataDomain', 'Retention', '7'),
              ('AWS-EC2', 'Retention', '168'); -- needs to be based on data center

            IF( '$(targetEnv)' = 'DEV')
            BEGIN
                INSERT INTO #DatabaseConfig ( [DatabaseName], [ConfKey], [confValue] )
                  VALUES
                  ('AWS-EC2','StorageGatewayPath','\\dbbkdevawstgy01.as.local\alss3sqlsdev01');
            END
            IF( '$(targetEnv)' IN ('TEST', 'TST', 'QA', 'UAT') )
            BEGIN
                INSERT INTO #DatabaseConfig ( [DatabaseName], [ConfKey], [confValue] )
			        VALUES
			        ('AWS-EC2','StorageGatewayPath','\\dbbktstawstgy01.as.local\alss3sqlstst01');
            END
            IF( '$(targetEnv)' = 'STG')
            BEGIN
                INSERT INTO #DatabaseConfig ( [DatabaseName], [ConfKey], [confValue] )
			        VALUES
			        ('AWS-EC2','StorageGatewayPath','\\dbbkstgawstgy01.as.local\alss3sqlsstg01');
            END
        END

/* Set Default backup software */
INSERT INTO #DatabaseConfig ( [DatabaseName], [ConfKey], [confValue] )
    SELECT TOP 1 'Backup','Software', REPLACE(IsNull(ServerLocation, 'On-Prem'),'On-Prem','ddboost') FROM DBA.info.Instance order by HarvestDate

/* DataDomain static values */
INSERT INTO #DatabaseConfig ( [DatabaseName], [ConfKey], [confValue] )
	VALUES
	('DataDomain','User','ddboost'),
	('DataDomain','SetName','MSSQL'),
	('DataDomain','NumberOfFiles','8'), -- Hard coded because we are lazy and do not compare DB size.
	('DataDomain','DevicePath','/SQL_PROD'),
	('DataDomain','LockBoxPath','C:\Program Files\DPSAPPS\common\lockbox');

/* Populate DBA table */
MERGE [DBA].[info].[DatabaseConfig] AS TARGET
USING #DatabaseConfig AS SOURCE
ON ( TARGET.DatabaseName = SOURCE.DatabaseName AND TARGET.ConfKey = SOURCE.confkey )
/* Update if default is higher */
WHEN MATCHED AND ( TARGET.confValue <> SOURCE.confValue ) THEN
	UPDATE SET TARGET.confValue = SOURCE.confValue 
/* Inserts records into the target table */
WHEN NOT MATCHED BY TARGET THEN
    INSERT ( [DatabaseName], [confKey], [confValue] )
    VALUES ( SOURCE.[DatabaseName], SOURCE.[confKey], SOURCE.[confValue] )
/* Delete records that exist in the target table */
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;








