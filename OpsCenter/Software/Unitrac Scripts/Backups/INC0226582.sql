USE [UniTrac]
GO 



--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT C.COLLATERAL_CODE_ID --INTO UniTracHDStorage..INC0226582
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
--INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
--SELECT  C.COLLATERAL_CODE_ID, COLLATERAL_CODE_ID,*
--FROM    dbo.LOAN L
--        INNER JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX IN ( '4171' )
        AND L.NUMBER_TX IN ( '161184-91', '161836-91', '162147-91',
                             '162375-91', '165507-91', '165894-91',
                             '170692-91', '170950-91', '170950-92',
                             '170950-93', '171486-92', '174612-91',
                             '176246-91', '176737-92', '177863-91',
                             '179723-91', '180202-91', '182738-91',
                             '183180-91', '183704-91', '186433-91',
                             '188015-91', '193564-91', '194148-91',
                             '195342-93', '196451-91', '196715-91',
                             '197199-91', '198666-91', '200355-91',
                             '202465-91', '202465-92', '203054-91',
                             '106120-94', '108631-91', '111513-91',
                             '119022-91', '119022-92', '125551-91',
                             '129034-91', '129301-92', '12999-93', '130690-91',
                             '130690-92', '134481-91', '135777-91', '14053-91',
                             '204693-91', '205274-92', '207710-91',
                             '208480-91', '209493-91', '211186-91',
                             '213718-91', '214326-91', '215871-91',
                             '216506-92', '216506-91', '14053-92', '140715-91',
                             '144943-91', '148407-91', '148514-92',
                             '148703-91', '149045-91', '149646-92',
                             '152937-91', '154044-91', '154144-91',
                             '154218-91', '154449-92', '154611-93',
                             '154831-92', '155658-91', '155692-91',
                             '156168-92', '156208-91', '159666-91',
                             '224287-91', '22732-91', '24490-91', '26018-91',
                             '29248-91', '34954-91', '38912-91', '60212-91',
                             '64156-91', '77753-91', '81341-91', '85487-93',
                             '94950-91', '99199-91' )


SELECT LO.TYPE_CD, LO.CODE_TX , Lo.NAME_TX,*
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID --AND RD.DEF_ID = '105'
WHERE L.CODE_TX = '4171' AND Lo.TYPE_CD = 'DIV'


UPDATE dbo.LOAN
SET DIVISION_CODE_TX = '10', UPDATE_DT = GETDATE(),
UPDATE_USER_TX = 'INC0226582'
--SELECT * FROM dbo.LOAN
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0226582)



SELECT * FROM dbo.COLLATERAL_CODE
WHERE ID =  '511'