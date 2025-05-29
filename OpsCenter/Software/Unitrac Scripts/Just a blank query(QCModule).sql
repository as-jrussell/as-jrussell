USE QCModule



select ID INTO #tmpPD  from process_definition
WHERE   ACTIVE_IN = 'Y'
        AND STATUS_CD = 'Error'





select * from process_definition
WHERE   ACTIVE_IN = 'Y'
        AND STATUS_CD = 'Error'





select * from process_log
where create_dt >= '2021-06-03'
order by UPDATE_DT desc







select ID INTO #tmpPD  from process_definition
WHERE   ACTIVE_IN = 'Y'
        AND STATUS_CD = 'Error'




--update PD set
--STATUS_CD = 'Complete',
--LAST_RUN_DT = DATEADD(n,-1,getdate()),
--LAST_SCHEDULED_DT = DATEADD(n,1,getdate()),
--ANTICIPATED_NEXT_SCHEDULED_DT = DATEADD(n,1,getdate())
----SELECT * 
--FROM dbo.PROCESS_DEFINITION PD
--where id IN (SELECT ID FROM #tmpPD )



SELECT * 
FROM sys.objects
where type not in ('IT','U')
ORDER BY create_date DESC 
