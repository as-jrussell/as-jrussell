SELECT 	 
			L.NUMBER_TX AS LOAN_NUMBER,
			 dc.DISPLAY_DESC_TX ,
			 N.REFERENCE_ID_TX, 
  		  dc.DISPLAY_DT ,
			DC.PRINT_STATUS_ASSIGNED_DT,
			DC.PRINT_STATUS_CD, 
			DC.REJECT_REASON_TX, 
			DC.PRINTED_DT , 
			DC.RECIPIENT_TYPE_CD,
			        dc.RELATE_CLASS_NAME_TX , concat(SERVER_SHARE_TX,'\',RELATIVE_PATH_TX) as  [Document Location] 
				
			   
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
			inner join NOTICE N on N.id = pli.relate_id 
			inner join LOAN L on L.ID = n.LOAN_ID
			left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice'
			JOIN dbo.DOCUMENT_MANAGEMENT DM ON DM.ID = dc.DOCUMENT_MANAGEMENT_ID
		where
			pl.ID =45857462
			AND pli.PURGE_DT IS NULL
			AND N.PURGE_DT IS NULL 
			AND DC.PURGE_DT IS NULL