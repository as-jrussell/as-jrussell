USE [PerfStats];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[action].[IndexRebuildManagement]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      /* Create Empty Stored Procedure */
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [action].[IndexRebuildManagement] AS RETURN 0;';
  END;

GO

ALTER PROCEDURE [action].[Indexrebuildmanagement] (@ActionType    VARCHAR(50)=NULL,
                                                   @database_name SYSNAME = '',
                                                   @minutes       INT = 5,
                                                   @index_name    NVARCHAR(200) = '',
                                                   @table_name    NVARCHAR(200) ='',
                                                   @WhatIf        INT = 1,
                                                   @Force         INT =1)
AS
  /*
    ######################################################################
		Examples
    ######################################################################
  EXEC [Perfstats]. [action].[IndexRebuildManagement] @ActionType ='Rebuild', @database_name ='Unitrac', @index_name = 'IDX_IH_RELATE_ID', @table_name = 'INTERACTION_HISTORY', @WhatIF=1, @minutes =5
  
   EXEC [Perfstats]. [action].[IndexRebuildManagement] @ActionType ='Pause', @database_name ='Unitrac', @index_name = 'IDX_IH_RELATE_ID', @table_name = 'INTERACTION_HISTORY', @WhatIF=1, @minutes =5
  
  EXEC [Perfstats]. [action].[IndexRebuildManagement] @ActionType ='Monitor', @database_name ='Unitrac', @index_name = 'IDX_IH_RELATE_ID', @table_name = 'INTERACTION_HISTORY', @WhatIF=1, @minutes =5
  
  EXEC [Perfstats]. [action].[IndexRebuildManagement] @ActionType ='Inspect', @database_name ='Unitrac', @index_name = 'IDX_IH_RELATE_ID', @table_name = 'INTERACTION_HISTORY', @WhatIF=1, @minutes =5
  
    EXEC [Perfstats]. [action].[IndexRebuildManagement] @ActionType ='History', @WhatIF=0
  
  EXEC [Perfstats]. [action].[IndexRebuildManagement] @ActionType ='Rebuild', @database_name ='Unitrac', @index_name = 'IDX_IH_RELATE_ID', @table_name = 'INTERACTION_HISTORY', @WhatIF=0
  
   EXEC [Perfstats]. [action].[IndexRebuildManagement] @ActionType ='Pause', @database_name ='Unitrac', @index_name = 'IDX_IH_RELATE_ID', @table_name = 'INTERACTION_HISTORY',  @WhatIF=0 ,@Force =0
  
  EXEC [Perfstats]. [action].[IndexRebuildManagement] @ActionType ='Monitor', @database_name ='Unitrac', @index_name = 'IDX_IH_RELATE_ID', @table_name = 'INTERACTION_HISTORY',  @WhatIF=0
  
  EXEC [Perfstats]. [action].[IndexRebuildManagement] @ActionType ='Inspect', @database_name ='Unitrac', @index_name = 'IDX_IH_RELATE_ID', @table_name = 'INTERACTION_HISTORY',  @WhatIF=0
  
  */

    /*
    ######################################################################
		Declarations
    ######################################################################
    */

	      DECLARE @SQLCMD NVARCHAR(MAX);



  BEGIN
      SET NOCOUNT ON;


    /*
    ######################################################################
					   Pause Index Rebuild
    ######################################################################
    */
      IF @ActionType = 'Pause'
        BEGIN
            EXEC [action].[PauseRebuild]
              @database_name =@database_name,
              @index_name = @index_name,
              @table_name = @table_name,
              @WhatIF=@WhatIF,
              @Force=@Force;
        END
		
    /*
    ######################################################################
					    Monitor Index Rebuild
    ######################################################################
    */
      ELSE IF @ActionType = 'Monitor'
        BEGIN
            EXEC [action].[MonitorRebuild]
              @database_name =@database_name,
              @WhatIF=@WhatIF;
        END
		
    /*
    ######################################################################
					    Start or Restart Index Rebuild
    ######################################################################
    */
      ELSE IF @ActionType = 'Rebuild'
        BEGIN
            EXEC [action].[StartorResumeIndexRebuild]
              @database_name = @database_name,
              @index_name = @index_name,
              @table_name = @table_name,
              @minutes=@minutes,
              @WhatIF=@WhatIF;
        END
		
    /*
    ######################################################################
					  Inspect Index to Rebuild
    ######################################################################
    */
      ELSE IF @ActionType = 'Inspect'
        BEGIN
            EXEC [action].[FragStatsMonitor]
              @database_name =@database_name,
              @index_name = @index_name,
              @table_name = @table_name,
              @WhatIF=@WhatIF;
        END
		
    /*
    ######################################################################
					 History of Index Rebuilds
    ######################################################################
    */
      ELSE IF @ActionType = 'History'
        BEGIN
  
              BEGIN
                  SELECT @SQLCMD = '      SELECT * FROM [PerfStats].[dbo].[IndexRebuildLog]
		   WHERE DatabaseName like ''%'
                                   + @database_name
                                   + '%''
		   AND TableName like ''%' + @table_name
                                   + '%''
		   AND IndexName like ''%' + @index_name
                                   + '%'''
              END

            IF @WhatIf = 0
              BEGIN
                  EXEC (@SQLCMD)
              END
            ELSE
              BEGIN
                  PRINT ( @SQLCMD )
              END
        END
		
    /*
    ######################################################################
					    Missing Variable 
    ######################################################################
    */
      ELSE IF @ActionType IS NULL
        BEGIN
            PRINT 'WARNING: Invalid action type please provide aciton of Inspect,History, Monitor, Rebuild, Monitor, or Pause ';
        END
      ELSE IF @ActionType = ''
        BEGIN
            PRINT 'WARNING: Invalid action type please provide aciton of Inspect,History, Monitor, Rebuild, Monitor, or Pause ';
        END
      ELSE
        BEGIN
            PRINT'WARNING: Invalid action type please provide aciton of Inspect,History, Monitor, Rebuild, Monitor, or Pause ';
        END
  END 
