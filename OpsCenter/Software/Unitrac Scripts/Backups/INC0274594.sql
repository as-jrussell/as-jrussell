USE UniTrac	

/*
ORIGINAL BACKED UP TO 
UnitracHDStorage..INC0274594_Walls
UnitracHDStorage..INC0274594_Walls_2

UnitracHDStorage..INC0274594_OP
UnitracHDStorage..INC0274594_OP_2

Missed some in the first back up.
*/

		
--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.*
 FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
INNER JOIN dbo.IMPAIRMENT I ON I.REQUIRED_COVERAGE_ID = RC.ID
WHERE LL.CODE_TX IN ('7140') AND L.EFFECTIVE_DT <= '2009-01-01'
AND C.COLLATERAL_CODE_ID IN (313,435) AND L.ID NOT IN (SELECT ID FROM UnitracHDStorage..INC0274594_Walls)

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT OP.SPECIAL_HANDLING_XML.value('(/SH/WallsIn)[1]', 'varchar (50)') [Walls], OP.* INTO UnitracHDStorage..INC0274594_OP_2  FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
WHERE L.ID IN (SELECT ID FROM UnitracHDStorage..INC0274594_Walls_2)

SELECT SPECIAL_HANDLING_XML.value('(/SH/WallsIn)[1]', 'varchar (50)'), * FROM dbo.OWNER_POLICY
WHERE ID IN (SELECT ID FROM UnitracHDStorage..INC0274594_OP_2)
AND SPECIAL_HANDLING_XML IS NOT NULL


UPDATE OWNER_POLICY
SET SPECIAL_HANDLING_XML.modify('replace value of (/SH/WallsIn/text())[1] with "Y"'),
        LOCK_ID = LOCK_ID + 1
--SELECT SPECIAL_HANDLING_XML.value('(/SH/WallsIn)[1]', 'varchar (50)'), * FROM dbo.OWNER_POLICY
WHERE ID IN (
SELECT ID FROM UnitracHDStorage..INC0274594_OP_2) AND  SPECIAL_HANDLING_XML IS not NULL
 AND SPECIAL_HANDLING_XML.value('(/SH/WallsIn)[1]', 'varchar (50)') = 'N'






UPDATE OWNER_POLICY
SET SPECIAL_HANDLING_XML.modify('insert <WallsIn>Y</WallsIn> into (/SH)[1]'),
        LOCK_ID = LOCK_ID + 1
--SELECT SPECIAL_HANDLING_XML.value('(/SH/WallsIn)[1]', 'varchar (50)'), * FROM dbo.OWNER_POLICY
WHERE ID IN (SELECT ID FROM UnitracHDStorage..INC0274594_OP_2) AND SPECIAL_HANDLING_XML IS NOT NULL 
 AND SPECIAL_HANDLING_XML.value('(/SH/WallsIn)[1]', 'varchar (50)') IS NULL



 SELECT * FROM dbo.REF_CODE
 WHERE CODE_CD = 'H06'