USE UniTrac


SELECT * FROM dbo.LENDER
WHERE CODE_TX IN ('3067', '7350', '3140')


SELECT SPECIAL_HANDLING_XML.value('(/SH/Misc/VerifyDataWorkItemId)[1]', 'varchar (50)') [WorkItem], L.NUMBER_TX [Loan Number],
Le.NAME_TX, Le.CODE_TX
 INTO 
 #tmp
  FROM dbo.LOAN L 
 JOIN dbo.LENDER LE ON LE.ID = L.LENDER_ID
WHERE L.LENDER_ID IN (1449,1882,2260) AND 
 L.SPECIAL_HANDLING_XML IS NOT NULL
 AND L.SPECIAL_HANDLING_XML.value('(/SH/Misc/VerifyDataWorkItemId)[1]', 'varchar (50)') <> '0'


 SELECT * FROM #tmp