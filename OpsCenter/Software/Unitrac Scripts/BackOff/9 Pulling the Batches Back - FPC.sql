 
 
  ---- Once you get confirmation the file has been marked for deletion run this query using the PLI_ID---NTC_51804350_1053514:   for certs use -----allied.unitrac.forceplacedcertificate
  
  	Update DOCUMENT_CONTAINER
			set PRINTED_DT = NULL,PRINT_STATUS_ASSIGNED_USER_TX ='NULL', PRINT_STATUS_ASSIGNED_DT = NULL, PRINT_STATUS_CD = 'UNRES', REJECT_REASON_TX = NULL
	where ID in (
		
		select
			DC.ID AS DC_ID
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.forceplacedcertificate'
			inner join NOTICE N on N.id = pli.relate_id 
			inner join LOAN L on L.ID = n.LOAN_ID
			left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.forceplacedcertificate'
		where
			pl.ID = 51804350
			AND pli.PURGE_DT IS NULL
			AND N.PURGE_DT IS NULL 
			AND DC.PURGE_DT IS NULL		
			and dc.PRINT_STATUS_CD in ('PRINTED')) --'PRINTED', 'PEND' UNRES,EXCLUDE) 
			
			----Delete USER action info with the PLI.ID for notices/certs---
			
		Update PROCESS_LOG_ITEM					
		SET INFO_XML.modify('delete /INFO_LOG/USER_ACTION')
     , LOCK_ID = LOCK_ID + 1
	where id in (
	
		select
			PLI.ID
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.forceplacedcertificate'
			inner join NOTICE N on N.id = pli.relate_id 
			inner join LOAN L on L.ID = n.LOAN_ID
			left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.forceplacedcertificate'
		where
			pl.ID = 51804350
			AND pli.PURGE_DT IS NULL
			AND N.PURGE_DT IS NULL 
			AND DC.PURGE_DT IS NULL		
			and dc.PRINT_STATUS_CD in ('UNRES')) --'PRINTED', 'PEND' UNRES) )
			
			
		----Update the STATUS_CD to PEND and clear the OUTSOURCER_STATUS_CD by using the External_ID/batch ID
  
   update
   OB
   set OUTSOURCER_STATUS_CD = 'EMPTY', OB.STATUS_CD = 'EMPTY'
   --SELECT * 
   FROM dbo.OUTPUT_BATCH OB
   JOIN dbo.OUTPUT_CONFIGURATION OC ON OC.ID = OB.OUTPUT_CONFIGURATION_ID
   where PROCESS_LOG_ID = '51804350' AND OC.TYPE_CD LIKE 'FPC' AND OC.OUTPUT_TYPE_CD = 'os'
