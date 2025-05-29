USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[GetLenderClone]    Script Date: 1/3/2018 8:34:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetLenderClone]
(@lenderId bigint = null)
AS
BEGIN
   SET NOCOUNT ON

   if @lenderId is not null and @lenderId > 0 
   BEGIN
	SELECT
		L.AGENCY_ID
		,
		(
			SELECT
				LP.NAME_TX, LP.BASIC_TYPE_CD, LP.BASIC_SUB_TYPE_CD, CAST('1900/01/01' AS datetime) AS START_DT
				,
				(
					SELECT
						LCGCT.TYPE_CD, LCGCT.LCCG_ID, LCGCT.CREDIT_SCORE_TX, 
						LCGCT.LIEN_POSITION_NO, LCGCT.FLOOD_ZONE_AV_IN, LCGCT.OPTIONAL_IN
					FROM
						LENDER_COLLATERAL_GROUP_COVERAGE_TYPE LCGCT
					WHERE
						LCGCT.LENDER_PRODUCT_ID = LP.id 
						AND 
						LCGCT.PURGE_DT is NULL
					FOR xml
						PATH ('LenderCollateralGroupCoverageType') , ROOT ('LenderCollateralGroupCoverageTypes') , TYPE)
				,
				(
					SELECT
						MP.ID
					FROM
						MASTER_POLICY MP
						JOIN
						MASTER_POLICY_LENDER_PRODUCT_RELATE MPLPR
							ON MP.id = MPLPR.MASTER_POLICY_ID
					WHERE
						MPLPR.LENDER_PRODUCT_ID = LP.id 
						AND 
						MP.PURGE_DT is NULL
						AND 
						MPLPR.PURGE_DT is NULL
					FOR xml
						PATH ('MasterPolicy') , ROOT ('MasterPolicies') , TYPE)
				,
				(
					SELECT
						ESC.DESCRIPTION_TX, CAST('1900/01/01' AS datetime) AS START_DT, CAST('9999/12/31' AS datetime) AS END_DT, ESC.NOTICE_CYCLE_IN, ESC.COLLATERAL_CODE_ID
						,
						(
							SELECT
								ES.ORDER_NO, ES.EVENT_TYPE_CD, ES.TIMING_FROM_LAST_EVENT_DAYS_NO, 
								ES.QUOTE_EFFECTIVE_DATE_CD, ES.QUOTE_OFFSET_DAYS_NO, ES.QUOTE_PREMIUM_IN, 
								ES.IS_NOTICE_CYCLE_IN, ES.NOTICE_TYPE_CD, ES.NOTICE_SEQ_NO, 
								ES.SEND_CERTIFIED_IN, ES.TEMPLATE_ID
							FROM
								EVENT_SEQUENCE ES
							WHERE
								ES.EVENT_SEQ_CONTAINER_ID = ESC.id 
								AND 
								ES.PURGE_DT is NULL
							FOR xml
								PATH ('EventSequence') , ROOT ('EventSequences') , TYPE)
						,
						(
							SELECT
								ERD.ID, ERD.TYPE_CD, ERD.SUB_TYPE_CD, ERD.DESCRIPTION_TX, 
								ERD.DATE_COMPARISON_TYPE_CD
							FROM
								EVENT_REACTION_DEFINITION ERD
								JOIN
								ESC_ERD_RELATE EER
									ON ERD.id = EER.ERD_ID
							WHERE
								EER.ESC_ID = ESC.id 
								AND 
								EER.PURGE_DT is NULL
							FOR xml
								PATH ('EventReactionDefinition') , ROOT ('EventReactionDefinitions') , TYPE)
					FROM
						EVENT_SEQ_CONTAINER ESC
					WHERE
						ESC.LENDER_PRODUCT_ID = LP.id 
						AND
						ESC.PURGE_DT is NULL
					FOR xml
						PATH ('EventSequenceContainer') , ROOT ('EventSequenceContainers') , TYPE)
				,
				(
					SELECT
						id.TYPE_CD, id.LETTER_DESCRIPTION_TX, id.CAN_CANCEL_CPI_IN
					FROM
						IMPAIRMENT_DEFINITION id
					WHERE
						id.LENDER_PRODUCT_ID = LP.id 
						AND 
						id.PURGE_DT is NULL
					FOR xml
						PATH ('ImpairmentDefinition') , ROOT ('ImpairmentDefinitions') , TYPE)
				,
				(
					SELECT
						BOG.NAME_TX, BOG.DESCRIPTION_TX, BOG.GROUP_TYPE_CD, BOG.RELATE_CLASS_NM
						,
						(
							SELECT
								BRB.NAME_TX, BRB.RULE_TYPE_CD, BRB.ORDER_NO, BRB.SHARED_RULE_IN,
								BRB.RULE_EXTENSION_XML, BRB.DESCRIPTION_TX
								,
								(
									SELECT
										RCB.NAME_TX, RCB.CONDITION_TYPE_CD, RCB.ORDER_NO,
										RCB.LEVEL_NO, RCB.RULE_CONDITION_XML
									FROM
										RULE_CONDITION_BASE RCB
									WHERE
										RCB.BUSINESS_RULE_BASE_ID = BRB.id 
										AND 
										RCB.PURGE_DT is NULL
									FOR xml
										PATH ('RuleConditionBase') , ROOT ('RuleConditionBases') , TYPE)
								,
								(
									SELECT
										BO.NAME_TX, BO.DESCRIPTION_TX, BO.DEFAULT_VALUE_TX
									FROM
										BUSINESS_OPTION BO
									WHERE
										BO.BUSINESS_RULE_ID = BRB.id 
										AND 
										BO.PURGE_DT is NULL
									FOR xml
										PATH ('BusinessOption') , ROOT ('BusinessOptions') , TYPE)
							FROM
								BUSINESS_RULE_BASE BRB
							WHERE
								BRB.BUSINESS_OPTION_GROUP_ID = BOG.id 
								AND 
								BRB.PURGE_DT is NULL
							FOR xml
								PATH ('BusinessRuleBase') , ROOT ('BusinessRuleBases') , TYPE)
						,
						(
								SELECT
										BO.NAME_TX, BO.DESCRIPTION_TX, BO.DEFAULT_VALUE_TX
									FROM
										BUSINESS_OPTION BO
									WHERE
										BO.BUSINESS_OPTION_GROUP_ID = BOG.ID 
										AND 
										BO.PURGE_DT is NULL
									FOR xml
										PATH ('BusinessOptionRoot') , ROOT ('BusinessOptions') , TYPE
						)
					FROM
						BUSINESS_OPTION_GROUP BOG
					WHERE
						BOG.RELATE_ID = LP.id
						AND BOG.RELATE_CLASS_NM = 'Allied.UniTrac.LenderProduct'
					FOR xml
						PATH ('BusinessOptionGroup') , ROOT ('BusinessOptionGroups') , TYPE)
			FROM
				LENDER_PRODUCT LP
			WHERE
				LP.LENDER_ID = L.id 
				AND 
				LP.PURGE_DT is NULL
			FOR xml
				PATH ('LenderProduct') , TYPE)
		AS LenderProducts
		,
		(
			SELECT
				MP.ID, MP.CARRIER_PRODUCT_ID, MP.CARRIER_ID, CAST('1900/01/01' AS datetime) AS START_DT, MP.CARRIER_EFFECTIVE_DT,
				MP.DESCRIPTION_TX, MP.IN_USE, MP.END_REASON_CD, MP.COVER_LETTER_TEMPLATE_ID, 
				MP.IGNORE_CO_BORROWER_SAME_ADDRESS_IN
				,
				(
					SELECT
						MPA.COVERAGE_TYPE_CD, CAST('1900/01/01' AS datetime) AS START_DT, CAST('9999/12/31' AS datetime) AS END_DT, MPA.ISSUE_PROCEDURE_ID,
						MPA.CANCEL_PROCEDURE_ID, MPA.PRIMARY_CLASS_CD, MPA.SECONDARY_CLASS_CD, MPA.COLLATERAL_CODE_ID,
						MPA.FORM_NUMBER_TX, MPA.COVER_LETTER_TEMPLATE_ID, MPA.CERTIFICATE_TEMPLATE_ID, MPA.SPECIAL_HANDLING_XML
						,
						(
						SELECT 
							CAST('1900/01/01' AS datetime) AS START_DT, CAST('9999/12/31' AS datetime) AS END_DT, MPAE.POLICY_ENDORSEMENT_ID
							FROM 
								MASTER_POLICY_ENDORSEMENT MPAE
							WHERE 
								MPAE.MASTER_POLICY_ASSIGNMENT_ID = MPA.id 
								AND 
								MPAE.PURGE_DT is NULL
							FOR xml
								PATH ('MasterPolicyEndorsement') , ROOT ('MasterPolicyEndorsements') , TYPE)
				FROM
						MASTER_POLICY_ASSIGNMENT MPA
					WHERE
						MPA.MASTER_POLICY_ID = MP.id
						AND 
						MPA.PURGE_DT is NULL
					FOR xml
						PATH ('MasterPolicyAssignment') , ROOT ('MasterPolicieAssignments') , TYPE)
			FROM
				MASTER_POLICY MP
			WHERE
				MP.LENDER_ID = L.id 
				AND 
				MP.PURGE_DT is NULL
			FOR xml
				PATH ('MasterPolicyRoot') , ROOT ('MasterPolicies') , TYPE)
		,
		(
			SELECT
				LRC.DESCRIPTION_TX, LRC.GENERATION_TYPE_CD, LRC.GROUP_TX, LRC.SORT_TX,
				LRC.FILTER_TX, LRC.HEADER_TX, LRC.FOOTER_TX, LRC.WEB_ENABLED_CD,
				LRC.TITLE_TX, LRC.REPORT_CONFIG_ID, LRC.RETAIN_GROUP_IN, LRC.OUTPUT_TYPE_CD, LRC.COVERAGE_TYPE_CD
			FROM
				LENDER_REPORT_CONFIG LRC
			WHERE
				LRC.LENDER_ID = L.id
				AND
				LRC.PURGE_DT is NULL
			FOR xml
				PATH ('LenderReportConfig') , ROOT ('LenderReportConfigs') , TYPE)
		,
		(
			SELECT
				LCCG.ID, LCCG.NAME_TX
				,
				(
					SELECT
						LCCR.COLLATERAL_CODE_ID
					FROM
						LCCG_COLLATERAL_CODE_RELATE LCCR
					WHERE
						LCCR.LCCG_ID = LCCG.id 
						AND 
						LCCR.PURGE_DT is NULL
					FOR xml
						PATH ('LCCGCollateralCodeRelate') , ROOT ('LCCGCollateralCodeRelates') , TYPE)
			FROM
				LENDER_COLLATERAL_CODE_GROUP LCCG
			WHERE
				LCCG.LENDER_ID = L.id
				AND
				LCCG.PURGE_DT is NULL
			FOR xml
				PATH ('LenderCollateralCodeGroup') , ROOT ('LenderCollateralCodeGroups') , TYPE)
		,
		(
			SELECT
				RD.DEF_ID, RD.VALUE_TX
			FROM RELATED_DATA RD 
			JOIN RELATED_DATA_DEF RDD ON RD.DEF_ID = RDD.ID 
			WHERE 
			RDD.RELATE_CLASS_NM = 'Lender' 
			AND
			RD.RELATE_ID = L.ID
			FOR xml
				PATH ('RelatedData') , ROOT ('RelatedDatas') , TYPE)
	FROM
		LENDER L
	WHERE
		L.ID = @lenderId
	FOR xml
		PATH ('Lender') , ROOT ('Lenders')
   END
END

GO

