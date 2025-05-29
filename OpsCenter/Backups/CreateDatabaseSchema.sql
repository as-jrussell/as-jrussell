USE [HDTStorage]
GO

/****** Object:  StoredProcedure [deploy].[CreateDatabaseSchema]    Script Date: 7/11/2022 1:57:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [deploy].[CreateDatabaseSchema] ( @DryRun bit = 1 )
AS 
BEGIN
    -- EXEC [HDTStorage].[deploy].[CreateDatabaseSchema] @DryRun = 0 

    DECLARE @CurrentDB nvarchar(100)
    DECLARE @DiscoverQuery NVARCHAR(MAX) = 'SELECT name, 0 FROM sys.databases 
                                            WHERE database_ID > 4 
                                                    AND name NOT IN (''DBA'',''PerfStats'') 
                                                    AND name NOT LIKE ''%Storage'' 
                                                    AND name NOT IN (select name from sys.schemas)'
    DECLARE @CreateSchema nvarchar(100)

    IF OBJECT_ID('tempdb..#SchemaList') IS NOT NULL
	    DROP TABLE #SchemaList;		
    CREATE TABLE #SchemaList(
	    [DatabaseName] varchar(100),
        IsProcessed bit )

    INSERT INTO #SchemaList
    EXEC( @DiscoverQuery )

	    IF( @@RowCount > 0 )
		    begin
			    print 'Found missing SCHEMAS';
                WHILE EXISTS (SELECT * FROM #SchemaList WHERE IsProcessed = 0 )
                BEGIN
			        SELECT TOP 1 @currentDB = DatabaseName, @CreateSchema = 'CREATE SCHEMA ['+ DatabaseName +'];' FROM #SchemaList WHERE IsProcessed = 0
			        --EXEC sys.sp_executesql N'CREATE SCHEMA [alert]'

			        IF( @DryRun = 0 )
			            BEGIN
				            --EXEC( @CreateSchema)

                            EXEC sys.sp_executesql @CreateSchema
			            END
                    ELSE
                        BEGIN
                            PRINT @CreateSchema
                        END

                    UPDATE #SchemaList SET IsProcessed = 1 WHERE [DatabaseName] = @CurrentDB
                END -- WHILE
		    END
	    ELSE
		    BEGIN
			    PRINT '... No missing schemas in Storage database';
		    END
END;
GO

