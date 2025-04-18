USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT  rc.* 
into #tmp
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX = '1065' AND L.NUMBER_TX IN ('64873667', '98179267','2800277796')



select * 
into unitrachdstorage..INC0410460
from #tmp

select summary_status_cd, summary_sub_status_cd, * from #tmp

select * from ref_code
where domain_cd = 'RequiredCoverageInsStatus'
CODE_CD = 'X'

UPDATE RC SET GOOD_THRU_DT = NULL , 
EXPOSURE_DT = NULL , 
SUMMARY_STATUS_CD = INSURANCE_STATUS_CD , 
SUMMARY_SUB_STATUS_CD = INSURANCE_SUB_STATUS_CD , 
UPDATE_DT = GETDATE() , 
UPDATE_USER_TX = 'INC0410460' , 
LOCK_ID = RC.LOCK_ID % 255 + 1
---- SELECT CPI_QUOTE_ID,LAST_SEQ_CONTAINER_ID,NOTICE_TYPE_CD, NOTICE_SEQ_NO,NOTICE_DT,EXPOSURE_DT,GOOD_THRU_DT,*
FROM REQUIRED_COVERAGE RC 
WHERE ID IN (select id from #tmp) and type_cd = 'HAZARD'


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
	ID,
	'INC0410460',
	'N',
	GETDATE(),
	1,
	'Changed Summary status to Borrower Expired',
	'N',
	'Y',
	1,
	'Allied.UniTrac.RequiredCoverage',
	ID,
	'PEND',
	'N'
---- select *
FROM REQUIRED_COVERAGE RC 
WHERE ID IN (select id from #tmp) and type_cd = 'HAZARD'
	 ----- 853
	 
