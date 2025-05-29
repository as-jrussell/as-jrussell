USE UniTrac


------Pull notices or certs back from HOV and put back in the queue to be reworked-----

---------Use the work item ID to get the batch ID/External_ID ------------

 /*
 
 SELECT WI.ID [WorkItemId], OC.OUTPUT_TYPE_CD, OC.TYPE_CD, OB.* FROM dbo.OUTPUT_BATCH OB
JOIN dbo.OUTPUT_CONFIGURATION OC ON OC.ID = OB.OUTPUT_CONFIGURATION_ID
join WORK_ITEM WI ON WI.RELATE_ID = OB.PROCESS_LOG_ID AND WI.RELATE_TYPE_CD = 'Osprey.ProcessMgr.ProcessLog'
  WHERE WI.ID IN (58103215 )

  
  */
  
 -----Run the master script to check the status of the Batch ID---------
  
begin
DECLARE 
	@BATCHID NVARCHAR(50),
	@PROCESSLOGID BIGINT,
	@BATCHTYPE nvarchar(20), 
	@OBID BIGINT,				
	
	@seppos1 int,
	@seppart2 nvarchar(20),
	@seppos2 int
				
	set @BATCHID = 'FPC_84409170_3193512'

				
			
	SET @seppos1 = patindex('%[_]%', @BATCHID)
	SET @BATCHTYPE = LEFT(@BATCHID, @seppos1-1)
	set @seppart2 = right(@BATCHID, len(@BATCHID)-@seppos1)
	set @seppos2 = patindex('%[_]%', @seppart2)
	set @PROCESSLOGID = LEFT(@seppart2, @seppos2-1)
	set @OBID = RIGHT(@seppart2, len(@seppart2)-@seppos2)
	print @BATCHID
	print @BATCHTYPE 
	print @PROCESSLOGID 
	print @OBID
	
	IF @BATCHTYPE = 'FPC' 
	BEGIN	
		select
			'FPC',
			pl.PROCESS_DEFINITION_ID, 
			pl.START_DT, 
			pl.END_DT, 
			pl.ID as PROCESS_LOG_ID,
			pli.ID as PROCESS_LOG_ITEM_ID, 
			DC.ID AS DC_ID,
			DC.PRINT_STATUS_CD, 
			DC.REJECT_REASON_TX,
			DC.PRINT_STATUS_ASSIGNED_DT, 
			DC.PRINT_STATUS_ASSIGNED_USER_TX, 
			DC.PRINTED_DT, 
			DC.RECIPIENT_TYPE_CD,
			DC.CREATE_DT,
			FPC.LOAN_NUMBER_TX,
			FPC.ID AS FPC_ID, 
			FPC.NUMBER_TX AS FPC_NUMBER_TX,
			FPC.PDF_GENERATE_CD,
			FPC.TEMPLATE_ID,
			FPC.BILLING_STATUS_CD,
			FPC.CAPTURED_DATA_XML,
			PLI.CREATE_DT,
			PLI.ID AS PLI_ID,
			PLI.INFO_XML, 
			PLI.RELATE_ID,
			PLI.RELATE_TYPE_CD,
			PLI.CREATE_DT,
			PLI.UPDATE_DT,
			PLI.STATUS_CD,
			pli.*, fpc.*, dc.*
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.forceplacedcertificate'
			inner join FORCE_PLACED_CERTIFICATE fpc on fpc.id = pli.relate_id 
			left outer join document_container dc on dc.relate_id = fpc.id and dc.relate_class_name_tx = 'allied.unitrac.forceplacedcertificate'
		where
			pl.ID = @PROCESSLOGID	
			and pli.PURGE_DT is null		
	       -----and dc.PRINT_STATUS_CD = 'UNRES' ---'PEND'--- 'UNRES' ----'PRINTED' --'UNRES'	
		  -----and PRINTED_BY_USER_TX = '929'
		   -----and dc.RECIPIENT_TYPE_CD = ''
			---and PRINTED_DT IS NULL
		select
			'FPC',
			count(*) as cnt,
			fpc.PDF_GENERATE_CD
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.forceplacedcertificate'
			inner join FORCE_PLACED_CERTIFICATE fpc on fpc.id = pli.relate_id 
		where
			pl.ID = @PROCESSLOGID	
			and pli.PURGE_DT is null		
			and fpc.PURGE_DT is null
		group by fpc.PDF_GENERATE_CD			
			
		select
			'FPC DC STATUS',
			count(*) as cnt,
			DC.PRINT_STATUS_CD
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.forceplacedcertificate'
			inner join FORCE_PLACED_CERTIFICATE FPC on FPC.id = pli.relate_id 
			left outer join DOCUMENT_CONTAINER DC ON DC.RELATE_ID = fpc.ID AND DC.RELATE_CLASS_NAME_TX = 'Allied.unitrac.forceplacedcertificate'
		where
			pl.ID = @PROCESSLOGID	
			and pli.PURGE_DT is null		
			AND DC.PURGE_DT IS NULL		
		group by dc.PRINT_STATUS_CD
					
			
	END	

	IF @BATCHTYPE = 'NTC' 
	BEGIN
		select
			'NTC',
			pl.PROCESS_DEFINITION_ID, 
			pl.START_DT, 
			pl.END_DT, 
			pl.ID as PROCESS_LOG_ID, 
			DC.ID AS DC_ID,
			DC.PRINT_STATUS_CD, 
			DC.REJECT_REASON_TX,
			DC.PRINT_STATUS_ASSIGNED_DT, 
			DC.PRINT_STATUS_ASSIGNED_USER_TX, 
			DC.PRINTED_DT , 
			DC.RECIPIENT_TYPE_CD,
			DC.CREATE_DT,
			DC.PURGE_DT,
			N.ID AS N_ID, 
			L.NUMBER_TX AS LOAN_NUMBER,
			N.PDF_GENERATE_CD,
			N.TEMPLATE_ID,
			N.GENERATION_SOURCE_CD,
			N.REFERENCE_ID_TX,
			N.PURGE_DT AS NOTICE_PURGE_DT,
			PLI.CREATE_DT,
			PLI.ID AS PLI_ID,
			PLI.INFO_XML, 
			PLI.RELATE_ID,
			PLI.RELATE_TYPE_CD,
			PLI.CREATE_DT,
			PLI.UPDATE_DT,
			PLI.STATUS_CD,
			pli.*, N.*, dc.*
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
			inner join NOTICE N on N.id = pli.relate_id 
			inner join LOAN L on L.ID = n.LOAN_ID
			left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice'
		where
			pl.ID = @PROCESSLOGID	
			AND pli.PURGE_DT IS NULL
			AND N.PURGE_DT IS NULL 
			AND DC.PURGE_DT IS NULL		
		-----and dc.PRINT_STATUS_CD in ('UNRES') --'PRINTED', 'PEND' 'UNRES') 
		----order by NOTICE_PURGE_DT DESC, l.NUMBER_TX 
        -----and dc.RECIPIENT_TYPE_CD in ('BORR')
		------and dc.RELATE_ID = 16744202   
		------order by NOTICE_PURGE_DT DESC , l.NUMBER_TX			

		select
			'NTC',
			count(*) as cnt,
			
			N.PDF_GENERATE_CD
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
			inner join NOTICE N on N.id = pli.relate_id 
		where
			pl.ID = @PROCESSLOGID			
			AND pli.PURGE_DT IS NULL
			AND N.PURGE_DT IS NULL		
		group by n.PDF_GENERATE_CD			

		select
			'NTC DC STATUS',
			count(*) as cnt,
			DC.PRINT_STATUS_CD
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
			inner join NOTICE N on N.id = pli.relate_id 
			left outer join DOCUMENT_CONTAINER DC ON DC.RELATE_ID = N.ID AND DC.RELATE_CLASS_NAME_TX = 'Allied.unitrac.notice'
		where
			pl.ID = @PROCESSLOGID	
			AND pli.PURGE_DT IS NULL		
			AND DC.PURGE_DT IS NULL
			AND N.PURGE_DT IS NULL		
		group by dc.PRINT_STATUS_CD
	END	

	IF @BATCHTYPE = 'RPT' 
	BEGIN
		select
			'RPT',
			pl.PROCESS_DEFINITION_ID, 
			pl.START_DT, 
			pl.END_DT, 
			pl.ID as PROCESS_LOG_ID, 
			DC.ID AS DC_ID,
			DC.PRINT_STATUS_CD, 
			DC.REJECT_REASON_TX,
			DC.PRINT_STATUS_ASSIGNED_DT, 
			DC.PRINT_STATUS_ASSIGNED_USER_TX, 
			DC.PRINTED_DT , 
			DC.CREATE_DT,
			RH.ID AS N_ID, 
			RH.GENERATION_SOURCE_CD,
			RH.OUTPUT_TYPE_CD,
			RH.MSG_LOG_TX,
			RH.REPORT_ID,
			RH.REPORT_DATA_XML,
			RH.STATUS_CD,
			PLI.CREATE_DT,
			PLI.ID AS PLI_ID,
			PLI.INFO_XML, 
			PLI.RELATE_ID,
			PLI.RELATE_TYPE_CD,
			PLI.CREATE_DT,
			PLI.UPDATE_DT,
			PLI.STATUS_CD,
			pli.*, RH.*, dc.*
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.reporthistory'
			inner join REPORT_HISTORY RH on RH.id = pli.relate_id 
			left outer join document_container dc on dc.relate_id = rh.id and dc.relate_class_name_tx = 'allied.unitrac.reporthistory'
		where
			pl.ID = @PROCESSLOGID				
	END	
	
	SELECT 'OUTPUT_BATCH', * FROM OUTPUT_BATCH WHERE ID = @OBID
	
	SELECT 'OUTPUT_CONFIGURATION', * FROM OUTPUT_BATCH OB JOIN OUTPUT_CONFIGURATION OC ON OC.ID = OB.OUTPUT_CONFIGURATION_ID WHERE OB.ID = @OBID
	
	SELECT 'OUTPUT_BATCH_LOG', * FROM OUTPUT_BATCH_LOG WHERE OUTPUT_BATCH_ID = @OBID

	SELECT 'OUTPUT_DEVICE', OD.* 
		FROM 
			OUTPUT_BATCH OB 
			JOIN OUTPUT_CONFIGURATION OC ON OC.ID = OB.OUTPUT_CONFIGURATION_ID 
			JOIN OUTPUT_DEVICE OD ON OD.ID = OC.OUTPUT_DEVICE_ID 
		WHERE OB.ID = @OBID

	SELECT 'WORK_ITEM', * FROM WORK_ITEM WHERE RELATE_ID = @PROCESSLOGID AND WORKFLOW_DEFINITION_ID = 9

	SELECT 'WORK_ITEM_ACTIONS', WIA.* FROM 
		WORK_ITEM WI 
		JOIN WORK_ITEM_ACTION WIA ON WIA.WORK_ITEM_ID = WI.ID 
	WHERE WI.RELATE_ID = @PROCESSLOGID AND WI.WORKFLOW_DEFINITION_ID = 9
end
  
  ----------------------------------------------------------------------------------------------------------------------------------------
  
  
  --Go to the FTP folders, If batch is in this folder:
  -----\\ftp-01\FTPFolders\UnitracHOV----Please removed it.
   ----\\ftp-01\FTPFolders\UnitracHOV\DONE\DONE\09272016----Please reach out to HOV ans ask them to mark for deletion---email Harish.Gowda@sourcehov.com and/or Mark.Reznik@sourcehov.com
   
