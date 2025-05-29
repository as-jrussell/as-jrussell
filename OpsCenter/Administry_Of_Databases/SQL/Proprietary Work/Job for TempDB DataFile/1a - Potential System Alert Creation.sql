
DECLARE @sql char(1024)

SET @sql = (select message_id FROM sys.messages WHERE text LIKE '%The tempdb database has a mismatch of data file(s).%')


IF NOT EXISTS(SELECT * FROM  sys.messages WHERE text LIKE '%The tempdb database has a mismatch of data file(s).%')
BEGIN
exec sp_addmessage @msgnum= 51003 ,@severity=10,
@msgtext='The tempdb database has a mismatch of data file(s).'
END
ELSE 
BEGIN
PRINT 'One already exists it is Message Id:  ' + @sql
END 


