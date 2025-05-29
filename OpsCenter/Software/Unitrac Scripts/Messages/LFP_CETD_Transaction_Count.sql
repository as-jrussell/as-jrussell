USE UniTrac

declare @wi as varchar(MAX)
declare @ri as int
DECLARE @TID AS int
DECLARE @TranType AS varchar(max)

set @wi = 'add work item here'  

--SET @TranType ='UNITRAC'
SET @TranType ='INFA'

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



SELECT   *
FROM dbo.COLLATERAL_EXTRACT_TRANSACTION_DETAIL LETD (NOLOCK) 
WHERE LETD.TRANSACTION_ID = @TID 




--0

/*

select * from WORK_ITEM wi
join LENDER l on l.id = wi.LENDER_ID 
where CODE_TX = '2239' and WORKFLOW_DEFINITION_ID =1 
order by wi.UPDATE_DT desc 
*/

