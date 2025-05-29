USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[GetEscrowBillDetails]    Script Date: 5/3/2017 4:43:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetEscrowBillDetails]
(
	@workItemId   bigint = null
)
AS
BEGIN	
	SET NOCOUNT ON
	
	Declare @lenderID as bigint
	Declare @usePayeeCode as nvarchar(10)
	Declare @directPay as nvarchar(10)
	Declare @lenderEscrowFileIndicator as nvarchar(10)
	Declare @lenderName as nvarchar(100)
   Declare @processLogId as bigint
	
	select @lenderID = ISNULL(WI.LENDER_ID,0)  ,
	@processLogId = RELATE_ID
	from WORK_ITEM WI where ID = @workItemId
	
	Select @lenderName = NAME_TX  from LENDER where ID = @lenderID
		
	select @usePayeeCode = rd.VALUE_TX from RELATED_DATA rd join RELATED_DATA_DEF rdd
	on rdd.ID = rd.DEF_ID and rdd.NAME_TX = 'UsePayeeCode'
	where rd.RELATE_ID = @lenderID
	
	select @directPay = rd.VALUE_TX from RELATED_DATA rd join RELATED_DATA_DEF rdd
	on rdd.ID = rd.DEF_ID and rdd.NAME_TX = 'DirectPay'
	where rd.RELATE_ID = @lenderID	
	
	select @lenderEscrowFileIndicator = rd.VALUE_TX from RELATED_DATA rd join RELATED_DATA_DEF rdd
	on rdd.ID = rd.DEF_ID and rdd.NAME_TX = 'LenderEscrowFileIndicator'
	where rd.RELATE_ID = @lenderID	

   IF OBJECT_ID(N'tempdb..#tmpLCGCT',N'U') IS NOT NULL
	   DROP TABLE #tmpLCGCT   
	   
	Create Table #tmpLCGCT
	(	
	  LCGCTId bigint
	)
	
	Insert into #tmpLCGCT (LCGCTId)
	select Escrow.Col.value('.','bigint') as LCGCTId 
	FROM PROCESS_LOG pl join PROCESS_DEFINITION PD on 
	PD.ID = pl.PROCESS_DEFINITION_ID
	CROSS APPLY PD.SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LCGCTList/LCGCTId') as Escrow(Col)	
	where pl.ID = @processLogId
	
	IF OBJECT_ID(N'tempdb..#tmpMaxOption',N'U') IS NOT NULL
	   DROP TABLE #tmpMaxOption   
	   
	Create Table #tmpMaxOption
	(
	  EscrowId bigint,
	  PropertyId bigint,
	  MaxEscrowCollectionWindowTime int,
	  MaxMortgageOptionPremVariance decimal(10,5)
	)
	
	IF OBJECT_ID(N'tempdb..#tmpEscrow',N'U') IS NOT NULL
	   DROP TABLE #tmpEscrow   
	   
	Create Table #tmpEscrow
	(
	  EscrowId bigint,
	  PropertyId bigint,
	  EscrowCollectionWindowTime int ,
	  MortgageOptionPremVariance varchar(20)
	)

   IF OBJECT_ID(N'tempdb..#tmpPrevEscrow',N'U') IS NOT NULL
	   DROP TABLE #tmpPrevEscrow   
	   
	Create Table #tmpPrevEscrow
	(
	  EscrowId bigint,	
	  PrevTotal decimal(18, 5),
	  PrevBICName nvarchar(100),
	 Exclude int,
	 PrevPayeeCode nvarchar(20)
	)
	
	Insert into #tmpEscrow
	(EscrowId, PropertyId,EscrowCollectionWindowTime, MortgageOptionPremVariance)
	select distinct ESC.ID , ESC.PROPERTY_ID ,
		   EscrowCollectionWindowTime = ISNULL(RC1.EscrowCollectionTimeWindow,0) ,
		  RC1.MortgageOptionPremVariance		      
		 FROM WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR			
		 JOIN PROCESS_LOG_ITEM PLI ON PLI.ID = WIPLIR.PROCESS_LOG_ITEM_ID
		 JOIN ESCROW ESC ON ESC.ID = PLI.RELATE_ID AND PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Escrow'		 
		 INNER JOIN ESCROW_REQUIRED_COVERAGE_RELATE ER1 ON ER1.ESCROW_ID = ESC.ID
		  INNER JOIN REQUIRED_COVERAGE RC1 ON RC1.ID = ER1.REQUIRED_COVERAGE_ID
	WHERE WIPLIR.WORK_ITEM_ID = @workItemId
	
	Insert into #tmpMaxOption
	(EscrowId, PropertyId , MaxEscrowCollectionWindowTime, MaxMortgageOptionPremVariance)
	select EscrowId , PropertyId , MAX(EscrowCollectionWindowTime) as MaxEscrowCollectionWindowTime,
		   MAX(case when MortgageOptionPremVariance = '' then 0 else CAST (MortgageOptionPremVariance as decimal(10,5)) end) as MortgageOptionPremVariance from #tmpEscrow
		   group by EscrowId , PropertyId

	Insert into #tmpPrevEscrow
	(EscrowId , PrevTotal , PrevBICName, Exclude, PrevPayeeCode)	     
	select distinct maxOpt.EscrowId , isnull(PrevEsc.TOTAL_AMOUNT_NO,0) + ISNULL(PrevAddtl.TOTAL_AMOUNT_NO ,0 ) , BIC.NAME , 0 AS EXCLUDE, PrevPayee.PAYEE_CODE_TX as PrevPayeeCode
	from #tmpMaxOption maxOpt join ESCROW_REQUIRED_COVERAGE_RELATE rel on rel.ESCROW_ID = maxOpt.EscrowId
	join ESCROW esc1 on esc1.ID = maxOpt.EscrowId
	join REQUIRED_COVERAGE rc on rc.ID = rel.REQUIRED_COVERAGE_ID and rc.PURGE_DT is null
	join #tmpLCGCT on #tmpLCGCT.LCGCTId = rc.LCGCT_ID
	cross apply
	(
	   select Top 1  esc.ID as ESCROW_ID , esc.END_DT , esc.DUE_DT , esc.TOTAL_AMOUNT_NO , esc.BIC_ID
	   from REQUIRED_COVERAGE rc1 join ESCROW_REQUIRED_COVERAGE_RELATE escrel 
	   on escrel.REQUIRED_COVERAGE_ID = rc1.ID and rc1.PROPERTY_ID = rc.PROPERTY_ID
	   join #tmpLCGCT on #tmpLCGCT.LCGCTId = rc1.LCGCT_ID 	   
	   join ESCROW esc on esc.ID = escrel.ESCROW_ID 
	   where (rc1.TYPE_CD = 'HAZARD' OR rc1.ID = rc.ID)
	  and maxOpt.EscrowId <> esc.ID
	   and esc.PURGE_DT is null and escrel.PURGE_DT is null and esc.TYPE_CD = esc1.TYPE_CD 
	  and esc.SUB_TYPE_CD = esc1.SUB_TYPE_CD and esc.EXCESS_IN = esc1.EXCESS_IN 
	   and (esc.STATUS_CD = 'CLSE' and esc.SUB_STATUS_CD in ('RPTD' , 'LNDRPAID', 'INHSPAID' , 'BWRPAID' ))
		 and ISNULL(esc.END_DT, DATEADD(month, 12 , esc.DUE_DT))  < esc1.END_DT
		order by Case when rc1.TYPE_CD = 'HAZARD' Then 0 else 1 end asc ,
	  ISNULL(esc.END_DT, DATEADD(month, 12 , esc.DUE_DT)) desc 
	) as PrevEsc
	cross apply
	(
	   select SUM(esc.TOTAL_AMOUNT_NO ) as  TOTAL_AMOUNT_NO 
	   from REQUIRED_COVERAGE rc1 join ESCROW_REQUIRED_COVERAGE_RELATE escrel 
	   on escrel.REQUIRED_COVERAGE_ID = rc1.ID and rc1.PROPERTY_ID = rc.PROPERTY_ID
	   join #tmpLCGCT on #tmpLCGCT.LCGCTId = rc1.LCGCT_ID 	   
	   join ESCROW esc on esc.ID = escrel.ESCROW_ID 
	   where (rc1.TYPE_CD = 'HAZARD' OR rc1.ID = rc.ID)    
	  and esc.ID <> maxOpt.EscrowId and esc.ID <> PrevEsc.ESCROW_ID
	   and esc.PURGE_DT is null and esc.TYPE_CD = esc1.TYPE_CD and esc.SUB_TYPE_CD = esc1.SUB_TYPE_CD and esc.EXCESS_IN = esc1.EXCESS_IN 
	   and (esc.STATUS_CD = 'CLSE' and esc.SUB_STATUS_CD in ('RPTD' , 'LNDRPAID', 'INHSPAID'  , 'BWRPAID' ))
		 and ISNULL(esc.END_DT, DATEADD(month, 12 , esc.DUE_DT))  < esc1.END_DT 
		 and datediff( day , ISNULL(esc.END_DT, DATEADD(month, 12 , esc.DUE_DT)) , PrevEsc.END_DT ) = 0
		 and DATEDIFF( day , esc.DUE_DT , PrevEsc.DUE_DT) = 0	
	) as PrevAddtl	
	CROSS APPLY
	(
		SELECT TOP 1 esc.PAYEE_CODE_TX
		FROM 
			REQUIRED_COVERAGE rc1
		JOIN ESCROW_REQUIRED_COVERAGE_RELATE escrel ON escrel.REQUIRED_COVERAGE_ID = rc1.ID
			AND rc1.PROPERTY_ID = rc.PROPERTY_ID
		JOIN #tmpLCGCT ON #tmpLCGCT.LCGCTId = rc1.LCGCT_ID
		JOIN ESCROW esc ON esc.ID = escrel.ESCROW_ID
		WHERE rc1.ID = rc.ID
			AND maxOpt.EscrowId <> esc.ID
			AND esc.PURGE_DT IS NULL
			AND escrel.PURGE_DT IS NULL
			AND esc.TYPE_CD = esc1.TYPE_CD
			AND esc.SUB_TYPE_CD = esc1.SUB_TYPE_CD
			AND esc.EXCESS_IN = esc1.EXCESS_IN
			AND (esc.STATUS_CD = 'CLSE'
			AND esc.SUB_STATUS_CD IN ('RPTD', 'LNDRPAID', 'INHSPAID', 'BWRPAID' ))
		ORDER BY 
			ISNULL(esc.END_DT, DATEADD(MONTH, 12, esc.DUE_DT)) DESC
	) as PrevPayee
	left join BORROWER_INSURANCE_COMPANY bic on bic.ID = PrevEsc.BIC_ID 

   --- REMOVE DUPLICATES
	UPDATE #tmpPrevEscrow SET EXCLUDE = 1
	FROM #tmpPrevEscrow JOIN 
	(
	  SELECT ESCROWID , 
	  ISNULL(PrevBICName,'') AS PrevBICName , 
	  MIN(PREVTOTAL) AS PREVTOTAL
	  FROM  #tmpPrevEscrow GROUP BY ESCROWID , 
	  ISNULL(PrevBICName,'') HAVING COUNT(*) > 1) 
	  AS MULTI
	ON MULTI.ESCROWID = #tmpPrevEscrow.ESCROWID
	AND ISNULL(#tmpPrevEscrow.PrevBICName,'') = ISNULL(MULTI.PrevBICName, '')
	AND #tmpPrevEscrow.PREVTOTAL = MULTI.PREVTOTAL	   
   
   
   SELECT WIPLIR.ID WIPLIR_ID, PLI.ID AS PLI_ID, PLI.RELATE_ID, PLI.RELATE_TYPE_CD, PLI.INFO_XML, PLI.STATUS_CD AS PL_STATUS_CD,
		   LN.ID AS LOAN_ID,  LN.LENDER_ID , #tmpMaxOption.PropertyId as PROPERTY_ID, ----RC.ID RC_ID, 
		   (SELECT TOP 1 RC1.ID FROM REQUIRED_COVERAGE RC1 
			 JOIN ESCROW_REQUIRED_COVERAGE_RELATE ER1 ON ER1.REQUIRED_COVERAGE_ID = RC1.ID
			 WHERE ER1.ESCROW_ID = ESC.ID
			) AS RC_ID ,
		   TBLOWNER.OWNER_NAME, LN.NUMBER_TX AS LN_NUMBER_TX,
		   ESC.ID AS ESCROW_ID, ESC.DUE_DT, ESC.END_DT ,ESC.PREMIUM_NO, ESC.FEE_NO, ESC.OTHER_NO, 
		 isnull(ESC.POLICY_NUMBER_TX,'') as POLICY_NUMBER_TX ,
		   ISNULL(ESC.ORIGINAL_TOTAL_AMT_NO,0) as  ORIGINAL_TOTAL_AMT_NO, ESC.TOTAL_AMT_CHG_DT ,
		 ESC.TOTAL_AMOUNT_NO , ESC.REPORTED_DT, ISNULL(ESC.EXCESS_IN , 'N') AS EXCESS_IN ,
		 isnull(ESC.QUICK_PAY_IN,'N') as QUICK_PAY_IN,	
		   ISNULL(BIC.NAME,'') AS COMPANY_TX , 
		   isnull(PC.PAYEE_CODE_TX,'') as PAYEE_CODE_TX , 
		   isnull(#tmpPrevEscrow.PrevPayeeCode,'') AS PREV_PAYEE_CODE_TX,
		   'PAYEE_CODE_CHANGE_IN'= Case when isnull(PC.PAYEE_CODE_TX,'') != isnull(#tmpPrevEscrow.PrevPayeeCode, '') and #tmpPrevEscrow.EscrowId > 0 Then 'Y' else 'N' END,
		   USE_PAYEE_CODE_IN = Case when isnull(@usePayeeCode,'false') = 'true' Then 'Y' else 'N' end ,
		   DIRECT_PAY_IN = Case when isnull(@directPay,'false') = 'true' Then 'Y' else 'N' end ,
		   ESCROW_FILE_IN = Case when isnull(@lenderEscrowFileIndicator,'false') = 'true' Then 'Y' else 'N' end ,	
		   'NO_MATCH_IN' = Case when @usePayeeCode = 'true' and PC.LENDER_PAYEE_CODE_FILE_ID is NULL Then 'Y' Else 'N' End ,
		   isnull(ADDR.LINE_1_TX,'') as LINE_1_TX, ISNULL(ADDR.LINE_2_TX,'') as LINE_2_TX , 
		   isnull(ADDR.CITY_TX,'') as CITY_TX, isnull(ADDR.STATE_PROV_TX,'') as STATE_PROV_TX, 
			isnull(ADDR.POSTAL_CODE_TX,'') as  POSTAL_CODE_TX,	
			isnull(ADDR.CERTIFIED_IN,'N') as ADDR_CERTIFIED_IN,
		 #tmpMaxOption.MaxMortgageOptionPremVariance ,      
		   'PREM_VARIANCE_IN'= Case when ISNULL(#tmpPrevEscrow.PrevTotal,0) > 0 Then
			Case when
				abs((ESC.TOTAL_AMOUNT_NO) - ISNULL(#tmpPrevEscrow.PrevTotal,0)) >= ISNULL(#tmpPrevEscrow.PrevTotal,0) * 
				#tmpMaxOption.MaxMortgageOptionPremVariance Then 'Y' else 'N' end
				Else 'N' End ,
			#tmpMaxOption.MaxEscrowCollectionWindowTime as ESCROW_WINDOW_TIME_NO ,
		   CONVERT(varchar(20),'') as ESCROW_LENDER_INTENT ,
		   @lenderName as LENDER_NAME_TX	,
		 ISNULL(#tmpPrevEscrow.PrevTotal,0) * 
				ISNULL(#tmpMaxOption.MaxMortgageOptionPremVariance,0) as VARIANCE_NO ,  
		   ISNULL(#tmpPrevEscrow.PrevTotal,0) as PRIOR_TOTAL_NO  , 
		   ISNULL(#tmpPrevEscrow.PrevBICName,'') as PRIOR_COMP_TX  		   
	FROM WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR				 
		 JOIN PROCESS_LOG_ITEM PLI ON PLI.ID = WIPLIR.PROCESS_LOG_ITEM_ID AND PLI.PURGE_DT IS NULL
		 JOIN ESCROW ESC ON ESC.ID = PLI.RELATE_ID AND PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Escrow'		
		 JOIN #tmpMaxOption ON #tmpMaxOption.EscrowId = ESC.ID	 
		 JOIN LOAN LN ON LN.ID = ESC.LOAN_ID
	   JOIN LENDER_ORGANIZATION LO ON LO.LENDER_ID = LN.LENDER_ID
		 AND LO.TYPE_CD = 'BRCH' AND LO.CODE_TX = LN.BRANCH_CODE_TX
		 CROSS APPLY
		 (	SELECT LAST_NAME_TX + ', ' + FIRST_NAME_TX + '|'
			FROM OWNER OWN 
				JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = LN.ID AND OWN.ID = OLR.OWNER_ID
			WHERE OLR.PRIMARY_IN = 'Y'
			FOR XML PATH('')) TBLOWNER (OWNER_NAME)	
		LEFT JOIN BORROWER_INSURANCE_COMPANY BIC ON BIC.ID = ESC.BIC_ID 
	  OUTER APPLY
		(
		  SELECT DISTINCT TOP 1 LM.LENDER_PAYEE_CODE_FILE_ID , LF.PAYEE_CODE_TX , ISNULL(LF.BRCH_LENDER_ORG_ID,0) AS LF_BRCH_LENDER_ORG_ID FROM 
		   LENDER_PAYEE_CODE_MATCH LM JOIN 
		   LENDER_PAYEE_CODE_FILE LF ON LF.ID = LM.LENDER_PAYEE_CODE_FILE_ID
		   WHERE LF.LENDER_ID = LN.LENDER_ID AND LF.AGENCY_ID = LN.AGENCY_ID
		   AND LM.REMITTANCE_ADDR_ID = ESC.REMITTANCE_ADDR_ID	
		   AND (LM.BIC_ID = ESC.BIC_ID OR LM.REMITTANCE_TYPE_CD = 'BIA')
		 AND LM.PRIMARY_IN = 'Y' 
		 AND 
		   ( LF.BRCH_LENDER_ORG_ID = LO.ID OR 
			 ISNULL(LF.BRCH_LENDER_ORG_ID ,0) = 0		    
		   )
		 AND LF.PURGE_DT IS NULL 
		   AND LM.PURGE_DT IS NULL
		 ORDER BY LF_BRCH_LENDER_ORG_ID DESC
		) AS PC		
		JOIN ADDRESS ADDR ON ADDR.ID  = ESC.REMITTANCE_ADDR_ID
	  LEFT JOIN #tmpPrevEscrow ON #tmpPrevEscrow.EscrowId = #tmpMaxOption.EscrowId
	  AND #tmpPrevEscrow.EXCLUDE = 0
	WHERE WIPLIR.WORK_ITEM_ID = @workItemId AND WIPLIR.PURGE_DT IS NULL
   
END




GO

