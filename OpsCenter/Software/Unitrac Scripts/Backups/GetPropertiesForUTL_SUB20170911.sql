USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[GetPropertiesForUTL]    Script Date: 9/11/2017 4:56:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GetPropertiesForUTL](
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
	  select p.ID, col.LOAN_ID,
			 ISNULL(UPPER(p.DESCRIPTION_TX),''), ISNULL(UPPER(p.VIN_TX),''), ISNULL(UPPER(p.YEAR_TX),''), ISNULL(UPPER(p.MAKE_TX),''), ISNULL(UPPER(p.MODEL_TX),''),
			 ISNULL(UPPER(pa.LINE_1_TX),''), ISNULL(UPPER(pa.LINE_2_TX),''), ISNULL(UPPER(pa.CITY_TX),''), ISNULL(UPPER(pa.STATE_PROV_TX),''), ISNULL(UPPER(pa.POSTAL_CODE_TX),''),
			 col.COLLATERAL_CODE_ID,
			 p.ALT_MATCH_XML,
			 (REPLACE(ca1.RCTypes, ' ', '')),
			 (REPLACE(ca2.UTLMatchResultIds, ' ', '')),
			 p.FIELD_PROTECTION_XML
	  from PROPERTY p
	    inner join (select Lender_Id from dbo.fnGetLenderGroupLenderIdsForLender(@lenderId, 'Y')) lg on p.LENDER_ID =  lg.LENDER_ID
		left outer join OWNER_ADDRESS pa on p.ADDRESS_ID = pa.ID and pa.purge_dt is null
		inner join COLLATERAL col on col.PROPERTY_ID = p.ID and col.PURGE_DT is null
      inner join LOAN ln on ln.ID = col.LOAN_ID and ln.PURGE_DT is null
      and ln.RECORD_TYPE_CD = 'G'
		cross apply ( select rc.TYPE_CD + ':' + str(rc.ID) + ';' 
					  from REQUIRED_COVERAGE rc 
					  where p.ID = rc.PROPERTY_ID
						and rc.PURGE_DT is null
					  for xml path('') ) ca1 ( RCTypes )
		cross apply ( select str(u.UTL_LOAN_ID) + ',' + str(u.UTL_PROPERTY_ID) + ';' 
					  from UTL_MATCH_RESULT u 
					  where p.ID = u.PROPERTY_ID
						and u.PURGE_DT is null
					  for xml path('') ) ca2 ( UTLMatchResultIds )
	  where
		 p.RECORD_TYPE_CD = 'G'
		and p.PURGE_DT is NULL      
   END
   ELSE IF (@matchMode = 'INS')
   BEGIN
	  select p.ID, col.LOAN_ID,
			 ISNULL(UPPER(p.DESCRIPTION_TX),''), ISNULL(UPPER(p.VIN_TX),''), ISNULL(UPPER(p.YEAR_TX),''), ISNULL(UPPER(p.MAKE_TX),''), ISNULL(UPPER(p.MODEL_TX),''),
			 ISNULL(UPPER(pa.LINE_1_TX),''), ISNULL(UPPER(pa.LINE_2_TX),''), ISNULL(UPPER(pa.CITY_TX),''), ISNULL(UPPER(pa.STATE_PROV_TX),''), ISNULL(UPPER(pa.POSTAL_CODE_TX),''),
			 col.COLLATERAL_CODE_ID,
			 p.ALT_MATCH_XML,
			 (REPLACE(ca1.RCTypes, ' ', '')),
			 (REPLACE(ca2.UTLMatchResultIds, ' ', '')),
			 p.FIELD_PROTECTION_XML
	  from PROPERTY p
		left outer join OWNER_ADDRESS pa on p.ADDRESS_ID = pa.ID and pa.purge_dt is null
		inner join COLLATERAL col on col.PROPERTY_ID = p.ID and col.PURGE_DT is null
		inner join LOAN ln on ln.ID = col.LOAN_ID and ln.PURGE_DT is null
		and ln.RECORD_TYPE_CD = 'G'
		cross apply ( select rc.TYPE_CD + ':' + str(rc.ID) + ';' 
					  from REQUIRED_COVERAGE rc 
					  where p.ID = rc.PROPERTY_ID
						and rc.PURGE_DT is null
					  for xml path('') ) ca1 ( RCTypes )
		cross apply ( select str(u.UTL_LOAN_ID) + ',' + str(u.UTL_PROPERTY_ID) + ';' 
					  from UTL_MATCH_RESULT u 
					  where p.ID = u.PROPERTY_ID
						and u.PURGE_DT is null
					  for xml path('') ) ca2 ( UTLMatchResultIds )
	  where p.LENDER_ID = @lenderId
		and p.RECORD_TYPE_CD = 'G'
		and p.PURGE_DT is NULL
   END
   ELSE IF @matchMode = 'LFP' 
   BEGIN
		IF @transactionId IS NULL
		BEGIN
			  select p.ID, col.LOAN_ID,
					 ISNULL(UPPER(p.DESCRIPTION_TX),''), ISNULL(UPPER(p.VIN_TX),''), ISNULL(UPPER(p.YEAR_TX),''), ISNULL(UPPER(p.MAKE_TX),''), ISNULL(UPPER(p.MODEL_TX),''),
					 ISNULL(UPPER(pa.LINE_1_TX),''), ISNULL(UPPER(pa.LINE_2_TX),''), ISNULL(UPPER(pa.CITY_TX),''), ISNULL(UPPER(pa.STATE_PROV_TX),''), ISNULL(UPPER(pa.POSTAL_CODE_TX),''),
					 col.COLLATERAL_CODE_ID,
					 p.ALT_MATCH_XML,
					 (REPLACE(ca1.RCTypes, ' ', '')),
					 (REPLACE(ca2.UTLMatchResultIds, ' ', '')),
					 p.FIELD_PROTECTION_XML
			  from PROPERTY p
				left outer join OWNER_ADDRESS pa on p.ADDRESS_ID = pa.ID and pa.purge_dt is null
				inner join COLLATERAL col on col.PROPERTY_ID = p.ID and col.PURGE_DT is null
				cross apply ( select rc.TYPE_CD + ':' + str(rc.ID) + ';' 
							  from REQUIRED_COVERAGE rc 
							  where p.ID = rc.PROPERTY_ID
								and rc.PURGE_DT is null
							  for xml path('') ) ca1 ( RCTypes )
				cross apply ( select str(u.UTL_LOAN_ID) + ',' + str(u.UTL_PROPERTY_ID) + ';' 
							  from UTL_MATCH_RESULT u 
							  where p.ID = u.PROPERTY_ID
								and u.PURGE_DT is null
							  for xml path('') ) ca2 ( UTLMatchResultIds )
			  where p.LENDER_ID = @lenderId
				and p.RECORD_TYPE_CD IN ('G', 'A', 'D')
				and p.PURGE_DT is NULL  
		END
		ELSE
		BEGIN
			  select p.ID, col.LOAN_ID,
					 ISNULL(UPPER(p.DESCRIPTION_TX),''), ISNULL(UPPER(p.VIN_TX),''), ISNULL(UPPER(p.YEAR_TX),''), ISNULL(UPPER(p.MAKE_TX),''), ISNULL(UPPER(p.MODEL_TX),''),
					 ISNULL(UPPER(pa.LINE_1_TX),''), ISNULL(UPPER(pa.LINE_2_TX),''), ISNULL(UPPER(pa.CITY_TX),''), ISNULL(UPPER(pa.STATE_PROV_TX),''), ISNULL(UPPER(pa.POSTAL_CODE_TX),''),
					 col.COLLATERAL_CODE_ID,
					 p.ALT_MATCH_XML,
					 (REPLACE(ca1.RCTypes, ' ', '')),
					 (REPLACE(ca2.UTLMatchResultIds, ' ', '')),
					 p.FIELD_PROTECTION_XML
			  from PROPERTY p
				left outer join OWNER_ADDRESS pa on p.ADDRESS_ID = pa.ID and pa.purge_dt is null
				inner join COLLATERAL col on col.PROPERTY_ID = p.ID and col.PURGE_DT is null
				join fnGetCollateralIdsByTransactionId(@transactionId) fn on fn.ID = col.ID
				cross apply ( select rc.TYPE_CD + ':' + str(rc.ID) + ';' 
							  from REQUIRED_COVERAGE rc 
							  where p.ID = rc.PROPERTY_ID
								and rc.PURGE_DT is null
							  for xml path('') ) ca1 ( RCTypes )
				cross apply ( select str(u.UTL_LOAN_ID) + ',' + str(u.UTL_PROPERTY_ID) + ';' 
							  from UTL_MATCH_RESULT u 
							  where p.ID = u.PROPERTY_ID
								and u.PURGE_DT is null
							  for xml path('') ) ca2 ( UTLMatchResultIds )
			  where p.LENDER_ID = @lenderId
				and p.RECORD_TYPE_CD IN ('G', 'A', 'D')
				and p.PURGE_DT is NULL		
		END 
   END
   ELSE IF @matchMode = 'LFP_FP' 
   BEGIN
		IF @transactionId IS NULL
		BEGIN
			  select p.ID, col.LOAN_ID,
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Description" or @name="DESCRIPTION"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(p.DESCRIPTION_TX),'')),  
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Vin" or @name="VIN"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(p.VIN_TX),'')), 
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Year"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(p.YEAR_TX),'')), 
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Make"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(p.MAKE_TX),'')), 
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Model"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(p.MODEL_TX),'')),
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.Line1"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(pa.LINE_1_TX),'')), 
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.Line2"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(pa.LINE_2_TX),'')), 
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.City"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(pa.CITY_TX),'')), 
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.State"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(pa.STATE_PROV_TX),'')), 
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.PostalCode"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(pa.POSTAL_CODE_TX),'')),
					 col.COLLATERAL_CODE_ID,
					 p.ALT_MATCH_XML,
					 (REPLACE(ca1.RCTypes, ' ', '')),
					 (REPLACE(ca2.UTLMatchResultIds, ' ', '')),
					 p.FIELD_PROTECTION_XML
			  from PROPERTY p
				left outer join OWNER_ADDRESS pa on p.ADDRESS_ID = pa.ID and pa.purge_dt is null
				inner join COLLATERAL col on col.PROPERTY_ID = p.ID and col.PURGE_DT is null				
				cross apply ( select rc.TYPE_CD + ':' + str(rc.ID) + ';' 
							  from REQUIRED_COVERAGE rc 
							  where p.ID = rc.PROPERTY_ID
								and rc.PURGE_DT is null
							  for xml path('') ) ca1 ( RCTypes )
				cross apply ( select str(u.UTL_LOAN_ID) + ',' + str(u.UTL_PROPERTY_ID) + ';' 
							  from UTL_MATCH_RESULT u 
							  where p.ID = u.PROPERTY_ID
								and u.PURGE_DT is null
							  for xml path('') ) ca2 ( UTLMatchResultIds )
			  where p.LENDER_ID = @lenderId
				and p.RECORD_TYPE_CD IN ('G', 'A', 'D')
				and p.PURGE_DT is NULL 
		END
		ELSE
		BEGIN
			  select p.ID, col.LOAN_ID,
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Description" or @name="DESCRIPTION"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(p.DESCRIPTION_TX),'')),  
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Vin" or @name="VIN"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(p.VIN_TX),'')), 
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Year"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(p.YEAR_TX),'')), 
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Make"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(p.MAKE_TX),'')), 
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Model"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(p.MODEL_TX),'')),
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.Line1"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(pa.LINE_1_TX),'')), 
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.Line2"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(pa.LINE_2_TX),'')), 
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.City"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(pa.CITY_TX),'')), 
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.State"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(pa.STATE_PROV_TX),'')), 
					 ISNULL(UPPER(p.FIELD_PROTECTION_XML.value('(//FP/Field[@name="Address.PostalCode"]/@bv)[1]','varchar(100)')), ISNULL(UPPER(pa.POSTAL_CODE_TX),'')),
					 col.COLLATERAL_CODE_ID,
					 p.ALT_MATCH_XML,
					 (REPLACE(ca1.RCTypes, ' ', '')),
					 (REPLACE(ca2.UTLMatchResultIds, ' ', '')),
					 p.FIELD_PROTECTION_XML
			  from PROPERTY p
				left outer join OWNER_ADDRESS pa on p.ADDRESS_ID = pa.ID and pa.purge_dt is null
				inner join COLLATERAL col on col.PROPERTY_ID = p.ID and col.PURGE_DT is null
				join fnGetCollateralIdsByTransactionId(@transactionId) fn on fn.ID = col.ID
				cross apply ( select rc.TYPE_CD + ':' + str(rc.ID) + ';' 
							  from REQUIRED_COVERAGE rc 
							  where p.ID = rc.PROPERTY_ID
								and rc.PURGE_DT is null
							  for xml path('') ) ca1 ( RCTypes )
				cross apply ( select str(u.UTL_LOAN_ID) + ',' + str(u.UTL_PROPERTY_ID) + ';' 
							  from UTL_MATCH_RESULT u 
							  where p.ID = u.PROPERTY_ID
								and u.PURGE_DT is null
							  for xml path('') ) ca2 ( UTLMatchResultIds )
			  where p.LENDER_ID = @lenderId
				and p.RECORD_TYPE_CD IN ('G', 'A', 'D')
				and p.PURGE_DT is NULL 		
		END  
   END			
END

GO

