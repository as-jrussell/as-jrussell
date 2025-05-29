


--SELECT
--	LoanNumber_TX AS LoanNumber,
--	ContractStatus_TX AS ContractStatus,
--	BranchName_TX AS BranchName,
--	BranchCode_TX AS BranchCode,
--	DivisionName_TX AS DivisionName,
--	DivisionID_TX AS DivisionID,
--	DivisionCode_TX AS DivisionCode,
--	LoanEffectiveDate_DT AS LoanEffectiveDate,
--	LoanExpirationDate_DT AS LoanExpirationDate,
--	LoanTerm_TX AS LoanTerm,
--	LoanType_TX AS LoanType,
--	APR_TX AS APR,
--	InterestRate_TX AS InterestRate,
--	Margin_TX AS Margin,
--	LoanIndex_TX AS LoanIndex,
--	NextRateChangeDate_DT AS NextRateChangeDate,
--	Balloon_IN,'N' AS Balloon,
--	PaymentFrequency_TX AS PaymentFrequency,
--	DropZeroBalanceID_TX AS DropZeroBalanceID,
--	DropZeroBalance_TX AS DropZeroBalance,
--	LoanOfficerName_TX AS LoanOfficerName,
--	LoanOfficerTitle_TX AS LoanOfficerTitle,
--	LoanOfficerPhone_TX AS LoanOfficerPhone,
--	LoanOfficerFax_TX AS LoanOfficerFax,
--	LoanOfficerEmail_TX AS LoanOfficerEmail,
--	LoanOfficerNumber_TX AS LoanOfficerNumber,
--	LoanDealerName_TX AS LoanDealerName,
--	LoanDealerTitle_TX AS LoanDealerTitle,
--	LoanDealerPhone_TX AS LoanDealerPhone,
--	LoanDealerFax_TX AS LoanDealerFax,
--	LoanDealerEmail_TX AS LoanDealerEmail,
--	LoanDealerNumber_TX AS LoanDealerNumber,
--	CASE WHEN ISNULL(Escrow_IN,'N') = 'Y' THEN 1 ELSE 0 END AS Escrow,
--	LoanBalance_TX AS LoanBalance,
--	OriginalBalance_TX AS OriginalBalance,
--	CreditLineAmount_TX AS CreditLineAmount,
--	CASE WHEN ISNULL(CreditLine_IN,'N') = 'Y' THEN 1 ELSE 0 END  CreditLine,
--	LoanCreditScore_TX AS LoanCreditScore,
--	RepaymentMethod_TX AS RepaymentMethod,
--	CurrentPaymentAmount_TX AS CurrentPaymentAmount,
--	PaymentFrequencyCode_TX AS PaymentFrequencyCode,
--	OriginalPaymentAmount_TX AS OriginalPaymentAmount,
--	PaymentEffectiveDate_DT AS PaymentEffectiveDate,
--	NextScheduledPaymentDate_DT AS NextScheduledPaymentDate,
--	LastPaymentReceivedDate_DT AS LastPaymentReceivedDate,
--	DueNotPaidAmount_TX AS DueNotPaidAmount,
--	LoanPayoffDate_DT AS LoanPayoffDate,
--	NonAccrualDate_DT As NonAccrualDate,
--	LTV_TX AS LTV,
--	L.ExtractUnmatchCount_NO AS ExtractUnmatchCount,
--	RecordTypeCode_TX AS RecordTypeCode,
--	PartialPayBalance_TX AS PartialPayBalance,
--	Misc1_Tx AS Misc1,
--	Misc2_TX AS Misc2,
--	Misc3_TX AS Misc3,
--	Misc4_TX As Misc4,
----LoanMatchResult
--	LM_MatchLoanId_TX AS LM_MatchLoanId,
--	LM_MatchStatus_TX AS LM_MatchStatus,
--	LM_ExtractUnmatchCount_NO AS LM_ExtractUnmatchCount,
--	CASE WHEN ISNULL(LM_APRChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END  AS LM_APRChanged,
--	LM_APR_NO AS LM_APR,
--	CASE WHEN ISNULL(LM_IsDropZeroBalance_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_IsDropZeroBalance,
--	CASE WHEN ISNULL(LM_DealerChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_DealerChanged,
--	LM_Dealer_TX AS LM_Dealer,
--	CASE WHEN ISNULL(LM_EffectiveDateChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_EffectiveDateChanged,
--	LM_EffectiveDate_DT AS LM_EffectiveDate,
--	CASE WHEN ISNULL(LM_ExpirationDateChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_ExpirationDateChanged,
--	LM_ExpirationDate_DT AS LM_ExpirationDate,
--	CASE WHEN ISNULL(LM_OfficerChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_OfficerChanged,
--	LM_Officer_TX AS LM_Officer,
--	CASE WHEN ISNULL(LM_PayoffDateChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_PayoffDateChanged,
--	LM_PayoffDate_DT AS LM_PayoffDate,
--	CASE WHEN ISNULL(LM_ReOccurance_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_ReOccurance,
--	CASE WHEN ISNULL(LM_BalanceIncrease_IN,'N') = 'Y' THEN 1 ELSE 0 END LM_BalanceIncrease,
--	CASE WHEN ISNULL(LM_BalanceDecrease_IN,'N') = 'Y' THEN 1 ELSE 0 END LM_BalanceDecrease,
--	CASE WHEN ISNULL(LM_CPIInplace_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_CPIInplace,
--	CASE WHEN ISNULL(LM_BalanceChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_BalanceChanged,
--	LM_LoanChanged_IN AS LM_LoanChanged,
--	CASE WHEN ISNULL(LM_CreditLineChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_CreditLineChanged,
--	LM_CreditLine_TX AS LM_CreditLine,
--	CASE WHEN ISNULL(LM_CreditLineAmountChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_CreditLineAmountChanged,
--	LM_CreditLineAmount_TX AS LM_CreditLineAmount,
--	CASE WHEN ISNULL(LM_CurrentPaymentAmountChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_CurrentPaymentAmountChanged,
--	LM_CurrentPaymentAmount_TX AS LM_CurrentPaymentAmount,
--	CASE WHEN ISNULL(LM_EscrowChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_EscrowChanged,
--	CASE WHEN ISNULL(LM_Misc1Changed_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_Misc1Changed,
--	CASE WHEN ISNULL(LM_Misc2Changed_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_Misc2Changed,
--	CASE WHEN ISNULL(LM_Misc3Changed_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_Misc3Changed,
--	CASE WHEN ISNULL(LM_Misc4Changed_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_Misc4Changed,
--	CASE WHEN ISNULL(LM_NextScheduledPaymentDateChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_NextScheduledPaymentDateChanged,
--	LM_NextScheduledPaymentDate_DT AS LM_NextScheduledPaymentDate,
--	CASE WHEN ISNULL(LM_OriginalBalanceChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_OriginalBalanceChanged,
--	LM_OriginalBalance_TX AS LM_OriginalBalance,
--	CASE WHEN ISNULL(LM_OriginalPaymentAmountChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_OriginalPaymentAmountChanged,
--	LM_OriginalPaymentAmount_TX AS LM_OriginalPaymentAmount,
--	CASE WHEN ISNULL(LM_PaymentEffectiveDateChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_PaymentEffectiveDateChanged,
--	LM_PaymentEffectiveDate_DT AS LM_PaymentEffectiveDate,
--	CASE WHEN ISNULL(LM_PaymentFrequencyChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_PaymentFrequencyChanged,
--	LM_PaymentFrequency_TX AS LM_PaymentFrequency,
--	CASE WHEN ISNULL(LM_PartialPayBalanceChanged_IN,'N') = 'Y' THEN 1 ELSE 0 END As LM_PartialPayBalanceChanged,
--	CASE WHEN ISNULL(LM_Changed_IN,'N') = 'Y' THEN 1 ELSE 0 END AS LM_Changed,
--	LM_Balance_TX AS LM_Balance_TX,
--	C.LenderCollateralCode_TX AS C_LenderCollateralCode,
--	C.CollateralCode_TX AS C_CollateralCode,
--	C.CollateralType_TX AS C_CollateralType,
--	CASE
--		WHEN Cast(C.CollateralNumber_TX As Int) NOT BETWEEN 1 AND CollCount.value
--			THEN CollCount.value
--		WHEN 1 <> IsNumeric(IsNull(RTrim(C.CollateralNumber_TX), ''))
--			THEN CollCount.value
--		WHEN LM_MatchStatus_TX = 'Match' and CM_MatchStatus_TX = 'New'
--			THEN CollCount.value -- (Select COUNT(*) from COLLATERAL where EXTRACT_UNMATCH_COUNT_NO = 0 and STATUS_CD <> 'U' and PURGE_DT IS NULL and LOAN_ID = LM_MatchLoanId_TX)
--		WHEN Cast(C.CollateralNumber_TX As Int) BETWEEN 1 AND CollCount.value
--			THEN Cast(C.CollateralNumber_TX As Int)
--		ELSE Cast(C.CollateralNumber_TX As Int)
--	END AS C_CollateralNumber,
--	C_CollateralNumberFix = Cast(C.CollateralNumber_TX As Int),
--	CASE WHEN ISNULL(C.BadData_IN,'N') = 'Y' THEN 1 ELSE 0 END AS C_BadData,
--	CASE WHEN ISNULL(C.MultiCollateral_IN,'N') = 'Y' THEN 1 ELSE 0 END AS C_MultiCollateral,
----CollateralMatchResult
--	C.CM_MatchCollateralId_TX AS CM_MatchCollateralId,
--	C.CM_MatchPropertyId_TX AS CM_MatchPropertyId,
--	C.CM_MatchStatus_TX AS CM_MatchStatus,
--	CASE WHEN ISNULL(C.CM_CPIInplace_IN,'N') = 'Y' THEN 1 ELSE 0 END AS CM_CPIInplace,
--	CASE WHEN ISNULL(C.CM_PayoffRelease_IN,'N') = 'Y' THEN 1 ELSE 0 END AS CM_PayoffRelease,
--	CASE WHEN ISNULL(C.CM_DescriptionChanged_IN ,'N') = 'Y' AND COALESCE(C.CM_Description_TX, '') <> '' THEN 1 ELSE 0 END AS CM_DescriptionChanged,
--	C.EquipmentDescription_TX AS CM_Description,
--	--Vehicle
--	C.VehicleVIN_TX AS CV_VIN,				
--	C.VehicleYear_TX AS CV_Year,
--	C.VehicleMake_TX AS CV_Make,			
--	C.VehicleModel_TX AS CV_Model,			
--	--RealEstateProperty
--	C.RealEstateLine1_TX + ' ' + C.RealEstateLine2_TX + ' ' + C.RealEstateCity_TX + ' ' + C.RealEstateState_TX + ' ' + C.RealEstateZip_TX AS CA_CollateralAddress,
--	C.RealEstateLine1_TX AS CA_CollateralAddressLine1,
--	C.RealEstateLine2_TX AS CA_CollateralAddressLine2,
--	C.RealEstateCity_TX AS CA_CollateralAddressCity,
--	C.RealEstateState_TX AS CA_CollateralAddressState,
--	C.RealEstateZip_TX AS CA_CollateralAddressZip,
--	CASE WHEN C.EquipmentRequiredCoverageAmt_TX IS NULL THEN 0 ELSE convert(decimal(19,2),C.EquipmentRequiredCoverageAmt_TX) END AS CE_EQRequiredCoverageAmt,
--	--Equipment
--	C.BorrInsCompanyName_TX AS C_BorrowerInsCompanyName,
--	C.BorrInsPolicyNumber_TX AS C_BorrowerInsPolicyNumber,
--	C.CM_ExtractUnmatchCount_NO AS CM_ExtractUnmatchCount,
--	CASE WHEN ISNULL(C.Retain_IN ,'N') = 'Y' THEN 1 ELSE 0 END AS C_RetainIndicator

--INTO 
--	#Loans
--FROM
--	[LOAN_EXTRACT_TRANSACTION_DETAIL] L WITH(NOLOCK)
--	JOIN [COLLATERAL_EXTRACT_TRANSACTION_DETAIL] C WITH(NOLOCK) ON C.TRANSACTION_ID = L.TRANSACTION_ID 
--													  AND C.SEQUENCE_ID = L.SEQUENCE_ID 
--													  AND C.PURGE_DT IS NULL
--	CROSS APPLY (Select value=COUNT(*) from COLLATERAL As c2 with(nolock) where c2.EXTRACT_UNMATCH_COUNT_NO = 0 and c2.STATUS_CD <> 'U' and c2.PURGE_DT IS NULL and c2.LOAN_ID = LM_MatchLoanId_TX) As CollCount
--WHERE 
--	L.TRANSACTION_ID IN (SELECT MAX(T.RELATED_TRANSACTION_ID) FROM dbo.[TRANSACTION] T
--	JOIN dbo.DOCUMENT D ON D.ID = T.DOCUMENT_ID
--	JOIN dbo.MESSAGE M ON M.ID = D.MESSAGE_ID
--	JOIN dbo.TRADING_PARTNER TP ON TP.ID = M.RECEIVED_FROM_TRADING_PARTNER_ID
--	WHERE TP.ID = 2270)	and
--	 NOT(LM_MatchStatus_TX = 'New' and LM_IsDropZeroBalance_IN = 'Y')		
--	AND L.PURGE_DT IS NULL	


--SELECT
--	L.LoanNumber_TX AS LoanNumber,
--	O.LastName_TX AS O_LastName,
--	O.FirstName_TX AS O_FirstName,
--	O.MiddleInitial_TX AS O_MiddleInitial,
--	--CustAddress
--	O.Line1_TX AS OA_Line1,
--	O.City_TX AS OA_City,
--	O.State_TX AS OA_State,
--	O.Zip_TX AS OA_Zip,
--	--CustomerMatchResult
--	O.CM_MatchOwnerId_TX AS OM_OwnerId,
--	CASE WHEN ISNULL(O.CM_NameChanged_IN ,'N') = 'Y' THEN 1 ELSE 0 END AS OM_NameChanged,
--	CASE WHEN ISNULL(O.CM_AddressChanged_IN ,'N') = 'Y' THEN 1 ELSE 0 END AS OM_AddressChanged
----CustomerMatchResult
--INTO 
--	#Customers
--FROM 
--	[LOAN_EXTRACT_TRANSACTION_DETAIL] L WITH(NOLOCK)
--	JOIN [OWNER_EXTRACT_TRANSACTION_DETAIL] O WITH(NOLOCK) ON O.TRANSACTION_ID = L.TRANSACTION_ID 
--												 AND O.SEQUENCE_ID = L.SEQUENCE_ID 
--												 AND O.PURGE_DT IS NULL
--												 AND O.TYPE_TX = 'Borrower'
--WHERE 
--	L.TRANSACTION_ID IN (SELECT MAX(T.RELATED_TRANSACTION_ID) FROM dbo.[TRANSACTION] T
--	JOIN dbo.DOCUMENT D ON D.ID = T.DOCUMENT_ID
--	JOIN dbo.MESSAGE M ON M.ID = D.MESSAGE_ID
--	JOIN dbo.TRADING_PARTNER TP ON TP.ID = M.RECEIVED_FROM_TRADING_PARTNER_ID
--	WHERE TP.ID = 2270)
--	AND L.PURGE_DT IS NULL

--SELECT 
--		X.LoanNumber,
--		X.DivisionID,
--		X.LoanType,
--		O_LastName,
--		O_FirstName,
--		O_MiddleInitial,
--		OA_Line1,
--		OA_City,
--		OA_State,
--		OA_Zip,
--		CV_Year,
--		CV_Make,
--		CV_Model,
--		CV_VIN,
--		CA_CollateralAddress,
--		CA_CollateralAddressLine1,
--		CA_CollateralAddressLine2,
--		CA_CollateralAddressCity,
--		CA_CollateralAddressState,
--		CA_CollateralAddressZip,
--		CM_Description,
--		X.LM_MatchStatus,
--		X.CM_MatchStatus,
--		CU.OM_NameChanged,
--		CU.OM_AddressChanged,
--		X.CM_DescriptionChanged,
--		X.LM_EffectiveDateChanged,
--		X.OriginalBalance,
--		X.LoanBalance,
--		X.LM_BalanceIncrease,
--		X.LM_IsDropZeroBalance,
--		X.LM_ReOccurance,
--		X.C_BadData,
--		X.LM_CPIInplace,
--		X.CM_CPIInplace,
--		X.CM_PayoffRelease,
--		X.LoanEffectiveDate,
--		CASE
--			WHEN (LO.CODE_TX = '3' OR LO.CODE_TX = '8') AND ISNULL(CV_Year,'') <> '' THEN CV_Year + ' ' + CV_Make + '/' + CV_Model
--			ELSE ''
--		END AS PropertyDescriotion,
--		CreditLine,
--		CreditLineAmount,
--		LoanCreditScore,
--		X.C_LenderCollateralCode,
--		LM_Officer,
--		LM_ExtractUnmatchCount,
--		CM_ExtractUnmatchCount,
--		X.C_RetainIndicator,
--		LM_MatchLoanId,
--		CM_MatchCollateralId,
--		CM_MatchPropertyId,
--		C_MultiCollateral,
--		LoanOfficerNumber,
--		CU.OM_OwnerId,
--		LO.CODE_TX as DivisionCode,
--		X.BranchCode,
--		X.LoanPayoffDate,
--		X.C_CollateralCode,
--		X.C_CollateralType,
--		X.CE_EQRequiredCoverageAmt,
--		X.C_CollateralNumber,								
--		X.C_BorrowerInsCompanyName,
--		X.C_BorrowerInsPolicyNumber,									
--		X.LM_Balance_TX,
--		X.LM_EffectiveDate												
--INTO #EX
--FROM #Loans X WITH(NOLOCK)
--LEFT JOIN #Customers CU ON X.LoanNumber = CU.LoanNumber --AND CU.O_CustomerType = 'Borrower'
----LEFT JOIN #Collaterals CO ON X.LoanNumber = CO.LoanNumber AND (CM_MatchCollateralId > 0 OR ISNULL(CM_MatchStatus,'') = 'New')
--left join LENDER_ORGANIZATION LO WITH(NOLOCK) on LO.ID = X.DivisionID and X.DivisionCode is not null

SELECT
CASE WHEN #EX.LM_MatchStatus = 'Unmatch' OR (L.EXTRACT_UNMATCH_COUNT_NO > 0 AND #EX.LM_IsDropZeroBalance = 1) THEN 1 ELSE 0 END AS [ReportLoanUnMatch],
CASE WHEN #EX.CM_MatchStatus = 'Unmatch' THEN 1 ELSE 0 END AS [ReportCollateralUnMatch],
CASE WHEN #EX.LM_MatchStatus  = 'New' THEN 1 ELSE 0 END AS [ReportNewLoan],
CASE WHEN #EX.CM_MatchStatus = 'New' THEN 1 ELSE 0 END AS [ReportNewCollateral],
CASE WHEN #EX.OM_NameChanged = 1 THEN 1 ELSE 0 END AS [ReportNameChange],
CASE WHEN #EX.OM_AddressChanged = 1 THEN 1 ELSE 0 END AS [ReportAddressChange],
CASE WHEN #EX.CM_DescriptionChanged = 1 THEN 1 ELSE 0 END AS [ReportCollDescriptionChange],
CASE WHEN #EX.LM_EffectiveDateChanged = 1 THEN 1 ELSE 0 END AS [ReportEffDateChange],
CASE WHEN #EX.LM_BalanceIncrease = 1 THEN 1 ELSE 0 END AS [ReportBalanceIncrease],
CASE WHEN #EX.LM_IsDropZeroBalance = 1 THEN 1 ELSE 0 END AS [ReportIsDropZeroBalance],
ISNULL(LM_ReOccurance, 0) AS [ReportLoanReOccurance],
CASE WHEN (C_BadData = 1) THEN 1 ELSE 0 END AS [ReportBadData],
0 AS [ReportUTLCollateral],		--(Mayank) ReportUTLCollateral is MultiCollateral under Collateral  //if multiple match, picks the best match. So no UTL coll.
ISNULL(LM_CPIInplace, 0) AS [ReportCPIInPlace],
ISNULL(CM_PayoffRelease,0) AS [ReportPayOffRelease],
0 AS [ReportDeleteCount],
0 AS [ReportINSPolicyExist],
0 AS [ReportINSUTL],
0 AS [ReportINSUTLCollateral],
0 AS [ReportINSUTLCoverage],
#EX.C_RetainIndicator AS [ReportCollRetainIndicator],
ISNULL(ISNULL(L.OFFICER_CODE_TX,#EX.LoanOfficerNumber),'') AS [LOAN_OFFICER_CODE_TX],	
ISNULL(L.BRANCH_CODE_TX,#EX.BranchCode) AS [LOAN_BRANCHCODE_TX],
COALESCE(L.DIVISION_CODE_TX,#EX.DivisionCode, '') AS [LOAN_DIVISIONCODE_TX],	
ISNULL(RCDiv.MEANING_TX,RC_SC.DESCRIPTION_TX) AS [LOAN_TYPE_TX],
RC.TYPE_CD AS [REQUIREDCOVERAGE_CODE_TX],
RC_COVERAGETYPE.MEANING_TX as [REQUIREDCOVERAGE_TYPE_TX],
ISNULL(ISNULL(L.NUMBER_TX,#EX.LoanNumber),'') AS [LOAN_NUMBER_TX],
CASE WHEN #EX.LM_EffectiveDateChanged = 1 
	THEN #EX.LoanEffectiveDate 
	ELSE ISNULL(CAST(L.EFFECTIVE_DT AS datetime2(7)),#EX.LoanEffectiveDate) END AS [LOAN_EFFECTIVE_DT],
#EX.LM_EffectiveDate AS [LOAN_EFFECTIVE_DT_BEFORE_CHANGE_DT],								
ISNULL(#EX.LoanBalance, L.BALANCE_AMOUNT_NO) AS [LOAN_BALANCE_NO],
#EX.LM_Balance_TX As [LOAN_BALANCE_BEFORE_CHANGE_NO],			
CASE WHEN (L.TYPE_CD = 'CL') THEN 1 ELSE #EX.CreditLine END AS [CREDIT_LINE],
ISNULL(L.CREDIT_LINE_AMOUNT_NO,#EX.CreditLineAmount) AS [CREDIT_LINE_AMOUNT_NO],
ISNULL(CAST(L.PAYOFF_DT AS datetime2(7)),#EX.LoanPayoffDate) AS [PAYOFF_DT],
ISNULL(L.CREDIT_SCORE_CD,#EX.LoanCreditScore) AS [LOAN_CREDITSCORECODE_TX],
ISNULL(#EX.LoanCreditScore,'') AS [FILE_LOAN_CREDITSCORECODE_TX],
LND.CODE_TX AS [LENDER_CODE_TX],
LND.NAME_TX AS [LENDER_NAME_TX],
ISNULL(C.COLLATERAL_NUMBER_NO, #EX.C_CollateralNumber) AS [COLLATERAL_NUMBER_NO],
ISNULL(CC.CODE_TX,#EX.C_CollateralCode) AS [COLLATERAL_CODE_TX],
ISNULL(C.LENDER_COLLATERAL_CODE_TX,#EX.C_LenderCollateralCode) AS [LENDER_COLLATERAL_CODE_TX],
ISNULL(#EX.C_LenderCollateralCode,'') AS [FILE_LENDER_COLLATERAL_CODE_TX],
L.STATUS_CD AS [LOAN_STATUSCODE],
C.STATUS_CD AS [COLLATERAL_STATUSCODE],
ISNULL(ISNULL(O.LAST_NAME_TX,#EX.O_LastName),'') AS [OWNER_LASTNAME_TX],
ISNULL(ISNULL(O.FIRST_NAME_TX,#EX.O_FirstName),'') AS [OWNER_FIRSTNAME_TX],
ISNULL(ISNULL(O.MIDDLE_INITIAL_TX,#EX.O_MiddleInitial),'') AS [OWNER_MIDDLEINITIAL_TX],
RTRIM(ISNULL(ISNULL(O.LAST_NAME_TX,#EX.O_LastName),'') + ', ' 
	+ ISNULL(ISNULL(O.FIRST_NAME_TX,#EX.O_FirstName),'') + ' ' 
	+ ISNULL(ISNULL(O.MIDDLE_INITIAL_TX,#EX.O_MiddleInitial),'')) AS [OWNER_NAME_TX],
'' AS [COSIGN_TX],
ISNULL(ISNULL(AO.LINE_1_TX,#EX.OA_Line1),'') AS [OWNER_LINE1_TX],
ISNULL(AO.LINE_2_TX,'') AS [OWNER_LINE2_TX],
ISNULL(ISNULL(AO.STATE_PROV_TX,#EX.OA_State),'') AS [OWNER_STATE_TX],
ISNULL(ISNULL(AO.CITY_TX,#EX.OA_City),'') AS [OWNER_CITY_TX],
ISNULL(ISNULL(AO.POSTAL_CODE_TX,#EX.OA_Zip),'') AS [OWNER_ZIP_TX],
ISNULL(RCA_PROP.VALUE_TX,#EX.C_CollateralType) AS [PROPERTY_TYPE_CD],
NULL AS [PROPERTY_DESCRIPTION],--dbo.fn_GetPropertyDescriptionForReports(C.ID) AS [PROPERTY_DESCRIPTION],
CASE
	WHEN ISNULL(ISNULL(L.DIVISION_CODE_TX,#EX.DivisionCode),'0') in ('3','8') OR ISNULL(RCA_PROP.VALUE_TX,#EX.C_CollateralType) in ('VEH','BOAT')
		THEN ISNULL(#EX.CV_Year,'') + ' ' + ISNULL(#EX.CV_Make,'') + '/' + ISNULL(#EX.CV_Model,'')
	WHEN ISNULL(ISNULL(L.DIVISION_CODE_TX,#EX.DivisionCode),'0') in ('7','9') OR ISNULL(RCA_PROP.VALUE_TX,#EX.C_CollateralType) in ('EQ')
		THEN ISNULL(#EX.CM_Description,'')
	WHEN ISNULL(ISNULL(L.DIVISION_CODE_TX,#EX.DivisionCode),'0') in ('4','10') OR ISNULL(RCA_PROP.VALUE_TX,#EX.C_CollateralType) not in ('','VEH','BOAT','EQ','MH')
		THEN ISNULL(#EX.CA_CollateralAddressLine1, '') + CHAR(13) + CHAR(10) + ISNULL(#EX.CA_CollateralAddressLine2 + CHAR(13) + CHAR(10),'') + COALESCE(#EX.CA_CollateralAddressCity + ', ', '') 
				+ ISNULL(#EX.CA_CollateralAddressState, '') + ' ' + ISNULL(#EX.CA_CollateralAddressZip, '')		
	WHEN ISNULL(RCA_PROP.VALUE_TX,#EX.C_CollateralType) = 'MH'
		THEN CASE WHEN CC.VEHICLE_LOOKUP_IN = 'Y'
					THEN ISNULL(#EX.CV_Year,'') + ' ' + ISNULL(#EX.CV_Make,'') + '/' + ISNULL(#EX.CV_Model,'')
				 ELSE  ISNULL(#EX.CA_CollateralAddressLine1, '') + CHAR(13) + CHAR(10) + ISNULL(#EX.CA_CollateralAddressLine2 + CHAR(13) + CHAR(10),'') + COALESCE(#EX.CA_CollateralAddressCity + ', ', '')  
						+ ISNULL(#EX.CA_CollateralAddressState, '') + ' ' + ISNULL(#EX.CA_CollateralAddressZip, '')
				END
	ELSE ''
END AS [PROPERTY_DESCRIPTION_FILE],

ISNULL(P.VIN_TX,'') AS [COLLATERAL_VIN_TX],
ISNULL(#EX.CV_VIN,'') AS [COLLATERAL_VIN_FILE_TX],
AM.STATE_PROV_TX AS [COLLATERAL_STATE_TX],
AL.STATE_PROV_TX AS [LENDER_STATE_TX],
ISNULL(RC.REQUIRED_AMOUNT_NO, #EX.CE_EQRequiredCoverageAmt) AS [REQUIREDCOVERAGE_REQUIREDAMOUNT_NO],
CASE
	WHEN RC.NOTICE_DT is not null and RC.NOTICE_SEQ_NO > 0
		THEN cast(RC.NOTICE_SEQ_NO as char(1)) +  ' ' + NRef.MEANING_TX + ' ' + CONVERT(nvarchar(10), RC.NOTICE_DT, 101)
	ELSE CASE
	WHEN L.STATUS_CD in ('N','O','P') THEN LSRef.MEANING_TX
	WHEN C.STATUS_CD in ('R','S','X') THEN CSRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD in ('A','N')
			THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD not in ('A','N')
			THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD in ('A','N')
			THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD not in ('A','N')
			THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and C.STATUS_CD = 'Z' and RC.STATUS_CD not in ('A','D','T')
			THEN LSRef.MEANING_TX + ' ' + CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX
	WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD in ('A','N')
			THEN CSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD not in ('A','N')
			THEN CSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD in ('A','N')
			THEN CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD not in ('A','N')
			THEN CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN C.STATUS_CD = 'Z' and RC.STATUS_CD not in ('A','D','T')
			THEN CSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX
	WHEN L.STATUS_CD = 'A' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD in ('A','N')
			THEN RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'A' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD not in ('A','N')
			THEN RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'A' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD in ('A','N')
			THEN RCSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'A' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD not in ('A','N')
			THEN RCSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'A' and RC.STATUS_CD not in ('A','D','T')
			THEN RCSRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD in ('A','N')
			THEN LSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and RC.STATUS_CD in ('A','D') and RC.SUMMARY_STATUS_CD not in ('A','N')
			THEN LSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD in ('A','N')
			THEN LSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and RC.STATUS_CD = 'T' and RC.SUMMARY_STATUS_CD not in ('A','N')
			THEN LSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX + ' ' + RCISSRef.MEANING_TX + ' ' + RCISRef.MEANING_TX
	WHEN L.STATUS_CD = 'B' and RC.STATUS_CD not in ('A','D','T')
			THEN LSRef.MEANING_TX + ' ' + RCSRef.MEANING_TX
   END
END AS [COVERAGE_STATUS_TX],
'' AS [COVERAGEWAIVE_MEANING_TX],
RC.STATUS_CD AS [REQUIREDCOVERAGE_STATUSCODE],
RC.SUMMARY_SUB_STATUS_CD AS [COVERAGE_SUMMARY_SUB_STATUS_CD],
FPC.ACTIVE_IN AS [CPI_ACTIVE_TX],
CASE
	WHEN #EX.C_BorrowerInsCompanyName IS NOT NULL THEN #EX.C_BorrowerInsCompanyName
	WHEN RC.SUMMARY_SUB_STATUS_CD = 'C' THEN CR.NAME_TX
	WHEN RC.SUMMARY_SUB_STATUS_CD = 'P' THEN PCP.INSURANCE_COMPANY_NAME_TX
	ELSE NULL--OP.BIC_NAME_TX
END AS [INSCOMPANY_NAME_TX],
CASE
	WHEN #EX.C_BorrowerInsPolicyNumber IS NOT NULL THEN #EX.C_BorrowerInsPolicyNumber
	WHEN RC.SUMMARY_SUB_STATUS_CD = 'C' THEN FPC.NUMBER_TX
	WHEN RC.SUMMARY_SUB_STATUS_CD = 'P' THEN PCP.POLICY_NUMBER_TX
	ELSE NULL--OP.POLICY_NUMBER_TX
END AS [INSCOMPANY_POLICY_NO],
NULL AS [CPI_PREMIUM_AMOUNT_NO], --CASE WHEN RC.SUMMARY_SUB_STATUS_CD = 'C' THEN ISNULL(CDPRM.AMOUNT_NO,0) ELSE NULL END AS [CPI_PREMIUM_AMOUNT_NO],
NULL AS [PC_PREMIUM_AMOUNT_NO], --CASE WHEN RC.SUMMARY_SUB_STATUS_CD = 'C' THEN ISNULL(CDPRM.AMOUNT_NO,0) ELSE NULL END AS [PC_PREMIUM_AMOUNT_NO],

NULL,--OP.EFFECTIVE_DT AS [BORRINSCOMPANY_EFF_DT],
NULL,--CASE WHEN YEAR(OP.EXPIRATION_DT) = '9999' THEN NULL ELSE OP.EXPIRATION_DT END AS [BORRINSCOMPANY_EXP_DT],
NULL,--OP.CANCELLATION_DT AS [BORRINSCOMPANY_CAN_DT],
NULL,--OP.BIC_NAME_TX AS [INSAGENCY_NAME_TX],
NULL,--BIA.PHONE_EXT_TX AS [INSAGENCY_PHONE_TX],
NULL,--BIA.EMAIL_TX AS [INSAGENCY_EMAIL_TX],
NULL,--BIA.FAX_EXT_TX AS [INSAGENCY_FAX_TX],
L.ID AS [LOAN_ID],
C.ID AS [COLLATERAL_ID],
P.ID AS [PROPERTY_ID],
RC.ID AS [REQUIREDCOVERAGE_ID],
L.RECORD_TYPE_CD AS [LOAN_RECORDTYPE_TX],
RC.RECORD_TYPE_CD AS [RC_RECORDTYPE_TX],
P.RECORD_TYPE_CD AS [P_RECORDTYPE_TX],

--needs to be multiline
	CASE
		WHEN (FPC.STATUS_CD = 'F')
			THEN '-CPI InForce (currently)' + CHAR(13) + CHAR(10)
		WHEN (CM_CPIInplace = 1 OR LM_CPIInplace = 1)
			THEN '-CPI InForce (when the import was taken)' + CHAR(13) + CHAR(10)
		ELSE '' END +
	CASE WHEN OM_NameChanged = 1 THEN '-Name Change' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN OM_AddressChanged = 1 THEN '-Address Changed' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN (CM_DescriptionChanged = 1 AND ISNULL(P.VIN_TX,'') <> ISNULL(#EX.CV_VIN,'')) 
		THEN '-Collateral Description Changed(Old VIN: ' + ISNULL(#EX.CV_VIN,'MISSING') + ')' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN (CM_DescriptionChanged = 1 AND ISNULL(P.VIN_TX,'') = ISNULL(#EX.CV_VIN,'')) 
		THEN '-Collateral Description Changed' + CHAR(13) + CHAR(10) ELSE '' END + 
	CASE WHEN LM_ReOccurance = 1 THEN '-Loan Reoccurence' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN LM_EffectiveDateChanged = 1 
		THEN '-Effective Date Change(Old: ' + isnull(CONVERT(nvarchar(10),LM_EffectiveDate,101),'MISSING') + ')' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN #EX.LM_BalanceIncrease = 1 
		THEN '-Balance Increase(Old: ' + CONVERT(nvarchar(max), CONVERT(money,ISNULL(#EX.LM_Balance_TX,0)),1) + ')' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN (C_BadData = 1) THEN '-Bad Data' + CHAR(13) + CHAR(10) ELSE '' END +
	--CASE WHEN C_MultiCollateral = 1 THEN '-Unable to Locate Collateral(s)' + CHAR(13) + CHAR(10) ELSE '' END +
	CASE WHEN #EX.CM_PayoffRelease = 1 THEN '-Paid off or Released' + CHAR(13) + CHAR(10) ELSE '' END + ''
 AS [EXTR_EXCEPTION],

 CASE WHEN L.EXTRACT_LOAN_UPDATE_ONLY_IN = 'Y' THEN 1 ELSE 0 END AS [LoanUpdatesOnlyOnLoan],
 FPC.CPI_QUOTE_ID
 --SELECT * 
FROM #EX WITH(NOLOCK)
JOIN LENDER LND WITH(NOLOCK) on (/*@LenderID Is Null Or*/ LND.ID = '3411') and LND.PURGE_DT IS NULL
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