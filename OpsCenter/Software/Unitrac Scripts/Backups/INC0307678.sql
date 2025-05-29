USE UniTrac
SELECT  *
FROM    dbo.LENDER
WHERE   CODE_TX = '1761'

SELECT  *
--INTO    UniTracHDStorage.dbo.LOAN_1761_1
FROM    dbo.LOAN
WHERE   LENDER_ID IN ( 334 )
        AND NUMBER_TX IN ( '12941-1', '7000126-1', '7007301-1', '9970-1',
                           '12941-1', '18877-1', '21136-2', '477208-3',
                           '6562291-1', '6564899-3', '6568674-2', '6571683-2',
                           '6577324-1', '7000126-1', '7001628-2', '7003222-1',
                           '7006688-5', '7006688-6', '7007301-1', '7009726-4',
                           '7010009-2', '7010163-2', '7010279-1', '7011543-1',
                           '7012301-1', '7017393-1', '7019916-3', '7019918-1',
                           '7019930-1', '7019936-1', '7022218-1', '7022903-1',
                           '7023861-2', '7024011-1', '7024174-1', '7024230-1',
                           '7024271-1', '7024280-1', '7024576-5', '7025514-3',
                           '7026535-1', '7026539-1', '7026539-2', '7026556-1',
                           '7026573-1', '7026579-1' )

SELECT  *
FROM    UniTracHDStorage.dbo.LOAN_1761_1


UPDATE  Loan
SET     NUMBER_TX = '12941-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '12941-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7000126-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7000126-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7007301-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7007301-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '9970-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '9970-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '12941-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '12941-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '18877-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '18877-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '21136-0002' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '21136-2'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '477208-0003' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '477208-3'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '6562291-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '6562291-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '6564899-0003' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '6564899-3'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '6568674-0002' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '6568674-2'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '6571683-0002' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '6571683-2'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '6577324-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '6577324-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7000126-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7000126-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7001628-0002' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7001628-2'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7003222-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7003222-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7006688-0005' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7006688-5'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7006688-0006' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7006688-6'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7007301-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7007301-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7009726-0004' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7009726-4'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7010009-0002' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7010009-2'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7010163-0002' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7010163-2'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7010279-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7010279-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7011543-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7011543-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7012301-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7012301-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7017393-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7017393-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7019916-0003' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7019916-3'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7019918-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7019918-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7019930-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7019930-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7019936-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7019936-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7022218-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7022218-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7022903-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7022903-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7023861-0002' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7023861-2'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7024011-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7024011-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7024174-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7024174-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7024230-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7024230-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7024271-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7024271-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7024280-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7024280-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7024576-0005' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7024576-5'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7025514-0003' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7025514-3'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7026535-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7026535-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7026539-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7026539-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7026539-0002' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7026539-2'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7026556-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7026556-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7026573-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7026573-1'
        AND LENDER_ID = 334
        AND PURGE_DT IS NULL;
UPDATE  Loan
SET     NUMBER_TX = '7026579-0001' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0307678'
WHERE   NUMBER_TX = '7026579-1'
        AND LENDER_ID = 334
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
                'INC0307678' ,
                'N' ,
                '2017-07-19 00:00:00.000' ,
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
                        FROM    UnitracHDStorage.dbo.LOAN_1761_1 )
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
                UnitracHDStorage.dbo.LOAN_1761_1.NUMBER_TX ,
                LOAN.NUMBER_TX ,
                1 ,
                '2017-07-19 00:00:00.000' ,
                'Y' ,
                'U'
        FROM    PROPERTY_CHANGE
                INNER JOIN LOAN ON PROPERTY_CHANGE.ENTITY_ID = LOAN.ID
                                   AND ENTITY_NAME_TX = 'Allied.UniTrac.Loan'
                INNER JOIN UnitracHDStorage.dbo.LOAN_1761_1 ON LOAN.ID = UnitracHDStorage.dbo.LOAN_1761_1.ID --AND ENTITY_NAME_TX = 'Allied.UniTrac.Loan' 
        WHERE   PROPERTY_CHANGE.CREATE_DT = '2017-07-19 00:00:00.000'
                AND ENTITY_ID IN ( SELECT   ID
                                   FROM     UnitracHDStorage.dbo.LOAN_1761_1 )
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
                'INC0307678' ,
                1
        FROM    UnitracHDStorage.dbo.LOAN_1761_1 HD
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
                                 FROM   UnitracHDStorage.dbo.LOAN_1761_1 )
--42


EXEC SaveSearchFullText	37843761
EXEC SaveSearchFullText	38933778
EXEC SaveSearchFullText	38933781
EXEC SaveSearchFullText	38933783
EXEC SaveSearchFullText	38934386
EXEC SaveSearchFullText	38934387
EXEC SaveSearchFullText	38934388
EXEC SaveSearchFullText	38934453
EXEC SaveSearchFullText	38934454
EXEC SaveSearchFullText	38934455
EXEC SaveSearchFullText	38934456
EXEC SaveSearchFullText	38934458
EXEC SaveSearchFullText	38934474
EXEC SaveSearchFullText	38934652
EXEC SaveSearchFullText	38934822
EXEC SaveSearchFullText	38934824
EXEC SaveSearchFullText	2550317
EXEC SaveSearchFullText	38934988
EXEC SaveSearchFullText	38934989
EXEC SaveSearchFullText	38934997
EXEC SaveSearchFullText	38935006
EXEC SaveSearchFullText	38935007
EXEC SaveSearchFullText	2550317
EXEC SaveSearchFullText	38935119
EXEC SaveSearchFullText	38935140
EXEC SaveSearchFullText	38935141
EXEC SaveSearchFullText	38935143
EXEC SaveSearchFullText	38935151
EXEC SaveSearchFullText	38935155
EXEC SaveSearchFullText	38935156
EXEC SaveSearchFullText	38935158
EXEC SaveSearchFullText	37843761
EXEC SaveSearchFullText	92694533
EXEC SaveSearchFullText	92694534
EXEC SaveSearchFullText	92694535
EXEC SaveSearchFullText	92694536
EXEC SaveSearchFullText	92694537
EXEC SaveSearchFullText	92694541
EXEC SaveSearchFullText	93209309
EXEC SaveSearchFullText	93209310
EXEC SaveSearchFullText	93209311
EXEC SaveSearchFullText	93209316
EXEC SaveSearchFullText	93209317
EXEC SaveSearchFullText	93209318
EXEC SaveSearchFullText	126478837
EXEC SaveSearchFullText	126478852
EXEC SaveSearchFullText	126478878
EXEC SaveSearchFullText	126478891
EXEC SaveSearchFullText	126478898
EXEC SaveSearchFullText	126478914
EXEC SaveSearchFullText	126478920
EXEC SaveSearchFullText	126478924
EXEC SaveSearchFullText	126478931
EXEC SaveSearchFullText	126478932
EXEC SaveSearchFullText	126478934
EXEC SaveSearchFullText	126478937
EXEC SaveSearchFullText	2767073
EXEC SaveSearchFullText	32617827
EXEC SaveSearchFullText	126478941
EXEC SaveSearchFullText	126478950
EXEC SaveSearchFullText	126478952
EXEC SaveSearchFullText	126478954
EXEC SaveSearchFullText	126478958
EXEC SaveSearchFullText	126478960
EXEC SaveSearchFullText	126478961
EXEC SaveSearchFullText	126478963
EXEC SaveSearchFullText	126478964
EXEC SaveSearchFullText	126478965
EXEC SaveSearchFullText	126478966
EXEC SaveSearchFullText	126478967
EXEC SaveSearchFullText	126479196
EXEC SaveSearchFullText	126479228
EXEC SaveSearchFullText	126479240
EXEC SaveSearchFullText	126479242
EXEC SaveSearchFullText	126479249
EXEC SaveSearchFullText	126479252
EXEC SaveSearchFullText	126479254
EXEC SaveSearchFullText	126479255
EXEC SaveSearchFullText	126479259
EXEC SaveSearchFullText	126479260
EXEC SaveSearchFullText	126479261
EXEC SaveSearchFullText	2767073
EXEC SaveSearchFullText	126479262
EXEC SaveSearchFullText	32617827
EXEC SaveSearchFullText	126479265
EXEC SaveSearchFullText	126479275
EXEC SaveSearchFullText	126479280
EXEC SaveSearchFullText	126479282
EXEC SaveSearchFullText	126479285
EXEC SaveSearchFullText	126479288
EXEC SaveSearchFullText	126479293
EXEC SaveSearchFullText	126479294
EXEC SaveSearchFullText	126479295
EXEC SaveSearchFullText	126479296
EXEC SaveSearchFullText	126479297
EXEC SaveSearchFullText	126479298
EXEC SaveSearchFullText	160690577