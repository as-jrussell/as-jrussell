USE [PerfStats];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[action].[PauseRebuild]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      /* Create Empty Stored Procedure */
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [action].[PauseRebuild] AS RETURN 0;';
  END;

GO

/* Alter Stored Procedure */
ALTER PROCEDURE [action].[PauseRebuild] (@database_name SYSNAME = NULL,
                                          @index_name    NVARCHAR(200) = NULL,
                                          @table_name    NVARCHAR(200) =NULL,
                                          @WhatIf        INT = 1,
                                          @Force         INT =1)
AS

    /*
    ######################################################################
		Examples
    ######################################################################
	  EXEC [Perfstats]. [action].[PauseRebuild] @database_name ='Unitrac', @index_name = 'IDX_IH_RELATE_ID', @table_name = 'INTERACTION_HISTORY',@WhatIf=0

    EXEC [Perfstats]. [action].[PauseRebuild] @database_name ='Unitrac', @index_name = 'IDX_IH_RELATE_ID', @table_name = 'INTERACTION_HISTORY',@Force=0

	    EXEC [Perfstats]. [action].[PauseRebuild] @database_name ='Unitrac', @index_name = 'IDX_IH_RELATE_ID', @table_name = 'INTERACTION_HISTORY',@Force=0,@WhatIf=0
    */


    /*
    ######################################################################
		Declarations
    ######################################################################
    */
	    DECLARE @SQLCMD NVARCHAR(MAX)


  BEGIN
    /*
    ######################################################################
					    Missing Variable - Failure
    ######################################################################
    */
      IF @database_name IS NULL
          OR @index_name IS NULL
          OR @table_name IS NULL
          OR @database_name = ''
          OR @index_name = ''
          OR @table_name = ''
        BEGIN
            PRINT 'Required parameters @database_name, @index_name, or @table_name are missing or all three are missing. Please provide this information before continuing.';

            RETURN; -- Gracefully exit the procedure
        END
      ELSE
        BEGIN

    /*
    ######################################################################
		Construct dynamic SQL for pausing the index and error handling
    ######################################################################
    */
SELECT @sqlcmd = 'USE [' + @database_name + ']; ' 
              + 'BEGIN TRY ' 
              + '    ALTER INDEX [' + @index_name + '] ON [dbo].[' + @table_name + '] PAUSE; ' 
             + '    PRINT ''Index paused successfully!''; ' 
              + 'END TRY ' 
              + 'BEGIN CATCH ' 
              + '    DECLARE @ErrorMessage NVARCHAR(4000); '
              + '    DECLARE @ErrorSeverity INT; '
              + '    DECLARE @ErrorState INT; ' 
              + '    SELECT @ErrorMessage = ERROR_MESSAGE(), '
              + '           @ErrorSeverity = ERROR_SEVERITY(), '
              + '           @ErrorState = ERROR_STATE(); ' 
              + '    PRINT ''Error Occurred:''; '
              + '    PRINT @ErrorMessage; '
              + '    PRINT ''Severity: '' + CAST(@ErrorSeverity AS NVARCHAR); '
              + '    PRINT ''State: '' + CAST(@ErrorState AS NVARCHAR); '
              + 'END CATCH;';


        END

      IF @Force = 0
        BEGIN
    /*
    ######################################################################
		Construct dynamic SQL for aborting the index and error handling
    ######################################################################
    */
SELECT @sqlcmd = 'USE [' + @database_name + ']; ' 
              + 'BEGIN TRY ' 
              + '    ALTER INDEX [' + @index_name + '] ON [dbo].[' + @table_name + '] ABORT; ' 
             + '    PRINT ''Index aborted successfully!''; ' 
              + 'END TRY ' 
              + 'BEGIN CATCH ' 
              + '    DECLARE @ErrorMessage NVARCHAR(4000); '
              + '    DECLARE @ErrorSeverity INT; '
              + '    DECLARE @ErrorState INT; ' 
              + '    SELECT @ErrorMessage = ERROR_MESSAGE(), '
              + '           @ErrorSeverity = ERROR_SEVERITY(), '
              + '           @ErrorState = ERROR_STATE(); ' 
              + '    PRINT ''Error Occurred:''; '
              + '    PRINT @ErrorMessage; '
              + '    PRINT ''Severity: '' + CAST(@ErrorSeverity AS NVARCHAR); '
              + '    PRINT ''State: '' + CAST(@ErrorState AS NVARCHAR); '
              + 'END CATCH;';

        END

      IF( @WhatIF = 0 )
        BEGIN
            EXEC ( @sqlcmd)
        END
      ELSE
        BEGIN
            PRINT ( @sqlcmd )
        END
  END; 
