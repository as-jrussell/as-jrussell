USE UniTrac


UPDATE dbo.BORROWER_INSURANCE_AGENCY
SET EMAIL_TX = '', UPDATE_DT = GETDATE(), LOCK_ID= LOCK_ID+1, UPDATE_USER_TX = 'INC0231728'
--SELECT *  FROM dbo.BORROWER_INSURANCE_AGENCY
WHERE EMAIL_TX = 'gmcfax@geico.com'