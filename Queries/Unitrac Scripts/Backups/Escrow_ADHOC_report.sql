/*
EXEC dbo.Report_Escrow @LenderCode = N'7545', -- nvarchar(10)
    @ReportType = N'ESCPRMDUE', -- nvarchar(50)
    @GroupByCode = N'L/B/C/C', -- nvarchar(50)
    @SortByCode = N'BorrowerName', -- nvarchar(50)
    @FilterByCode = N'', -- nvarchar(50)
    @SpecificReport = '', -- varchar(50)
    @Report_History_ID = 0 -- bigint
	*/


DECLARE @Regenerated as bit
DECLARE @ProcessLogID as bigint
DECLARE @WorkItemID as BIGINT
DECLARE @SpecificReport as varchar(50)=NULL
DECLARE @Coverage as nvarchar(100)=NULL
DECLARE @Division as nvarchar(10)=NULL
DECLARE @Branch AS nvarchar(max)=NULL
DECLARE @InsCompany as nvarchar(100)=NULL
Declare @RD_MISC1_ID as BIGINT


DECLARE @BranchTable AS TABLE(ID int, STRVALUE nvarchar(30))
			INSERT INTO @BranchTable SELECT * FROM SplitFunction(@Branch, ',')  

Select @RD_MISC1_ID = ID from RELATED_DATA_DEF where NAME_TX = 'Misc1'
SET @SpecificReport ='ESCPRMDUE'

	SELECT @Regenerated = 
		CASE WHEN WI.CONTENT_XML.value('(/Content/Escrow/Regenerated)[1]', 'nvarchar(10)') = 'YES' THEN 'True' ELSE 'False' END 
	FROM WORK_ITEM WI 
	WHERE WI.ID = 28231952

SELECT E.REPORTED_DT,e.id,*
from WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR 
Join PROCESS_LOG_ITEM PLI ON WIPLIR.PROCESS_LOG_ITEM_ID = PLI.ID and PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Escrow' and PLI.Purge_DT IS NULL
Join ESCROW E on PLI.RELATE_ID = E.ID AND E.PURGE_DT IS NULL AND E.REPORTED_DT IS NOT NULL
JOIN PROPERTY P ON E.PROPERTY_ID = P.ID AND P.PURGE_DT IS NULL
Join COLLATERAL C on C.PROPERTY_ID = P.ID AND C.PURGE_DT IS NULL
Join LOAN L on L.ID = C.LOAN_ID and L.LENDER_ID = P.LENDER_ID AND L.PURGE_DT IS NULL
Join LENDER LND on LND.ID = L.LENDER_ID AND LND.PURGE_DT IS NULL
left JOIN LENDER_ORGANIZATION LO ON LO.LENDER_ID = L.LENDER_ID AND LO.TYPE_CD = 'BRCH' AND LO.CODE_TX = L.BRANCH_CODE_TX and LO.PURGE_DT is null
Join OWNER_LOAN_RELATE OL on OL.LOAN_ID = L.ID AND OL.PRIMARY_IN = 'Y' AND OL.PURGE_DT IS NULL
Join [OWNER] O on O.ID = OL.OWNER_ID AND O.PURGE_DT IS NULL
left Join OWNER_ADDRESS AO on AO.ID = O.ADDRESS_ID AND AO.PURGE_DT IS NULL
left Join OWNER_ADDRESS AM on AM.ID = P.ADDRESS_ID AND AM.PURGE_DT IS NULL
left Join [ADDRESS] AE on AE.ID = E.REMITTANCE_ADDR_ID and AE.PURGE_DT IS NULL

OUTER APPLY 
(
	SELECT TOP 1 ESCROW_REQUIRED_COVERAGE_RELATE.* 
	FROM ESCROW_REQUIRED_COVERAGE_RELATE
	JOIN REQUIRED_COVERAGE ON REQUIRED_COVERAGE.ID = ESCROW_REQUIRED_COVERAGE_RELATE.REQUIRED_COVERAGE_ID 
		AND ((@Coverage IS NULL OR @Coverage ='1') OR @Coverage = REQUIRED_COVERAGE.TYPE_CD)
		AND REQUIRED_COVERAGE.PURGE_DT IS NULL
	WHERE E.ID = ESCROW_REQUIRED_COVERAGE_RELATE.ESCROW_ID AND ESCROW_REQUIRED_COVERAGE_RELATE.PURGE_DT IS NULL 
	ORDER BY CASE WHEN REQUIRED_COVERAGE.TYPE_CD = 'HAZARD' THEN 0 ELSE 1 END
) AS ERCR

left Join REQUIRED_COVERAGE RC on ERCR.REQUIRED_COVERAGE_ID = RC.ID AND RC.PURGE_DT IS NULL
left Join BORROWER_INSURANCE_COMPANY BIC on BIC.ID = E.BIC_ID AND BIC.PURGE_DT IS NULL
LEFT JOIN BORROWER_INSURANCE_AGENCY BIA ON BIA.ESCROW_REMITTANCE_ADDRESS_ID = E.REMITTANCE_ADDR_ID AND BIA.PURGE_DT IS NULL
LEFT Join RELATED_DATA RD on RD.RELATE_ID = L.ID and DEF_ID = @RD_MISC1_ID

OUTER APPLY
(
	SELECT TOP 1 LM.ID, LF.PAYEE_CODE_TX 
	FROM LENDER_PAYEE_CODE_MATCH LM 
	JOIN LENDER_PAYEE_CODE_FILE LF ON LF.ID = LM.LENDER_PAYEE_CODE_FILE_ID
	WHERE LF.LENDER_ID = L.LENDER_ID AND LF.AGENCY_ID = L.AGENCY_ID
	AND LM.REMITTANCE_ADDR_ID = E.REMITTANCE_ADDR_ID
	AND (LM.BIC_ID = E.BIC_ID OR LM.REMITTANCE_TYPE_CD = 'BIA')
	AND LM.PRIMARY_IN = 'Y'   
	AND (LF.BRCH_LENDER_ORG_ID = LO.ID 
		OR ISNULL(LF.BRCH_LENDER_ORG_ID ,0) = 0)
	AND LF.PURGE_DT IS NULL 
	AND LM.PURGE_DT IS NULL
	ORDER BY LF.BRCH_LENDER_ORG_ID DESC
) AS PC	
	
OUTER APPLY
(		
	SELECT TOP 1 esc.PAYEE_CODE_TX
	FROM REQUIRED_COVERAGE rc1
	JOIN ESCROW_REQUIRED_COVERAGE_RELATE escrel ON escrel.REQUIRED_COVERAGE_ID = rc1.ID AND rc1.PROPERTY_ID = RC.PROPERTY_ID
	JOIN ESCROW esc ON esc.ID = escrel.ESCROW_ID
	WHERE rc1.ID = rc.ID
	AND e.Id <> esc.ID
	AND esc.PURGE_DT IS NULL
	AND escrel.PURGE_DT IS NULL
	AND esc.TYPE_CD = e.TYPE_CD
	AND esc.SUB_TYPE_CD = e.SUB_TYPE_CD
	AND esc.EXCESS_IN = e.EXCESS_IN
	AND (esc.STATUS_CD = 'CLSE'
	AND esc.SUB_STATUS_CD IN ('RPTD', 'LNDRPAID', 'INHSPAID', 'BWRPAID' ))
	ORDER BY ISNULL(esc.END_DT, DATEADD(MONTH, 12, esc.DUE_DT)) DESC
) AS PREV_ESCROW

left Join REF_CODE NRef on NRef.DOMAIN_CD = 'NoticeType' and NRef.CODE_CD = RC.NOTICE_TYPE_CD 
left Join REF_CODE LSRef on LSRef.DOMAIN_CD = 'LoanStatus' and LSRef.CODE_CD = L.STATUS_CD 
left Join REF_CODE CSRef on CSRef.DOMAIN_CD = 'CollateralStatus' and CSRef.CODE_CD = C.STATUS_CD 
left Join REF_CODE RCSRef on RCSRef.DOMAIN_CD = 'RequiredCoverageStatus' and RCSRef.CODE_CD = RC.STATUS_CD 
left Join REF_CODE RCISRef on RCISRef.DOMAIN_CD = 'RequiredCoverageInsStatus' and RCISRef.CODE_CD = RC.SUMMARY_STATUS_CD 
left Join REF_CODE RCISSRef on RCISSRef.DOMAIN_CD = 'RequiredCoverageInsSubStatus' and RCISSRef.CODE_CD = RC.SUMMARY_SUB_STATUS_CD 
left Join REF_CODE RC_DIVISION on RC_DIVISION.DOMAIN_CD = 'ContractType' and RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
left Join REF_CODE RC_COVERAGETYPE on RC_COVERAGETYPE.DOMAIN_CD = 'Coverage' and RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD 
LEFT JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
left Join REF_CODE RC_SC on RC_SC.DOMAIN_CD = 'SecondaryClassification' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left Join REF_CODE_ATTRIBUTE RCA_PROP on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
CROSS APPLY dbo.fn_FilterCollateralByDivisionCd(C.ID, @Division) fn_FCBD
where 
WIPLIR.WORK_ITEM_ID = 28231952 AND WIPLIR.PURGE_DT IS NULL AND
L.RECORD_TYPE_CD = 'G' and P.RECORD_TYPE_CD = 'G' and RC.RECORD_TYPE_CD = 'G' and E.RECORD_TYPE_CD = 'G' and
L.EXTRACT_UNMATCH_COUNT_NO = 0 and C.EXTRACT_UNMATCH_COUNT_NO = 0 and
L.STATUS_CD != 'U' and C.STATUS_CD != 'U' and
C.PRIMARY_LOAN_IN = 'Y' AND 
P.PURGE_DT IS NULL AND	
P.LENDER_ID = 1920
AND (L.BRANCH_CODE_TX IN (SELECT STRVALUE FROM @BranchTable) or @Branch = '1' or @Branch = '' or @Branch is NULL)
AND fn_FCBD.loanType IS NOT NULL
AND (RC.TYPE_CD = @Coverage or @Coverage = '1' or @Coverage is NULL)
AND (E.BIC_ID = @InsCompany or @InsCompany = 0 or @InsCompany = '' or @InsCompany is NULL)
and  (E.REPORTED_DT BETWEEN '2015-12-04 09:14:08.010' and '2015-12-11 11:54:55.500')
and 
((@Regenerated = 'True' and @SpecificReport <> 'ESCREJECT' and ISNULL(PLI.INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]','varchar(20)') , '') = 'Approve') or @Regenerated = 'False')
	
