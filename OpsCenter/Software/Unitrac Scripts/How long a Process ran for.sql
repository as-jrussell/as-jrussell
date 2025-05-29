DECLARE @SQLcmd NVARCHAR(max)
DECLARE @SQLcmd2 NVARCHAR(max)
DECLARE @SourceDatabase NVARCHAR(100) = 'Unitrac'
DECLARE @id NVARCHAR(10) = 92379
DECLARE @TimeIncrement NVARCHAR(100) ='0:00:00'
DECLARE @WhatIf BIT = 1


SELECT @SQLcmd = ( 'USE [' + @SourceDatabase
                   + '] 
					SELECT  CONVERT(TIME,END_DT- START_DT)[hh:mm:ss],  PD.NAME_TX,  PL.*
					FROM ' + @SourceDatabase + '.'+ 'dbo.PROCESS_LOG PL
					JOIN  ' + @SourceDatabase + '.'+ 'dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
					WHERE PROCESS_DEFINITION_ID =' + @id + 'AND (END_DT- START_DT) > '''+@TimeIncrement+'''
						ORDER BY ID DESC


' );

SELECT @SQLcmd2 = ( 'USE [' + @SourceDatabase
                    + '] 
					SELECT *
					FROM ' + @SourceDatabase + '.' + 'dbo.PROCESS_DEFINITION PD
					WHERE ID =' + @id + '
						ORDER BY ID DESC' );

IF @WhatIf = 0
  BEGIN
      EXEC (@SQLcmd)
	  EXEC (@SQLcmd2)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
	  PRINT ( @SQLcmd2 )
  END 
