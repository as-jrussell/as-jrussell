SELECT * FROM dbo.WORK_ITEM
WHERE ID IN (35547506 , 35547520)




SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (39725569, 39725570)
AND RELATE_TYPE_CD = 'Allied.UniTrac.Loan'


SELECT  LE.Collaterals_XML.value( '(/Collaterals/Collateral/StatusCode)[1]', 'varchar(500)' ), L.STATUS_CD,
 * FROM dbo.COLLATERAL_EXTRACT_TRANSACTION_DETAIL LE
JOIN dbo.LOAN L ON L.NUMBER_TX =  LE.LoanNumber_TX AND L.LENDER_ID = '253'
WHERE L.Id IN (SELECT * FROM #tmp)


--DROP TABLE #tmp

SELECT  RecordTypeCode_TX, --LE.Collaterals_XML.value( '(/Collaterals/Collateral/StatusCode)[1]', 'varchar(500)' ), 
 * FROM dbo.LOAN_EXTRACT_TRANSACTION_DETAIL LE
 WHERE ID IN (1097519102)


 SELECT * FROM dbo.[TRANSACTION]
 WHERE ID = '164395501'

USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.*
--INTO UniTracHDStorage..INC0274491
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE L.LENDER_ID = '253'
AND L.STATUS_CD = 'B'

L.ID IN (SELECT * FROM #tmp) 


SELECT * FROM dbo.LENDER
WHERE ID = '253'


UPDATE dbo.LOAN
SET STATUS_CD = 'A', UPDATE_DT = GETDATE(), LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'INC0274491'
--SELECT * FROM dbo.LOAN
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0274491)



INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0274491' , 'N' , 
 GETDATE() ,  1 , 
'Make Loan Active', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0274491)




SELECT * FROM UniTracHDStorage..INC0274491



UPDATE L
SET L.STATUS_CD= I.STATUS_CD
FROM dbo.LOAN L 
JOIN UniTracHDStorage..INC0274491 I ON I.ID = L.ID




USE UniTrac

DECLARE @wi AS VARCHAR(MAX)
DECLARE @ri AS INT
DECLARE @TID AS INT
DECLARE @TranType AS VARCHAR(MAX)

SET @wi = 35547506

SET @TranType ='UNITRAC'
--SET @TranType ='INFA'

SELECT
      @ri = RELATE_ID 
FROM
      dbo.WORK_ITEM WI
WHERE
      WI.id = @wi
 
SELECT
   @TID =   T.ID
FROM
      dbo.[TRANSACTION] T
      JOIN
      dbo.DOCUMENT D
            ON T.document_id = D.id
WHERE
      D.message_id = @ri  AND (RELATE_TYPE_CD = @TranType OR T.RELATE_TYPE_CD ='')

 
--SELECT count(*) FROM LOAN_EXTRACT_TRANSACTION_DETAIL LETD (NOLOCK) WHERE LETD.TRANSACTION_ID = @TID 


SELECT RC.DESCRIPTION_TX [System Loan Status], LETD.Collaterals_XML.value( '(/Collaterals/Collateral/StatusCode)[1]', 'varchar(500)' ) [Loan Status from LETD], 
L.* 
INTO jcs..WI35547506
FROM LOAN_EXTRACT_TRANSACTION_DETAIL LETD 
JOIN dbo.LOAN L ON L.NUMBER_TX = LETD.LoanNumber_TX AND L.LENDER_ID = '253'
JOIN dbo.REF_CODE RC ON RC.CODE_CD = L.STATUS_CD AND rc.DOMAIN_CD = 'LoanStatus'
WHERE LETD.TRANSACTION_ID = @TID 
AND RC.DESCRIPTION_TX <> LETD.Collaterals_XML.value( '(/Collaterals/Collateral/StatusCode)[1]', 'varchar(500)' )


CREATE TABLE #tmpWICleanup (ID NVARCHAR(255), NewLoanStatus NVARCHAR(1),OldLoanStatus NVARCHAR(1))
INSERT INTO #tmpWICleanup
        ( ID, NewLoanStatus, OldLoanStatus )
  (SELECT ID, code_cd, status_cd FROM #tmpWI35547506)


SELECT RC.CODE_CD, W.* --INTO #tmpWI35547506
FROM UniTracHDStorage..WI35547506 W

LEFT JOIN dbo.REF_CODE RC ON RC.DESCRIPTION_TX = W.[Loan Status from LETD] AND RC.DOMAIN_CD = 'LoanStatus'



UPDATE L
SET L.STATUS_CD = T.NewLoanStatus, L.UPDATE_DT = GETDATE(), L.UPDATE_USER_TX = 'INC0274491', L.LOCK_ID = L.LOCK_ID+1
--SELECT L.STATUS_CD , T.NewLoanStatus, *
FROM dbo.LOAN L
JOIN  #tmpWICleanup T ON T.ID = L.ID
WHERE L.STATUS_CD <> T.NewLoanStatus



INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0274491' , 'N' , 
 GETDATE() ,  1 , 
'Updated Status from LETD', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM #tmpWICleanup)



SELECT L.* INTO UniTracHDStorage..zzzzzzzzzzzINC0274491
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM #tmpWICleanup)

SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'LoanStatus'