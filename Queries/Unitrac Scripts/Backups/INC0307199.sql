USE UniTrac


SELECT LL.NAME_TX, L.*
--INTO jcs..INC0307199
 FROM dbo.LOAN L
JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX = '7073' AND L.NUMBER_TX = --'919929-600'
'205151-600'

SELECT PROPERTY.* FROM dbo.COLLATERAL
JOIN dbo.PROPERTY ON PROPERTY.ID = COLLATERAL.PROPERTY_ID
WHERE LOAN_ID = 3603270

