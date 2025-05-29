USE UniTrac

declare @wi as varchar(MAX)
declare @ri as int
DECLARE @TID AS int
DECLARE @TranType AS varchar(max)

set @wi = 45706936 

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



SELECT LoanNumber_TX into #tmp FROM LOAN_EXTRACT_TRANSACTION_DETAIL LETD (NOLOCK) WHERE LETD.TRANSACTION_ID = @TID 
--AND LoanNumber_TX = ''


select  * --into unitrachdstorage..INC0348253
from loan 
where Number_tx IN (select * from #tmp)
and lender_id = 435

select * from lender_organization
where lender_id = 435


update L
set branch_code_tx = 'ESCROW'
from Loan L
where ID IN (select ID from unitrachdstorage..INC0348253)



INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0348253' , 'N' , 
 GETDATE() ,  1 , 
'Moved to Escrow Branch', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0348253)

