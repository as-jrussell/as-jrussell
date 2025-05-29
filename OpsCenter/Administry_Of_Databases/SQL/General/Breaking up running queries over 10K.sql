USE UniTrac







declare @rowcount int = 10000
while @rowcount >= 10000
BEGIN
 BEGIN TRY

 UPDATE TOP (10000) L
SET l.STATUS_CD = 'ERR'
--SELECT   count(STATUS_CD)  
FROM dbo.[TRANSACTION] l
WHERE l.STATUS_CD = 'HOLD' 

where  ISNULL(status_cd, '') != 'B'

--88291

 select @rowcount = @@rowcount
 END TRY
 BEGIN CATCH
  select Error_number(),
      error_message(),
      error_severity(),
    error_state(),
    error_line()
   THROW
   BREAK
 END CATCH
END
				 


