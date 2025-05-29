use UniTrac

IF EXISTS (select * from sys.tables where name = 'tgt_LETD_Error')
BEGIN
ALTER TABLE tgt_LETD_Error DROP COLUMN ID
ALTER TABLE tgt_LETD_Error ADD ID INT IDENTITY(1,1)
	PRINT 'SUCCESS: tgt_LETD_Error table updated!' 
END
ELSE
BEGIN 
	PRINT 'WARNING: Problem with tgt_LETD_Error table' 
END

IF EXISTS (select * from sys.tables where name = 'tgt_CETD_Error')
BEGIN
ALTER TABLE tgt_CETD_Error DROP COLUMN ID
ALTER TABLE tgt_CETD_Error ADD ID INT IDENTITY(1,1)
	PRINT 'SUCCESS: tgt_CETD_Error table updated!' 
END
ELSE
BEGIN 
	PRINT 'WARNING: Problem with tgt_CETD_Error table' 
END


IF EXISTS (select * from sys.tables where name = 'tgt_OETD_Error')
BEGIN
ALTER TABLE tgt_OETD_Error DROP COLUMN ID
ALTER TABLE tgt_OETD_Error ADD ID INT IDENTITY(1,1)
	PRINT 'SUCCESS: tgt_OETD_Error table updated!' 
END
ELSE
BEGIN 
	PRINT 'WARNING: Problem with tgt_OETD_Error table' 
END


