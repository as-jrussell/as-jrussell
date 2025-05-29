USE [PerfStats];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[action].[MonitorRebuild]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      /* Create Empty Stored Procedure */
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [action].[MonitorRebuild] AS RETURN 0;';
  END;

GO

/* Alter Stored Procedure */
ALTER PROCEDURE [action].[MonitorRebuild] (@database_name SYSNAME = NULL,
                                        @WhatIF        BIT = 1)
AS
  BEGIN

  
  /*
    ######################################################################
		Examples
    ######################################################################
     
        EXEC [Perfstats]. [action].[MonitorRebuild] @database_name ='Unitrac',@WhatIf=0
    
     */

    /*
    ######################################################################
		Declarations
    ######################################################################
    */

      DECLARE @SQLCMD NVARCHAR(MAX)

	      /*
    ######################################################################
		Content of stored procedure 
    ######################################################################
    */
           IF @database_name IS NOT NULL
        BEGIN
            SELECT @sqlcmd = ' USE [' + @database_name + ']

SELECT total_execution_time, percent_complete, state_desc, last_pause_time, Object_Name(object_id) Table_Name, name
FROM sys.index_resumable_operations;


'
        END
      ELSE
        BEGIN
            PRINT 'WARNING: PLEASE PROVIDE A DATABASE NAME'
        END

      IF( @WhatIF = 0 )
        BEGIN
            /* Do NOT invoke any change - display what would happen */
            EXEC ( @sqlcmd)
        END
      ELSE
        BEGIN
            /* Invoke changes */
            PRINT ( @sqlcmd )
        END
  END; 
