USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT l.number_tx, pcp.*
--into unitrachdstorage..INC0446657
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
inner join [UniTrac].[dbo].[PRIOR_CARRIER_POLICY] pcp on pcp.required_coverage_id = rc.id
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX = '7365' 
and CPI_STATUS_CD = 'F' and CPI_SUB_STATUS_CD = 'P'
and PCP.effective_dt <= '2019-08-01' and PCP.EXPIRATION_DT >= '2019-08-01' 


update pcp set cancellation_dt = '2019-08-01', update_dt= GETDATE(), update_user_tx = 'INC0446657', pcp.LOCK_ID = CASE WHEN pcp.LOCK_ID >= 255 THEN 1 ELSE pcp.LOCK_ID + 1 END
--select *
from [PRIOR_CARRIER_POLICY] pcp 
join unitrachdstorage..INC0446657 i on i.id = pcp.id

update rc set GOOD_THRU_DT = NULL ,  update_dt= GETDATE(), update_user_tx = 'INC0446657', rc.LOCK_ID = CASE WHEN rc.LOCK_ID >= 255 THEN 1 ELSE rc.LOCK_ID + 1 END
--select GOOD_THRU_DT, *
from required_coverage rc 
where id in (select required_coverage_id from unitrachdstorage..INC0446657)



SELECT  RC.TYPE_CD ,
        RC1.DESCRIPTION_TX [Coverage Status] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,
		CONCAT(RC6.DESCRIPTION_TX, ' ', RC5.DESCRIPTION_TX) AS [Insurance Coverage Status],
        L.EFFECTIVE_DT ,
        L.NUMBER_TX ,
        L.BRANCH_CODE_TX [Branch Code] ,
        PCP.effective_dt, pcp.EXPIRATION_DT
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
        LEFT JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
        LEFT JOIN dbo.REF_CODE RC5 ON RC5.CODE_CD = RC.INSURANCE_STATUS_CD
                                       AND RC5.DOMAIN_CD = 'RequiredCoverageInsStatus'
        LEFT JOIN dbo.REF_CODE RC6 ON RC6.CODE_CD = RC.INSURANCE_SUB_STATUS_CD
                                       AND RC6.DOMAIN_CD = 'RequiredCoverageInsSubStatus'
        LEFT JOIN dbo.REF_CODE RC7 ON RC7.CODE_CD = RC.SUB_STATUS_CD
                                       AND RC7.DOMAIN_CD = 'RequiredCoverageSubStatus'
		LEFT JOIN dbo.LENDER_ORGANIZATION LO ON LO.LENDER_ID = LL.ID 
									    AND LO.TYPE_CD = 'DIV' AND LO.CODE_TX = L.DIVISION_CODE_TX							   
                                        
inner join [UniTrac].[dbo].[PRIOR_CARRIER_POLICY] pcp on pcp.required_coverage_id = rc.id
WHERE LL.CODE_TX = '7365' 
and CPI_STATUS_CD = 'F' and CPI_SUB_STATUS_CD = 'P'
and PCP.effective_dt <= '2019-08-01' and PCP.EXPIRATION_DT >= '2019-08-01' 


