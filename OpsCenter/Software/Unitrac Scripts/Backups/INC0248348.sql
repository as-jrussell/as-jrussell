USE UniTrac

SELECT  SPECIAL_HANDLING_XML.value('(/SH/WallsIn)[1]', 'varchar (50)'),* FROM dbo.OWNER_POLICY
WHERE ID = '140937859'




UPDATE  dbo.OWNER_POLICY
SET     SPECIAL_HANDLING_XML.modify('insert (/SH/WallsIn/) after (/SH/Replacement[Replacement='Y']/step[1])[1]'),
        LOCK_ID = LOCK_ID + 1
		WHERE ID = '140937859'


DECLARE @newValue nVarChar(128) = 'Y'

UPDATE dbo.OWNER_POLICY
   SET SPECIAL_HANDLING_XML.modify('insert text{sql:variable("@newValue")} as first into (/SH/WallsIn)[1]') 
   WHERE ID = '138648291'


UPDATE OWNER_POLICY
SET SPECIAL_HANDLING_XML.modify('insert <WallsIn>Y</WallsIn> into (/SH)[1]')
		WHERE ID = '140937859'
GO