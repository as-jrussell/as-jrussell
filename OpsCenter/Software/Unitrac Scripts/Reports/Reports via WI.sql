USE UniTrac
GO

declare @wi as varchar(MAX)
DECLARE @pl AS VARCHAR(max)
DECLARE @TranType AS varchar(max)

set @wi = 33139606

SET @TranType ='UNITRAC'


SELECT
      @pl = RELATE_ID 
FROM
      dbo.WORK_ITEM WI
WHERE
      WI.id = @wi
 
SELECT
RELATE_ID
INTO #tmp
FROM
      dbo.PROCESS_LOG_ITEM
	  WHERE PROCESS_LOG_ID = @pl
	  AND RELATE_TYPE_CD LIKE 'Allied.UniTrac.ReportHistory'



SELECT * FROM dbo.REPORT_HISTORY
WHERE id IN (SELECT * FROM #tmp)