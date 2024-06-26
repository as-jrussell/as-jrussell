USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.*
into UnitracHDStorage..Lender1534_20181104 FROM LOAN L
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('1534') AND L.NUMBER_TX IN ('31947111-89-9',
'31946888-81-0',
'31946981-81-3',
'31947014-81-2',
'31946870-81-8',
'31946872-89-7',
'31947501-81-8',
'31947636-81-2',
'31947254-81-4',
'31947751-81-9',
'31947695-81-8',
'31946923-81-5',
'31947654-81-5',
'31947654-81-5',
'31947019-89-4',
'31947763-81-4',
'31947557-81-0',
'31947681-83-4',
'31947309-81-6',
'31946999-89-8',
'31947509-81-1',
'31946800-81-5',
'31947366-81-6',
'31947339-81-3',
'31947426-81-8',
'31947473-81-0',
'31947464-81-9',
'31947242-89-2',
'31946759-81-3',
'31946959-81-9',
'31946960-81-7',
'31946906-81-0',
'31947336-81-9',
'31947761-81-8',
'31947044-81-9',
'31947174-89-7',
'31947743-81-6',
'31946990-89-7',
'31947214-81-8',
'31947170-81-2',
'31947027-81-4',
'31947688-81-3',
'31947676-81-8',
'31947403-81-7',
'31946875-81-7',
'31947030-87-5',
'31946823-81-7',
'31946823-81-7',
'31947639-81-6',
'31946838-81-5',
'31946730-81-4',
'31947204-81-9',
'31947641-89-5',
'31947410-81-2',
'31947193-81-4',
'31947265-81-0',
'31947046-81-4',
'31947650-83-9',
'31947157-81-9',
'31946932-81-6',
'31947736-81-0',
'31946757-81-7',
'31947399-89-0',
'31946771-81-8',
'31947549-89-0',
'31947513-81-3',
'31947703-81-0',
'31947611-81-5',
'31946865-81-8',
'31947728-81-7',
'31946917-81-7',
'31946997-81-9',
'31947348-89-7',
'31947758-81-4',
'31947757-81-6',
'31947732-81-9',
'31946857-81-5',
'31947359-81-1',
'31946985-81-4',
'31947498-80-9',
'31946799-81-9',
'31947601-85-7',
'31947098-81-5',
'31947686-81-7',
'31947516-81-6',
'31947562-81-0',
'31947563-81-8',
'31947361-81-7',
'31947427-81-6',
'31947581-81-0')




SELECT * 
INTO #TMPLOAN
FROM  UnitracHDStorage..Lender1534_20181104
----- 43123


---- DROP TABLE #TMPLOAN_01
SELECT * 
INTO #TMPLOAN_01
FROM #TMPLOAN

-- 230


----- DROP TABLE #TMPRC
SELECT T1.ID AS LOAN_ID ,  T1.NUMBER_TX , T1.BRANCH_CODE_TX , T1.DIVISION_CODE_TX , T1.RECORD_TYPE_CD , 
T1.STATUS_CD AS LN_STATUS_CD , T1.EXTRACT_UNMATCH_COUNT_NO AS LN_EXTRACT_UNMATCH_COUNT_NO , 
COLL.ID AS COLL_ID , COLL.COLLATERAL_CODE_ID , COLL.PROPERTY_ID , COLL.PRIMARY_LOAN_IN , 
COLL.STATUS_CD AS COLL_STATUS_CD , COLL.EXTRACT_UNMATCH_COUNT_NO AS COLL_EXTRACT_UNMATCH_COUNT_NO ,
PR.RECORD_TYPE_CD AS PR_RECORD_TYPE_CD , PR.ADDRESS_ID , 
OA.LINE_1_TX , OA.CITY_TX , OA.STATE_PROV_TX , OA.POSTAL_CODE_TX , 
RC.ID AS RC_ID , RC.TYPE_CD AS RC_TYPE_CD , RC.NOTICE_DT , RC.NOTICE_SEQ_NO , 
RC.NOTICE_TYPE_CD , RC.CPI_QUOTE_ID , RC.LAST_EVENT_DT , 
RC.LAST_EVENT_SEQ_ID , RC.LAST_SEQ_CONTAINER_ID , RC.RECORD_TYPE_CD AS RC_RECORD_TYPE_CD , 
CC.CODE_TX AS CC_CODE_TX , CC.DESCRIPTION_TX AS CC_DESCRIPTION_TX ,
0 AS EXCLUDE
INTO #TMPRC
FROM #TMPLOAN_01 t1
JOIN COLLATERAL COLL ON COLL.LOAN_ID = T1.ID
AND COLL.PURGE_DT IS NULL AND T1.PURGE_DT IS NULL
JOIN PROPERTY PR ON PR.ID = COLL.PROPERTY_ID
AND PR.PURGE_DT IS NULL
LEFT JOIN OWNER_ADDRESS OA ON OA.ID = PR.ADDRESS_ID
JOIN REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = PR.ID
AND RC.PURGE_DT IS NULL
JOIN COLLATERAL_CODE CC ON CC.ID = COLL.COLLATERAL_CODE_ID
ORDER BY T1.NUMBER_TX
----459


SELECT T1.LOAN_ID
into #TMPRC_2
FROM #TMPRC T1
JOIN COLLATERAL COLL ON COLL.PROPERTY_ID = T1.PROPERTY_ID
AND COLL.ID <> T1.COLL_ID
AND COLL.LOAN_ID <> T1.LOAN_ID
AND  COLL.PURGE_DT IS NULL
JOIN LOAN ON LOAN.ID = COLL.LOAN_ID
AND LOAN.PURGE_DT IS NULL


UPDATE T1  SET EXCLUDE = 1
from #TMPRC T1
join #TMPRC_2 T2 on T1.LOAN_ID = T2.LOAN_ID

----24

---- DROP TABLE #TMPRC_01
SELECT * 
INTO #TMPRC_01
FROM #TMPRC
WHERE EXCLUDE = 0
ORDER BY NUMBER_TX
----- 435

--- DROP TABLE #TMPRC_02
SELECT * 
INTO #TMPRC_02
FROM #TMPRC
WHERE EXCLUDE = 1
ORDER BY NUMBER_TX
----- 24



SELECT NUMBER_TX , LOAN_ID , WI.*
INTO #TMPWI
	FROM WORK_ITEM WI JOIN #TMPRC_01 T1 ON T1.LOAN_ID = WI.RELATE_ID
where WI.status_cd not in ('Complete', 'Error', 'Withdrawn')
and WI.purge_dt is null
and WI.relate_type_cd = 'Allied.UniTrac.Loan'
----- 2



SELECT * 
INTO UnitracHDStorage.dbo.INC0368356_LN
from #TMPLOAN
---- 43123


SELECT * 
INTO UnitracHDStorage.dbo.INC0368356_LN_01
from #TMPLOAN_01
---- 230

SELECT * 
INTO UnitracHDStorage.dbo.INC0368356_RC
FROM #TMPRC
---- 459


SELECT * 
INTO UnitracHDStorage.dbo.INC0368356_RC_01
FROM #TMPRC_01
---- 435


SELECT * 
INTO UnitracHDStorage.dbo.INC0368356_RC_02
FROM #TMPRC_02
---- 24

SELECT * 
INTO UnitracHDStorage.dbo.INC0368356_WI
FROM #TMPWI
---- 2

/* Update the Branch Code (if needed) */
UPDATE LN SET BRANCH_CODE_TX = '1771' , 
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'INC0368356', 
LOCK_ID = LN.LOCK_ID % 255 + 1
---- SELECT BRANCH_CODE_TX, *
FROM LOAN LN JOIN #TMPRC_02 T1 ON T1.LOAN_ID = LN.ID
---- 0


UPDATE LN SET BRANCH_CODE_TX = '1771' , 
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'INC0368356', 
LOCK_ID = LN.LOCK_ID % 255 + 1
---- SELECT LN.BRANCH_CODE_TX, *
FROM LOAN LN JOIN #TMPRC_01 T1 ON T1.LOAN_ID = LN.ID
---- 6

/* Update the Division Code (if needed) */
UPDATE LN SET DIVISION_CODE_TX = '4' , 
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'INC0368356', 
LOCK_ID = LN.LOCK_ID % 255 + 1
---- SELECT *
FROM LOAN LN JOIN #TMPRC_01 T1 ON T1.LOAN_ID = LN.ID
WHERE LN.DIVISION_CODE_TX = '10'
---- 6

/* Update the Lender Number  in Loan (if needed) */
UPDATE LN SET LENDER_ID = 968 , 
RECORD_TYPE_CD = CASE WHEN LN.RECORD_TYPE_CD IN ( 'D' , 'A') THEN 'G' ELSE LN.RECORD_TYPE_CD END ,
STATUS_CD = 'A',
EXTRACT_UNMATCH_COUNT_NO = 0  , 
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'INC0368356', 
LOCK_ID = LN.LOCK_ID % 255 + 1
---- SELECT DISTINCT LN.ID , LN.LENDER_ID , LN.STATUS_CD , LN.EXTRACT_UNMATCH_COUNT_NO , LN.DIVISION_CODE_TX
FROM LOAN LN JOIN #TMPRC_02 T1 ON T1.LOAN_ID = LN.ID
---- 218

/* Update the Collateral Code (if needed) please ensure there is an update for every Collateral needed  */
UPDATE COLL SET COLLATERAL_CODE_ID = 427 ,
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'INC0368356' , 
LOCK_ID = COLL.LOCK_ID % 255 + 1
---- SELECT DISTINCT COLL.ID , COLL.COLLATERAL_CODE_ID, T1.*
FROM COLLATERAL COLL JOIN #TMPRC_01 T1 ON T1.COLL_ID = COLL.ID
AND COLL.PURGE_DT IS NULL
---- 79





/* Update the Lender Number  in Property Table (if needed) */
UPDATE PR SET LENDER_ID = 968 , 
RECORD_TYPE_CD = CASE WHEN PR.RECORD_TYPE_CD IN ( 'D' , 'A') THEN 'G' ELSE PR.RECORD_TYPE_CD END ,
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'INC0368356', 
LOCK_ID = PR.LOCK_ID % 255 + 1
---- SELECT DISTINCT PR.ID , PR.RECORD_TYPE_CD
FROM PROPERTY PR JOIN #TMPRC_02 T1 ON T1.PROPERTY_ID = PR.ID

----- 182

/* Add inserts to the history */
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
	'Allied.UniTrac.Loan',
	LOAN_ID,
	'INC0368356',
	'N',
	GETDATE(),
	1,
	'Moved Loan from Lender 1534 to 1771',
	'N',
	'Y',
	1,
	'Allied.UniTrac.Loan',
	LOAN_ID,
	'PEND',
	'N'
FROM #TMPRC_02
---- 218

/* Update the Lender Number  in Search Fulltext (if needed) */
update SEARCH_FULLTEXT
	set LENDER_ID = 968,
		UPDATE_DT = GETDATE()
		----- SELECT DISTINCT SF.PROPERTY_ID
	FROM #TMPRC_02 t
	JOIN SEARCH_FULLTEXT sf ON sf.PROPERTY_ID = t.PROPERTY_ID
	----- 182

/* Update the work items lender code (if needed) */	
update WI
set CONTENT_XML.modify('replace value of (/Content/Lender/Code/text())[1] with ("1771")'),
	UPDATE_DT = GETDATE(),
	UPDATE_USER_TX = 'INC0368356',
	LOCK_ID = (WI.LOCK_ID + 1) % 256
	----- SELECT *
	FROM WORK_ITEM WI JOIN #TMPRC_02 T1 ON T1.LOAN_ID = WI.RELATE_ID
where WI.status_cd not in ('Complete', 'Error', 'Withdrawn')
and WI.purge_dt is null
and WI.relate_type_cd = 'Allied.UniTrac.Loan'
----- 2

/* Update the work items lender Id (if needed) */	
update WI
set CONTENT_XML.modify('replace value of (/Content/Lender/Id/text())[1] with ("968")'),
	UPDATE_DT = GETDATE(),
	UPDATE_USER_TX = 'INC0368356',
	LOCK_ID = (WI.LOCK_ID + 1) % 256
	----- SELECT *
	FROM WORK_ITEM WI JOIN #TMPRC_02 T1 ON T1.LOAN_ID = WI.RELATE_ID
where WI.status_cd not in ('Complete', 'Error', 'Withdrawn')
and WI.purge_dt is null
and WI.relate_type_cd = 'Allied.UniTrac.Loan'
----- 2

/* Update the work items lender name (if needed) */	
update WI
set CONTENT_XML.modify('replace value of (/Content/Lender/Name/text())[1] with ("Pentagon Federal Credit Union")'),
	UPDATE_DT = GETDATE(),
	UPDATE_USER_TX = 'INC0368356',
	LOCK_ID = (WI.LOCK_ID + 1) % 256
	----- SELECT *
	FROM WORK_ITEM WI JOIN #TMPRC_02 T1 ON T1.LOAN_ID = WI.RELATE_ID
where WI.status_cd not in ('Complete', 'Error', 'Withdrawn')
and WI.purge_dt is null
and WI.relate_type_cd = 'Allied.UniTrac.Loan'
----- 2

/* Purge out any EVALUATION QUEUE (if needed) */		
update EQ
	set PURGE_DT = GETDATE(),
		UPDATE_DT = GETDATE(),
		UPDATE_USER_TX = 'INC0368356',
		LOCK_ID = (eq.LOCK_ID + 1) % 256
		---- SELECT EQ.*
	from #TMPRC_01 t    
    inner join EVALUATION_QUEUE eq on T.RC_ID = eq.REQUIRED_COVERAGE_ID and eq.PURGE_DT is null
	----- 0

/* Purge out any EVALUATION EVENTS (if needed) */		
update ee
	set STATUS_CD = 'CLR',
		PURGE_DT = GETDATE() ,
		UPDATE_DT = GETDATE() ,
		UPDATE_USER_TX = 'INC0368356',
		LOCK_ID = (ee.LOCK_ID + 1) % 256
		---- SELECT *
	from #TMPRC_02 t   
    inner join EVALUATION_EVENT ee on ee.REQUIRED_COVERAGE_ID = T.RC_ID and ee.PURGE_DT is null
	where ee.STATUS_CD = 'PEND'
	----- 0

/* Update Required Coverages as needed */	
update rc
	set UPDATE_DT = GETDATE() ,
		UPDATE_USER_TX = 'INC0368356',
		LOCK_ID = (rc.LOCK_ID + 1) % 256,
		GOOD_THRU_DT = null,
		LENDER_PRODUCT_ID = null,
		LCGCT_ID = null,
		NOTICE_DT = null,
		NOTICE_TYPE_CD = NULL,
		NOTICE_SEQ_NO = null,
		CPI_QUOTE_ID = null,
		LAST_EVENT_SEQ_ID = null,
		LAST_EVENT_DT = null,
		LAST_SEQ_CONTAINER_ID = null ,
		RECORD_TYPE_CD = CASE WHEN RC.RECORD_TYPE_CD IN ( 'D' , 'A') THEN 'G' ELSE RC.RECORD_TYPE_CD END 
		---- SELECT RC.RECORD_TYPE_CD , RC.CPI_QUOTE_ID , RC.NOTICE_SEQ_NO ,  *
	from #TMPRC_02 t    
    inner join REQUIRED_COVERAGE rc on rc.ID = T.RC_ID 
    and rc.PURGE_DT is null 
    ---- 435