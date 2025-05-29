USE UniTrac
SELECT  *
FROM    dbo.LENDER
WHERE   CODE_TX = '13100'

SELECT  * --INTO UniTracHDStorage.dbo.LOAN_13100_2
FROM    dbo.LOAN
WHERE   LENDER_ID IN ( 2100 )
        AND NUMBER_TX IN ( '702-4927980', '151-4997310', '410-7528180',
                           '30-7530830', '30-7529280', '30-4162920',
                           '702-4927980', '151-4326040', '425-9436640',
                           '30-4467390', '30-7530930', '30-7531140',
                           '30-9460880', '151-4326040', '425-9436640',
                           '30-4467390', '30-7530930', '30-7531140',
                           '30-9460880', '410-7528180', '30-7530830',
                           '30-7529280', '30-4162920', '702-4927980',
                           '151-4997310', '151-4228140', '425-5087040',
                           '701-4996910', '425-9745550', '411-428600',
                           '410-4620080', '501-4997230', '425-9244800',
                           '151-4997310', '151-4228140', '701-4996910',
                           '425-9745550', '501-4997230', '425-9244800',
                           '425-5087040', '411-428600', '410-4620080' )

SELECT  *
FROM    UniTracHDStorage.dbo.LOAN_13100_2

UPDATE  Loan
SET     NUMBER_TX = '49279808702' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '702-4927980'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '49973108151' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '151-4997310'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '75281808410' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '410-7528180'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '75308308030' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '30-7530830'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '75292808030' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '30-7529280'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '41629208030' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '30-4162920'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '49279808702' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '702-4927980'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '43260408151' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '151-4326040'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '94366408425' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '425-9436640'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '44673908030' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '30-4467390'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '75309308030' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '30-7530930'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '75311408030' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '30-7531140'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '94608808030' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '30-9460880'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '43260408151' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '151-4326040'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '94366408425' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '425-9436640'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '44673908030' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '30-4467390'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '75309308030' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '30-7530930'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '75311408030' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '30-7531140'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '94608808030' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '30-9460880'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '75281808410' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '410-7528180'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '75308308030' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '30-7530830'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '75292808030' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '30-7529280'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '41629208030' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '30-4162920'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '49279808702' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '702-4927980'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '49973108151' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '151-4997310'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '42281408151' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '151-4228140'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '50870408425' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '425-5087040'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '49969108701' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '701-4996910'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '97455508425' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '425-9745550'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '4286008411' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '411-428600'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '46200808410' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '410-4620080'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '49972308501' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '501-4997230'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '92448008425' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '425-9244800'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '49973108151' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '151-4997310'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '42281408151' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '151-4228140'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '49969108701' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '701-4996910'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '97455508425' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '425-9745550'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '49972308501' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '501-4997230'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '92448008425' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '425-9244800'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '50870408425' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '425-5087040'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '4286008411' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '411-428600'
        AND LENDER_ID = 2100
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '46200808410' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'tmartinreq'
WHERE   NUMBER_TX = '410-4620080'
        AND LENDER_ID = 2100
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
                'tmartinreq' ,
                'N' ,
                '2017-08-04 00:00:00.000' ,
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
                        FROM    UnitracHDStorage.dbo.LOAN_13100_2 )
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
                UnitracHDStorage.dbo.LOAN_13100_2.NUMBER_TX ,
                LOAN.NUMBER_TX ,
                1 ,
                '2017-08-04 00:00:00.000' ,
                'Y' ,
                'U'
        FROM    PROPERTY_CHANGE
                INNER JOIN LOAN ON PROPERTY_CHANGE.ENTITY_ID = LOAN.ID
                                   AND ENTITY_NAME_TX = 'Allied.UniTrac.Loan'
                INNER JOIN UnitracHDStorage.dbo.LOAN_13100_2 ON LOAN.ID = UnitracHDStorage.dbo.LOAN_13100_2.ID --AND ENTITY_NAME_TX = 'Allied.UniTrac.Loan' 
        WHERE   PROPERTY_CHANGE.CREATE_DT = '2017-08-04 00:00:00.000'
                AND ENTITY_ID IN ( SELECT   ID
                                   FROM     UnitracHDStorage.dbo.LOAN_13100_2 )
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
                GETDATE() ,
                GETDATE() ,
                GETDATE() ,
                'tmartinreq' ,
                1
        FROM    UnitracHDStorage.dbo.LOAN_13100_2 HD
                INNER JOIN dbo.LOAN ON HD.ID = LOAN.ID AND LOAN.EFFECTIVE_DT IS  NULL
--42

SELECT EFFECTIVE_DT, * FROM dbo.LOAN
WHERE ID IN (207290950,
208469122)

--5) Full Text Search Updates

--Create updates
SELECT  'EXEC SaveSearchFullText' ,
        PROPERTY.ID
FROM    PROPERTY
        INNER JOIN COLLATERAL ON PROPERTY.ID = COLLATERAL.PROPERTY_ID
                                 AND LOAN_ID IN (
                                 SELECT ID
                                 FROM   UnitracHDStorage.dbo.LOAN_13100_2 )
--42



EXEC SaveSearchFullText	94998374
EXEC SaveSearchFullText	70995539
EXEC SaveSearchFullText	94998375
EXEC SaveSearchFullText	94998376
EXEC SaveSearchFullText	94998377
EXEC SaveSearchFullText	94998379
EXEC SaveSearchFullText	94998380
EXEC SaveSearchFullText	94998382
EXEC SaveSearchFullText	94998384
EXEC SaveSearchFullText	95106553
EXEC SaveSearchFullText	95106554
EXEC SaveSearchFullText	95106555
EXEC SaveSearchFullText	70995539
EXEC SaveSearchFullText	95106557
EXEC SaveSearchFullText	95106559
EXEC SaveSearchFullText	95106558
EXEC SaveSearchFullText	95106561
EXEC SaveSearchFullText	95106562
EXEC SaveSearchFullText	70994950
EXEC SaveSearchFullText	70995932
EXEC SaveSearchFullText	151347883
EXEC SaveSearchFullText	151347884
EXEC SaveSearchFullText	151347886
EXEC SaveSearchFullText	151347887
EXEC SaveSearchFullText	151347890
EXEC SaveSearchFullText	151347893
EXEC SaveSearchFullText	151347894
EXEC SaveSearchFullText	151347895
EXEC SaveSearchFullText	151347899
EXEC SaveSearchFullText	151349861
EXEC SaveSearchFullText	151349863
EXEC SaveSearchFullText	151349864
EXEC SaveSearchFullText	151349865
EXEC SaveSearchFullText	151349866
EXEC SaveSearchFullText	151349868
EXEC SaveSearchFullText	70994950
EXEC SaveSearchFullText	70995932
EXEC SaveSearchFullText	151349871
EXEC SaveSearchFullText	151349873
EXEC SaveSearchFullText	151349874
EXEC SaveSearchFullText	178859259
EXEC SaveSearchFullText	180037139