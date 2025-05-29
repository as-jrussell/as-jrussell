SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Added @excludeLoansWithCPIIn flag for bug 29219
--exec GetPortfolioXML @lenderId = 317
CREATE PROCEDURE [dbo].[GetPortfolioXML] (
	@lenderId BIGINT
	,@branchId BIGINT = NULL
	,@divisionId BIGINT = NULL
	,@coverageTypeCode NVARCHAR(1000) = NULL
	,@lccgId BIGINT = NULL
	,@collCodeId BIGINT = NULL
	,@activeLoansIn CHAR(1) = 'N'
	,-- => activeLoansOnlyIn
	@uninsuredLoansOnlyIn CHAR(1) = 'N'
	,@excludeLoansWithCPIIn CHAR(1) = 'N'
	,@escrowIn CHAR(1) = NULL
	,@includeUTLs CHAR(1) = 'N'
	,@department NVARCHAR(20) = NULL
	,@debug as bit=0
	)
AS
BEGIN
	DECLARE @escrowInMatch CHAR(1) = @escrowIn

	IF @activeLoansIn IS NULL
		SET @activeLoansIn = 'N'

	IF @includeUTLs IS NULL
		SET @includeUTLs = 'N'

	IF @uninsuredLoansOnlyIn IS NULL
		SET @uninsuredLoansOnlyIn = 'N'

	IF @excludeLoansWithCPIIn IS NULL
		SET @excludeLoansWithCPIIn = 'N'

	DECLARE @cvgTypeCodeXml XML
	DECLARE @cvgTypeCodeTable TABLE (cvgTypecode NVARCHAR(30))

	SELECT @cvgTypeCodeXml = CAST('<CvgType>' + REPLACE(@coverageTypeCode, ',', '</CvgType><CvgType>') + '</CvgType>' AS XML)

	INSERT INTO @cvgTypeCodeTable
	SELECT t.value('.', 'nvarchar(30)') AS cvgTypeCode
	FROM @cvgTypeCodeXml.nodes('/CvgType') AS cvgTypeCodeXml(t)

	DECLARE @filterByCollCode CHAR

	SET @filterByCollCode = 'N'

	DECLARE @tmpCC TABLE (CC_ID BIGINT)

	IF (ISNULL(@lccgId, 0) > 0)
	BEGIN
		SET @filterByCollCode = 'Y'

		INSERT INTO @tmpCC (CC_ID)
		SELECT DISTINCT cc.id
		FROM LENDER_COLLATERAL_CODE_GROUP lccg
		INNER JOIN LCCG_COLLATERAL_CODE_RELATE r ON r.LCCG_ID = lccg.id
		INNER JOIN COLLATERAL_CODE cc ON cc.id = r.COLLATERAL_CODE_ID
		WHERE r.PURGE_DT IS NULL
			AND cc.PURGE_DT IS NULL
			AND lccg.id = @lccgId
	END

	IF (
			ISNULL(@collCodeId, 0) > 0
			AND NOT EXISTS (
				SELECT 1
				FROM @tmpCC
				WHERE CC_ID = @collCodeId
				)
			)
	BEGIN
		SET @filterByCollCode = 'Y'

		INSERT INTO @tmpCC (CC_ID)
		VALUES (@collCodeId)
	END

	----select only those loans/properties that match the search criteria. 
	----Otherwise the final select query will pull in all loans because the search criteria is applied at different levels in that query

	IF OBJECT_ID(N'tempdb..#tmpLoans') IS NULL
	BEGIN
		CREATE TABLE #tmpLoans (
			LOAN_ID BIGINT NOT NULL
			,PROPERTY_ID BIGINT
			,COLLATERAL_ID BIGINT
			,REQUIRED_COVERAGE_ID BIGINT
			,REQ_ESCROW_IN VARCHAR(1)
			)

		CREATE INDEX IX_2 ON #tmpLoans (
			LOAN_ID )

		CREATE INDEX IX_3 ON #tmpLoans (
			REQUIRED_COVERAGE_ID )

		CREATE INDEX IX_4 ON #tmpLoans (
			COLLATERAL_ID )

		CREATE INDEX IX_5 ON #tmpLoans (
			PROPERTY_ID )
	END

	INSERT INTO #tmpLoans (
		LOAN_ID
		,PROPERTY_ID
		,COLLATERAL_ID
		,REQUIRED_COVERAGE_ID
		,REQ_ESCROW_IN
		)
	SELECT DISTINCT ln.id
		,p.id
		,c.id
		,rc.id
		,CASE 
			WHEN re.ID IS NULL
				THEN 'N'
			ELSE 'Y'
			END
	FROM LOAN ln
	INNER JOIN COLLATERAL c ON c.LOAN_ID = ln.id
	INNER JOIN property p ON c.PROPERTY_ID = p.id
	INNER JOIN REQUIRED_COVERAGE rc ON rc.PROPERTY_ID = p.id
	--Branch
	LEFT JOIN LENDER_ORGANIZATION LO_BRANCH ON (
			LO_BRANCH.LENDER_ID = LN.LENDER_ID
			AND LO_BRANCH.CODE_TX = LN.BRANCH_CODE_TX
			AND LO_BRANCH.TYPE_CD = 'BRCH'
			AND LO_BRANCH.PURGE_DT IS NULL
			)
	--Division
	LEFT JOIN LENDER_ORGANIZATION LO_DIVISION ON (
			LO_DIVISION.LENDER_ID = LN.LENDER_ID
			AND LO_DIVISION.CODE_TX = LN.DIVISION_CODE_TX
			AND LO_DIVISION.TYPE_CD = 'DIV'
			AND LO_DIVISION.PURGE_DT IS NULL
			)
	LEFT JOIN REQUIRED_ESCROW re ON (
			rc.ID = re.REQUIRED_COVERAGE_ID
			AND RE.PURGE_DT IS NULL
			AND RE.ACTIVE_IN = 'Y'
			)
	WHERE ln.LENDER_ID = @lenderId
		AND ln.PURGE_DT IS NULL
		AND p.PURGE_DT IS NULL
		AND c.PURGE_DT IS NULL
		AND rc.PURGE_DT IS NULL
		AND ln.RECORD_TYPE_CD <> 'D'
		AND p.RECORD_TYPE_CD <> 'D'
		AND (
			@filterByCollCode = 'N'
			OR c.COLLATERAL_CODE_ID IN (
				SELECT cc_id
				FROM @tmpCC
				)
			)
		AND (
			@branchId IS NULL
			OR LO_BRANCH.id = @branchId
			)
		AND (
			@divisionId IS NULL
			OR LO_DIVISION.id = @divisionId
			)
		AND (
			(
				@activeLoansIn = 'N'
				AND LN.STATUS_CD IN (
					'A'
					,'B'
					,'F'
					,'L'
					,'N'
					)
				)
			OR (
				@activeLoansIn = 'Y'
				AND LN.STATUS_CD = 'A'
				)
			)
		AND (
			rc.STATUS_CD IN (
				'A'
				,'M'
				,'D'
				,'T'
				)
			)
		AND c.Status_Cd = 'A'
		AND (
			(
				@includeUTLs = 'N'
				AND LN.RECORD_TYPE_CD IN ('G')
				)
			OR (
				@includeUTLs = 'Y'
				AND LN.RECORD_TYPE_CD IN (
					'G'
					,'E'
					,'I'
					,'U'
					)
				)
			)
		AND (
			@coverageTypeCode IS NULL
			OR rc.TYPE_CD IN (
				SELECT cvgTypeCode
				FROM @cvgTypeCodeTable
				)
			)
		AND (
			(
				@escrowInMatch = 'Y'
				AND NOT re.ID IS NULL
				)
			OR (
				@escrowInMatch = 'N'
				AND re.ID IS NULL
				)
			OR (@escrowInMatch IS NULL)
			)
		--the following condition is not checked for in the subsequent select query - the idea is to basically retreive all loans (with all coverages) that have at least one uninsured coverage
		AND (
			@uninsuredLoansOnlyIn = 'N'
			OR rc.INSURANCE_STATUS_CD IN (
				'A'
				,'C'
				,'CH'
				,'E'
				,'EH'
				,'N'
				)
			OR rc.INSURANCE_SUB_STATUS_CD IN ('I')
			)
		AND (
			@excludeLoansWithCPIIn = 'N'
			OR rc.SUMMARY_SUB_STATUS_CD NOT IN (
				'P'
				,'C'
				)
			)
		AND LN.EXTRACT_UNMATCH_COUNT_NO = 0
		AND (
			@department IS NULL
			OR ISNULL(ln.DEPARTMENT_CODE_TX, '') = @department
			)

if @debug = 1
begin
	select * from #tmpLoans
end


	DECLARE @isDirectPayDefId BIGINT

	SELECT @isDirectPayDefId = rdd.Id
	FROM RELATED_DATA_DEF rdd
	WHERE rdd.NAME_TX = 'DirectPay'
		AND rdd.RELATE_CLASS_NM = 'Lender'

	SELECT ISNULL(rd.VALUE_TX, 'N') AS [@directPayIn]
		,@lenderId AS [@lenderID]
		,l.code_tx AS [@lenderCode]
		,ISNULL(@escrowInMatch, 'A') AS [@escrowRunType]
		,(
			SELECT
				--LOAN
				LN.id AS [@id]
				,NULLIF(LN.NUMBER_TX, '') AS [@num]
				,NULLIF(LN.BALANCE_AMOUNT_NO, 0) AS [@bal]
				,NULLIF(LO_DIVISION.NAME_TX, '') AS [@divNm]
				,NULLIF(LN.BRANCH_CODE_TX, '') AS [@branchCd]
				,NULLIF(LN.DEPARTMENT_CODE_TX, '') AS [@departmentCd]
				,NULLIF(LN.EFFECTIVE_DT, '') AS [@effDt]
				,NULLIF(LN.MATURITY_DT, '') AS [@expDt]
				,NULLIF(LN.APR_AMOUNT_NO, 0) AS [@apr]
				,
				--LN.STATUS_CD AS [@statCd],
				rc.MEANING_TX AS [@status]
				,NULLIF(rd.VALUE_TX, '') AS [@misc1]
				,-- In VUT it is used for Old Policy number,
				[@dlnqDt] = CASE 
					WHEN GETDATE() >= DATEADD(DAY, 120, LN.NEXT_SCHEDULED_PAYMENT_DT)
						THEN CONVERT(CHAR(8), DATEADD(DAY, 120, LN.NEXT_SCHEDULED_PAYMENT_DT), 112)
					ELSE NULL
					END
				,NULLIF(rd2.VALUE_TX, '') AS [@misc2]
				,NULLIF(LN.SERVICECENTER_CODE_TX, '') AS [@svcCd]
				,
				--Collaterals		
				(
					SELECT
						--COLLATERAL
						COLL.id AS [@id]
						,
						--nullif(CC.CODE_TX, '') AS [@collCd],
						nullif(CC.PRIMARY_CLASS_CD, '') AS [@priClassCD]
						,
						--NULLIF(CC.SECONDARY_CLASS_CD, '') AS [@secClassCD],
						NULLIF(PROPERTY_TYPE_RCA.MEANING_TX, '') AS [@propTyp]
						,NULLIF(COLL.COLLATERAL_NUMBER_NO, 0) AS [@num]
						,NULLIF(COLL.LOAN_BALANCE_NO, 0) AS [@bal]
						,NULLIF(COLL.PURPOSE_CODE_TX, '') AS [@purpCd]
						,NULLIF(COLL.ASSET_NUMBER_TX, '') AS [@assetNum]
						,NULLIF(COLL.PRIMARY_LOAN_IN, 'N') AS [@primaryLoan]
						,
						---PROPERTY
						P.id AS [@propID]
						,NULLIF(P.DESCRIPTION_TX, '') AS [@desc]
						,NULLIF(P.VIN_TX, '') AS [@vin]
						,NULLIF(P.MAKE_TX, '') AS [@make]
						,NULLIF(P.MODEL_TX, '') AS [@model]
						,NULLIF(P.BODY_TX, '') AS [@body]
						,NULLIF(P.YEAR_TX, '') AS [@year]
						,NULLIF(PROP_ADD.LINE_1_TX, '') AS [@line1]
						,NULLIF(PROP_ADD.LINE_2_TX, '') AS [@line2]
						,NULLIF(PROP_ADD.CITY_TX, '') AS [@city]
						,NULLIF(PROP_ADD.STATE_PROV_TX, '') AS [@state]
						,NULLIF(PROP_ADD.POSTAL_CODE_TX, '') AS [@zip]
						,NULLIF(P.FLOOD_ZONE_TX, '') AS [@floodZn]
						,NULLIF(P.ACV_NO, 0) AS [@acv]
						,--COVERAGES, POLICIES, NOTICE, CERT
						(
							SELECT RC.id AS [@id]
								,RC.TYPE_CD AS [@typCd]
								,typ.MEANING_TX AS [@typ]
								,RC.STATUS_CD AS [@statCd]
								,REQ_ESCROW_IN AS [@escrowIn]
								,RC.REQUIRED_AMOUNT_NO AS [@reqAmt]
								,RC.INSURANCE_STATUS_CD AS [@insStatCd]
								,stat.MEANING_TX AS [@insStat]
								,rc.INSURANCE_SUB_STATUS_CD AS [@insSubStatCd]
								,NULLIF(rc.good_thru_dt, '') AS [@goodThruDt]
								,substat.MEANING_TX AS [@insSubStat]
								,NULLIF(RC.EXPOSURE_DT, '') AS [@expoDt]
								,NULLIF(WT.AUTHORIZED_BY_TX, '') AS [@waiveAuthBy]
								,
								-- Notice
								NULLIF(RC.NOTICE_TYPE_CD, '') AS [@ntcTypCd]
								,NULLIF(ntcType.MEANING_TX, '') AS [@ntcTyp]
								,NULLIF(RC.NOTICE_SEQ_NO, '') AS [@ntcSeq]
								,NULLIF(RC.NOTICE_DT, '') AS [@ntcIssDt]
								,
								--- FPC
								NULLIF(FPC_INFO.id, 0) AS [@fpcID]
								,[@fpcInd] = CASE 
									WHEN FPC_INFO.NUMBER_TX IS NULL
										THEN 'N'
									ELSE 'Y'
									END
								,NULLIF(FPC_INFO.NUMBER_TX, '') AS [@fpcNumb]
								,NULLIF(FPC_INFO.EFFECTIVE_DT, '') AS [@fpcEffDt]
								,NULLIF(FPC_INFO.CANCELLATION_DT, '') AS [@fpcCxlDt]
								,
								--nullif(FPC_INFO.MONTHLY_BILLING_IN, '') AS [@fpcMonBillIn],
								NULLIF(FPC_INFO.EXPIRATION_DT, '') AS [@fpcExpDt]
								,
								--nullif(FPC_INFO.PRODUCER_NUMBER_TX, '') AS [@fpcProdNo],
								NULLIF(FPC_INFO.ISSUE_DT, '') AS [@fpcIssDt]
								,NULLIF(FPC_INFO.STATUS_CD, '') AS [@fpcStatCd]
								,-- Policies
								NULLIF(FPC_INFO.TOTAL_PREMIUM_NO, 0) AS [@fpcPolicyAmt]
								,NULLIF(FPC_INFO.COVERAGE_AMT, '0') AS [@fpcCoverageAmt]
								,(
									SELECT NULLIF(OP.id, 0) AS [@id]
										,ISNULL(bic.NAME, OP.BIC_NAME_TX) AS [@bicName]
										,ISNULL(bico.CONTINUOUS_IN, 'N') AS [@continuousIn]
										,NULLIF(OP.BIC_ID, '') AS [@bicID]
										,NULLIF(OP.POLICY_NUMBER_TX, '') AS [@num]
										,NULLIF(e.POLICY_NUMBER_TX, '') AS [@escrowNum]
										,NULLIF(e.DUE_DT, '') AS [@escrowDueDt]
										,NULLIF(e.OTHER_NO, 0) AS [@otherAMT]
										,e.TOTAL_AMOUNT_NO AS [@policyAMT]
										,NULLIF(e.PREMIUM_NO, 0) AS [@escrowPremAMT]
										,NULLIF(e.TOTAL_POLICY_PREMIUM_NO, 0) AS [@totalPlcyPremAMT]
										,NULLIF(e.END_DT, '') AS [@EndDt]
										,NULLIF(OP.EFFECTIVE_DT, '') AS [@effDt]
										,NULLIF(e.EFFECTIVE_DT, '') AS [@eff1Dt]
										,NULLIF(OP.MOST_RECENT_EFFECTIVE_DT, '') AS [@eff2Dt]
										,NULLIF(OP.MOST_RECENT_MAIL_DT, '') AS [@mailDt]
										,NULLIF(OP.EXPIRATION_DT, '') AS [@expDt]
										,NULLIF(OP.CANCELLATION_DT, '') AS [@cxlDt]
										,NULLIF(OP.SPECIAL_HANDLING_XML.value('(//SH/LienHolderName)[1]', 'nvarchar(500)'), '') AS [@lhName]
										,NULLIF(OP.CREATE_DT, '') AS [@createDt]
										,NULLIF(OP.UPDATE_DT, '') AS [@updateDt]
										,NULLIF(OP.PURGE_DT, '') AS [@purgeDt]
										,NULLIF(OP.EXCESS_IN, '') AS [@policyExcessIn]
										,NULLIF(e.EXCESS_IN, '') AS [@escrowExcessIn]
										,NULLIF(BIA.AGENT_TX, '') AS [@agentName]
										,NULLIF(BIA.PHONE_TX, '') AS [@agentPhn]
										,NULLIF(BIA.PHONE_EXT_TX, '') AS [@agentPhnExt]
										,CASE 
											WHEN OP_BASEPROP_TYPE_RCA.CODE_CD IN (
													'COND'
													,'COCOND'
													)
												AND OP.BASE_PROPERTY_TYPE_CD = 'RE'
												THEN OP_BASEPROP_TYPE_RCA.VALUE_TX
											ELSE NULLIF(OP.BASE_PROPERTY_TYPE_CD, '')
											END AS [@basePropType]
										,NULLIF(OP.STATUS_CD, '') AS [@policyStatCd]
										,NULLIF(OP.SUB_STATUS_CD, '') AS [@policySubStatCd]
										,(
											SELECT NULLIF(PC2.SUB_TYPE_CD, '') AS [@subTypCd]
												,NULLIF(PC2.AMOUNT_NO, 0) AS [@covAmt]
												,NULLIF(PC2.DEDUCTIBLE_NO, 0) AS [@ded]
											FROM POLICY_COVERAGE PC2
											WHERE PC2.OWNER_POLICY_ID = OP.id
												AND PC2.TYPE_CD = RC.TYPE_CD
											FOR XML PATH('PlcyCvg')
												,TYPE
											) AS 'PlcyCvgs'
										,(
											SELECT TOP 1 NULLIF(EP.ID, 0) AS [@id]
													,NULLIF(EP.POLICY_NUMBER_TX, '') AS [@escrowNum]
													,escsubstat.MEANING_TX AS [@escrowSubStat]
													,NULLIF(EP.DUE_DT, '') AS [@escrowDueDt]
													,NULLIF(EP.OTHER_NO, 0) AS [@otherAMT]
													,EP.TOTAL_AMOUNT_NO AS [@policyAMT]
													,NULLIF(EP.PREMIUM_NO, 0) AS [@escrowPremAMT]
													,NULLIF(EP.TOTAL_POLICY_PREMIUM_NO, 0) AS [@totalPlcyPremAMT]
													,NULLIF(EP.END_DT, '') AS [@escrowEndDt]
													,NULLIF(EP.EFFECTIVE_DT, '') AS [@eff1Dt]
													,NULLIF(EP.EXCESS_IN, '') AS [@escrowExcessIn]
													,NULLIF(EP.BIC_ID, '') AS [@escrowBicId]
											FROM ESCROW EP
											LEFT JOIN REF_CODE escsubstat ON escsubstat.CODE_CD = EP.SUB_STATUS_CD
												AND escsubstat.DOMAIN_CD = 'EscrowSubStatus'
											WHERE 
												EP.PURGE_DT IS NULL
												AND EP.ID IN (SELECT ESCROW_ID FROM ESCROW_REQUIRED_COVERAGE_RELATE WHERE REQUIRED_COVERAGE_ID = RC.ID AND PURGE_DT IS NULL)
												AND EP.PROPERTY_ID = RC.PROPERTY_ID
												AND EP.SUB_STATUS_CD NOT IN ('DUPLICATE', 'QCREJ')
												AND CASE WHEN
														(CASE WHEN OP_BASEPROP_TYPE_RCA.CODE_CD IN (
																'COND'
																,'COCOND'
																)
															AND OP.BASE_PROPERTY_TYPE_CD = 'RE'
															THEN OP_BASEPROP_TYPE_RCA.VALUE_TX
														ELSE NULLIF(OP.BASE_PROPERTY_TYPE_CD, '')
														END) = 'CA'
													THEN 'ASSC'
													ELSE 'PB'
													END = EP.SUB_TYPE_CD
											ORDER BY EP.ID DESC
											FOR XML PATH('PlcyEscrow')
												, TYPE
											) AS 'PlcyEscrows'
									FROM OWNER_POLICY OP
									LEFT JOIN ESCROW e ON (
											e.PROPERTY_ID = RC.PROPERTY_ID
											AND e.ID IN (SELECT ESCROW_ID FROM ESCROW_REQUIRED_COVERAGE_RELATE WHERE REQUIRED_COVERAGE_ID = RC.ID AND PURGE_DT IS NULL)
											AND LN.ID = e.LOAN_ID
											AND e.STATUS_CD <> 'CLSE'
											AND e.END_DT > GETDATE()
											)
									LEFT JOIN BORROWER_INSURANCE_AGENCY BIA ON BIA.id = OP.BIA_ID
									LEFT JOIN BORROWER_INSURANCE_COMPANY_OFFERING bico ON (
											bico.BORROWER_INSURANCE_COMPANY_ID = OP.BIC_ID
											AND bico.COVERAGE_TYPE_CD = @coverageTypeCode
											)
									LEFT JOIN BORROWER_INSURANCE_COMPANY bic ON BIC.ID = e.BIC_ID
									WHERE BIA.PURGE_DT IS NULL
										AND OP.id IN (
											SELECT ID
											FROM dbo.GetCurrentCoverage(RC.PROPERTY_ID, RC.ID, RC.TYPE_CD)
											)
										AND (
											@escrowInMatch = REQ_ESCROW_IN
											OR @escrowInMatch IS NULL
											)
									FOR XML PATH('Plcy')
										,TYPE
									) AS 'Plcys'
								,(
									SELECT i.ID AS [@id]
										,NULLIF(i.code_cd, '') AS [@impCode]
									FROM IMPAIRMENT i
									WHERE i.REQUIRED_COVERAGE_ID = RC.id
										AND i.CURRENT_IMPAIRED_IN = 'Y'
										AND i.END_DT > GETDATE()
										AND i.PURGE_DT IS NULL
									FOR XML PATH('Imp')
										,TYPE
									) AS 'Imps'
							FROM REQUIRED_COVERAGE RC
							INNER JOIN (SELECT DISTINCT REQUIRED_COVERAGE_ID, REQ_ESCROW_IN FROM #tmpLoans) tmpRC ON tmpRC.REQUIRED_COVERAGE_ID = RC.ID							
							LEFT JOIN REF_CODE stat ON stat.CODE_CD = rc.INSURANCE_STATUS_CD
								AND stat.DOMAIN_CD = 'RequiredCoverageInsStatus'
							LEFT JOIN REF_CODE substat ON substat.CODE_CD = rc.INSURANCE_SUB_STATUS_CD
								AND substat.DOMAIN_CD = 'RequiredCoverageInsSubStatus'
							LEFT JOIN REF_CODE typ ON typ.CODE_CD = rc.TYPE_CD
								AND typ.DOMAIN_CD = 'Coverage'
							--NOTICE          
							LEFT JOIN REF_CODE ntcType ON ntcType.CODE_CD = RC.NOTICE_TYPE_CD
								AND ntcType.DOMAIN_CD = 'NoticeType'
							--FPC
							LEFT JOIN (
								SELECT FPCRCR.REQUIRED_COVERAGE_ID
									,FPC.id
									,FPC.NUMBER_TX
									,FPC.EFFECTIVE_DT
									,FPC.CANCELLATION_DT
									,FPC.MONTHLY_BILLING_IN
									,FPC.EXPIRATION_DT
									,FPC.PRODUCER_NUMBER_TX
									,FPC.ISSUE_DT
									,FPC.STATUS_CD
									,ca.TOTAL_PREMIUM_NO
									,ISNULL(FPC.CAPTURED_DATA_XML.value('(//CapturedData/CPIQuote)[1]/@coverageAmount', 'nvarchar(500)'), '0') AS COVERAGE_AMT
								FROM FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR
								INNER JOIN FORCE_PLACED_CERTIFICATE FPC ON FPC.id = FPCRCR.FPC_ID
									AND FPC.LOAN_ID = LN.id
									AND FPC.ACTIVE_IN = 'Y'
								INNER JOIN (
									SELECT CPI_QUOTE_ID AS CPI_QUOTE_ID
										,SUM(TOTAL_PREMIUM_NO) AS TOTAL_PREMIUM_NO
									FROM CPI_ACTIVITY
									WHERE TYPE_CD IN (
											'I'
											,'C'
											,'MT'
											)
										AND PURGE_DT IS NULL
									GROUP BY CPI_QUOTE_ID
									) AS ca ON ca.CPI_QUOTE_ID = FPC.CPI_QUOTE_ID
								WHERE FPCRCR.PURGE_DT IS NULL
									AND FPC.PURGE_DT IS NULL
								) FPC_INFO ON FPC_INFO.REQUIRED_COVERAGE_ID = RC.id
							--waive
							LEFT JOIN (
								SELECT TOP 1 *
								FROM WAIVE_TRACK
								WHERE REQUIRED_COVERAGE_ID = RC.id
									AND END_DT = '9999-12-31 23:59:59.9999999'
									AND purge_dt IS NULL
								) WT ON WT.REQUIRED_COVERAGE_ID = rc.id
							WHERE RC.PURGE_DT IS NULL
								AND WT.PURGE_DT IS NULL
								AND RC.PROPERTY_ID = P.id
								AND (
									@coverageTypeCode IS NULL
									OR rc.TYPE_CD IN (
										SELECT cvgTypeCode
										FROM @cvgTypeCodeTable
										)
									)
								AND (
									@uninsuredLoansOnlyIn = 'N'
									OR rc.INSURANCE_STATUS_CD IN (
										'A'
										,'C'
										,'CH'
										,'E'
										,'EH'
										,'N'
										)
									OR rc.INSURANCE_SUB_STATUS_CD IN ('I')
									)
								AND (
									@excludeLoansWithCPIIn = 'N'
									OR rc.SUMMARY_SUB_STATUS_CD NOT IN (
										'P'
										,'C'
										)
									)
								AND rc.STATUS_CD IN (
									'A'
									,'M'
									,'D'
									,'T'
									)
								AND (
									@escrowInMatch IS NULL
									OR REQ_ESCROW_IN = @escrowInMatch
									)
							FOR XML PATH('Cvg')
								,TYPE
							) AS [Cvgs]
					FROM Collateral COLL 
					INNER JOIN (SELECT DISTINCT COLLATERAL_ID FROM #tmpLoans) tmpC ON tmpC.COLLATERAL_ID = COLL.ID
					JOIN property P ON COLL.PROPERTY_ID = P.id
					INNER JOIN (SELECT DISTINCT PROPERTY_ID FROM #tmpLoans) tmpP ON tmpP.PROPERTY_ID = P.ID
					LEFT JOIN OWNER_ADDRESS PROP_ADD ON P.ADDRESS_ID = PROP_ADD.id
					--Collatral Code
					LEFT JOIN COLLATERAL_CODE CC ON COLL.COLLATERAL_CODE_ID = CC.id
						AND (
							@filterByCollCode = 'N'
							OR CC.id IN (
								SELECT cc_id
								FROM @tmpCC
								)
							)
					--Property type
					OUTER APPLY (
						SELECT RCA.VALUE_TX
							,RC.MEANING_TX
						FROM REF_CODE_ATTRIBUTE RCA
						INNER JOIN REF_CODE RC ON (
								RCA.VALUE_TX = RC.CODE_CD
								AND RC.DOMAIN_CD = 'PropertyType'
								)
						WHERE RCA.REF_CD = cc.SECONDARY_CLASS_CD
							AND RCA.DOMAIN_CD = 'SecondaryClassification'
							AND RCA.ATTRIBUTE_CD = 'PropertyType'
						) AS PROPERTY_TYPE_RCA
					--Owner Policy Base Property type
					OUTER APPLY (
						SELECT RCA.VALUE_TX
							,RC.CODE_CD
						FROM REF_CODE_ATTRIBUTE RCA
						INNER JOIN REF_CODE RC ON (
								RC.CODE_CD = cc.SECONDARY_CLASS_CD
								AND RC.DOMAIN_CD = 'SecondaryClassification'
								)
						WHERE RCA.REF_CD = RC.CODE_CD
							AND RCA.DOMAIN_CD = 'SecondaryClassification'
							AND RCA.ATTRIBUTE_CD = 'OwnerPolicyBasePropertyType'
						) AS OP_BASEPROP_TYPE_RCA
					WHERE COLL.LOAN_ID = ln.id
						AND COLL.PURGE_DT IS NULL
						AND P.PURGE_DT IS NULL
						AND PROP_ADD.PURGE_DT IS NULL
						AND CC.PURGE_DT IS NULL
					FOR XML PATH('Coll')
						,TYPE
					) AS [Colls]
				,---OWNERS
				(
					SELECT O.id AS [@id]
						,NULLIF(O.LAST_NAME_TX, '') AS [@lastName]
						,NULLIF(O.FIRST_NAME_TX, '') AS [@firstName]
						,NULLIF(O.MIDDLE_INITIAL_TX, '') AS [@middleInitial]
						,NULLIF(OA.LINE_1_TX, '') AS [@line1]
						,NULLIF(OA.LINE_2_TX, '') AS [@line2]
						,NULLIF(OA.CITY_TX, '') AS [@city]
						,NULLIF(OA.STATE_PROV_TX, '') AS [@state]
						,NULLIF(OA.POSTAL_CODE_TX, '') AS [@zip]
						,NULLIF(OLR.OWNER_TYPE_CD, '') AS [@typCd]
						,NULLIF(O.EMAIL_TX, '') AS [@email]
						,NULLIF(O.CELL_PHONE_TX, '') AS [@cellPhn]
						,NULLIF(O.HOME_PHONE_TX, '') AS [@homePhn]
					FROM OWNER_LOAN_RELATE OLR
					JOIN OWNER O ON OLR.OWNER_ID = O.id
					JOIN OWNER_ADDRESS OA ON OA.id = O.ADDRESS_ID
					WHERE OLR.PURGE_DT IS NULL
						AND o.PURGE_DT IS NULL
						AND OA.PURGE_DT IS NULL
						AND LN.id = OLR.LOAN_ID
						AND OLR.OWNER_TYPE_CD IN (
							'B'
							,'CS'
							,'DBA'
							)
					FOR XML PATH('Owner')
						,TYPE
					) AS [Owners]
			FROM Loan LN
			INNER JOIN (SELECT DISTINCT LOAN_ID FROM #tmpLoans) tmpLN ON tmpLN.LOAN_ID = LN.ID
			LEFT JOIN REF_CODE rc ON rc.CODE_CD = LN.STATUS_CD
				AND rc.DOMAIN_CD = 'LoanStatus'
			LEFT JOIN RELATED_DATA rd ON rd.RELATE_ID = LN.id
				AND rd.DEF_ID = (
					SELECT id
					FROM RELATED_DATA_DEF
					WHERE RELATE_CLASS_NM = 'Loan'
						AND NAME_TX = 'Misc1'
						AND ACTIVE_IN = 'Y'
					)
			LEFT JOIN RELATED_DATA rd2 ON rd2.RELATE_ID = LN.id
				AND rd2.DEF_ID = (
					SELECT id
					FROM RELATED_DATA_DEF
					WHERE RELATE_CLASS_NM = 'Loan'
						AND NAME_TX = 'Misc2'
						AND ACTIVE_IN = 'Y'
					)
			LEFT JOIN LENDER_ORGANIZATION LO_DIVISION ON (
					LO_DIVISION.LENDER_ID = LN.LENDER_ID
					AND LO_DIVISION.CODE_TX = LN.DIVISION_CODE_TX
					AND LO_DIVISION.TYPE_CD = 'DIV'
					AND LO_DIVISION.PURGE_DT IS NULL
					)
			ORDER BY ln.NUMBER_TX
			FOR XML PATH('Loan')
				,TYPE
			)
	FROM LENDER l
	LEFT OUTER JOIN RELATED_DATA rd ON rd.DEF_ID = @isDirectPayDefId
		AND rd.RELATE_ID = @lenderId
	WHERE l.id = @lenderId
	FOR XML PATH('Portfolio')

	IF OBJECT_ID(N'tempdb..#tmpLoans') IS NOT NULL
	BEGIN
		DROP TABLE #tmpLoans
	END
END
GO
