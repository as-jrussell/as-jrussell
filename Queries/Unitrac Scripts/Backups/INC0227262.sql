SELECT  * --INTO UniTracHDStorage.dbo.LOAN_1045_3
FROM    dbo.LOAN
WHERE   LENDER_ID IN (2047  )
        AND NUMBER_TX IN ( '11082164',
'12867650',
'13195850',
'1464675082',
'15022550',
'15529750',
'1606075080',
'172088509',
'1859755050',
'19289550',
'20066550',
'2019565205',
'2058195050',
'2059295050',
'4143910',
'518865080',
'5230950',
'548395081' )

SELECT * FROM dbo.LENDER
WHERE CODE_TX = '1045'

SELECT * FROM UniTracHDStorage.dbo.LOAN_1045_3

UPDATE  Loan
SET     NUMBER_TX = '11082164' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '11082164'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '12867650' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '12867650'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '13195850' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '13195850'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '1464675082' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '1464675082'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '15022550' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '15022550'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '15529750' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '15529750'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '1606075080' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '1606075080'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '172088509' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '172088509'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '1859755050' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '1859755050'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '19289550' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '19289550'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '20066550' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '20066550'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '2019565205' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '2019565205'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '2058195050' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '2058195050'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '2059295050' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '2059295050'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '4143910' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '4143910'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '518865080' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '518865080'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '5230950' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '5230950'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '548395081' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0227262'
WHERE   NUMBER_TX = '548395081'
        AND LENDER_ID = 2047
        AND PURGE_DT IS NULL;



--2) INSERT into PROPERTY_CHANGE table
INSERT INTO PROPERTY_CHANGE (ENTITY_NAME_TX,ENTITY_ID,USER_TX,ATTACHMENT_IN,CREATE_DT,AGENCY_ID,DETAILS_IN,FORMATTED_IN,LOCK_ID,PARENT_NAME_TX,PARENT_ID,TRANS_STATUS_CD,UTL_IN)
SELECT 'Allied.UniTrac.Loan',LOAN.ID,'INC0227262','N','2016-03-29 00:00:00.000',1,'Y','N',1,'Allied.UniTrac.Loan',LOAN.ID,'PEND','N'
FROM LOAN
WHERE ID IN (SELECT ID FROM UnitracHDStorage.dbo.LOAN_1045_3)
--37


--3) INSERT into PROPERTY_CHANGE_UPDATE table
INSERT INTO PROPERTY_CHANGE_UPDATE (CHANGE_ID, TABLE_NAME_TX, TABLE_ID, COLUMN_NM, FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
select PROPERTY_CHANGE.ID,'LOAN',ENTITY_ID,'NUMBER_TX',UnitracHDStorage.dbo.LOAN_1045_3.NUMBER_TX,LOAN.NUMBER_TX,1,'2016-03-29 00:00:00.000','Y','U'
from PROPERTY_CHANGE
INNER JOIN LOAN ON PROPERTY_CHANGE.ENTITY_ID = LOAN.ID AND ENTITY_NAME_TX = 'Allied.UniTrac.Loan' 
INNER JOIN UnitracHDStorage.dbo.LOAN_1045_3 ON LOAN.ID = UnitracHDStorage.dbo.LOAN_1045_3.ID --AND ENTITY_NAME_TX = 'Allied.UniTrac.Loan' 
WHERE PROPERTY_CHANGE.CREATE_DT = '2016-03-29 00:00:00.000'
AND ENTITY_ID IN (SELECT ID FROM UnitracHDStorage.dbo.LOAN_1045_3)
--37

---4) Insert into LOAN_NUMBER Table (Leave old numbers for matching purposes)

INSERT INTO LOAN_NUMBER (LOAN_ID,NUMBER_TX,EFFECTIVE_DT,CREATE_DT,UPDATE_DT,UPDATE_USER_TX, LOCK_ID)
SELECT dbo.LOAN.ID, dbo.LOAN.NUMBER_TX,dbo.LOAN.EFFECTIVE_DT,GETDATE(),GETDATE(),'INC0227262',1
FROM UnitracHDStorage.dbo.LOAN_1045_3 HD INNER JOIN dbo.LOAN ON HD.ID = LOAN.ID
WHERE LOAn.ID NOT IN (149545308)
--37

--5) Full Text Search Updates

--Create updates
SELECT 'EXEC SaveSearchFullText', PROPERTY.ID 
FROM PROPERTY
INNER JOIN COLLATERAL ON PROPERTY.ID = COLLATERAL.PROPERTY_ID
AND LOAN_ID in (select ID FROM UnitracHDStorage.dbo.LOAN_1045_3)
--42
EXEC SaveSearchFullText	54317589
EXEC SaveSearchFullText	54318444
EXEC SaveSearchFullText	54318979
EXEC SaveSearchFullText	54318996
EXEC SaveSearchFullText	54319197
EXEC SaveSearchFullText	54319985
EXEC SaveSearchFullText	54320253
EXEC SaveSearchFullText	54321446
EXEC SaveSearchFullText	54321600
EXEC SaveSearchFullText	54322044
EXEC SaveSearchFullText	54322072
EXEC SaveSearchFullText	54322263
EXEC SaveSearchFullText	54322282
EXEC SaveSearchFullText	54322339
EXEC SaveSearchFullText	54322357
EXEC SaveSearchFullText	54322044
EXEC SaveSearchFullText	61378560
EXEC SaveSearchFullText	54322263
EXEC SaveSearchFullText	65927371
EXEC SaveSearchFullText	65918115
EXEC SaveSearchFullText	71449155
EXEC SaveSearchFullText	54317742
EXEC SaveSearchFullText	71449155
EXEC SaveSearchFullText	54321446
EXEC SaveSearchFullText	54322072
EXEC SaveSearchFullText	54322282
EXEC SaveSearchFullText	54318996
EXEC SaveSearchFullText	54322339
EXEC SaveSearchFullText	72712213
EXEC SaveSearchFullText	61378560
EXEC SaveSearchFullText	72712213
EXEC SaveSearchFullText	118208880
EXEC SaveSearchFullText	118208888
EXEC SaveSearchFullText	118209038
EXEC SaveSearchFullText	119342527
EXEC SaveSearchFullText	122289333
EXEC SaveSearchFullText	118208841