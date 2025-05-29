USE UniTrac
/* Bug#32600 : 2013 Service First FCU - Tier Tracking Changes
Lender has gone through a Data Processor conversion and is a tier tracking lender. I need the collateral codes that have changes updated. Work Item #21117211. Thanks.
*/


----------------------------------------------------------------------------------
---------- Collateral codes for a lender
----------------------------------------------------------------------------------
--SELECT c.COLLATERAL_CODE_ID, Cc.DESCRIPTION_TX, cc.CODE_TX, COUNT(*), MIN(L.RECORD_TYPE_CD), MAX(L.RECORD_TYPE_CD) FROM lender ldr 
--JOIN LOAN L ON L.LENDER_ID = ldr.ID AND ldr.CODE_TX = '4318' AND L.RECORD_TYPE_CD IN ('d','a') AND L.PURGE_DT IS NULL AND L.DIVISION_CODE_TX = '3' -- Vehicle
--JOIN COLLATERAL C ON C.LOAN_ID = L.id AND C.PURGE_DT IS NULL JOIN COLLATERAL_CODE CC ON cc.id = C.COLLATERAL_CODE_ID 
--GROUP BY C.COLLATERAL_CODE_ID,Cc.DESCRIPTION_TX, cc.CODE_TX


----------------------------------------------------------------------------------
---------- Loans  belong to a Collateral code
----------------------------------------------------------------------------------
--SELECT C.COLLATERAL_CODE_ID,C.* FROM lender ldr 
--JOIN LOAN L ON L.LENDER_ID = ldr.ID AND ldr.CODE_TX = '4318' AND L.RECORD_TYPE_CD IN ('d','a') AND L.PURGE_DT IS NULL AND L.DIVISION_CODE_TX = '3' -- Vehicle
--JOIN COLLATERAL C ON C.LOAN_ID = L.id AND C.PURGE_DT IS NULL AND C.COLLATERAL_CODE_ID IN( 623,12,14,1,9,4)
------ Post this script to change a deleted loan's collateral code ID from 1(DEFAULT) to 68(VEH-OT)
----UPDATE COLLATERAL SET COLLATERAL_CODE_ID = 68 WHERE ID = 


-- SELECT * FROM LENDER WHERE CODE_TX = '4318'
DECLARE @WorkItemID BIGINT =  61763459  
DECLARE @TransID BIGINT = 0

IF OBJECT_ID('tempdb..#TMP_TXN_ID') IS NOT NULL DROP TABLE #TMP_TXN_ID
	SELECT @TransID = t.ID FROM [TRANSACTION] t JOIN DOCUMENT d ON t.DOCUMENT_ID = d.ID JOIN MESSAGE m ON d.MESSAGE_ID = m.ID JOIN WORK_ITEM wi ON wi.RELATE_ID = m.ID WHERE wi.ID = @WorkItemID 

IF OBJECT_ID('tempdb..#TMP_EXTRACT') IS NOT NULL DROP TABLE #TMP_EXTRACT
SELECT 
		LETD.id,
		LETD.LoanNumber_TX					AS MatchLoanNumber
		,LETD.LM_MatchLoanId_TX				AS MatchLoanId
		,CETD.CM_MatchCollateralId_TX		AS MatchCollateralId
		,CETD.CM_MatchPropertyId_TX			AS MatchPropertyId
		,CETD.CollateralCodeID_TX			AS MatchCollateralCodeId
		,CETD.CollateralCode_TX				AS MatchCollateralCode
		,CETD.LenderCollateralCode_TX		AS MatchLenderCollateralCode
		,OETD.FirstName_TX					AS MatchCustomerFirstName
		,OETD.LastName_TX					AS MatchCustomerLastName
		INTO #TMP_EXTRACT
from LOAN_EXTRACT_TRANSACTION_DETAIL LETD
			JOIN COLLATERAL_EXTRACT_TRANSACTION_DETAIL CETD on LETD.TRANSACTION_ID = CETD.TRANSACTION_ID and LETD.SEQUENCE_ID = CETD.SEQUENCE_ID
			JOIN OWNER_EXTRACT_TRANSACTION_DETAIL OETD ON OETD.TRANSACTION_ID = LETD.TRANSACTION_ID AND LETD.SEQUENCE_ID = OETD.SEQUENCE_ID
	WHERE
		LETD.transaction_id = @TransID
		AND LETD.LM_MatchStatus_TX = 'Match'
---- (28273 row(s) affected) @ 10:19 AM 11/17/2014

IF OBJECT_ID('tempdb..#TMP_SYSTEM_DATA') IS NOT NULL DROP TABLE #TMP_SYSTEM_DATA
	SELECT DISTINCT
		TMP.MatchLoanNumber				AS ExtractLoanNumber
		,TMP.MatchLoanId				AS ExtractLoanId
		,TMP.MatchCollateralId			AS ExtractCollateralId
		,TMP.MatchPropertyId			AS ExtractPropertyId
		,TMP.MatchCollateralCodeId		AS ExtractCollCodeId
		,TMP.MatchCollateralCode		AS ExtractCollateralCode
		,TMP.MatchLenderCollateralCode	AS ExtractLenderCollateralCode
		,TMP.MatchCustomerFirstName		AS ExtractCustomerFirstName
		,TMP.MatchCustomerLastName		AS ExtractCustomerLatName
		,C.COLLATERAL_NUMBER_NO			AS SystemCollateralNumber
		,C.LENDER_COLLATERAL_CODE_TX	AS SystemLenderCollateralCode
		,CC.id							AS SystemCollateralCodeId
		,CC.CODE_TX						AS SystemCollateralCode
		,P.VIN_TX						AS SystemVIN
		,P.YEAR_TX						AS SystemYear
		,P.MAKE_TX						AS SystemMake
		,P.MODEL_TX						AS SystemModel
		,P.BODY_TX						AS SystemBody
		,RC.id							AS RCId
		,RC.NOTICE_DT					AS NoticeDate
		,RC.NOTICE_SEQ_NO				AS NoticeSequence
		,RC.NOTICE_TYPE_CD				AS NoticeType
		,RC.SUMMARY_STATUS_CD			AS SummaryStatus
		,RC.SUMMARY_SUB_STATUS_CD		AS SummarySubStatus
		,RC.STATUS_CD					AS CoverageStatus
		,L.EFFECTIVE_DT
		INTO #TMP_SYSTEM_DATA
	FROM
		LOAN L (NOLOCK) JOIN COLLATERAL C (NOLOCK) ON L.id = C.LOAN_ID
		JOIN property P (NOLOCK) ON C.PROPERTY_ID = P.id
		JOIN REQUIRED_COVERAGE RC (NOLOCK) ON P.id = RC.PROPERTY_ID
		JOIN COLLATERAL_CODE CC (NOLOCK) ON C.COLLATERAL_CODE_ID = CC.id
		JOIN #TMP_EXTRACT TMP ON (TMP.MatchCollateralId = C.id AND L.id = TMP.MatchLoanId AND TMP.MatchPropertyId = P.id)
	WHERE
		L.RECORD_TYPE_CD = 'G'
		AND P.RECORD_TYPE_CD = 'G'
		AND RC.RECORD_TYPE_CD = 'G'
		AND L.PURGE_DT IS NULL
		AND C.PURGE_DT IS NULL
		AND P.PURGE_DT IS NULL
-- (28243 row(s) affected) 

--SELECT count(*) FROM #TMP_SYSTEM_DATA TSD WHERE TSD.ExtractLenderCollateralCode LIKE '%-OT%' OR TSD.ExtractCollateralCode LIKE '%-A%' -- 47994
--SELECT * FROM #TMP_SYSTEM_DATA TSD WHERE TSD.ExtractLenderCollateralCode LIKE '%-OT%' OR TSD.ExtractCollateralCode LIKE '%-A%'


----SELECT * FROM #TMP_SYSTEM_DATA WHERE ExtractLoanNumber = '1008290-20'
----SELECT * FROM #TMP_SYSTEM_DATA WHERE CoverageStatus = 'B' ExtractCollateralCode LIKE '%-OT%' AND CoverageStatus = 'B'


IF OBJECT_ID('tempdb..#TMP_TEM1') IS NOT NULL DROP TABLE #TMP_TEM1
--The one's that are changing Coll Codes , after we change it from -OT to A we need to restart the Notice Cycle.
-- Query to get the report/excel data for Client to fill ChangeTo field.
	SELECT DISTINCT 
		TSD.ExtractLoanNumber			AS LoanNumber
		,TSD.ExtractLoanId				AS LoanID
		,TSD.ExtractCollateralId		AS CollateralId
		,TSD.ExtractPropertyId			AS PropertyID
		,TSD.ExtractCollCodeId			AS CollCodeId
		,TSD.RCId						AS RequiredCoverageId
		,TSD.SystemCollateralNumber		AS CollateralNumber
		,TSD.ExtractCustomerLatName		AS CustomerLastName
		,TSD.ExtractCustomerFirstName	AS CustomerFirstName
		,TSD.ExtractCollateralCode		AS ExtractCollateralCode
		,TSD.SystemLenderCollateralCode
		,TSD.SystemCollateralCode
		,''								AS ChangeTo -- Usually filled by Allied. For this bug we just need to flip -A to -OT and vice versa.
		,TSD.SystemVIN					AS VIN
		,TSD.SystemYear					AS [Year]
		,TSD.SystemMake					AS Make
		,TSD.SystemModel				AS Model
		,TSD.SystemBody					AS Body
		,TSD.ExtractLenderCollateralCode
		,TSD.NoticeDate
		,TSD.NoticeSequence
		,TSD.NoticeType
		,TSD.SummaryStatus
		,TSD.SummarySubStatus
		,TSD.CoverageStatus
--		,TSD.EFFECTIVE_DT
	INTO #TMP_TEM1
	FROM
		#TMP_SYSTEM_DATA TSD
	--WHERE 
	--TSD.ExtractCollateralCode LIke '%-A' OR TSD.ExtractCollateralCode LIke '%-OT' -- 63340
--	ExtractCollateralCode LIke '%-A%' OR ExtractLenderCollateralCode LIke '%-A%' OR ExtractCollateralCode LIKE '%-OT%' OR ExtractLenderCollateralCode LIKE '%-OT%' -- count is 63299 
ORDER BY TSD.SystemCollateralCode


IF OBJECT_ID('tempdb..#TMP_CHANGED_CODES') IS NOT NULL DROP TABLE #TMP_CHANGED_CODES
SELECT  #TMP_TEM1.* 
INTO #TMP_CHANGED_CODES
FROM #TMP_TEM1
WHERE SystemCollateralCode <> ExtractCollateralCode


-- Tier Tracking report query 
-- 1995 records
SELECT * FROM #TMP_CHANGED_CODES ORDER BY ExtractCollateralCode

----------------------------------------------------------------------------------
---------- Deleted loans In Excel format
----------------------------------------------------------------------------------
--SELECT 
--L.NUMBER_TX						AS LoanNumber
--,L.ID							AS LoanID
--,C.ID							AS CollateralId
--,P.ID							AS PropertyID
--,C.COLLATERAL_CODE_ID			AS CollCodeId
--,RC.ID							AS RequiredCoverageId
--,C.COLLATERAL_NUMBER_NO			AS CollateralNumber
--,''								AS CustomerLastName
--,''								AS CustomerFirstName
--,''								AS ExtractCollateralCode
--,C.LENDER_COLLATERAL_CODE_TX	AS SystemLenderCollateralCode
--,CC.CODE_TX						AS SystemCollateralCode
--,''								AS ChangeTo
--,P.VIN_TX						AS VIN
--,P.YEAR_TX						AS [Year]
--,P.MAKE_TX						AS Make
--,P.MODEL_TX						AS Model
--,P.BODY_TX						AS Body
--,''								AS ExtractLenderCollateralCode
--,RC.NOTICE_DT					AS NoticeDate
--,RC.NOTICE_SEQ_NO				AS NoticeSequence
--,RC.NOTICE_TYPE_CD				AS NoticeType
--,RC.SUMMARY_STATUS_CD			AS SummaryStatus
--,RC.SUMMARY_SUB_STATUS_CD		AS SummarySubStatus
--,RC.STATUS_CD					AS CoverageStatus
--FROM lender ldr 
--JOIN LOAN L ON L.LENDER_ID = ldr.ID AND ldr.CODE_TX = '2013' AND L.RECORD_TYPE_CD IN ('d','a') AND L.PURGE_DT IS NULL AND L.DIVISION_CODE_TX = '3' -- Vehicle
--JOIN COLLATERAL C ON C.LOAN_ID = L.id AND C.PURGE_DT IS NULL AND C.COLLATERAL_CODE_ID IN (1)
--JOIN property P ON C.PROPERTY_ID = P.id AND P.PURGE_DT IS NULL
--JOIN REQUIRED_COVERAGE RC ON P.id = RC.PROPERTY_ID AND RC.PURGE_DT IS NULL
--JOIN COLLATERAL_CODE CC ON C.COLLATERAL_CODE_ID = CC.id
---- There may be multiple owners so you may get duplicates
----JOIN OWNER_LOAN_RELATE OL_REL ON L.ID = OL_REL.LOAN_ID 
----JOIN [OWNER] O ON OL_REL.OWNER_ID = O.ID 
--ORDER BY CC.CODE_TX,L.NUMBER_TX


