USE UniTrac


SELECT * FROM dbo.WORK_ITEM
WHERE ID = --'37616366'
'37488880'

SELECT RELATE_ID INTO #tmpNN FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = --'42307518'
'42109554'
AND RELATE_TYPE_CD = 'Allied.UniTrac.Notice'


SELECT * FROM dbo.NOTICE
WHERE TYPE_CD = 'AN'
AND ID IN (SELECT * FROM #tmpN)

SELECT * FROM dbo.NOTICE
WHERE TYPE_CD = 'AN'
AND ID IN (SELECT * FROM #tmpNN)

--2017-02-15 11:35:08.133

SELECT DISTINCT L.CODE_TX, L.NAME_TX, LP.DESCRIPTION_TX [Lender Product], ESC.DESCRIPTION_TX [Event Sequence], 
TEMPLATE_ID, ESC.UPDATE_USER_TX, ES.UPDATE_DT

FROM dbo.LENDER_PRODUCT LP
JOIN dbo.EVENT_SEQ_CONTAINER ESC ON LP.ID = ESC.LENDER_PRODUCT_ID
JOIN dbo.EVENT_SEQUENCE ES ON ESC.ID = ES.EVENT_SEQ_CONTAINER_ID
JOIN dbo.LENDER L ON L.ID = LP.LENDER_ID
WHERE  NOTICE_TYPE_CD = 'AN'
--AND TEMPLATE_ID = '0' 
AND 
ESC.PURGE_DT IS NULL AND es.PURGE_DT IS NULL
AND lp.PURGE_DT IS NULL AND AGENCY_ID ='1' AND l.CODE_TX = '3104'

update N
set PDF_GENERATE_CD= 'PEND', lock_id = lock_id+1, update_dt = getdate(), update_user_tx = 'INC0285402', TEMPLATE_ID = '135'
--select *
 from notice N
WHERE ID IN (SELECT * FROM #tmpN) AND PDF_GENERATE_CD != 'COMP'