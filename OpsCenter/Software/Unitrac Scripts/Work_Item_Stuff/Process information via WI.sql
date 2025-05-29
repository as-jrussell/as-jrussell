USE UniTrac
GO

declare @wi as varchar(MAX)
DECLARE @pl AS VARCHAR(max)
DECLARE @TranType AS varchar(max)

set @wi = XXXXXXX 

SET @TranType ='UNITRAC'


SELECT
      @pl = RELATE_ID 
FROM
      dbo.WORK_ITEM WI
WHERE
      WI.id = @wi
 

SELECT
*
FROM
      dbo.PROCESS_LOG_ITEM
	  WHERE PROCESS_LOG_ID = @pl

	  