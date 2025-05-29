USE [RPA]
GO

/****** Object:  StoredProcedure [UIPath].[QueueItemsCleanup]    Script Date: 8/23/2021 12:50:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--CREATE PROCEDURE [UIPath].[QueueItemsCleanup] ( @Archive BIT = 0 )
--AS 
BEGIN
    DECLARE @JobName varchar(100) = 'UIPath-QueueItemsCleanup'
    DECLARE @TableName varchar(100) = 'QueueItems'
    DECLARE @NumberOfDaysToKeep INT, @RetainRows INT
    DECLARE @BatchSize INT, @Enabled INT, @RemoveRows INT
    DECLARE @SQLStatement nvarchar(200)


    -- SELECT * FROM [RPA].[UIPath].[AgentJobTableRetention]
    SELECT  @NumberOfDaysToKeep = TableRetention,
	    @BatchSize = BatchSize,
	    @Enabled = Enabled
    FROM [RPA].[UIPath].[AgentJobTableRetention] 
    WHERE JobName = @JobName and TableName = @TableName;

    -- Record Beginning counts
    SELECT @SQLStatement = 'SELECT @RemoveCount = count(*) FROM [UIPath].[dbo].['+ @TableName +'] WHERE DateDiff(day, CreationTime, GetDate()) > '+ convert(varchar(10), @NumberOfDaysToKeep)
    exec sp_executesql @SQLStatement, N'@RemoveCount int out', @RemoveRows out

    SELECT @SQLStatement = 'SELECT @RetainCount = count(*) FROM [UIPath].[dbo].['+ @TableName +'] WHERE DateDiff(day, CreationTime, GetDate()) < '+ convert(varchar(10), @NumberOfDaysToKeep)
    exec sp_executesql @SQLStatement, N'@RetainCount int out', @RetainRows out

    PRINT 'JobName: '+ @jobName +' 
    TableName: '+ @TableName +' 
    Keeping: '+ convert(varchar(10), @NumberOfDaysToKeep) +' Days 
    BatchSize: '+ convert(varchar(10), @BatchSize) +' rows 
    Enabled: '+ convert(varchar(10), @Enabled) +' 
    Rows to be deleted: '+ convert(varchar(10), @RemoveRows) +' 
    Rows to remain: '+ convert(varchar(10), @RetainRows)

    IF( (@Enabled = 1) AND (@RemoveRows > 0) )
	    BEGIN
		    PRINT 'Populate TEMP table for cleaning child tables'
		    -- create temp table with list of IDs that we want to delete
		    SELECT @SQLStatement = 'select ID
		    from [UIPath].[dbo].['+ @TableName +']
		    where status=3 -- and TenantId = 1 -- and ReviewStatus != 0
		    and DateDiff(day, CreationTime, GetDate()) > '+ convert(varchar(10), @NumberOfDaysToKeep)

		    IF OBJECT_ID('tempdb..#TempDeletedIds') IS NOT NULL 
		    BEGIN 
			    DROP TABLE #TempDeletedIds 
		    END
		    CREATE TABLE #TempDeletedIds ( IdToDelete INT );
		    INSERT INTO #TempDeletedIds
			    EXEC(@SQLStatement)

		    --SELECT * FROM #TempDeletedIds
		    -------------------- QueueItemEvents
		    SET @TableName = 'QueueItemEvents'
		    SELECT @SQLStatement = 'SELECT @RemoveCount = count(*) FROM [UIPath].[dbo].['+ @TableName +'] where Exists (select 1 from #TempDeletedIds where IdToDelete = QueueItemId)'
		    exec sp_executesql @SQLStatement, N'@RemoveCount int out', @RemoveRows out

		    SELECT @SQLStatement = 'SELECT @RetainCount = count(*) FROM [UIPath].[dbo].['+ @TableName +'] where NOT Exists (select 1 from #TempDeletedIds where IdToDelete = QueueItemId)'
		    exec sp_executesql @SQLStatement, N'@RetainCount int out', @RetainRows out

		    PRINT '
		    JobName: '+ @jobName +' 
		    TableName: '+ @TableName +' 
		    Keeping: '+ convert(varchar(10), @NumberOfDaysToKeep) +' Days 
		    BatchSize: '+ convert(varchar(10), @BatchSize) +' rows 
		    Enabled: '+ convert(varchar(10), @Enabled) +' 
		    Rows to be deleted: '+ convert(varchar(10), @RemoveRows) +' 
		    Rows to remain: '+ convert(varchar(10), @RetainRows)

		    IF( @RemoveRows > 0 )
		    BEGIN
			    INSERT INTO [RPA].[UIPath].[TableCleanupHistory]
				    ([JobName],[StepName],[TableName],[RemoveCount],[RetainCount],[RunDate])
			    VALUES
				    ( @jobName, 'QueueItems - QueueItemsEvents - QueueItemComments', @TableName, @RemoveRows, @RetainRows, GetDate() )
			    /* Insert statement will return @@RowCount = 1 */
			    WHILE ( @@Rowcount > 0 )
				    BEGIN
					    --delete from [UiPath].[dbo].[QueueItemEvents] where Exists (select 1 from #TempDeletedIds where IdToDelete = QueueItemId)
					    SELECT @SQLStatement = 'DELETE TOP('+ convert(varchar(10), @BatchSize) +') FROM [UIPath].[dbo].['+  @TableName +'] where Exists (select 1 from #TempDeletedIds where IdToDelete = QueueItemId)'
					 --   PRINT @SQLStatement
					   --EXEC(@SQLStatement)
				    END
		    END

		    -------------------- QueueItemComments
		    SET @TableName = 'QueueItemComments'
		    SELECT @SQLStatement = 'SELECT @RemoveCount = count(*) FROM [UIPath].[dbo].['+ @TableName +'] where Exists (select 1 from #TempDeletedIds where IdToDelete = QueueItemId)'
		    exec sp_executesql @SQLStatement, N'@RemoveCount int out', @RemoveRows out

		    SELECT @SQLStatement = 'SELECT @RetainCount = count(*) FROM [UIPath].[dbo].['+ @TableName +'] where NOT Exists (select 1 from #TempDeletedIds where IdToDelete = QueueItemId)'
		    exec sp_executesql @SQLStatement, N'@RetainCount int out', @RetainRows out

		    PRINT '
		    JobName: '+ @jobName +' 
		    TableName: '+ @TableName +' 
		    Keeping: '+ convert(varchar(10), @NumberOfDaysToKeep) +' Days 
		    BatchSize: '+ convert(varchar(10), @BatchSize) +' rows 
		    Enabled: '+ convert(varchar(10), @Enabled) +' 
		    Rows to be deleted: '+ convert(varchar(10), @RemoveRows) +' 
		    Rows to remain: '+ convert(varchar(10), @RetainRows)

		    IF( @RemoveRows > 0 )
		    BEGIN
			    INSERT INTO [RPA].[UIPath].[TableCleanupHistory]
				    ([JobName],[StepName],[TableName],[RemoveCount],[RetainCount],[RunDate])
			    VALUES
				    ( @jobName, 'QueueItems - QueueItemsEvents - QueueItemComments', @TableName, @RemoveRows, @RetainRows, GetDate() )
			    /* Insert statement will return @@RowCount = 1 */
			    WHILE ( @@Rowcount > 0 )
				    BEGIN
					    --delete from [UiPath].[dbo].[QueueItemComments] where Exists (select 1 from #TempDeletedIds where IdToDelete = QueueItemId)
					    SELECT @SQLStatement = 'DELETE TOP('+ convert(varchar(10), @BatchSize) +') FROM [UIPath].[dbo].['+  @TableName +'] where Exists (select 1 from #TempDeletedIds where IdToDelete = QueueItemId)'
					 --   PRINT @SQLStatement
					    --EXEC(@SQLStatement)
				    END
		    END

		    -------------------- QueueItems
		    SET @TableName = 'QueueItems'
		    SELECT @SQLStatement = 'SELECT @RemoveCount = count(*) FROM [UIPath].[dbo].['+ @TableName +'] WHERE Exists (select 1 from #TempDeletedIds where IdToDelete = [UiPath].[dbo].[QueueItems].[Id])'
		    exec sp_executesql @SQLStatement, N'@RemoveCount int out', @RemoveRows out

		    SELECT @SQLStatement = 'SELECT @RetainCount = count(*) FROM [UIPath].[dbo].['+ @TableName +'] WHERE NOT Exists (select 1 from #TempDeletedIds where IdToDelete = [UiPath].[dbo].[QueueItems].[Id])'
		    exec sp_executesql @SQLStatement, N'@RetainCount int out', @RetainRows out

		    PRINT '
		    JobName: '+ @jobName +' 
		    TableName: '+ @TableName +' 
		    Keeping: '+ convert(varchar(10), @NumberOfDaysToKeep) +' Days 
		    BatchSize: '+ convert(varchar(10), @BatchSize) +' rows 
		    Enabled: '+ convert(varchar(10), @Enabled) +' 
		    Rows to be deleted: '+ convert(varchar(10), @RemoveRows) +' 
		    Rows to remain: '+ convert(varchar(10), @RetainRows)

		    IF( @RemoveRows > 0 )
		    BEGIN
			    INSERT INTO [RPA].[UIPath].[TableCleanupHistory]
				    ([JobName],[StepName],[TableName],[RemoveCount],[RetainCount],[RunDate])
			    VALUES
				    ( @jobName, 'QueueItems - QueueItemsEvents - QueueItemComments', @TableName, @RemoveRows, @RetainRows, GetDate() )
			    /* Insert statement will return @@RowCount = 1 */
			    WHILE ( @@Rowcount > 0 )
				    BEGIN
					    --delete from [UiPath].[dbo].[QueueItems] where Exists (select 1 from #TempDeletedIds where IdToDelete = [UiPath].[dbo].[QueueItems].[Id])
					    SELECT @SQLStatement = 'DELETE TOP('+ convert(varchar(10), @BatchSize) +') FROM [UIPath].[dbo].['+ @TableName +']  WHERE DateDiff(day, CreationTime, GetDate()) > '+ convert(varchar(10), @NumberOfDaysToKeep)
					 --   PRINT @SQLStatement
				  -- EXEC(@SQLStatement)
				    END
		    END

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
GO

