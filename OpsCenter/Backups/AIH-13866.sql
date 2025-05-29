DECLARE @srvr   NVARCHAR(128),
        @retval INT;

SET @srvr ='BUTTERS'

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

DECLARE @srvr   NVARCHAR(128),
        @retval INT;

SET @srvr ='DS-SQLDEV-02'

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

DECLARE @srvr   NVARCHAR(128),
        @retval INT;

SET @srvr ='MRHAT'

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

DECLARE @srvr   NVARCHAR(128),
        @retval INT;

SET @srvr ='UTSTAGE01'

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
