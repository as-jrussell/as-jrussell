declare @sqlcmd nvarchar(1000)
declare @login nvarchar(100) = 'ELDREDGE_A\orchestrator_admin'
declare @whatif bit = 0

select @sqlcmd = '
IF EXISTS (SELECT *
           FROM   sys.server_principals
           WHERE  name = '''+@login+'''
                 )
  BEGIN

IF EXISTS (SELECT *
           FROM   sys.server_principals
           WHERE  name = '''+@login+'''
                  AND is_disabled = ''1'')
  BEGIN
      BEGIN TRY
          ALTER LOGIN [ '+@login+'  ] ENABLE

          PRINT ''SUCCESS: '+@login+'  ENABLED!!!''
      END TRY
      BEGIN CATCH
          PRINT ''FAIL: PROBLEMS WITH  '+@login+' please research!!!!''
          RETURN
      END CATCH
  END
ELSE
  BEGIN
      PRINT ''WARNING: '+@login+' is already enabled go find some other work to do!!!''
  END 
  END
ELSE
  BEGIN
      PRINT ''FAIL: ACCOUNT DOES NOT EXIST!''
  END '



IF @whatif = 0
BEGIN 
EXEC (@sqlcmd)
END 
ELSE 
BEGIN 
PRINT (@sqlcmd)
END 