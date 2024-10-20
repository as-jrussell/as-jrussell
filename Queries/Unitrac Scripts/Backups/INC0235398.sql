SELECT * FROM dbo.LENDER
WHERE CODE_TX = '2086'

SELECT  * INTO UniTracHDStorage.dbo.LOAN_2086_1
FROM    dbo.LOAN
WHERE   LENDER_ID IN ( 2288 )
        AND NUMBER_TX IN ( '93410001',
'93540001' )

SELECT * FROM UniTracHDStorage.dbo.LOAN_2086_1


UPDATE  Loan
SET     NUMBER_TX = '93410000001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0235398'
WHERE   NUMBER_TX = '93410001'
        AND LENDER_ID = 2288
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '93540000001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0235398'
WHERE   NUMBER_TX = '93540001'
        AND LENDER_ID = 2288
        AND PURGE_DT IS NULL;



--2) INSERT into PROPERTY_CHANGE table
INSERT INTO PROPERTY_CHANGE (ENTITY_NAME_TX,ENTITY_ID,USER_TX,ATTACHMENT_IN,CREATE_DT,AGENCY_ID,DETAILS_IN,FORMATTED_IN,LOCK_ID,PARENT_NAME_TX,PARENT_ID,TRANS_STATUS_CD,UTL_IN)
SELECT 'Allied.UniTrac.Loan',LOAN.ID,'INC0235398','N','2016-06-02 00:00:00.000',1,'Y','N',1,'Allied.UniTrac.Loan',LOAN.ID,'PEND','N'
FROM LOAN
WHERE ID IN (SELECT ID FROM UnitracHDStorage.dbo.LOAN_2086_1)
--42


--3) INSERT into PROPERTY_CHANGE_UPDATE table
INSERT INTO PROPERTY_CHANGE_UPDATE (CHANGE_ID, TABLE_NAME_TX, TABLE_ID, COLUMN_NM, FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
select PROPERTY_CHANGE.ID,'LOAN',ENTITY_ID,'NUMBER_TX',UnitracHDStorage.dbo.LOAN_2086_1.NUMBER_TX,LOAN.NUMBER_TX,1,'2016-06-02 00:00:00.000','Y','U'
from PROPERTY_CHANGE
INNER JOIN LOAN ON PROPERTY_CHANGE.ENTITY_ID = LOAN.ID AND ENTITY_NAME_TX = 'Allied.UniTrac.Loan' 
INNER JOIN UnitracHDStorage.dbo.LOAN_2086_1 ON LOAN.ID = UnitracHDStorage.dbo.LOAN_2086_1.ID --AND ENTITY_NAME_TX = 'Allied.UniTrac.Loan' 
WHERE PROPERTY_CHANGE.CREATE_DT = '2016-06-02 00:00:00.000'
AND ENTITY_ID IN (SELECT ID FROM UnitracHDStorage.dbo.LOAN_2086_1)
--0

---4) Insert into LOAN_NUMBER Table (Leave old numbers for matching purposes)

INSERT INTO LOAN_NUMBER (LOAN_ID,NUMBER_TX,EFFECTIVE_DT,CREATE_DT,UPDATE_DT,UPDATE_USER_TX, LOCK_ID)
SELECT dbo.LOAN.ID, dbo.LOAN.NUMBER_TX,dbo.LOAN.EFFECTIVE_DT,GETDATE(),GETDATE(),'INC0235398',1
FROM UnitracHDStorage.dbo.LOAN_2086_1 HD INNER JOIN dbo.LOAN ON HD.ID = LOAN.ID
--42

--5) Full Text Search Updates

--Create updates
SELECT 'EXEC SaveSearchFullText', PROPERTY.ID 
FROM PROPERTY
INNER JOIN COLLATERAL ON PROPERTY.ID = COLLATERAL.PROPERTY_ID
AND LOAN_ID in (select ID FROM UnitracHDStorage.dbo.LOAN_2086_1)
--42



EXEC SaveSearchFullText	128760305
EXEC SaveSearchFullText	128760347
EXEC SaveSearchFullText	128760363
EXEC SaveSearchFullText	128763695