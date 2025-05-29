DECLARE @sqlcmd VARCHAR(max)
DECLARE @Comments NVARCHAR(100) = 'DCOM-AIH-3025'
DECLARE @ServerName NVARCHAR(200) = 'DB-SQLCLST-01-1'
DECLARE @WhatIf INT = 1
DECLARE @Verbose INT = 0
DECLARE @Decomm VARCHAR(3) = ''

/*
@WhatIf = 1 and @Verbose = 0 executes the select
@WhatIf = 0 and @Verbose = 0 executes the update
@WhatIf = 1 and @Verbose = 1 shows the select query
@WhatIf = 0 and @Verbose = 1 shows the update query

*/


IF @WhatIf = 0
  BEGIN
      SELECT @sqlcmd = '	
  UPDATE I
  SET  ServerEnvironment = ''_DCOM'', ServerStatus = ''DOWN'',
  Update_DT = GETDATE(), UPDATE_USER = (  SELECT SYSTEM_USER ) ,
  Comments = ''' + @Comments
                       + '''
--select *
  FROM [InventoryDWH].[inv].[Instance] I
  WHERE MachineName IN (''' + @ServerName
                       + ''')'

      IF @Verbose = 0
        BEGIN
            EXEC ( @SQLcmd)
        END
      ELSE
        BEGIN
            PRINT ( @SQLcmd )
        END
  END

ELSE IF  @Decomm = 'ALL'
  BEGIN
      SELECT @sqlcmd = '	
 SELECT *
  FROM [InventoryDWH].[inv].[Instance] I
  WHERE Comments LIKE ''%' + @Comments + '%'''

      IF @Verbose = 0
        BEGIN
            EXEC ( @SQLcmd)
        END
      ELSE
        BEGIN
            PRINT ( @SQLcmd )
        END
  END
ELSE
  BEGIN
      SELECT @sqlcmd = '
SELECT *
  FROM [InventoryDWH].[inv].[Instance] I
  WHERE MachineName IN (''' + @ServerName
                       + ''')'

      IF @Verbose = 0
        BEGIN
            EXEC ( @SQLcmd)
        END
      ELSE
        BEGIN
            PRINT ( @SQLcmd )
        END
  END 
