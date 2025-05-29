USE [UniTrac]
GO 


select   L.ORIGINAL_PAYMENT_AMOUNT_NO, I.[Original Payment AMount Before Change],I.* 
from loan L
join UniTracHDStorage..INC0387912 I on  L.NUMBER_TX = I.NUMBER_TX
WHERE L.LENDER_ID IN (670)



declare @rowcount int = 10000
while @rowcount >= 10000
BEGIN
 BEGIN TRY

 UPDATE TOP (10000) L
set L.ORIGINAL_PAYMENT_AMOUNT_NO = I.[Original Payment Amount Before Change], UPDATE_DT = GETDATE(),LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END, UPDATE_USER_TX = 'INC0387912'
--select   L.ORIGINAL_PAYMENT_AMOUNT_NO, I.[Original Payment AMount Before Change],L.* 
from loan L
join UniTracHDStorage..INC0387912 I on  L.NUMBER_TX = I.NUMBER_TX
WHERE L.LENDER_ID IN (670) and L.ORIGINAL_PAYMENT_AMOUNT_NO <> I.[Original Payment AMount Before Change]

select   L.ORIGINAL_PAYMENT_AMOUNT_NO, I.[Original Payment AMount Before Change],  L.NUMBER_TX,MAX([Payment Amt Changed on date]) [Payment Amt Changed on date] into #tmp 
from loan L
join UniTracHDStorage..INC0387912 I on  L.NUMBER_TX = I.NUMBER_TX
WHERE L.LENDER_ID IN (670) and L.ORIGINAL_PAYMENT_AMOUNT_NO <> I.[Original Payment AMount Before Change]
and [Reason code for Payment amt Change] = 'LC'
group by  L.ORIGINAL_PAYMENT_AMOUNT_NO, I.[Original Payment AMount Before Change], L.NUMBER_TX


 UPDATE  L
set L.ORIGINAL_PAYMENT_AMOUNT_NO = I.[Original Payment Amount Before Change], UPDATE_DT = GETDATE(),LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END, UPDATE_USER_TX = 'INC0387912'
--select   L.ORIGINAL_PAYMENT_AMOUNT_NO, I.[Original Payment AMount Before Change],L.* 
from loan L
join #tmp I on  L.NUMBER_TX = I.NUMBER_TX
WHERE L.LENDER_ID IN (670) and L.ORIGINAL_PAYMENT_AMOUNT_NO <> I.[Original Payment AMount Before Change]

select * from #tmp
where number_tx= '68745-771'


delete D
--select * 
from 
 #tmp D
where  [Payment Amt Changed on date] = '2018-02-20 00:00:00.000'
and number_tx= '68745-771'








 select @rowcount = @@rowcount
 END TRY
 BEGIN CATCH
  select Error_number(),
      error_message(),
      error_severity(),
    error_state(),
    error_line()
   THROW
   BREAK
 END CATCH
END
			


	
INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0387912' , 'N' , 
 GETDATE() ,  1 , 
'Update Original Payment Amount Before Change', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0387912)


