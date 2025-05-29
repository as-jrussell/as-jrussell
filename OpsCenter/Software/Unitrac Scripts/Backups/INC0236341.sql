USE [UniTrac]
GO 



--  add owner,  date CPI funded 
--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT 
		DISTINCT p.ID
INTO #tmp
--SELECT COUNT(*)
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
		INNER JOIN dbo.REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
		INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX = '2106'




SELECT DISTINCT
		L.EFFECTIVE_DT [Loan Effective Date] ,
        IH.EFFECTIVE_DT [Refund Date] ,
				IH.SPECIAL_HANDLING_XML.value('(/SH/MailDate)[1]', 'varchar (50)') [Mailed] ,
        IH.SPECIAL_HANDLING_XML.value('(/SH/Reason)[1]', 'varchar (50)') [Refund Reason] ,

        L.NUMBER_TX ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,
        LO.NAME_TX [Division Code] ,
        L.BRANCH_CODE_TX ,
        O.LAST_NAME_TX ,
        O.FIRST_NAME_TX ,
        OA.LINE_1_TX ,
        OA.LINE_2_TX ,
        OA.CITY_TX ,
        OA.STATE_PROV_TX ,
        OA.COUNTRY_TX ,
        OA.POSTAL_CODE_TX
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
        INNER JOIN LENDER_ORGANIZATION LO ON LL.ID = LO.LENDER_ID
                                             AND LO.CODE_TX IN ( '3' )
                                             AND LO.TYPE_CD = 'DIV'
WHERE   ih.TYPE_CD = 'cpI'
        AND P.ID IN ( SELECT    *
                      FROM      #tmp )
        AND IH.EFFECTIVE_DT <= '2016-06-27 '
        AND IH.EFFECTIVE_DT >= '2015-01-01 '
        AND RC.CPI_STATUS_CD = 'F'





