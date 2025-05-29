
declare @wi as varchar(MAX)
declare @ri as int
DECLARE @TID AS int
DECLARE @TranType AS varchar(max)

set @wi = 33636066

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

 
--SELECT count(*) FROM LOAN_EXTRACT_TRANSACTION_DETAIL LETD (NOLOCK) WHERE LETD.TRANSACTION_ID = @TID 


SELECT Collaterals_XML.value('(/Collaterals/Collateral/CollateralMatchResult/MatchStatus)[1]', 'varchar (50)'), * FROM LOAN_EXTRACT_TRANSACTION_DETAIL LETD (NOLOCK) WHERE LETD.TRANSACTION_ID = @TID 
AND LM_MatchStatus_TX = 'Unmatch' AND ExtractUnmatchCount_NO = '1'





SELECT  LoanNumber_TX, LoanEffectiveDate_DT, LM_Balance_TX
INTO UniTracHDStorage..INC0252757
FROM    [LOAN_EXTRACT_TRANSACTION_DETAIL] L WITH ( NOLOCK )
WHERE   L.TRANSACTION_ID = '163484041'
        AND LM_ExtractUnmatchCount_NO = '1' AND PROCESSED_IN = 'Y'

