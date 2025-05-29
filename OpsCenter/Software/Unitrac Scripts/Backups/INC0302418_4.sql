USE UniTrac


SELECT  N.SEQUENCE_NO,	 LOAN_ID,
			L.NUMBER_TX AS LOAN_NUMBER,
			 dc.DISPLAY_DESC_TX ,
			 N.REFERENCE_ID_TX, 
  		  dc.DISPLAY_DT ,
			DC.PRINT_STATUS_ASSIGNED_DT,
			DC.PRINT_STATUS_CD, 
			DC.REJECT_REASON_TX, 
			DC.PRINTED_DT , 
			DC.RECIPIENT_TYPE_CD,
			        dc.RELATE_CLASS_NAME_TX ,
			        --dc.PRINT_STATUS_CD ,
					 concat(SERVER_SHARE_TX,'\',RELATIVE_PATH_TX) as  [Document Location] 
			--	INTO jcs..INC0302418_NoticeToBeUpdated20170712
--SELECT LOAN_ID INTO #tmp			   
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
			inner join NOTICE N on N.id = pli.relate_id 
			inner join LOAN L on L.ID = n.LOAN_ID
			left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice'
			JOIN dbo.DOCUMENT_MANAGEMENT DM ON DM.ID = dc.DOCUMENT_MANAGEMENT_ID
		where
			pl.ID =45857462  AND REJECT_REASON_TX = 'Reject'
			AND pli.PURGE_DT IS NULL
			AND N.PURGE_DT IS NULL 
			AND DC.PURGE_DT IS NULL



SELECT  RC2.DESCRIPTION_TX, RC1.DESCRIPTION_TX,
RC.* FROM dbo.COLLATERAL C
JOIN dbo.REQUIRED_COVERAGE Rc ON RC.PROPERTY_ID = C.PROPERTY_ID
JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.INSURANCE_STATUS_CD AND RC1.DOMAIN_CD = 'RequiredCoverageInsStatus'
JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = RC.INSURANCE_SUB_STATUS_CD AND RC2.DOMAIN_CD = 'RequiredCoverageInsSubStatus'
WHERE LOAN_ID IN (SELECT * FROM #tmp) AND INSURANCE_STATUS_CD <> 'C'


SELECT * FROM dbo.REF_CODE
WHERE CODE_CD = 'D'



SELECT ID INTO #tmpN FROM dbo.NOTICE
WHERE LOAN_ID IN (SELECT * FROM #tmp)


EXEC dbo.Support_BackoffNotice @noticeId = 0 -- bigint


SELECT * FROM #tmpN



SELECT * FROM jcs..INC0302418_NoticeToBeUpdated20170712