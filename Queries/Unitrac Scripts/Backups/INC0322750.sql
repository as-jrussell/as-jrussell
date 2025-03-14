USE UniTrac

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT OP.SPECIAL_HANDLING_XML.value('(/SH/WallsIn)[1]', 'varchar (50)') [Walls],  RE.ACTIVE_IN [Escrow Flag], L.*
INTO JCs..INC0322750
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN dbo.REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
INNER JOIN dbo.REQUIRED_ESCROW RE ON RE.REQUIRED_COVERAGE_ID = RC.ID
WHERE LL.CODE_TX IN ('2107') AND OP.SPECIAL_HANDLING_XML.value('(/SH/WallsIn)[1]', 'varchar (50)') = 'Y'
AND L.RECORD_TYPE_CD = 'G'
AND RE.ACTIVE_IN = 'Y'

UPDATE OWNER_POLICY
SET SPECIAL_HANDLING_XML.modify('insert <WallsIn>Y</WallsIn> into (/SH)[1]'),
        LOCK_ID = LOCK_ID + 1
--SELECT SPECIAL_HANDLING_XML.value('(/SH/WallsIn)[1]', 'varchar (50)'), * FROM dbo.OWNER_POLICY
WHERE ID IN (SELECT ID FROM UnitracHDStorage..INC0323704) AND SPECIAL_HANDLING_XML IS NOT NULL 
 AND SPECIAL_HANDLING_XML.value('(/SH/WallsIn)[1]', 'varchar (50)') IS NULL
 --

UPDATE OWNER_POLICY
SET SPECIAL_HANDLING_XML.modify('replace value of (/SH/WallsIn/text())[1] with "Y"'),
        LOCK_ID = LOCK_ID + 1
--SELECT SPECIAL_HANDLING_XML.value('(/SH/WallsIn)[1]', 'varchar (50)'), * FROM dbo.OWNER_POLICY
WHERE ID IN (
SELECT ID FROM UnitracHDStorage..INC0323704) AND  SPECIAL_HANDLING_XML IS not NULL
 AND SPECIAL_HANDLING_XML.value('(/SH/WallsIn)[1]', 'varchar (50)') = 'N'
