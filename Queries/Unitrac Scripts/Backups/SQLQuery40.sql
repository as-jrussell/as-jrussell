USE UniTrac

SELECT
	L.LoanNumber_TX AS LoanNumber,
	O.LastName_TX AS O_LastName,
	O.FirstName_TX AS O_FirstName,
	O.MiddleInitial_TX AS O_MiddleInitial,
	--CustAddress
	O.Line1_TX AS OA_Line1,
	O.City_TX AS OA_City,
	O.State_TX AS OA_State,
	O.Zip_TX AS OA_Zip,
	--CustomerMatchResult
	O.CM_MatchOwnerId_TX AS OM_OwnerId,
	CASE WHEN ISNULL(O.CM_NameChanged_IN ,'N') = 'Y' THEN 1 ELSE 0 END AS OM_NameChanged,
	CASE WHEN ISNULL(O.CM_AddressChanged_IN ,'N') = 'Y' THEN 1 ELSE 0 END AS OM_AddressChanged
--CustomerMatchResult
--INTO 	#Customers
FROM 
	[LOAN_EXTRACT_TRANSACTION_DETAIL] L WITH(NOLOCK)
	JOIN [OWNER_EXTRACT_TRANSACTION_DETAIL] O WITH(NOLOCK) ON O.TRANSACTION_ID = L.TRANSACTION_ID 
												 AND O.SEQUENCE_ID = L.SEQUENCE_ID 
												 AND O.PURGE_DT IS NULL
												 AND O.TYPE_TX = 'Borrower'
WHERE 
	L.TRANSACTION_ID IN (SELECT TOP 1 [TRANSACTION].ID
FROM [TRANSACTION] WITH(NOLOCK) CROSS APPLY DATA.nodes('/Lender/Lender') As T2(Loc) WHERE DOCUMENT_ID = 1427346 AND PURGE_DT IS NULL and isnull(RELATE_TYPE_CD,'') != 'INFA'
)
	AND L.PURGE_DT IS NULL

If @Debug > 1
Begin
	Select 'Debug'='#Customers:',* From #Customers
End

SELECT 
		X.LoanNumber,
		X.DivisionID,
		X.LoanType,
		O_LastName,
		O_FirstName,
		O_MiddleInitial,
		OA_Line1,
		OA_City,
		OA_State,
		OA_Zip,
		CV_Year,
		CV_Make,
		CV_Model,
		CV_VIN,
		CA_CollateralAddress,
		CA_CollateralAddressLine1,
		CA_CollateralAddressLine2,
		CA_CollateralAddressCity,
		CA_CollateralAddressState,
		CA_CollateralAddressZip,
		CM_Description,
		X.LM_MatchStatus,
		X.CM_MatchStatus,
		CU.OM_NameChanged,
		CU.OM_AddressChanged,
		X.CM_DescriptionChanged,
		X.LM_EffectiveDateChanged,
		X.OriginalBalance,
		X.LoanBalance,
		X.LM_BalanceIncrease,
		X.LM_IsDropZeroBalance,
		X.LM_ReOccurance,
		X.C_BadData,
		X.LM_CPIInplace,
		X.CM_CPIInplace,
		X.CM_PayoffRelease,
		X.LoanEffectiveDate,
		CASE
			WHEN (LO.CODE_TX = '3' OR LO.CODE_TX = '8') AND ISNULL(CV_Year,'') <> '' THEN CV_Year + ' ' + CV_Make + '/' + CV_Model
			ELSE ''
		END AS PropertyDescriotion,
		CreditLine,
		CreditLineAmount,
		LoanCreditScore,
		X.C_LenderCollateralCode,
		LM_Officer,
		LM_ExtractUnmatchCount,
		CM_ExtractUnmatchCount,
		X.C_RetainIndicator,
		LM_MatchLoanId,
		CM_MatchCollateralId,
		CM_MatchPropertyId,
		C_MultiCollateral,
		LoanOfficerNumber,
		CU.OM_OwnerId,
		LO.CODE_TX as DivisionCode,
		X.BranchCode,
		X.LoanPayoffDate,
		X.C_CollateralCode,
		X.C_CollateralType,
		X.CE_EQRequiredCoverageAmt,
		X.C_CollateralNumber,								
		X.C_BorrowerInsCompanyName,
		X.C_BorrowerInsPolicyNumber,									
		X.LM_Balance_TX,
		X.LM_EffectiveDate												
INTO #EX
FROM #Loans X WITH(NOLOCK)
LEFT JOIN #Customers CU ON X.LoanNumber = CU.LoanNumber --AND CU.O_CustomerType = 'Borrower'
--LEFT JOIN #Collaterals CO ON X.LoanNumber = CO.LoanNumber AND (CM_MatchCollateralId > 0 OR ISNULL(CM_MatchStatus,'') = 'New')
left join LENDER_ORGANIZATION LO WITH(NOLOCK) on LO.ID = X.DivisionID and X.DivisionCode is not null



SELECT *
FROM #EX WITH(NOLOCK)
JOIN LENDER LND WITH(NOLOCK) on (/*@LenderID Is Null Or*/ LND.ID = @LenderID) and LND.PURGE_DT IS NULL
LEFT JOIN LOAN L WITH(NOLOCK) ON L.ID = #EX.LM_MatchLoanId and L.PURGE_DT IS NULL
LEFT JOIN OWNER_LOAN_RELATE OL WITH(NOLOCK) ON OL.LOAN_ID = L.ID AND OL.PRIMARY_IN = 'Y' AND OL.PURGE_DT IS NULL
LEFT JOIN [OWNER] O WITH(NOLOCK) ON O.ID = ISNULL(OL.OWNER_ID,#EX.OM_OwnerId) AND O.PURGE_DT IS NULL
OUTER APPLY
(select * from COLLATERAL C WITH(NOLOCK) where (    (#EX.CM_MatchCollateralId > 0 and C.ID = #EX.CM_MatchCollateralId) 
                                    or (C.LOAN_ID IS NULL)
								  )  
								  AND C.PURGE_DT IS NULL) C
LEFT JOIN PROPERTY P WITH(NOLOCK) ON P.ID = ISNULL(C.PROPERTY_ID,#EX.CM_MatchPropertyId) AND P.PURGE_DT IS NULL
LEFT JOIN [OWNER_ADDRESS] AM WITH(NOLOCK) ON AM.ID = P.ADDRESS_ID AND AM.PURGE_DT IS NULL
LEFT JOIN [OWNER_ADDRESS] AO WITH(NOLOCK) ON AO.ID = O.ADDRESS_ID AND AO.PURGE_DT IS NULL
LEFT JOIN [ADDRESS] AL WITH(NOLOCK) ON AL.ID = LND.PHYSICAL_ADDRESS_ID AND AL.PURGE_DT IS NULL
LEFT JOIN REQUIRED_COVERAGE RC WITH(NOLOCK) ON RC.PROPERTY_ID = P.ID AND RC.PURGE_DT IS NULL
--OUTER APPLY
--(SELECT TOP 1 * FROM dbo.GetCurrentCoverage(P.ID, RC.ID, RC.TYPE_CD)
--ORDER BY ISNULL(UNIT_OWNERS_IN, 'N') DESC
--) OP
--LEFT JOIN BORROWER_INSURANCE_AGENCY BIA WITH(NOLOCK) ON BIA.ID = OP.BIA_ID AND BIA.PURGE_DT IS NULL
LEFT JOIN PRIOR_CARRIER_POLICY PCP WITH(NOLOCK) ON PCP.REQUIRED_COVERAGE_ID = RC.ID and RC.SUMMARY_SUB_STATUS_CD = 'P' AND PCP.PURGE_DT IS NULL
OUTER APPLY
(SELECT FPC.* FROM FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCR WITH(NOLOCK) JOIN FORCE_PLACED_CERTIFICATE FPC WITH(NOLOCK) ON FPCR.FPC_ID = FPC.ID AND fpcr.REQUIRED_COVERAGE_ID = rc.ID AND FPC.ACTIVE_IN = 'Y' AND (FPC.LOAN_ID = L.ID OR FPC.LOAN_ID IS NULL) AND FPC.PURGE_DT IS NULL
WHERE FPCR.PURGE_DT IS NULL) FPC
LEFT JOIN CARRIER CR WITH(NOLOCK) on CR.ID = FPC.CARRIER_ID AND RC.SUMMARY_SUB_STATUS_CD = 'C' AND CR.PURGE_DT IS NULL
--LEFT JOIN CPI_QUOTE CPQ WITH(NOLOCK) ON CPQ.ID = FPC.CPI_QUOTE_ID and RC.SUMMARY_SUB_STATUS_CD = 'C' AND CPQ.PURGE_DT IS NULL
--LEFT JOIN CPI_ACTIVITY CPA WITH(NOLOCK) ON CPA.CPI_QUOTE_ID = CPQ.ID AND CPA.TYPE_CD = 'I'	and RC.SUMMARY_SUB_STATUS_CD = 'C' AND CPA.PURGE_DT IS NULL
--LEFT JOIN CERTIFICATE_DETAIL CDPRM WITH(NOLOCK) ON CDPRM.CPI_ACTIVITY_ID = CPA.ID AND CDPRM.TYPE_CD = 'PRM' AND RC.SUMMARY_SUB_STATUS_CD = 'C' AND CDPRM.PURGE_DT IS NULL
LEFT JOIN REF_CODE RC_COVERAGETYPE WITH(NOLOCK) ON RC_COVERAGETYPE.DOMAIN_CD = 'Coverage' and RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
LEFT JOIN COLLATERAL_CODE CC WITH(NOLOCK) ON CC.ID = C.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL
LEFT JOIN REF_CODE NRef WITH(NOLOCK) ON NRef.DOMAIN_CD = 'NoticeType' AND NRef.CODE_CD = RC.NOTICE_TYPE_CD
LEFT JOIN REF_CODE LSRef WITH(NOLOCK) ON LSRef.DOMAIN_CD = 'LoanStatus' AND LSRef.CODE_CD = L.STATUS_CD
LEFT JOIN REF_CODE CSRef WITH(NOLOCK) ON CSRef.DOMAIN_CD = 'CollateralStatus' AND CSRef.CODE_CD = C.STATUS_CD
LEFT JOIN REF_CODE RCSRef WITH(NOLOCK) ON RCSRef.DOMAIN_CD = 'RequiredCoverageStatus' AND RCSRef.CODE_CD = RC.STATUS_CD
LEFT JOIN REF_CODE RCISRef WITH(NOLOCK) ON RCISRef.DOMAIN_CD = 'RequiredCoverageInsStatus' AND RCISRef.CODE_CD = RC.SUMMARY_STATUS_CD
LEFT JOIN REF_CODE RCISSRef WITH(NOLOCK) ON RCISSRef.DOMAIN_CD = 'RequiredCoverageInsSubStatus' AND RCISSRef.CODE_CD = RC.SUMMARY_SUB_STATUS_CD
LEFT JOIN REF_CODE RCCCDIV WITH(NOLOCK) ON RCCCDIV.DOMAIN_CD = 'ContractType' AND RCCCDIV.CODE_CD = CC.CONTRACT_TYPE_CD AND RCCCDIV.PURGE_DT IS NULL	
LEFT JOIN REF_CODE RCDiv WITH(NOLOCK) ON RCDiv.DOMAIN_CD = 'ContractType' AND RCDiv.CODE_CD = ISNULL(L.DIVISION_CODE_TX,#EX.DivisionCode)		
left Join REF_CODE RC_SC WITH(NOLOCK) on RC_SC.DOMAIN_CD = 'SecondaryClassification' AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
left Join REF_CODE_ATTRIBUTE RCA_PROP WITH(NOLOCK) on RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD and RC_SC.CODE_CD = RCA_PROP.REF_CD and RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
)