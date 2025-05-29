
SELECT * FROM PerfStats.DBO.QueryPlanHistory
WHERE ProcedureName ='GetEscrowBatchDetails'


SELECT * FROM PerfStats.DBO.QueryPlanHistory
where CurrentTime >= '2024-08-18'and ExecutionTime   <= '2024-08-18'
order by QueryID 


EXEC PerfStats.dbo.CaptureDBQueryPlans @WhatIF= 0,@ElapsedTimeThreshold = 0

EXEC PerfStats.dbo.CaptureDBQueryPlans @Database ='vut',@ElapsedTimeThreshold = 0
 
EXEC PerfStats.dbo.CaptureDBQueryPlans @StoredProcName = 'GetEscrowBatchDetails',@ElapsedTimeThreshold = 0




EXEC PerfStats.dbo.CompareQueryPlans @ElapsedTimeThreshold = 20000


select * from DBA.deploy.ExecHistory
order by TimeStampUTC desc 


SELECT * FROM PerfStats.DBO.QueryPlanHistory
WHERE ProcedureName = 'GetLoanExtractTransactionDetails'
ORDER BY CreationTime DESC

SELECT * FROM PerfStats.DBO.QueryPlanHistory
where CreationTime >= '2024-09-16'--and ExecutionTime   <= '2024-08-18'
order by QueryID 


EXEC PerfStats.dbo.CaptureDBQueryPlans @WhatIF= 0,@ElapsedTimeThreshold = 0

EXEC PerfStats.dbo.CaptureDBQueryPlans 
 
EXEC PerfStats.dbo.CaptureDBQueryPlans @StoredProcName = 'GetLoanExtractTransactionDetails',@admin = 0




SELECT CAST(CREATE_DT AS DATE),  count(*)
FROM Unitrac.dbo.PROCESS_LOG_ITEM
WHERE RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'
  AND STATUS_CD = 'ERR'
  AND INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar(500)') LIKE '%HTTP status 503: Server Error.%'
  AND CREATE_DT >= '2024-08-29'
  GROUP BY CAST(CREATE_DT AS date)
  ORDER BY CAST(CREATE_DT AS date)
  ;



