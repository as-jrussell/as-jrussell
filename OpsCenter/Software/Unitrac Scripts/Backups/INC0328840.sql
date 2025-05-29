USE UniTrac

declare @wi as varchar(MAX)
declare @ri as int
DECLARE @TID AS int
DECLARE @TranType AS varchar(max)

set @wi = 42570361  

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
      D.message_id = @ri  and (RELATE_TYPE_CD = @TranType OR T.RELATE_TYPE_CD ='')



SELECT  LETD.Collaterals_XML.value( '(/Collaterals/Collateral/CollateralMatchResult/MatchPropertyId)[1]', 'varchar(500)' ) [PropertyID] ,
  * 
INTO #tmp  
  FROM LOAN_EXTRACT_TRANSACTION_DETAIL LETD (NOLOCK)
 WHERE LETD.TRANSACTION_ID = @TID 
--AND LoanNumber_TX = ''


SELECT L.* 
INTO UniTracHDStorage..workitem42570361
FROM dbo.LOAN L
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
WHERE P.ID IN (SELECT PropertyID FROM #tmp)
AND L.LENDER_ID = 2254 AND L.RECORD_TYPE_CD IN ('A', 'G')
AND L.PURGE_DT IS NULL


UPDATE L
SET L.BRANCH_CODE_TX = 'FICS PUD', L.UPDATE_DT = GETDATE(), L.LOCK_ID = L.LOCK_ID+1, L.UPDATE_USER_TX = 'INC0328840'
--SELECT L.BRANCH_CODE_TX, * 
FROM dbo.LOAN L
WHERE ID IN (SELECT ID FROM UniTracHDStorage..workitem42570361)
AND l.BRANCH_CODE_TX = 'FICS PUD' AND L.UPDATE_USER_TX = 'admin'


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0328840' , 'N' , 
 GETDATE() ,  1 , 
'Change Branch to FICS PUD', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..workitem42570361)


SELECT * FROM dbo.LENDER_ORGANIZATION
WHERE LENDER_ID = 2254