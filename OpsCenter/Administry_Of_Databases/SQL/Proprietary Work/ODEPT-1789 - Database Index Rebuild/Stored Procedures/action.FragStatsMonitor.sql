USE [PerfStats];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[action].[FragStatsMonitor]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      /* Create Empty Stored Procedure */
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [action].[FragStatsMonitor] AS RETURN 0;';
  END;

GO

/* Alter Stored Procedure */
ALTER PROCEDURE [action].[FragStatsMonitor] (@database_name SYSNAME = NULL,
                                          @index_name    NVARCHAR(200) = NULL,
                                          @table_name    NVARCHAR(200) =NULL,
                                          @MIN           INT ='60',
                                          @WhatIF        BIT = 1)
AS

  /*
    ######################################################################
		Examples
    ######################################################################
  
    EXEC [Perfstats]. [action].[FragStatsMonitor] @database_name ='Unitrac', @table_name = 'INTERACTION_HISTORY',@WhatIf=0
  
  */

    /*
    ######################################################################
		Declarations
    ######################################################################
    */

      DECLARE @SQLCMD NVARCHAR(MAX)

    /*
    ######################################################################
					   Produce information from table 
    ######################################################################
    */
  BEGIN
      IF @database_name IS NOT NULL
        BEGIN
            SELECT @sqlcmd = 'USE [PerfStats]

IF NOT EXISTS(select 1   FROM sys.objects where name = ''TableFragStats'' AND SCHEMA_NAME(schema_id) ='''
                             + @database_name
                             + '''  )


BEGIN
 PRINT ''FAILURE: COMING SOON!!''
END

ELSE 
BEGIN
  SELECT 
  tablename, indexname,Index_type_desc, avg_fragmentation_in_percent,fragment_count, avg_fragment_size_in_pages, 
    CASE
			 WHEN Index_type_desc = ''CLUSTERED INDEX'' AND avg_fragmentation_in_percent >='
                             + Cast(@MIN AS NVARCHAR(100))
                             + ' THEN Concat(''DO WE REALLY NEED TO REBUILD A CLUSTERED INDEX ON '', tablename,'' IT CAN BE DONE '')
			 WHEN Index_type_desc = ''HEAP'' THEN Concat(''CANNOT REBUILD HEAPS that are on '', tablename, ''!!!'')
			 ELSE 
			 CASE WHEN avg_fragmentation_in_percent >= '
                             + Cast(@MIN AS NVARCHAR(100))
                             + '   THEN 
			 ''Good Luck with your REBUILD on ''+ indexname+'' that is on ''+ tablename+'''' 	 
			 ELSE Concat(''['' ,indexname,'' ] DOES NOT CURRENTLY NEED TO BE REORGANIZED!!!'')
				END	 END AS [Suggestion]

    FROM [PerfStats].[' + @database_name
                             + '].[TableFragStats]
	  where avg_fragmentation_in_percent >= '
                             + Cast(@MIN AS NVARCHAR(100))
                             + ' AND
	  tablename = ''' + @table_name
                             + '
	AND  indexname LIKE %' + @index_name + '%
	''
END



'
        END
      ELSE
    /*
    ######################################################################
					    Missing Variable 
    ######################################################################
    */
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
