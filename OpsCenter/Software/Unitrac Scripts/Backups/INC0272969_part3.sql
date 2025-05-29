USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.ID INTO #tmpLoanEscrow
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
        AND L.NUMBER_TX IN ( '143070-03', '209011-01', '202634-01',
                             '200661-02', '195701-03', '206512-01',
                             '206749-01', '101219-01', '177618-01',
                             '194561-01', '156581-01', '185924-01',
                             '157685-02', '159034-02', '72109-01', '88571-01',
                             '108798-02', '219157-01', '30399-01', '216029-01',
                             '145811-01', '7000002-41', '100-52', '130930-01',
                             '21861-02', '24405-03', '28407-01', '59687-03',
                             '79950-01', '82806-01', '104736-04', '145811-01',
                             '161033-01', '171339-02', '183550-02',
                             '7000000-58', '7000000-77', '7000002-41',
                             '7000002-60', '7000003-77' )


UPDATE L
SET BRANCH_CODE_TX = 'ESCROW', UPDATE_DT = GETDATE(), LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'INC0272969'
--SELECT BRANCH_CODE_TX, *
FROM dbo.LOAN L 
WHERE L.ID IN (SELECT * FROM #tmpLoanEscrow)


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , ' INC0272969' , 'N' , 
 GETDATE() ,  1 , 
'Moved to ESCROW branch per ticket INC0272969', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT * FROM #tmpLoanEscrow)