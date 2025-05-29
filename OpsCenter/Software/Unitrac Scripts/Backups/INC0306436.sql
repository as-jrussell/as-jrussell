USE UniTrac
SELECT  *
FROM    dbo.LENDER
WHERE   CODE_TX = '6088'

SELECT  *
INTO    UniTracHDStorage.dbo.LOAN_6088_1
FROM    dbo.LOAN
WHERE   LENDER_ID IN ( 1014 )
        AND NUMBER_TX IN ( '110022290-L4801' )

SELECT  *
FROM    UniTracHDStorage.dbo.LOAN_6088_1

UPDATE  Loan
SET     NUMBER_TX = '1100222904801' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0306436'
WHERE   NUMBER_TX = '110022290-L4801'
        AND LENDER_ID = 1014
        AND PURGE_DT IS NULL;





--2) INSERT into PROPERTY_CHANGE table
INSERT  INTO PROPERTY_CHANGE
        ( ENTITY_NAME_TX ,
          ENTITY_ID ,
          USER_TX ,
          ATTACHMENT_IN ,
          CREATE_DT ,
          AGENCY_ID ,
          DETAILS_IN ,
          FORMATTED_IN ,
          LOCK_ID ,
          PARENT_NAME_TX ,
          PARENT_ID ,
          TRANS_STATUS_CD ,
          UTL_IN
        )
        SELECT  'Allied.UniTrac.Loan' ,
                LOAN.ID ,
                'INC0306436' ,
                'N' ,
                '2017-07-07 00:00:00.000' ,
                1 ,
                'Y' ,
                'N' ,
                1 ,
                'Allied.UniTrac.Loan' ,
                LOAN.ID ,
                'PEND' ,
                'N'
        FROM    LOAN
        WHERE   ID IN ( SELECT  ID
                        FROM    UnitracHDStorage.dbo.LOAN_6088_1 )
--42


--3) INSERT into PROPERTY_CHANGE_UPDATE table
INSERT  INTO PROPERTY_CHANGE_UPDATE
        ( CHANGE_ID ,
          TABLE_NAME_TX ,
          TABLE_ID ,
          COLUMN_NM ,
          FROM_VALUE_TX ,
          TO_VALUE_TX ,
          DATATYPE_NO ,
          CREATE_DT ,
          DISPLAY_IN ,
          OPERATION_CD
        )
        SELECT  PROPERTY_CHANGE.ID ,
                'LOAN' ,
                ENTITY_ID ,
                'NUMBER_TX' ,
                UnitracHDStorage.dbo.LOAN_6088_1.NUMBER_TX ,
                LOAN.NUMBER_TX ,
                1 ,
                '2017-07-07 00:00:00.000' ,
                'Y' ,
                'U'
        FROM    PROPERTY_CHANGE
                INNER JOIN LOAN ON PROPERTY_CHANGE.ENTITY_ID = LOAN.ID
                                   AND ENTITY_NAME_TX = 'Allied.UniTrac.Loan'
                INNER JOIN UnitracHDStorage.dbo.LOAN_6088_1 ON LOAN.ID = UnitracHDStorage.dbo.LOAN_6088_1.ID --AND ENTITY_NAME_TX = 'Allied.UniTrac.Loan' 
        WHERE   PROPERTY_CHANGE.CREATE_DT = '2017-07-07 00:00:00.000'
                AND ENTITY_ID IN ( SELECT   ID
                                   FROM     UnitracHDStorage.dbo.LOAN_6088_1 )
--0

---4) Insert into LOAN_NUMBER Table (Leave old numbers for matching purposes)

INSERT  INTO LOAN_NUMBER
        ( LOAN_ID ,
          NUMBER_TX ,
          EFFECTIVE_DT ,
          CREATE_DT ,
          UPDATE_DT ,
          UPDATE_USER_TX ,
          LOCK_ID
        )
        SELECT  dbo.LOAN.ID ,
                dbo.LOAN.NUMBER_TX ,
                dbo.LOAN.EFFECTIVE_DT ,
                GETDATE() ,
                GETDATE() ,
                'INC0306436' ,
                1
        FROM    UnitracHDStorage.dbo.LOAN_6088_1 HD
                INNER JOIN dbo.LOAN ON HD.ID = LOAN.ID
--42

--5) Full Text Search Updates

--Create updates
SELECT  'EXEC SaveSearchFullText' ,
        PROPERTY.ID
FROM    PROPERTY
        INNER JOIN COLLATERAL ON PROPERTY.ID = COLLATERAL.PROPERTY_ID
                                 AND LOAN_ID IN (
                                 SELECT ID
                                 FROM   UnitracHDStorage.dbo.LOAN_6088_1 )
--42


EXEC SaveSearchFullText	50381260
EXEC SaveSearchFullText	51620682
EXEC SaveSearchFullText	52556373