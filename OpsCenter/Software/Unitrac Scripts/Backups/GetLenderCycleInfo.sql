
/****** Object:  StoredProcedure [dbo].[GetLenderCycleInfo]    Script Date: 02/03/2012 14:43:21 ******/
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = object_id(N'[dbo].[GetLenderCycleInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) 
BEGIN
	DROP PROCEDURE [dbo].[GetLenderCycleInfo]
END
GO

/****** Object:  StoredProcedure [dbo].[GetLenderCycleInfo]    Script Date: 02/03/2012 14:43:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetLenderCycleInfo]
(
	@LenderId bigint,
	@ProcessTypeCode nvarchar(10) = null,
	@LcgctId bigint = null,
	@PropertyType nvarchar(10) = null
)
AS
BEGIN
	--Default to cycle 
	if @ProcessTypeCode is null
		set @ProcessTypeCode = 'CYCLEPRC' 
	
	IF @LcgctId = 0
		Set @LcgctId = NULL
	
	IF @PropertyType = ''
		Set @PropertyType = NULL
		
	IF (@LenderId IS NOT NULL AND @LcgctId IS NOT NULL)
	BEGIN
		Select  
			DISTINCT TOP 1
			P.ID,
			LP.LENDER_ID,
			case 
				WHEN T3.Loc.value('.','datetimeoffset') = '0001-01-01 00:00:00' THEN GETDATE()
				ELSE T3.Loc.value('.','datetime') 
			END as NextCycle,
			T3.Loc.value('.','nvarchar(30)') as NextCycle,
			P.LAST_SCHEDULED_DT as LastCycle
		FROM   
			PROCESS_DEFINITION P 
			CROSS APPLY SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LCGCTList/LCGCTId') as T2(Loc) 
			CROSS APPLY SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/AnticipatedNextScheduledDate') as T3(Loc) 
			JOIN LENDER_COLLATERAL_GROUP_COVERAGE_TYPE LCGCT on LCGCT.ID = T2.Loc.value('.','bigint')
			JOIN LENDER_PRODUCT LP on LP.ID = LCGCT.LENDER_PRODUCT_ID
		WHERE
			P.PROCESS_TYPE_CD = @ProcessTypeCode
			and T3.Loc is not null
			and P.STATUS_CD <> 'Expired'
			and P.ACTIVE_IN = 'Y'
			AND LP.LENDER_ID = @LenderId
			AND LCGCT.ID = @LcgctId	
			AND LCGCT.PURGE_DT IS NULL
			AND LP.PURGE_DT IS NULL
			AND P.PURGE_DT IS NULL
		ORDER BY
			3 ASC	
	END	
	ELSE IF (@LenderId IS NOT NULL AND @PropertyType IS NOT NULL)
	BEGIN
		Select  
			DISTINCT TOP 1
			P.ID,
			LP.LENDER_ID,
			case 
				WHEN T3.Loc.value('.','datetimeoffset') = '0001-01-01 00:00:00' THEN GETDATE()
				ELSE T3.Loc.value('.','datetime') 
			END as NextCycle,
			T3.Loc.value('.','nvarchar(30)') as NextCycle,
			P.LAST_SCHEDULED_DT as LastCycle
		FROM   
			PROCESS_DEFINITION P 
			CROSS APPLY SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LCGCTList/LCGCTId') as T2(Loc) 
			CROSS APPLY SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/AnticipatedNextScheduledDate') as T3(Loc) 
			JOIN LENDER_COLLATERAL_GROUP_COVERAGE_TYPE LCGCT on LCGCT.ID = T2.Loc.value('.','bigint')
			JOIN LENDER_PRODUCT LP on LP.ID = LCGCT.LENDER_PRODUCT_ID
			JOIN dbo.LCCG_COLLATERAL_CODE_RELATE lccgRel on lccgRel.LCCG_ID = LCGCT.LCCG_ID
			JOIN dbo.COLLATERAL_CODE cc ON cc.ID = lccgRel.COLLATERAL_CODE_ID
			JOIN dbo.REF_CODE_ATTRIBUTE rca ON rca.ATTRIBUTE_CD='PropertyType' AND rca.DOMAIN_CD='SecondaryClassification'
							AND rca.REF_CD = cc.SECONDARY_CLASS_CD			
		WHERE
			P.PROCESS_TYPE_CD = @ProcessTypeCode
			and T3.Loc is not null
			and P.STATUS_CD <> 'Expired'
			and P.ACTIVE_IN = 'Y'
			AND LP.LENDER_ID = @LenderId
			AND rca.VALUE_TX = @PropertyType
			and lccgRel.PURGE_DT is NULL
			and cc.PURGE_DT is NULL
			and rca.PURGE_DT is NULL
			AND LCGCT.PURGE_DT IS NULL
			AND LP.PURGE_DT IS NULL
			AND P.PURGE_DT IS NULL
		ORDER BY
			3 ASC	
	END
	ELSE
	BEGIN
		Select  
			DISTINCT TOP 1
			P.ID,
			LP.LENDER_ID,
			case 
				WHEN T3.Loc.value('.','datetimeoffset') = '0001-01-01 00:00:00' THEN GETDATE()
				ELSE T3.Loc.value('.','datetime') 
			END as NextCycle,
			T3.Loc.value('.','nvarchar(30)') as NextCycle,
			P.LAST_SCHEDULED_DT as LastCycle
		FROM   
			PROCESS_DEFINITION P 
			CROSS APPLY SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LCGCTList/LCGCTId') as T2(Loc) 
			CROSS APPLY SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/AnticipatedNextScheduledDate') as T3(Loc) 
			JOIN LENDER_COLLATERAL_GROUP_COVERAGE_TYPE LCGCT on LCGCT.ID = T2.Loc.value('.','bigint')
			JOIN LENDER_PRODUCT LP on LP.ID = LCGCT.LENDER_PRODUCT_ID
		WHERE
			P.PROCESS_TYPE_CD = @ProcessTypeCode
			and T3.Loc is not null
			and P.STATUS_CD <> 'Expired'
			and P.ACTIVE_IN = 'Y'
			AND LP.LENDER_ID = @LenderId	
			and LCGCT.PURGE_DT IS NULL
			AND LP.PURGE_DT IS NULL
			AND P.PURGE_DT IS NULL
		ORDER BY
			3 ASC	
	END
	
END
GO


