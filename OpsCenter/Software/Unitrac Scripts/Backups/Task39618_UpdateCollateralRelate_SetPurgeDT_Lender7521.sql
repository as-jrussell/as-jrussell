/* Task 39618
 Update for Lender 7521
 */

Declare @Lender varchar (200)
Declare @LenderID int

set @Lender = '7521'

select @LenderID = ID From Lender where code_tx = @Lender

--select * 

UPDATE utlldr SET utlldr.PURGE_DT = GETDATE(), utlldr.UPDATE_DT = GETDATE(),
 utlldr.UPDATE_USER_TX = 'Bug39618', utlldr.LOCK_ID = (utlldr.LOCK_ID % 255) + 1 

 FROM UNITRAC_TO_LATEST_LENDER_DATA_RELATE utlldr
 INNER JOIN COLLATERAL c ON c.ID = utlldr.UNITRAC_RELATE_CLASS_ID AND c.PURGE_DT IS NULL AND utlldr.UNITRAC_RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Collateral'
 INNER JOIN LOAN l ON l.ID = c.LOAN_ID AND l.PURGE_DT IS NULL  AND l.Record_Type_CD IN ('G','A','D')
 WHERE l.LENDER_ID in (@LenderID) -- Lender 7521
 and utlldr.PURGE_DT IS NULL
 and utlldr.LENDER_DATA_RELATE_CLASS_ID NOT IN 
 (SELECT cetd.ID FROM COLLATERAL_EXTRACT_TRANSACTION_DETAIL cetd)

 


