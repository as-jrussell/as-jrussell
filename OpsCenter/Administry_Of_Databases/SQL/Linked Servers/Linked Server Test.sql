DECLARE @sqlcmd VARCHAR(max)
DECLARE @ServerName sysname
DECLARE @a int
DECLARE @DryRun INT = 0

SET @ServerName = 'IVOS-SQLQA'


  SELECT @sqlcmd = '	
  DECLARE @a int
  DECLARE @ServerName sysname = '''+@ServerName+'''

IF EXISTS(SELECT 1 FROM master.dbo.sysservers WHERE srvname LIKE @ServerName)
BEGIN
EXEC @a = sys.sp_testlinkedserver @servername = @ServerName
IF @a = 0


print ''LINKED SERVER '''''' + ISNULL('''+@ServerName+''','''') + '''''' IS CONNECTED.''
ELSE
print ''LINKED SERVER '''''' + ISNULL('''+@ServerName+''','''') + '''''' IS NOT CONNECTED!''
END
ELSE
BEGIN
PRINT ''LINKED SERVER ''''''+ ISNULL('''+@ServerName+''','''') + '''''' DOES NOT EXIST!''
END'

      IF @DryRun = 0
        BEGIN
            EXEC ( @SQLcmd)
        END
      ELSE
        BEGIN
            PRINT ( @SQLcmd )
			END