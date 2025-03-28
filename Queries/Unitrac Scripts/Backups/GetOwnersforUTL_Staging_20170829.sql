USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[GetOwnersForUTL]    Script Date: 8/29/2017 1:35:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetOwnersForUTL](
   @lenderId bigint,
   @matchMode varchar(10) = 'UTL',
   @transactionId bigint = null  
)
AS
BEGIN
  SET NOCOUNT ON
   
  --UTL Lender grouping changes
  IF (@matchMode = 'UTL')
  BEGIN
      select
		l.ID,
		o.ID,
		ISNULL(UPPER(o.FIRST_NAME_TX),''),
		ISNULL(UPPER(o.LAST_NAME_TX),''),
		ISNULL(UPPER(o.NAME_TX),''),
		ISNULL(UPPER(oa.LINE_1_TX),''),
		ISNULL(UPPER(oa.LINE_2_TX),''),
		ISNULL(UPPER(oa.CITY_TX),''),
		ISNULL(UPPER(oa.STATE_PROV_TX),''),
		ISNULL(UPPER(oa.POSTAL_CODE_TX),''),
		olr.OWNER_TYPE_CD
	  from LOAN l
	    inner join (select Lender_Id from dbo.fnGetLenderGroupLenderIdsForLender(@lenderId, 'Y')) lg on l.LENDER_ID =  lg.LENDER_ID
		inner join OWNER_LOAN_RELATE olr on l.ID = olr.LOAN_ID and olr.PURGE_DT IS NULL
		inner join OWNER o on olr.OWNER_ID = o.ID and o.PURGE_DT is null
		left outer join OWNER_ADDRESS oa on o.ADDRESS_ID = oa.ID and oa.PURGE_DT IS NULL
	  where
		l.RECORD_TYPE_CD = 'G'
		and l.PURGE_DT is NULL
	  order by l.ID
	  OPTION (RECOMPILE)
  END
  ELSE IF (@matchMode = 'INS')
  BEGIN
	  select
		l.ID,
		o.ID,
		ISNULL(UPPER(o.FIRST_NAME_TX),''),
		ISNULL(UPPER(o.LAST_NAME_TX),''),
		ISNULL(UPPER(o.NAME_TX),''),
		ISNULL(UPPER(oa.LINE_1_TX),''),
		ISNULL(UPPER(oa.LINE_2_TX),''),
		ISNULL(UPPER(oa.CITY_TX),''),
		ISNULL(UPPER(oa.STATE_PROV_TX),''),
		ISNULL(UPPER(oa.POSTAL_CODE_TX),''),
		olr.OWNER_TYPE_CD
	  from LOAN l
		inner join OWNER_LOAN_RELATE olr on l.ID = olr.LOAN_ID and olr.PURGE_DT IS NULL
		inner join OWNER o on olr.OWNER_ID = o.ID and o.PURGE_DT is null
		left outer join OWNER_ADDRESS oa on o.ADDRESS_ID = oa.ID and oa.PURGE_DT IS NULL
	  where l.LENDER_ID = @lenderId
		and l.RECORD_TYPE_CD = 'G'
		and l.PURGE_DT is NULL
	  order by l.ID
	  OPTION (RECOMPILE)
  END
    
  ELSE IF @matchMode = 'LFP' 
  BEGIN
	IF @transactionId IS NULL
	BEGIN
		  select
			l.ID,
			o.ID,
			ISNULL(UPPER(o.FIRST_NAME_TX),''),
			ISNULL(UPPER(o.LAST_NAME_TX),''),
			ISNULL(UPPER(o.NAME_TX),''),
			ISNULL(UPPER(oa.LINE_1_TX),''),
			ISNULL(UPPER(oa.LINE_2_TX),''),
			ISNULL(UPPER(oa.CITY_TX),''),
			ISNULL(UPPER(oa.STATE_PROV_TX),''),
			ISNULL(UPPER(oa.POSTAL_CODE_TX),''),
			olr.OWNER_TYPE_CD
		  from LOAN l
			inner join OWNER_LOAN_RELATE olr on l.ID = olr.LOAN_ID and olr.OWNER_TYPE_CD <> 'AI' and olr.PURGE_DT IS NULL
			inner loop join OWNER o on olr.OWNER_ID = o.ID and o.PURGE_DT is null
			left outer loop join OWNER_ADDRESS oa on o.ADDRESS_ID = oa.ID and oa.PURGE_DT IS NULL
		  where l.LENDER_ID = @lenderId
			and l.RECORD_TYPE_CD IN ('G', 'A', 'D')
			and l.PURGE_DT is NULL
		  order by l.ID  
		  OPTION (RECOMPILE)
	END
	ELSE
	BEGIN
		  select
			l.ID,
			o.ID,
			ISNULL(UPPER(o.FIRST_NAME_TX),''),
			ISNULL(UPPER(o.LAST_NAME_TX),''),
			ISNULL(UPPER(o.NAME_TX),''),
			ISNULL(UPPER(oa.LINE_1_TX),''),
			ISNULL(UPPER(oa.LINE_2_TX),''),
			ISNULL(UPPER(oa.CITY_TX),''),
			ISNULL(UPPER(oa.STATE_PROV_TX),''),
			ISNULL(UPPER(oa.POSTAL_CODE_TX),''),
			olr.OWNER_TYPE_CD
		  from LOAN l
			inner join OWNER_LOAN_RELATE olr on l.ID = olr.LOAN_ID and olr.OWNER_TYPE_CD <> 'AI' and olr.PURGE_DT IS NULL
			inner loop join OWNER o on olr.OWNER_ID = o.ID and o.PURGE_DT is null
			join COLLATERAL col on col.LOAN_ID = l.ID and col.PURGE_DT is NULL
			join fnGetCollateralIdsByTransactionId(@transactionId) fn on fn.ID = col.ID
			left outer loop join OWNER_ADDRESS oa on o.ADDRESS_ID = oa.ID and oa.PURGE_DT IS NULL
		  where l.LENDER_ID = @lenderId
			and l.RECORD_TYPE_CD IN ('G', 'A', 'D')
			and l.PURGE_DT is NULL
		  order by l.ID  
		  OPTION (RECOMPILE)
	END	  
  END
  ELSE IF @matchMode = 'LFP_FP' 
  BEGIN
	IF @transactionId IS NULL
	BEGIN
		  select
			l.ID,
			o.ID,
			ISNULL(UPPER(o.FIELD_PROTECTION_XML.value('(//FP/Field[@name="FirstName"]/@bv)[1]','varchar(100)')),ISNULL(UPPER(o.FIRST_NAME_TX),'')),
			ISNULL(UPPER(o.FIELD_PROTECTION_XML.value('(//FP/Field[@name="LastName"]/@bv)[1]','varchar(100)')),ISNULL(UPPER(o.LAST_NAME_TX),'')),
			ISNULL(UPPER(o.NAME_TX),''),
			ISNULL(UPPER(o.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.Line1"]/@bv)[1]','varchar(100)')),ISNULL(UPPER(oa.LINE_1_TX),'')), 
			ISNULL(UPPER(o.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.Line2"]/@bv)[1]','varchar(100)')),ISNULL(UPPER(oa.LINE_2_TX),'')), 
			ISNULL(UPPER(o.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.City"]/@bv)[1]','varchar(100)')),ISNULL(UPPER(oa.CITY_TX),'')), 
			ISNULL(UPPER(o.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.State"]/@bv)[1]','varchar(100)')),ISNULL(UPPER(oa.STATE_PROV_TX),'')), 
			ISNULL(UPPER(o.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.PostalCode"]/@bv)[1]','varchar(100)')),ISNULL(UPPER(oa.POSTAL_CODE_TX),'')),
			olr.OWNER_TYPE_CD
		  from LOAN l
			inner join OWNER_LOAN_RELATE olr on l.ID = olr.LOAN_ID and olr.OWNER_TYPE_CD <> 'AI' and olr.PURGE_DT IS NULL
			inner loop join OWNER o on olr.OWNER_ID = o.ID and o.PURGE_DT is null
			left outer loop join OWNER_ADDRESS oa on o.ADDRESS_ID = oa.ID and oa.PURGE_DT IS NULL
		  where l.LENDER_ID = @lenderId
			and l.RECORD_TYPE_CD IN ('G', 'A', 'D')
			and l.PURGE_DT is NULL
		  order by l.ID  
		  OPTION (RECOMPILE)
	END
	ELSE
	BEGIN
		  select
			l.ID,
			o.ID,
			ISNULL(UPPER(o.FIELD_PROTECTION_XML.value('(//FP/Field[@name="FirstName"]/@bv)[1]','varchar(100)')),ISNULL(UPPER(o.FIRST_NAME_TX),'')),
			ISNULL(UPPER(o.FIELD_PROTECTION_XML.value('(//FP/Field[@name="LastName"]/@bv)[1]','varchar(100)')),ISNULL(UPPER(o.LAST_NAME_TX),'')),
			ISNULL(UPPER(o.NAME_TX),''),
			ISNULL(UPPER(o.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.Line1"]/@bv)[1]','varchar(100)')),ISNULL(UPPER(oa.LINE_1_TX),'')), 
			ISNULL(UPPER(o.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.Line2"]/@bv)[1]','varchar(100)')),ISNULL(UPPER(oa.LINE_2_TX),'')), 
			ISNULL(UPPER(o.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.City"]/@bv)[1]','varchar(100)')),ISNULL(UPPER(oa.CITY_TX),'')), 
			ISNULL(UPPER(o.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.State"]/@bv)[1]','varchar(100)')),ISNULL(UPPER(oa.STATE_PROV_TX),'')), 
			ISNULL(UPPER(o.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.PostalCode"]/@bv)[1]','varchar(100)')),ISNULL(UPPER(oa.POSTAL_CODE_TX),'')),
			olr.OWNER_TYPE_CD
		  from LOAN l
			inner join OWNER_LOAN_RELATE olr on l.ID = olr.LOAN_ID and olr.OWNER_TYPE_CD <> 'AI' and olr.PURGE_DT IS NULL
			inner loop join OWNER o on olr.OWNER_ID = o.ID and o.PURGE_DT is null
			join COLLATERAL col on col.LOAN_ID = l.ID and col.PURGE_DT is NULL
			join fnGetCollateralIdsByTransactionId(@transactionId) fn on fn.ID = col.ID
			left outer loop join OWNER_ADDRESS oa on o.ADDRESS_ID = oa.ID and oa.PURGE_DT IS NULL
		  where l.LENDER_ID = @lenderId
			and l.RECORD_TYPE_CD IN ('G', 'A', 'D')
			and l.PURGE_DT is NULL
		  order by l.ID  
		  OPTION (RECOMPILE)	
	END
  END  	  
END
