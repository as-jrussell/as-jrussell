USE UniTrac


SELECT SPECIAL_HANDLING_XML.value('(/SH/WallsIn)[1]', 'varchar (50)'), * FROM dbo.OWNER_POLICY
WHERE ID IN (138648789)



UPDATE OWNER_POLICY
SET SPECIAL_HANDLING_XML.modify('insert <WallsIn>Y</WallsIn> into (/SH)[1]'),
        LOCK_ID = LOCK_ID + 1
--SELECT SPECIAL_HANDLING_XML.value('(/SH/WallsIn)[1]', 'varchar (50)'), * FROM dbo.OWNER_POLICY
WHERE ID IN (
SELECT Owner_policy#ID FROM UniTracHDStorage..UnivofIowa2725Cleanup WHERE [Action #2] IS NOT NULL)
--SELECT ID FROM UniTracHDStorage..INC0248348_OP_2) 
--AND SPECIAL_HANDLING_XML.value('(/SH/WallsIn)[1]', 'varchar (50)') IS NULL 
GO 

SELECT * 
INTO UniTracHDStorage..INC0248348_OP_2
FROM dbo.OWNER_POLICY
WHERE ID IN (
SELECT Owner_policy#ID FROM UniTracHDStorage..UnivofIowa2725Cleanup
WHERE [Action #2] IS NOT NULL)


