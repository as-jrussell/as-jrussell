use unitrac

select * from work_item
where id in (53547828 )

select * from process_log_item
where process_log_id in (71555744)
and RELATE_TYPE_CD NOT IN ('Allied.UniTrac.Notice', 'Allied.UniTrac.RequiredCoverage','Allied.UniTrac.ReportHistory')

select RELATE_ID 
into #tmpNotice
from process_log_item
where process_log_id in (71555744)
and RELATE_TYPE_CD = 'Allied.UniTrac.Notice'




select RELATE_ID 
into #tmpRH
from process_log_item
where process_log_id in (71555744)
and RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'


select * from notice
where id in (select * from #tmpNotice) and pdf_generate_cd NOT IN ('COMP' , 'NT')



select pdf_generate_cd, Count(*) from notice n
where id in (select * from #tmpNotice) 
group by pdf_generate_cd

select Name_tx, Count(*) from notice n
where id in (select * from #tmpNotice) and PDF_GENERATE_CD  = 'Comp' 
group by Name_tx

select * from ref_code
where code_cd = 'NT'

select * from REPORT_HISTORY
where id in (select * from #tmpRH)
and status_cd <> 'COMP'


select * from OUTPUT_BATCH
where id in (2459467,
2459468,
2459469)


 SELECT WI.ID [WorkItemId], OC.OUTPUT_TYPE_CD, OC.TYPE_CD, OB.* FROM dbo.OUTPUT_BATCH OB
JOIN dbo.OUTPUT_CONFIGURATION OC ON OC.ID = OB.OUTPUT_CONFIGURATION_ID
join WORK_ITEM WI ON WI.RELATE_ID = OB.PROCESS_LOG_ID AND WI.RELATE_TYPE_CD = 'Osprey.ProcessMgr.ProcessLog'
  WHERE WI.ID IN (53547828 )


  ----REPLACE XXXXXXX WITH THE THE WI ID
SELECT  *
INTO UniTracHDStorage..INC0415579
FROM    UniTrac..WORK_ITEM
WHERE   ID IN (53547828 )



  --REPLACE XXXXXXX WITH THE THE WI ID
UPDATE  UniTrac..WORK_ITEM
SET     STATUS_CD = 'Complete' ,
        LOCK_ID = LOCK_ID + 1 ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0415579'
WHERE   ID IN ( SELECT ID FROM UniTracHDStorage..INC0415579 )
        AND WORKFLOW_DEFINITION_ID = 9
        AND ACTIVE_IN = 'Y'
