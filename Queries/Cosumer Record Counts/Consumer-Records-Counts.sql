/******   
IQQ
14,279,695
******/
SELECT DISTINCT COUNT(ID)
--TOP 1000 [GIVEN_NAME_TX], [FAMILY_NAME_TX]
FROM [iqq_common].[dbo].[PERSON]
WHERE FAMILY_NAME_TX IS NOT NULL
AND GIVEN_NAME_TX IS NOT NULL
AND LEN(GIVEN_NAME_TX) > 1
AND LEN(FAMILY_NAME_TX) > 1
AND FAMILY_NAME_TX NOT LIKE '%(%'
AND FAMILY_NAME_TX NOT LIKE '%&%'
AND FAMILY_NAME_TX NOT LIKE '%?%'
AND FAMILY_NAME_TX NOT LIKE '%;%'
AND FAMILY_NAME_TX NOT LIKE '%:%'
AND FAMILY_NAME_TX NOT LIKE '%-%'
AND FAMILY_NAME_TX NOT LIKE '%#%'
AND FAMILY_NAME_TX NOT LIKE '%"%'
AND FAMILY_NAME_TX NOT LIKE '%*%'
AND FAMILY_NAME_TX NOT LIKE '%,%'
AND FAMILY_NAME_TX NOT LIKE '%@%'
AND FAMILY_NAME_TX NOT LIKE '%~%'
AND FAMILY_NAME_TX NOT LIKE '%[0-9]%'
AND FAMILY_NAME_TX NOT LIKE '%test%'
AND FAMILY_NAME_TX NOT IN ('...')--,'aa','aaa','aaaa','aaaaaaa','aaaadngr','AAAC')

/******   
IVOS
1,499,951
******/
Select COUNT(*) FROM [dbo].[claimant]

/******   
UniTrac
92,330,593
******/
SELECT COUNT(OP.ID)
		FROM OWNER_POLICY OP
		JOIN PROPERTY_OWNER_POLICY_RELATE PR ON PR.OWNER_POLICY_ID = OP.ID
		JOIN PROPERTY PROP ON PROP.ID = PR.PROPERTY_ID



/******   
RefundPlus
81,074
******/
  DECLARE @command varchar(1000) 
SELECT @command = 'USE ? SELECT DB_NAME(), COUNT(ID) AS TOTAL FROM [dbo].[CONTACT]' 
EXEC sp_MSforeachdb @command 