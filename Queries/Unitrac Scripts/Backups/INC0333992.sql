USE UniTrac





SELECT C.*
INTO UniTracHDStorage..INC0333992_C
 FROM dbo.LOAN L
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
WHERE L.NUMBER_TX = '22387' AND L.LENDER_ID = 2358


SELECT C.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') [Column] , C.*
INTO UniTracHDStorage..INC0333992_C2
 FROM dbo.LOAN L
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
WHERE  L.LENDER_ID = 2358 AND C.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') = 'CollateralCodeId'





UPDATE C
SET C.FIELD_PROTECTION_XML = NULL, C.UPDATE_DT = GETDATE(), C.UPDATE_USER_TX = 'INC0333992', C.LOCK_ID = C.LOCK_ID+1
--SELECT C.FIELD_PROTECTION_XML, * 
FROM dbo.COLLATERAL C
WHERE C.ID IN (SELECT ID FROM UniTracHDStorage..INC0333992_C2)
AND C.FIELD_PROTECTION_XML IS NOT NULL;