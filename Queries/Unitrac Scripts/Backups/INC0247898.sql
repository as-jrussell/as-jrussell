USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT IH.* 
--INTO UniTracHDStorage..INC0247898
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID 
WHERE LL.CODE_TX IN ('2281') AND L.NUMBER_TX = '9000907378'



UPDATE  dbo.INTERACTION_HISTORY
SET     SPECIAL_HANDLING_XML.modify('replace value of (/SH/ExpirationDate/text())[1] with "1/9/2016 12:00:00 AM"'),
        LOCK_ID = LOCK_ID + 1
--SELECT * FROM dbo.INTERACTION_HISTORY
WHERE ID = '164791480'