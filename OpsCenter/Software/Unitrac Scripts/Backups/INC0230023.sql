USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT TOP 10 RC.TYPE_CD ,
        RC1.DESCRIPTION_TX [Coverage Status] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,
        L.EFFECTIVE_DT ,
        L.NUMBER_TX ,
        L.BRANCH_CODE_TX [Branch Code] ,
        RC.ID [RC_ID] ,
        L.ID [LoanID]
--INTO    UniTracHDStorage..AAAINC0230023
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.LENDER_PRODUCT LP ON LP.ID = RC.LENDER_PRODUCT_ID
        INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.STATUS_CD
                                       AND RC1.DOMAIN_CD = 'RequiredCoverageStatus'
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
WHERE   LL.CODE_TX IN ( '2982' )
        AND L.BRANCH_CODE_TX IN ( '924', '924E' )
        AND PURPOSE_CODE_TX NOT IN ( 'CONDO', 'CONDOE' )
       AND RC.ID IN ( SELECT   RC_ID
                           FROM     UniTracHDStorage..AAAINC0230023 )	
    
	
/*

UPDATE  dbo.REQUIRED_COVERAGE
SET     STATUS_CD = 'A' ,
        UPDATE_DT = GETDATE() ,
        LOCK_ID = LOCK_ID + 1 ,
        UPDATE_USER_TX = 'INC0230023'
--SELECT * FROM dbo.REQUIRED_COVERAGE
WHERE   ID IN ( SELECT  RC_ID
                FROM    UniTracHDStorage..AAAINC0230023 )	
	
INSERT  INTO PROPERTY_CHANGE
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
                RC.ID ,
                'INC0230023' ,
                'N' ,
                GETDATE() ,
                1 ,
                'Moved Status From Tracking to Active' ,
                'Y' ,
                'N' ,
                1 ,
                'Allied.UniTrac.RequiredCoverage' ,
                RC.ID ,
                'PEND' ,
                'N'
        FROM    REQUIRED_COVERAGE RC
                INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
                INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
                INNER JOIN LOAN L ON L.ID = C.LOAN_ID
        WHERE   RC.ID IN ( SELECT   RC_ID
                           FROM     UniTracHDStorage..AAAINC0230023 )	
	
	
*/	 



--SELECT  *
--FROM    dbo.COLLATERAL_CODE
--WHERE   DESCRIPTION_TX LIKE '%%'
--        AND AGENCY_ID = '1'
--        AND ID IN (  )



--SELECT LO.TYPE_CD, LO.CODE_TX , Lo.NAME_TX,*
--FROM LENDER L
--INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
--INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID --AND RD.DEF_ID = '105'
--WHERE L.CODE_TX = '2982' AND LO.CODE_TX IN ('924', '924E')




--SELECT  * FROM dbo.LENDER_PRODUCT
--WHERE --ID IN (8459,8458,8457,8456,8459)

--LENDER_ID = '2257'


--SELECT * FROM dbo.LENDER
--WHERE CODE_TX = '2982'