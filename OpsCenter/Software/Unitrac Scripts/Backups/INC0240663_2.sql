USE UniTrac
GO

declare @wi as varchar(MAX)
declare @ri as int
DECLARE @TID AS int
DECLARE @TranType AS varchar(max)

set @wi = 33127694

SET @TranType ='UNITRAC'


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


SELECT LoanNumber_TX, Misc1_TX [Repo Date] FROM LOAN_EXTRACT_TRANSACTION_DETAIL LETD (NOLOCK) WHERE LETD.TRANSACTION_ID = @TID AND Misc1_TX IS NOT NULL