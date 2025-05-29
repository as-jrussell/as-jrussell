USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[GetUTL]    Script Date: 5/29/2018 6:12:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetUTL]
(
	@loanId bigint = null,
	@collateralId bigint = null
)
AS
BEGIN
   SET NOCOUNT ON

   IF @loanId IS NOT NULL
   BEGIN	
	   select
		 l.ID as 'l_ID',
		 l.AGENCY_ID as 'l_AGENCY_ID',
		 l.LENDER_ID as 'l_LENDER_ID',
		 l.NUMBER_TX as 'l_NUMBER_TX',
		 l.SOURCE_CD as 'l_SOURCE_CD',
		 l.CREATE_DT as 'l_CREATE_DT',
		 o.ID as 'o_ID',
		 o.FIRST_NAME_TX as 'o_FIRST_NAME_TX',
		 o.LAST_NAME_TX as 'o_LAST_NAME_TX',
		 o.NAME_TX as 'o_NAME_TX',
		 olr.PRIMARY_IN as 'o_PRIMARY_IN',
		 oa.ID as 'oa_ID',
		 oa.LINE_1_TX as 'oa_LINE_1_TX',
		 oa.LINE_2_TX as 'oa_LINE_2_TX',
		 oa.CITY_TX as 'oa_CITY_TX',
		 oa.STATE_PROV_TX as 'oa_STATE_PROV_TX',
		 oa.POSTAL_CODE_TX as 'oa_POSTAL_CODE_TX',
		 c.ID as 'c_ID',
		 c.COLLATERAL_CODE_ID as 'c_COLLATERAL_CODE_ID',
		 p.ID as 'p_ID',
		 p.YEAR_TX as 'p_YEAR_TX',
		 p.MAKE_TX as 'p_MAKE_TX',
		 p.MODEL_TX as 'p_MODEL_TX',
		 p.BODY_TX as 'p_BODY_TX',
		 p.DESCRIPTION_TX as 'p_DESCRIPTION_TX',
		 p.VIN_TX as 'p_VIN_TX',
		 pa.ID as 'pa_ID',
		 pa.LINE_1_TX as 'pa_LINE_1_TX',
		 pa.LINE_2_TX as 'pa_LINE_2_TX',
		 pa.CITY_TX as 'pa_CITY_TX',
		 pa.STATE_PROV_TX as 'pa_STATE_PROV_TX',
		 pa.POSTAL_CODE_TX as 'pa_POSTAL_CODE_TX',
		 rc.ID as 'rc_ID',
		 rc.TYPE_CD as 'rc_TYPE_CD',
		 escrow.HasEscrow AS 'escrow_HAS_ESCROW_IN',
		 ISNULL(bicl.APPLY_EXACT_MATCH_IN,'N') as 'escrow_APPLY_EXACT_MATCH_IN',
		 escrowRemit.REMITTANCE_ADDR_ID,
		 op.ID as 'op_ID',
		 op.POLICY_NUMBER_TX as 'op_POLICY_NUMBER_TX',
		 op.MOST_RECENT_TXN_TYPE_CD as 'op_MOST_RECENT_TXN_TYPE_CD',
		 op.MOST_RECENT_MAIL_DT as 'op_MOST_RECENT_MAIL_DT',
		 pc.ID as 'pc_ID',
		 pc.TYPE_CD as 'pc_TYPE_CD',
		 pc.SUB_TYPE_CD as 'pc_SUB_TYPE_CD'
	   from LOAN l
		 inner join COLLATERAL c on l.ID = c.LOAN_ID
		 inner join PROPERTY p on c.PROPERTY_ID = p.ID
		 left outer join REQUIRED_COVERAGE rc on p.ID = rc.PROPERTY_ID AND rc.PURGE_DT is null
		 left outer join OWNER_LOAN_RELATE olr on l.ID = olr.LOAN_ID AND olr.PURGE_DT is null
		 left outer join OWNER o on olr.OWNER_ID = o.ID AND o.PURGE_DT is null
		 left outer join OWNER_ADDRESS oa ON o.ADDRESS_ID = oa.ID and oa.PURGE_DT is null
		 left outer join OWNER_ADDRESS pa ON p.ADDRESS_ID = pa.ID and pa.PURGE_DT is null
		 left outer join PROPERTY_OWNER_POLICY_RELATE popr on p.ID = popr.PROPERTY_ID and popr.PURGE_DT is null
		 left outer join OWNER_POLICY op ON popr.OWNER_POLICY_ID = op.ID and op.PURGE_DT is null
		 left outer join POLICY_COVERAGE pc ON op.ID = pc.OWNER_POLICY_ID and pc.PURGE_DT is null
		 LEFT OUTER JOIN BORROWER_INSURANCE_COMPANY bic ON bic.ID = op.BIC_ID AND bic.PURGE_DT IS NULL
		 LEFT OUTER JOIN BORROWER_INSURANCE_COMPANY_LENDER bicl ON bicl.LENDER_ID = l.LENDER_ID AND (bicl.BIC_ID = bic.ID OR bicl.BIC_ID = bic.PARENT_ID) AND bicl.PURGE_DT IS NULL
		 cross apply
		  (select count(*) utl_count from UTL_MATCH_RESULT utl
			where utl.utl_loan_id = l.ID 
			and utl.UTL_PROPERTY_ID = p.ID
			and (utl.APPLY_STATUS_CD IN ('PEND', 'HOLD')
			OR (utl.APPLY_STATUS_CD = 'APP' AND (utl.USER_MATCH_RESULT_CD = 'EXACT' OR utl.MATCH_RESULT_CD = 'EXACT')))
			and utl.PURGE_DT is null
			) utl		 
		  CROSS apply	
			(SELECT CASE WHEN COUNT(*) > 0 THEN 'Y' ELSE 'N' END HasEscrow
			FROM  ESCROW_REQUIRED_COVERAGE_RELATE ERCR
			JOIN ESCROW E ON E.ID = ERCR.ESCROW_ID	AND E.PURGE_DT IS NULL
			WHERE ERCR.REQUIRED_COVERAGE_ID = rc.ID AND ERCR.PURGE_DT IS NULL) escrow	   
		  OUTER apply	
			(SELECT E.REMITTANCE_ADDR_ID				
			FROM  ESCROW_REQUIRED_COVERAGE_RELATE ERCR
			JOIN ESCROW E ON E.ID = ERCR.ESCROW_ID	AND E.PURGE_DT IS NULL
			WHERE ERCR.REQUIRED_COVERAGE_ID = rc.ID AND ERCR.PURGE_DT IS NULL
			) escrowRemit	
	where l.ID = @loanId
	   and utl.utl_count = 0
	   and l.PURGE_DT is null
	   and c.PURGE_DT is null
	   and p.PURGE_DT is null
   END
   ELSE IF @collateralId IS NOT NULL
   BEGIN
	   select
		 l.ID as 'l_ID',
		 l.AGENCY_ID as 'l_AGENCY_ID',
		 l.LENDER_ID as 'l_LENDER_ID',
		 l.NUMBER_TX as 'l_NUMBER_TX',
		 l.SOURCE_CD as 'l_SOURCE_CD',
		 l.CREATE_DT as 'l_CREATE_DT',
		 o.ID as 'o_ID',
		 o.FIRST_NAME_TX as 'o_FIRST_NAME_TX',
		 o.LAST_NAME_TX as 'o_LAST_NAME_TX',
		 o.NAME_TX as 'o_NAME_TX',
		 olr.PRIMARY_IN as 'o_PRIMARY_IN',
		 oa.ID as 'oa_ID',
		 oa.LINE_1_TX as 'oa_LINE_1_TX',
		 oa.LINE_2_TX as 'oa_LINE_2_TX',
		 oa.CITY_TX as 'oa_CITY_TX',
		 oa.STATE_PROV_TX as 'oa_STATE_PROV_TX',
		 oa.POSTAL_CODE_TX as 'oa_POSTAL_CODE_TX',
		 c.ID as 'c_ID',
		 c.COLLATERAL_CODE_ID as 'c_COLLATERAL_CODE_ID',
		 p.ID as 'p_ID',
		 p.YEAR_TX as 'p_YEAR_TX',
		 p.MAKE_TX as 'p_MAKE_TX',
		 p.MODEL_TX as 'p_MODEL_TX',
		 p.BODY_TX as 'p_BODY_TX',
		 p.DESCRIPTION_TX as 'p_DESCRIPTION_TX',
		 p.VIN_TX as 'p_VIN_TX',
		 pa.ID as 'pa_ID',
		 pa.LINE_1_TX as 'pa_LINE_1_TX',
		 pa.LINE_2_TX as 'pa_LINE_2_TX',
		 pa.CITY_TX as 'pa_CITY_TX',
		 pa.STATE_PROV_TX as 'pa_STATE_PROV_TX',
		 pa.POSTAL_CODE_TX as 'pa_POSTAL_CODE_TX',
		 rc.ID as 'rc_ID',
		 rc.TYPE_CD as 'rc_TYPE_CD',
		 escrow.HasEscrow AS 'escrow_HAS_ESCROW_IN',		 
		 ISNULL(bicl.APPLY_EXACT_MATCH_IN,'N') as 'escrow_APPLY_EXACT_MATCH_IN',
		 escrowRemit.REMITTANCE_ADDR_ID,
		 op.ID as 'op_ID',
		 op.POLICY_NUMBER_TX as 'op_POLICY_NUMBER_TX',
		 op.MOST_RECENT_TXN_TYPE_CD as 'op_MOST_RECENT_TXN_TYPE_CD',
		 op.MOST_RECENT_MAIL_DT as 'op_MOST_RECENT_MAIL_DT',
		 pc.ID as 'pc_ID',
		 pc.TYPE_CD as 'pc_TYPE_CD',
		 pc.SUB_TYPE_CD as 'pc_SUB_TYPE_CD'
	   from LOAN l
		 inner join COLLATERAL c on l.ID = c.LOAN_ID
		 inner join PROPERTY p on c.PROPERTY_ID = p.ID
		 left outer join REQUIRED_COVERAGE rc on p.ID = rc.PROPERTY_ID AND rc.PURGE_DT is null
		 left outer join OWNER_LOAN_RELATE olr on l.ID = olr.LOAN_ID AND olr.PURGE_DT is null
		 left outer join OWNER o on olr.OWNER_ID = o.ID AND o.PURGE_DT is null
		 left outer join OWNER_ADDRESS oa ON o.ADDRESS_ID = oa.ID and oa.PURGE_DT is null
		 left outer join OWNER_ADDRESS pa ON p.ADDRESS_ID = pa.ID and pa.PURGE_DT is null
		 left outer join PROPERTY_OWNER_POLICY_RELATE popr on p.ID = popr.PROPERTY_ID and popr.PURGE_DT is null
		 left outer join OWNER_POLICY op ON popr.OWNER_POLICY_ID = op.ID and op.PURGE_DT is null
		 left outer join POLICY_COVERAGE pc ON op.ID = pc.OWNER_POLICY_ID and pc.PURGE_DT is null
		 LEFT OUTER JOIN BORROWER_INSURANCE_COMPANY bic ON bic.ID = op.BIC_ID AND bic.PURGE_DT IS NULL
		 LEFT OUTER JOIN BORROWER_INSURANCE_COMPANY_LENDER bicl ON bicl.LENDER_ID = l.LENDER_ID AND (bicl.BIC_ID = bic.ID OR bicl.BIC_ID = bic.PARENT_ID) AND bicl.PURGE_DT IS NULL
		 cross apply
		  (select count(*) utl_count from UTL_MATCH_RESULT utl
			where utl.utl_loan_id = l.ID 
			and utl.UTL_PROPERTY_ID = p.ID
			and (utl.APPLY_STATUS_CD IN ('PEND', 'HOLD')
			OR (utl.APPLY_STATUS_CD = 'APP' AND (utl.USER_MATCH_RESULT_CD = 'EXACT' OR utl.MATCH_RESULT_CD = 'EXACT')))
			and utl.PURGE_DT is null
			) utl		 
		  CROSS apply	
			(SELECT CASE WHEN COUNT(*) > 0 THEN 'Y' ELSE 'N' END HasEscrow
			FROM  ESCROW_REQUIRED_COVERAGE_RELATE ERCR
			JOIN ESCROW E ON E.ID = ERCR.ESCROW_ID	AND E.PURGE_DT IS NULL
			WHERE ERCR.REQUIRED_COVERAGE_ID = rc.ID AND ERCR.PURGE_DT IS NULL) escrow	
		  OUTER apply	
			(SELECT E.REMITTANCE_ADDR_ID				
			FROM  ESCROW_REQUIRED_COVERAGE_RELATE ERCR
			JOIN ESCROW E ON E.ID = ERCR.ESCROW_ID	AND E.PURGE_DT IS NULL
			WHERE ERCR.REQUIRED_COVERAGE_ID = rc.ID AND ERCR.PURGE_DT IS NULL
			) escrowRemit	
	   where c.ID = @collateralId
	   and utl.utl_count = 0
	   and l.PURGE_DT is null
	   and c.PURGE_DT is null
	   and p.PURGE_DT is null   
   END

END

GO

