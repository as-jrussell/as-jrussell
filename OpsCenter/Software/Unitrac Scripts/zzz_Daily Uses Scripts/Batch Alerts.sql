use unitrac

 

--Search by relate id
 SELECT ob.STATUS_CD, ob.EXTERNAL_ID, INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (max)') MESSAGE_LOG,  * 
 from PROCESS_LOG_ITEM pli
 join dbo.OUTPUT_BATCH ob on pli.relate_id = ob.id 
where  relate_type_cd like ('Allied.UniTrac.%Batch') and 	ob.update_dt >= '2020-02-24 '
and pli.STATUS_CD = 'Err' and OB.STATUS_CD != 'comp' AND OB.PURGE_DT IS NULL
order by PLI.UPDATE_DT DESC


SELECT * 
 FROM dbo.OUTPUT_BATCH ob
where 	ob.update_dt >= DATEADD(DAY, -1, GETDATE())
and ob.STATUS_CD = 'Err' AND ob.EXTERNAL_ID NOT LIKE 'RPT%'


--Search by relate id
 SELECT ob.STATUS_CD, ob.EXTERNAL_ID, INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (max)') MESSAGE_LOG,  * 
 from PROCESS_LOG_ITEM pli
 join dbo.OUTPUT_BATCH ob on pli.relate_id = ob.id 
where  relate_type_cd like ('Allied.UniTrac.%Batch') and 	ob.update_dt >= '2020-02-24 '
and 	ob.update_dt <= '2020-02-24 13:23 '
and ob.STATUS_CD = 'COMP'
order by PLI.UPDATE_DT DESC

 

--Search by date for notices or certs problems
 SELECT  INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (max)') MESSAGE_LOG,  * 
 from PROCESS_LOG_ITEM pli
where  CAST(pli.UPDATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE) and pli.STATUS_CD = 'ERR'
and relate_type_cd in ('Allied.UniTrac.NoticeBatch', 'Allied.UniTrac.FPCBatch','Allied.UniTrac.ReportBatch')
order by PLI.UPDATE_DT DESC




 
---Search by process id
SELECT CONVERT(TIME,END_DT- START_DT)[hh:mm:ss], PD.NAME_TX,  PL.*
FROM dbo.PROCESS_LOG PL
JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE PL.UPDATE_DT >= '2020-01-07 ' AND PD.ID IN (51)
ORDER BY PL.UPDATE_DT DESC 

select *
   FROM dbo.OUTPUT_BATCH ob
   WHERE   ID IN (SELECT ID
	FROM dbo.OUTPUT_BATCH WHERE STATUS_CD IN ('IP','ERR','ERROR' ) AND CAST(UPDATE_DT AS DATE) >= CAST(GETDATE()-4 AS DATE))


	select *
   FROM dbo.OUTPUT_BATCH ob
   WHERE   ID IN (SELECT ID
	FROM dbo.OUTPUT_BATCH WHERE STATUS_CD IN ('IGN' ) AND CAST(UPDATE_DT AS DATE) >= CAST(GETDATE()-7 AS DATE))



---Updating if necessary

--Standard  reseting
   update ob
   set STATUS_CD = 'IGN', OUTSOURCER_STATUS_CD = NULL,  purge_dt = GETDATE()
   --select *
   FROM dbo.OUTPUT_BATCH ob
   WHERE   ID IN (SELECT ID
	FROM dbo.OUTPUT_BATCH WHERE STATUS_CD IN ('IP','ERR','ERROR', 'IGN' ) AND CAST(UPDATE_DT AS DATE) >= CAST(GETDATE()-4 AS DATE))
   AND EXTERNAL_ID not LIKE 'RPT%'AND PURGE_DT IS NULL )

--Purging batch
   update ob
   set STATUS_CD = 'IGN', OUTSOURCER_STATUS_CD = NULL, purge_dt = GETDATE()
   --select *
   FROM OUTPUT_BATCH ob
   WHERE   ID IN (SELECT RELATE_id from PROCESS_LOG_ITEM pli
 join dbo.OUTPUT_BATCH ob on pli.relate_id = ob.id 
where  relate_type_cd like ('Allied.UniTrac.%Batch') and 	ob.update_dt >= '2020-02-24 '
and pli.STATUS_CD = 'Err' and OB.STATUS_CD != 'comp')



   select * from OUTPUT_BATCH_LOG
WHERE LOG_TXN_TYPE_CD IN ('ACK','Verify') and  
CREATE_DT >= DateAdd(MINUTE, -15, getdate())


--2020-02-25 12:08:53.783

--2020-02-25 12:09:46.440

