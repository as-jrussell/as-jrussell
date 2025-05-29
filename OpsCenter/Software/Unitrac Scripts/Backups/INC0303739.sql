USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT * --RC.* INTO UniTracHDStorage..INC0303739
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX IN ( '1877' ) AND C.PROPERTY_ID = '175877495'
        AND L.NUMBER_TX IN ( '7015179-0001', '7015332-0001', '7015332-0002',
                             '7015426-0001', '7015476-0001', '7015750-0001',
                             '7015816-0001', '7015865-0001', '7016050-0002',
                             '7016204-0001', '7016486-0001', '7016768-0001',
                             '7016835-0001', '7016947-0001', '7016955-0001',
                             '7016975-0001', '7016979-0001', '7017159-0001',
                             '7017179-0001', '7017242-0001', '7017255-0001',
                             '7017528-0001', '7017659-0001', '7017974-0002',
                             '7018074-0001', '7018560-0001', '7018809-0002',
                             '7019124-0001', '7019187-0001', '7019366-0001',
                             '7019875-0001', '7019964-0001', '7020304-0001',
                             '7020502-0001', '7020538-0001', '7020667-0001',
                             '7020748-0001', '7020856-0001', '7021227-0002',
                             '7021361-0001', '7021429-0001', '7021558-0002',
                             '7021585-0001', '7021655-0001', '7021702-0001',
                             '7021746-0001', '7021764-0001', '7022494-0002',
                             '7022583-0001', '7022790-0001', '7022818-0001',
                             '7022867-0001', '7022998-0001', '7023103-0001',
                             '7023126-0001', '7023415-0001', '7023495-0001',
                             '7023600-0001', '7023731-0001', '7023743-0001',
                             '7023754-0001', '7024241-0001', '7024246-0002' )




							 SELECT * FROM dbo.REF_CODE
							 WHERE CODE_CD = 'B'


                             UPDATE dbo.REQUIRED_COVERAGE
                             SET    STATUS_CD = 'B' ,
                                    UPDATE_DT = GETDATE() ,
                                    LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1
                                                   ELSE LOCK_ID + 1
                                              END ,
                                    UPDATE_USER_TX = 'INC0303739'
							 --SELECT * FROM dbo.REQUIRED_COVERAGE
                             WHERE  ID IN (
                                    SELECT  ID
                                    FROM    UniTracHDStorage..INC0303739 )


                             INSERT INTO PROPERTY_CHANGE
                                    ( ENTITY_NAME_TX ,
                                      ENTITY_ID ,
                                      USER_TX ,
                                      ATTACHMENT_IN ,
                                      CREATE_DT ,
                                      AGENCY_ID ,
                                      DESCRIPTION_TX ,
                                      DETAILS_IN ,
                                      FORMATTED_IN ,
                                      LOCK_ID ,
                                      PARENT_NAME_TX ,
                                      PARENT_ID ,
                                      TRANS_STATUS_CD ,
                                      UTL_IN
                                    )
                                    SELECT DISTINCT
                                            'Allied.UniTrac.RequiredCoverage' ,
                                            L.ID ,
                                            'INC0303739' ,
                                            'N' ,
                                            GETDATE() ,
                                            1 ,
                                            'Moved Status to Blankey' ,
                                            'Y' ,
                                            'N' ,
                                            1 ,
                                            'Allied.UniTrac.RequiredCoverage' ,
                                            L.ID ,
                                            'PEND' ,
                                            'N'
                                    FROM    LOAN L
                                    WHERE   L.ID IN (
                                            SELECT  ID
                                            FROM    UniTracHDStorage..INC0303739 )