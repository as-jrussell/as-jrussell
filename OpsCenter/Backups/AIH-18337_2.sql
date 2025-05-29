DECLARE @sqlcmd VARCHAR(max)
DECLARE @ServerName sysname =  'POS-SQLSTAGING1'
DECLARE @a int
DECLARE @DryRun INT =1

IF EXISTS(SELECT 1 FROM master.dbo.sysservers WHERE srvname LIKE @ServerName)
BEGIN
EXEC @a = sys.sp_testlinkedserver @servername = @ServerName

IF @a = 0
        
            PRINT 'Dropping Server ' + @ServerName + ''

             select @SQLCMD = 'EXEC master.dbo.Sp_dropserver
                @server= '''+@ServerName+''',
                @droplogins=''droplogins'''
 
       IF @DryRun = 0
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
PRINT 'WARNING: LINKED SERVER '''+ ISNULL(@ServerName,'') + ''' DOES NOT EXIST!'
END




