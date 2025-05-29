USE [UniTrac]
GO

/****** Object:  View [dbo].[vuTitleProgram]    Script Date: 11/22/2017 4:01:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vuTitleProgram]
AS
SELECT
          LND.CODE_TX AS LenderID			           /*LenderID  */ 
        , O.LAST_NAME_TX as LastName                   /*tblCUstomer.LastName  */ 
        , O.FIRST_NAME_TX as FirstName                 /*tblCustomer.FirstName  */ 
        , O.MIDDLE_INITIAL_TX as MiddleInitial         
        , AO.LINE_1_TX as Address1                      /*tblCustomer.Address1  */ 
        , AO.LINE_2_TX as Address2                      /*tblCustomer.Address2  */ 
        , AO.CITY_TX as City                            /*tblCustomer.City  */ 
        , AO.STATE_PROV_TX as State                     /*tblCustomer.State  */ 
        , AO.POSTAL_CODE_TX as Zip                      /*tblCustomer.Zip  */ 
        , L.NUMBER_TX AS ContractNumber                 /*tblContract.ContractNumber  */ 
        , C.COLLATERAL_NUMBER_NO As CollateralNumber    /*tblCollateral.CollateralNumber  */ 
        , L.EFFECTIVE_DT AS ContractEffectiveDate       /*tblContract.ContractEffectiveDate   */        
        , P.YEAR_TX AS Year                             /*tblCollateralVehicle.Year  */ 
        , P.MAKE_TX AS Make                             /*tblCollateralVehicle.Make  */ 
        , P.MODEL_TX AS Model                           /*tblCollateralVehicle.Model  */ 
        , P.VIN_TX as VIN                               /*tblCollateralVehicle.Vin  */ 
        , CASE WHEN P.TITLE_CD IN ('Y', 'N','U') THEN P.TITLE_CD ELSE 'N' END as Status                    /*tblCollateralVehicle.Title AS Status  */ 
        , '00' AS SURCHARGE                             /*00' AS Surcharge          */ 
        , OP.BIC_NAME_TX as BorrInsCompanyName          /*tblCoverage.BorrInsCompanyName  */ 
        , OP.POLICY_NUMBER_TX as BorrInsPolicyNumber    /*tblCoverage.BorrInsPolicyNumber  */ 
        , OP.EFFECTIVE_DT AS BorrInsEffectiveDate       /*tblCoverage.BorrInsEffectiveDate  */ 
        , L.NOTE_TX as ContractComment                  /*tblContract.ContractComment  */ 
        , L.OFFICER_CODE_TX as Officer                  /*tblContract.Officer  */ 
        , L.BRANCH_CODE_TX as BranchID                  /*tblBranch.BranchID   */        
               
        , L.LENDER_ID AS 'LenderKey'                   /*tblContract.LenderKey  */ 
		, L.ID	   AS LOAN_ID
		, P.ID	   AS PROPERTY_ID
		, RC.ID	   AS REQUIRED_COVERAGE_ID
        , L.CONTRACT_TYPE_CD  as ContractTypeKey        /*tblContract.ContractTypeKey  */ 
        , L.BALANCE_AMOUNT_NO as ContractBalance        /*tblContract.ContractBalance  */ 
		, L.STATUS_CD  AS LoanStatusCode
        , C.STATUS_CD  AS CollateralStatusCode          /*tblCollateral.CollateralStatusCode  */ 
        , RC.STATUS_CD AS CoverageStatusCode            /*tblCoverage.CoverageStatusCode  */                       

FROM      LOAN L 
	JOIN LENDER LND ON LND.ID = L.LENDER_ID AND LND.PURGE_DT IS NULL
	JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = L.ID AND OLR.PRIMARY_IN = 'Y' AND OLR.PURGE_DT IS NULL
	JOIN [OWNER] O ON O.ID = OLR.OWNER_ID AND O.PURGE_DT IS NULL
	JOIN COLLATERAL C ON C.LOAN_ID = L.ID AND C.PURGE_DT IS NULL
	JOIN dbo.COLLATERAL_CODE cc ON C.COLLATERAL_CODE_ID = cc.ID
	JOIN PROPERTY P ON P.ID = C.PROPERTY_ID AND P.PURGE_DT IS NULL
	LEFT JOIN [OWNER_ADDRESS] AO ON AO.ID = O.ADDRESS_ID AND AO.PURGE_DT IS NULL
	LEFT JOIN REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID AND RC.PURGE_DT IS NULL
	OUTER APPLY GetCurrentCoverage(P.ID, RC.ID, RC.TYPE_CD) OP
WHERE L.RECORD_TYPE_CD = 'G' AND
	L.PURGE_DT IS NULL AND
	L.DIVISION_CODE_TX IN ('3', '8', '99') AND
	cc.SECONDARY_CLASS_CD IN ('VEH', 'COVEH', 'RV', 'BOAT') AND
	L.EXTRACT_UNMATCH_COUNT_NO = 0 AND
	C.EXTRACT_UNMATCH_COUNT_NO = 0 AND
	L.STATUS_CD <> 'P' AND
	C.STATUS_CD <> 'R' AND
	ISNULL(P.MAKE_TX, '') <> '' AND
	(ISNULL(P.YEAR_TX, '') <> '' OR ISNULL(P.MODEL_TX, '') <> '')
	AND (P.TITLE_CD IN ('Y', 'N','U') OR P.TITLE_CD IS NULL)
	AND P.RECORD_TYPE_CD = 'G'
	AND (COLLATERAL_NUMBER_NO = 1)


GO

