USE UniTrac
GO 


--Grab all Property Ids for Lender
SELECT P.ID INTO #TMP 
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
		INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX IN ( '4846' ) 



--Grab the Property IDs with the most effective date prior to the approrpriate date below
SELECT DISTINCT SPECIAL_HANDLING_XML.value('(/SH/Desc)[1]', 'varchar (50)')[Description], 
IH.SPECIAL_HANDLING_XML.value('(/SH/OwnerPolicy/MostRecentEffectiveDate)[1]',
                                      'varchar (50)') [Most Recent Effective Date], PROPERTY_ID
INTO #tmpA
FROM #TMP T
LEFT JOIN dbo.INTERACTION_HISTORY IH ON T.ID = IH.PROPERTY_ID
WHERE IH.SPECIAL_HANDLING_XML.value('(/SH/OwnerPolicy/MostRecentEffectiveDate)[1]',
                                      'varchar (50)')  <= '2015-12-23 '


--Grab the Property IDs with the most effective date after to the approrpriate date below
SELECT DISTINCT  SPECIAL_HANDLING_XML.value('(/SH/Desc)[1]', 'varchar (50)')[Description], 
 IH.SPECIAL_HANDLING_XML.value('(/SH/OwnerPolicy/MostRecentEffectiveDate)[1]',
                                      'varchar (50)') [Most Recent Effective Date], PROPERTY_ID 
 INTO #tmpB
FROM #TMP T
LEFT JOIN dbo.INTERACTION_HISTORY IH ON T.ID = IH.PROPERTY_ID
WHERE  IH.SPECIAL_HANDLING_XML.value('(/SH/OwnerPolicy/MostRecentEffectiveDate)[1]',
                                      'varchar (50)')   >= '2015-12-23 '

---Just ensuring that all of the most effective dates were obtained that are prior to the date shown above
SELECT A.* 
INTO #tmpC
FROM #tmpA A
LEFT JOIN #tmpB B ON A.PROPERTY_ID = B.PROPERTY_ID
WHERE B.PROPERTY_ID IS NULL

--Get all loans that are active status and active loan
SELECT DISTINCT
        L.NUMBER_TX ,
        RC.ID [RC_ID] ,
        OP.ID [OP_ID] ,
        L.ID [LoanID],
		IH.ID [IH_ID],RC.INSURANCE_STATUS_CD, 
		Rc.INSURANCE_SUB_STATUS_CD
		 INTO #tmpD
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
        INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
        INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
        INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID
WHERE   LL.CODE_TX IN ( '4846' )
        AND P.ID IN ( SELECT    PROPERTY_ID
                      FROM      #tmpC )
        AND L.STATUS_CD IN ( 'A')
        AND L.TYPE_CD = 'EQ'
        AND L.RECORD_TYPE_CD = 'G'
        AND IH.SPECIAL_HANDLING_XML.value('(/SH/OwnerPolicy/MostRecentEffectiveDate)[1]',
                                          'varchar (50)') <=  '2015-12-23 '

---Get loans that are not in re-audit status currently
SELECT  *
INTO #tmpE
 FROM #tmpD
WHERE (INSURANCE_STATUS_CD IN ('F','C') OR INSURANCE_SUB_STATUS_CD IN ('D'))



----back up everything

SELECT * INTO UniTracHDStorage..INC0231685_loan_9 FROM dbo.LOAN
WHERE ID IN (SELECT LoanID FROM #tmpE)

SELECT * INTO UniTracHDStorage..INC0231685_OP_9
FROM dbo.OWNER_POLICY
WHERE ID IN (SELECT [OP_ID] FROM #tmpE)



SELECT * INTO UniTracHDStorage..INC0231685_RC_9
FROM dbo.REQUIRED_COVERAGE
WHERE ID IN (SELECT [RC_ID] FROM #tmpE)


SELECT * INTO UniTracHDStorage..INC0231685_IH_9
FROM dbo.INTERACTION_HISTORY
WHERE ID IN (SELECT [IH_ID] FROM #tmpE)



--Update Owner Policy

UPDATE OP
SET OP.SUB_STATUS_CD = 'R', OP.STATUS_CD =  'E' , OP.UPDATE_DT = GETDATE(), 
OP.UPDATE_USER_TX = 'INC0231685', OP.EXPIRATION_DT = DATEADD(MONTH, 6, OP.MOST_RECENT_EFFECTIVE_DT)
--SELECT  OP.MOST_RECENT_EFFECTIVE_DT, OP.EFFECTIVE_DT, OP.MOST_RECENT_MAIL_DT,  OP.EXPIRATION_DT, OP.* 
FROM dbo.OWNER_POLICY OP
INNER JOIN #tmpE OPP ON Opp.OP_ID = OP.ID 


--Update  Policy Coverage
UPDATE PC SET PC.END_DT = OP.EXPIRATION_DT , 
PC.CANCELLED_IN = 'N' ,
PC.UPDATE_DT = GETDATE() , 
PC.UPDATE_USER_TX = 'INC0231685' , 
PC.LOCK_ID = PC.LOCK_ID % 255 + 1
---- SELECT PC.END_DT, OP.EXPIRATION_DT, PC.*
FROM POLICY_COVERAGE PC 
JOIN #tmpE T1 ON T1.[OP_ID] = PC.OWNER_POLICY_ID
JOIN dbo.OWNER_POLICY OP ON op.ID = PC.OWNER_POLICY_ID


--Update Required Coverage
UPDATE RC SET GOOD_THRU_DT = NULL , 
INSURANCE_STATUS_CD = 'E' , 
INSURANCE_SUB_STATUS_CD = 'R' , 
SUMMARY_STATUS_CD = 'E' , 
SUMMARY_SUB_STATUS_CD = 'R' , 
NOTICE_DT = NULL , 
NOTICE_SEQ_NO = NULL , 
NOTICE_TYPE_CD = NULL , 
LAST_EVENT_DT = NULL , 
LAST_EVENT_SEQ_ID = NULL , 
LAST_SEQ_CONTAINER_ID = NULL ,
UPDATE_DT = GETDATE() , 
UPDATE_USER_TX = 'INC0231685' , 
LOCK_ID = RC.LOCK_ID % 255 + 1
--SELECT RC.SUMMARY_STATUS_CD ,RC.SUMMARY_SUB_STATUS_CD,RC.EXPOSURE_DT, RC.LAST_GOOD_INSURANCE_DT, RC.EXPOSURE_STATUS_DT, RC.*
FROM REQUIRED_COVERAGE RC JOIN  #tmpE T1 ON T1.[RC_ID] = RC.ID



---Insert a row into the property change
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
	'INC0231685',
	'N',
	GETDATE(),
	1,
	'Changed Summary status to Re-audit Expired',
	'N',
	'Y',
	1,
	'Allied.UniTrac.RequiredCoverage',
	RC_ID,
	'PEND',
	'N'
--SELECT * 
FROM
	 #tmpE 






/*
DROP TABLE #tmpE
DROP TABLE #tmpD
DROP TABLE #tmpC
DROP TABLE #tmpB
DROP TABLE #tmpA
DROP TABLE #TMP
*/