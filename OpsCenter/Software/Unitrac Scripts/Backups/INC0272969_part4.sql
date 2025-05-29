USE [UniTrac]
GO 
--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT  L.ID
INTO    #tmpLoanEscrow
--SELECT BRANCH_CODE_TX, *
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX IN ( '4171' )
        AND L.NUMBER_TX IN ( '10058', '10058', '10612001', '10612001',
                             '1061206', '1061206', '11664401', '11664401',
                             '12400501', '12400501', '12400502', '12400502',
                             '12749902', '12749902', '1278401', '1278401',
                             '1292101', '1292101', '13410601', '13410601',
                             '13811801', '13811801', '13818001', '13818001',
                             '13890201', '13890201', '14232202', '14232202',
                             '14234101', '14234101', '14363802', '14363802',
                             '14568603', '14568603', '14687601', '14687601',
                             '15366901', '15366901', '15716501', '15716501',
                             '16124902', '16124902', '16289901', '16289901',
                             '16301003', '16301003', '1631501', '1631501',
                             '16316102', '16316102', '17036501', '17036501',
                             '1709401', '1709401', '17483302', '17483302',
                             '17617302', '17617302', '17656501', '17656501',
                             '17722901', '17722901', '18112101', '18112101',
                             '18886901', '18886901', '18980501', '18980501',
                             '19140003', '19140003', '19800301', '19800301',
                             '20145301', '20145301', '20424001', '20424001',
                             '20524502', '20524502', '20563501', '20563501',
                             '20614501', '20614501', '20663201', '20663201',
                             '20675501', '20675501', '20785801', '20785801',
                             '20815301', '20815301', '20874501', '20874501',
                             '20907601', '20907601', '21450001', '21450001',
                             '21502601', '21502601', '21548501', '21548501',
                             '21668501', '21668501', '3855401', '3855401',
                             '4766801', '4766801', '6305303', '6305303',
                             '6492503', '6492503', '700000040', '700000040',
                             '700000099', '700000099', '700000101',
                             '700000101', '700000130', '700000130',
                             '700000267', '700000267', '700000279',
                             '700000279', '700000415', '700000415',
                             '700000444', '700000444', '8339304', '8339304',
                             '8407001', '8407001', '8615101', '8615101',
                             '8823801', '8823801', '700000346' )


UPDATE L
SET BRANCH_CODE_TX = 'FICSNONESC', UPDATE_DT = GETDATE(), LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'INC0272969'
--SELECT BRANCH_CODE_TX, *
FROM dbo.LOAN L 
WHERE L.ID IN (SELECT * FROM #tmpLoanEscrow)


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , ' INC0272969' , 'N' , 
 GETDATE() ,  1 , 
'Moved to FICSNONESC branch per ticket INC0272969', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT * FROM #tmpLoanEscrow)


SELECT REPORT_ID,* FROM dbo.LENDER_REPORT_CONFIG LRC
JOIN dbo.REPORT_CONFIG RC ON RC.ID = LRC.REPORT_CONFIG_ID
WHERE LRC.LENDER_ID = '2275' AND LRC.DESCRIPTION_TX = 'Lender File Posting Errors Report'

SELECT * FROM dbo.REPORT
WHERE ID = '85'


SELECT * FROM dbo.LENDER_ORGANIZATION
WHERE LENDER_ID = '2275'