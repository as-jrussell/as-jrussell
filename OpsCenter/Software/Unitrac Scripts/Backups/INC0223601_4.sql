--SELECT * FROM LENDER WHERE CODE_TX = '4750'
---- 2231

--- DROP TABLE #TMPPLCY
SELECT LOAN.NUMBER_TX , LOAN.DIVISION_CODE_TX , LOAN.BRANCH_CODE_TX , 
COLL.LOAN_ID , COLL.ID AS COLL_ID , 
---COLL.PROPERTY_ID , 
RC.TYPE_CD AS RC_TYPE_CD , RC.ID AS RC_ID , 
RC.SUMMARY_SUB_STATUS_CD , RC.SUMMARY_STATUS_CD , RC.EXPOSURE_DT , 
RC.CPI_QUOTE_ID , RC.NOTICE_DT , RC.NOTICE_SEQ_NO , RC.NOTICE_TYPE_CD , 
RC.LAST_EVENT_DT , RC.LAST_EVENT_SEQ_ID , RC.LAST_SEQ_CONTAINER_ID , 
PLCY.* , 0 AS EXCLUDE
INTO #TMPPLCY
FROM LOAN
JOIN COLLATERAL COLL ON COLL.LOAN_ID = LOAN.ID
AND COLL.PURGE_DT IS NULL AND LOAN.PURGE_DT IS NULL
AND COLL.PRIMARY_LOAN_IN = 'Y'
JOIN PROPERTY PR ON PR.ID = COLL.PROPERTY_ID
AND PR.PURGE_DT IS NULL
JOIN REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = COLL.PROPERTY_ID
AND RC.PURGE_DT IS NULL
CROSS APPLY
(
SELECT * FROM dbo.GetCurrentCoverage(PR.ID , RC.ID , RC.TYPE_CD)
)  AS PLCY
WHERE LOAN.LENDER_ID = 2047
AND Loan.ID IN (SELECT LoanID FROM UniTracHDStorage..INC0223601_3)
ORDER BY NUMBER_TX
----10



UPDATE #TMPPLCY SET EXCLUDE = 1 WHERE SUMMARY_SUB_STATUS_CD = 'D'
----0

--SELECT DISTINCT SUMMARY_STATUS_CD , SUMMARY_SUB_STATUS_CD FROM #TMPPLCY
--WHERE EXCLUDE = 0 

UPDATE #TMPPLCY SET EXCLUDE = 2 WHERE SUMMARY_SUB_STATUS_CD <> 'R'
AND EXCLUDE = 0
----- 0

UPDATE #TMPPLCY SET EXCLUDE = 3 WHERE SUMMARY_STATUS_CD <> 'F'
AND EXCLUDE = 0
----0

--UPDATE #TMPPLCY SET EXCLUDE = -1 WHERE EXCLUDE = 0 
--AND NOTICE_SEQ_NO > 0
----22

DROP TABLE #TMPPC
SELECT T1.* , PC.ID AS PC_ID , PC.START_DT , PC.END_DT , PC.TYPE_CD , PC.SUB_TYPE_CD ,
PC.UPDATE_USER_TX AS PC_UPDATE_USER_TX
INTO #TMPPC
FROM POLICY_COVERAGE PC JOIN #TMPPLCY T1 ON T1.ID = PC.OWNER_POLICY_ID
WHERE PC.PURGE_DT IS NULL
AND EXCLUDE = 0 
----- 10
DROP TABLE #TMPPLCY_01
SELECT * 
INTO #TMPPLCY_01
FROM #TMPPLCY
WHERE EXCLUDE = 0
----10


SELECT * 
INTO UnitracHDStorage.dbo.tmpTask36802_PLCY_01
FROM #TMPPLCY
---- 10

SELECT * 
INTO UnitracHDStorage.dbo.tmpTask36802_PC_01
FROM #TMPPC
---- 10

UPDATE PLCY SET 
SUB_STATUS_CD = 'F', 
UPDATE_DT = GETDATE() , 
UPDATE_USER_TX = 'INC0223601' , 
LOCK_ID = PLCY.LOCK_ID % 255 + 1
---- SELECT *
FROM OWNER_POLICY PLCY JOIN #TMPPLCY_01 T1 ON T1.ID = PLCY.ID
AND PLCY.STATUS_CD = 'E'
AND PLCY.SUB_STATUS_CD = 'D'
----- 10



----- GET THE LIST OF RC'S IN #TMPRC
---- DROP TABLE #TMPRC
SELECT  *
INTO #TMPRC
FROM #TMPPLCY_01
WHERE CPI_QUOTE_ID > 0
AND EXCLUDE = 0 
----0

---- DROP TABLE #tmpIH
SELECT IH.ID AS IH_ID
INTO #tmpIH
FROM #TMPRC tmp
		JOIN INTERACTION_HISTORY IH ON IH.RELATE_ID = tmp.CPI_QUOTE_ID
WHERE
		IH.TYPE_CD = 'CPI'
		AND IH.RELATE_CLASS_TX = 'ALLIED.UNITRAC.CPIQUOTE'
		AND tmp.RC_ID = ISNULL(IH.SPECIAL_HANDLING_XML.value('(/SH/RC)[1]', 'BIGINT'),0 )
		and tmp.PROPERTY_ID = IH.property_id     
		AND ISNULL(IH.SPECIAL_HANDLING_XML.value('(/SH/Status)[1]', 'varchar(20)'),'') = 'Open'
		AND IH.PURGE_DT IS NULL
		---- 0
	
INSERT INTO
	PROPERTY_CHANGE (
		ENTITY_NAME_TX,
		ENTITY_ID,
		USER_TX,
		ATTACHMENT_IN,
		CREATE_DT,
		AGENCY_ID,
		DESCRIPTION_TX,
		DETAILS_IN,
		FORMATTED_IN,
		LOCK_ID,
		PARENT_NAME_TX,
		PARENT_ID,
		TRANS_STATUS_CD,
		UTL_IN)
SELECT DISTINCT
	'Allied.UniTrac.RequiredCoverage',
	tf.RC_ID,
	'TASK36802',
	'N',
	GETDATE(),
	1,
	'Notice Cycle Cleared',
	'N',
	'Y',
	1,
	'Allied.UniTrac.RequiredCoverage',
	TF.RC_ID,
	'PEND',
	'N'
FROM
	 #TMPPLCY_01 tf
WHERE
	NOTICE_SEQ_NO > 0
	AND EXCLUDE = 0 
	----- 0		
						
			
UPDATE QT
	SET	QT.CLOSE_REASON_CD = 'NCC',
		QT.CLOSE_DT = GETDATE(),
		QT.UPDATE_DT = GETDATE(),
		QT.UPDATE_USER_TX = 'INC0223601',
		QT.LOCK_ID = (QT.LOCK_ID % 255) + 1
	--SELECT COUNT(*)
	FROM CPI_QUOTE QT
	JOIN #TMPRC RC
		ON RC.CPI_QUOTE_ID = QT.ID
		---- 0
			
			
UPDATE IH
SET	SPECIAL_HANDLING_XML.modify('replace value of (/SH/Status/text())[1] with "Closed" '),
	UPDATE_DT = GETDATE(),
	UPDATE_USER_TX = 'TASK36802',
	LOCK_ID = (IH.LOCK_ID % 255) + 1
--SELECT COUNT(*)
FROM INTERACTION_HISTORY IH
JOIN #tmpIH
	ON #tmpIH.IH_ID = IH.ID
----- 0



UPDATE RC SET GOOD_THRU_DT = NULL , 
INSURANCE_STATUS_CD = 'F' , 
INSURANCE_SUB_STATUS_CD = 'D' , 
SUMMARY_STATUS_CD = 'F' , 
SUMMARY_SUB_STATUS_CD = 'D' , 
NOTICE_DT = NULL , 
NOTICE_SEQ_NO = NULL , 
NOTICE_TYPE_CD = NULL , 
LAST_EVENT_DT = NULL , 
LAST_EVENT_SEQ_ID = NULL , 
LAST_SEQ_CONTAINER_ID = NULL ,
CPI_QUOTE_ID = NULL , 
UPDATE_DT = GETDATE() , 
UPDATE_USER_TX = 'INC0223601' , 
LOCK_ID = RC.LOCK_ID % 255 + 1
---- SELECT *
FROM REQUIRED_COVERAGE RC JOIN #TMPPLCY_01 T1 ON T1.RC_ID = RC.ID
WHERE EXCLUDE = 0 
AND RC.SUMMARY_SUB_STATUS_CD = 'D'
AND RC.SUMMARY_STATUS_CD = 'E'
AND RC.INSURANCE_SUB_STATUS_CD = 'D'
AND RC.INSURANCE_STATUS_CD = 'E'
----- 10

INSERT INTO
	PROPERTY_CHANGE (
		ENTITY_NAME_TX,
		ENTITY_ID,
		USER_TX,
		ATTACHMENT_IN,
		CREATE_DT,
		AGENCY_ID,
		DESCRIPTION_TX,
		DETAILS_IN,
		FORMATTED_IN,
		LOCK_ID,
		PARENT_NAME_TX,
		PARENT_ID,
		TRANS_STATUS_CD,
		UTL_IN)
SELECT DISTINCT
	'Allied.UniTrac.RequiredCoverage',
	RC_ID,
	'INC0223601',
	'N',
	GETDATE(),
	1,
	'Changed Summary status to In Force',
	'N',
	'Y',
	1,
	'Allied.UniTrac.RequiredCoverage',
	RC_ID,
	'PEND',
	'N'
FROM
	 #TMPPLCY_01 WHERE EXCLUDE = 0 
	 ----- 10
	 
	 
UPDATE EVALUATION_EVENT
SET STATUS_CD = 'CLR',
	UPDATE_DT = GETDATE(),
	UPDATE_USER_TX = 'INC0223601',
	LOCK_ID = (LOCK_ID % 255) + 1
--SELECT ee.*
FROM
	EVALUATION_EVENT ee
	JOIN #TMPPLCY_01 te ON ee.REQUIRED_COVERAGE_ID = te.RC_ID
	WHERE ee.STATUS_CD = 'PEND'
	AND ee.EVENT_SEQUENCE_ID > 0
	----0


