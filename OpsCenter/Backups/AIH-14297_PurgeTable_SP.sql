USE AppLog

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[archive].[PurgeTable]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      /* Create Empty Stored Procedure */
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [archive].[PurgeTable] AS RETURN 0;';
  END;

GO

/* Alter Stored Procedure */
ALTER PROCEDURE [archive].[Purgetable] (@JobName      NVARCHAR(100)='archive-PurgeTable',
                                        @DatabaseName [NVARCHAR](100) ='Applog',
                                        @SchemaName   [NVARCHAR](100)='dbo',
                                        @TableName    [NVARCHAR](100)='Applog',
                                        @WhatIf       BIT = 0)
AS
  BEGIN
      -- DECLARE @JobName varchar(100) = 'archive-LedgerCleanup'
      -- DECLARE @TableName varchar(100) = 'LedgerDeliveries'
      DECLARE @NumberOfDaysToKeep INT,
              @RetainRows         INT
      DECLARE @BatchSize  INT,
              @Enabled    INT,
              @RemoveRows INT
      DECLARE @SQLStatement NVARCHAR(200)

      -- SELECT * FROM [OUR_FIRST_DATABASE].[archive].[AgentJobTableRetention]
      SELECT @NumberOfDaysToKeep = TableRetention,
             @BatchSize = BatchSize,
             @Enabled = Enabled
      FROM   [AppLog].[archive].[PurgeConfig]
      WHERE  JobName = @JobName
             AND TableName = @TableName;

      -- Record Beginning counts
      SELECT @SQLStatement = 'SELECT @RemoveCount = count(*) FROM ['
                             + @DatabaseName + '].[dbo].[' + @TableName
                             + '] WHERE DateDiff(day, Modified, GetDate()) > '
                             + CONVERT(VARCHAR(10), @NumberOfDaysToKeep)

      EXEC Sp_executesql
        @SQLStatement,
        N'@RemoveCount int out',
        @RemoveRows out

      SELECT @SQLStatement = 'SELECT @RetainCount = count(*) FROM['
                             + @DatabaseName + '].[dbo].[' + @TableName
                             + '] WHERE DateDiff(day, Modified, GetDate()) < '
                             + CONVERT(VARCHAR(10), @NumberOfDaysToKeep)

      EXEC Sp_executesql
        @SQLStatement,
        N'@RetainCount int out',
        @RetainRows out

      PRINT 'JobName: ' + @jobName + ' 
    TableName: '
            + @TableName + ' 
    Keeping: '
            + CONVERT(VARCHAR(10), @NumberOfDaysToKeep)
            + ' Days 
    BatchSize: '
            + CONVERT(VARCHAR(10), @BatchSize)
            + ' rows 
    Enabled: '
            + CONVERT(VARCHAR(10), @Enabled)
            + ' 
    Rows to be deleted: '
            + CONVERT(VARCHAR(10), @RemoveRows)
            + ' 
    Rows to remain: '
            + CONVERT(VARCHAR(10), @RetainRows)

      IF( ( @Enabled = 1 )
          AND ( @RemoveRows > 0 ) )
        BEGIN
            INSERT INTO [AppLog].[archive].[PurgeHistory]
                        ([JobName],
                         [DatabaseName],
                         [SChemaName],
                         [TableName],
                         [RemoveCount],
                         [RetainCount],
                         [RunDate])
            VALUES      ( @jobName,
                          @DatabaseName,
                          @SchemaName,
                          @TableName,
                          @RemoveRows,
                          @RetainRows,
                          Getdate() )

            /* Insert statement will return @@RowCount = 1 */
            WHILE ( @@ROWCOUNT > 0 )
              BEGIN
                  -- Ledger table cleanup
                  SELECT @SQLStatement = 'DELETE TOP('
                                         + CONVERT(VARCHAR(10), @BatchSize)
                                         + ') FROM [' + @DatabaseName
                                         + '] .[dbo].[' + @TableName
                                         + '] WHERE DateDiff(day, Modified, GetDate()) > '
                                         + CONVERT(VARCHAR(10), @NumberOfDaysToKeep)

                  -- PRINT @SQLStatement
                  EXEC(@SQLStatement)
              END
        -- SELECT * FROM [OUR_FIRST_DATABASE].[archive].[PurgeHistory]
        END
      ELSE
        BEGIN
            IF( @Enabled = 0 )
              BEGIN
                  PRINT 'Nothing Processed - Table Disabled.'
              END
            ELSE
              BEGIN
                  PRINT 'No rows to delete.'
              END
        END
  END;
