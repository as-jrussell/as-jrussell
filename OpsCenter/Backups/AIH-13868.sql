DECLARE @srvr   NVARCHAR(128),
        @retval INT;

SET @srvr ='IGNITE-SQL14'

BEGIN try
    EXEC @retval = sys.Sp_testlinkedserver
      @srvr;
END try
BEGIN catch
    SET @retval = Sign(@@ERROR);
END catch;

IF @retval <> 0
  PRINT 'Dropping Server ' + @srvr + ''

IF @retval <> 0
  EXEC master.dbo.Sp_dropserver
    @server= @srvr,
    @droplogins='droplogins' 
