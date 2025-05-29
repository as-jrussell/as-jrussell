exec sp_addmessage @msgnum= 55001 ,@severity=10, @with_log= 'TRUE',
@msgtext='I/O greater than 15 seconds'



SELECT * FROM SYS.messages
where message_id = '65'