USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[GetCycleReviewAllEvents]    Script Date: 4/11/2017 11:41:43 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--exec [GetCycleReviewEvents] @workItemId=965(5) 617875(7)
CREATE PROCEDURE [dbo].[GetCycleReviewAllEvents]
(
	@workItemId   bigint = null,
	@startPLIId bigint = 0,
	@pageSize int = 1000,
	@isNotice char(1) = 'N',
	@isISCT char(1) = 'N',
	@isOBCL char(1) = 'N',
	@isAOBC char(1) = 'N',
	@isUnworked char(1) = 'N',
	@appliedStatus varchar(20) = null,
	@searchText varchar(100) = null
)
WITH RECOMPILE
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @processLogId bigint
    DECLARE @isImmediate varchar(10)

	--Identify if WI is immediate 
	SELECT @isImmediate = CONTENT_XML.value('(/Content/Cycle/Immediate)[1]', 'varchar(10)')
		, @processLogId = RELATE_ID
	FROM WORK_ITEM
	WHERE ID = @workItemId
	
	IF @isImmediate IS NULL
		SET @isImmediate = 'NO'	

	CREATE TABLE #TMP_TYPE
	(
		RELATE_TYPE_CD VARCHAR(50)
	)

	CREATE TABLE #tmpPLI1
	(
		PLI_ID		bigint,
		WIPLIR_ID	bigint,
		PARENT_WORK_ITEM_ID	bigint
	)
	CREATE TABLE #tmpPLI2
	(
		PLI_ID		bigint,
		WIPLIR_ID	bigint,
		PARENT_WORK_ITEM_ID	bigint
	)
	CREATE TABLE #tmpPLI
	(
		PLI_ID		bigint,
		WIPLIR_ID	bigint,
		PARENT_WORK_ITEM_ID	bigint
	)

	IF @isNotice = 'Y'
	BEGIN
		INSERT INTO #TMP_TYPE (RELATE_TYPE_CD) VALUES ('Allied.Unitrac.Notice')
	END
    IF @isISCT = 'Y'
	BEGIN
		INSERT INTO #TMP_TYPE (RELATE_TYPE_CD) VALUES ('Allied.Unitrac.ForcePlacedCertificate')
	END
    IF @isOBCL = 'Y'
	BEGIN
		INSERT INTO #TMP_TYPE (RELATE_TYPE_CD) VALUES ('Allied.UniTrac.Workflow.OutboundCallWorkItem')
	END
    IF @isAOBC = 'Y'
	BEGIN
		INSERT INTO #TMP_TYPE (RELATE_TYPE_CD) VALUES ('Allied.UniTrac.NoticeInteraction')
	END

	IF @startPLIId = 0
    BEGIN
      SELECT @startPLIId = MIN(x.ID) - 1
      FROM
      (
		  select ID
		  from
		  (
				select top 1 PLI.ID
				from PROCESS_LOG_ITEM PLI
					JOIN #TMP_TYPE tmp ON tmp.RELATE_TYPE_CD = PLI.RELATE_TYPE_CD
					JOIN WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR ON PLI.ID = WIPLIR.PROCESS_LOG_ITEM_ID
				WHERE PLI.PURGE_DT IS NULL
					  AND PLI.STATUS_CD = 'COMP'
					  and WIPLIR.WORK_ITEM_ID = @workItemId
					  and WIPLIR.PURGE_DT IS NULL
				order by PLI.ID
		  )WKID
		  union
          select ID
          from
          (
				select top 1 PLI.ID
                from PROCESS_LOG_ITEM PLI
					JOIN #TMP_TYPE tmp ON tmp.RELATE_TYPE_CD = PLI.RELATE_TYPE_CD
					JOIN WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR ON PLI.ID = WIPLIR.PROCESS_LOG_ITEM_ID
                WHERE PLI.PURGE_DT IS NULL
                      AND PLI.STATUS_CD = 'COMP'
                      and WIPLIR.PARENT_WORK_ITEM_ID = @workItemId
                      and WIPLIR.PURGE_DT IS NULL
				order by PLI.ID
		   )PWKID
      ) x
    END

	IF @appliedStatus = ''
		SET @appliedStatus = NULL
	
	SELECT PLI_ID
	INTO #tmpPLISearch
	FROM GetProcessLogItemSearch(@processLogId, @searchText, '|')

	IF @isUnworked = 'Y'
	BEGIN
		INSERT INTO #tmpPLI1(PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID)
		SELECT PLI.ID PLI_ID, WIPLIR.ID WIPLIR_ID, WIPLIR.PARENT_WORK_ITEM_ID PARENT_WORK_ITEM_ID
		FROM PROCESS_LOG_ITEM PLI
			JOIN #TMP_TYPE tmp ON tmp.RELATE_TYPE_CD = PLI.RELATE_TYPE_CD
			JOIN WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR ON PLI.ID = WIPLIR.PROCESS_LOG_ITEM_ID AND WIPLIR.PURGE_DT IS NULL									
			JOIN #tmpPLISearch tmpsearch ON tmpsearch.PLI_ID = PLI.ID
		WHERE (WIPLIR.WORK_ITEM_ID = @workItemId)
		AND PLI.PURGE_DT IS NULL
		AND PLI.STATUS_CD = 'COMP'
		AND PLI.ID > @startPLIId
		AND PLI.INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar(100)') IS NULL
		ORDER by PLI.ID
		option (FAST 1)

		INSERT INTO #tmpPLI2(PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID)
		SELECT PLI.ID PLI_ID, WIPLIR.ID WIPLIR_ID, WIPLIR.PARENT_WORK_ITEM_ID PARENT_WORK_ITEM_ID
		FROM PROCESS_LOG_ITEM PLI
			JOIN #TMP_TYPE tmp ON tmp.RELATE_TYPE_CD = PLI.RELATE_TYPE_CD
			JOIN WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR ON PLI.ID = WIPLIR.PROCESS_LOG_ITEM_ID AND WIPLIR.PURGE_DT IS NULL
			JOIN #tmpPLISearch tmpsearch ON tmpsearch.PLI_ID = PLI.ID
		WHERE (WIPLIR.PARENT_WORK_ITEM_ID = @workItemId)
		AND PLI.PURGE_DT IS NULL
		AND PLI.STATUS_CD = 'COMP'
		AND PLI.ID > @startPLIId
		AND PLI.INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar(100)') IS NULL
		ORDER by PLI.ID
		option (FAST 1)

		INSERT #tmpPLI (PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID)
		SELECT PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID
		FROM
		(
			SELECT PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID from #tmpPLI1
			UNION
			SELECT PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID from #tmpPLI2
		) tbl
		ORDER by PLI_ID

    END
    ELSE IF @appliedStatus IS NOT NULL
	BEGIN
		INSERT INTO #tmpPLI1(PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID)
		SELECT PLI.ID PLI_ID, WIPLIR.ID WIPLIR_ID, WIPLIR.PARENT_WORK_ITEM_ID PARENT_WORK_ITEM_ID
		FROM PROCESS_LOG_ITEM PLI
			JOIN #TMP_TYPE tmp ON tmp.RELATE_TYPE_CD = PLI.RELATE_TYPE_CD
			JOIN WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR ON PLI.ID = WIPLIR.PROCESS_LOG_ITEM_ID AND WIPLIR.PURGE_DT IS NULL
			JOIN #tmpPLISearch tmpsearch ON tmpsearch.PLI_ID = PLI.ID
		WHERE (WIPLIR.WORK_ITEM_ID = @workItemId)
		AND PLI.PURGE_DT IS NULL
		AND PLI.STATUS_CD = 'COMP'
		AND PLI.ID > @startPLIId
		AND PLI.INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar(100)') = @appliedStatus
		ORDER by PLI.ID
		option (FAST 1)

		INSERT INTO #tmpPLI2(PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID)
		SELECT PLI.ID PLI_ID, WIPLIR.ID WIPLIR_ID, WIPLIR.PARENT_WORK_ITEM_ID PARENT_WORK_ITEM_ID
		FROM PROCESS_LOG_ITEM PLI
			JOIN #TMP_TYPE tmp ON tmp.RELATE_TYPE_CD = PLI.RELATE_TYPE_CD
			JOIN WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR ON PLI.ID = WIPLIR.PROCESS_LOG_ITEM_ID AND WIPLIR.PURGE_DT IS NULL
			JOIN #tmpPLISearch tmpsearch ON tmpsearch.PLI_ID = PLI.ID
		WHERE (WIPLIR.PARENT_WORK_ITEM_ID = @workItemId)
		AND PLI.PURGE_DT IS NULL
		AND PLI.STATUS_CD = 'COMP'
		AND PLI.ID > @startPLIId
		AND PLI.INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar(100)') = @appliedStatus
		ORDER by PLI.ID
		option (FAST 1)

		INSERT #tmpPLI (PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID)
		SELECT PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID
		FROM
		(
			SELECT PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID from #tmpPLI1
			UNION
			SELECT PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID from #tmpPLI2
		) tbl
		ORDER by PLI_ID
    END
	ELSE
	BEGIN
		INSERT INTO #tmpPLI1(PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID)
		SELECT PLI.ID PLI_ID, WIPLIR.ID WIPLIR_ID, WIPLIR.PARENT_WORK_ITEM_ID PARENT_WORK_ITEM_ID
		FROM PROCESS_LOG_ITEM PLI
			JOIN #TMP_TYPE tmp ON tmp.RELATE_TYPE_CD = PLI.RELATE_TYPE_CD
			JOIN WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR ON PLI.ID = WIPLIR.PROCESS_LOG_ITEM_ID AND WIPLIR.PURGE_DT IS NULL
			JOIN #tmpPLISearch tmpsearch ON tmpsearch.PLI_ID = PLI.ID
		WHERE (WIPLIR.WORK_ITEM_ID = @workItemId)
		AND PLI.PURGE_DT IS NULL
		AND PLI.STATUS_CD = 'COMP'
		AND PLI.ID > @startPLIId
		ORDER by PLI.ID
		option (FAST 1)

		INSERT INTO #tmpPLI2(PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID)
		SELECT PLI.ID PLI_ID, WIPLIR.ID WIPLIR_ID, WIPLIR.PARENT_WORK_ITEM_ID PARENT_WORK_ITEM_ID
		FROM PROCESS_LOG_ITEM PLI
			JOIN #TMP_TYPE tmp ON tmp.RELATE_TYPE_CD = PLI.RELATE_TYPE_CD
			JOIN WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR ON PLI.ID = WIPLIR.PROCESS_LOG_ITEM_ID AND WIPLIR.PURGE_DT IS NULL
			JOIN #tmpPLISearch tmpsearch ON tmpsearch.PLI_ID = PLI.ID
		WHERE (WIPLIR.PARENT_WORK_ITEM_ID = @workItemId)
		AND PLI.PURGE_DT IS NULL
		AND PLI.STATUS_CD = 'COMP'
		AND PLI.ID > @startPLIId
		ORDER by PLI.ID
		option (FAST 1)

		INSERT #tmpPLI (PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID)
		SELECT PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID
		FROM
		(
			SELECT PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID from #tmpPLI1
			UNION
			SELECT PLI_ID, WIPLIR_ID, PARENT_WORK_ITEM_ID from #tmpPLI2
		) tbl
		ORDER by PLI_ID
	END

	--Notices
	IF @isNotice = 'Y'
	BEGIN
		SELECT tmp.WIPLIR_ID, tmp.PARENT_WORK_ITEM_ID, PLI.EVALUATION_EVENT_ID EVENT_ID, PLI.ID AS PLI_ID, PLI.RELATE_ID, PLI.RELATE_TYPE_CD, PLI.INFO_XML, PLI.STATUS_CD,
			   LN.ID AS LOAN_ID, RC.PROPERTY_ID, RC.ID RC_ID, RC.EXPOSURE_DT, 'Y' AS CAPTURED_DATA_IND, TBL.DCCNT, TBLOWNER.OWNER_NAME,
			   '' AS BILLING_STATUS_CD,
			   LN.NUMBER_TX, NTC.TYPE_CD NOTICE_TYPE_CD,
			   '' AS DESCRIPTION_TX, '' AS YEAR_TX, '' AS MAKE_TX, '' AS MODEL_TX, '' AS VIN_TX,
			   RC.TYPE_CD, RC.INSURANCE_STATUS_CD, RC.INSURANCE_SUB_STATUS_CD, RC.SUMMARY_STATUS_CD, RC.SUMMARY_SUB_STATUS_CD,
			   RC.STATUS_CD RC_STATUS_CD, LN.STATUS_CD LN_STATUS_CD, COL.STATUS_CD COL_STATUS_CD,
			   '' AS SECONDARY_CLASS_CD,
			   '' AS LINE_1_TX, '' AS CITY_TX, '' AS STATE_PROV_TX, '' AS POSTAL_CODE_TX,
			   isnull(TBLIMP.OVERRIDE_TYPE_CD, '') OVERRIDE_TYPE_CD
			   , NTC.PDF_GENERATE_CD, NTC.CPI_QUOTE_ID
            , ISNULL(ES.TIMING_FROM_LAST_EVENT_DAYS_NO , ES1.TIMING_FROM_LAST_EVENT_DAYS_NO) AS TIMING_FROM_LAST_EVENT_DAYS_NO
			   , NTC.CAPTURED_DATA_XML.value('(/CapturedData/Coverage/@typeCode)[1]', 'varchar(100)') CD_TYPECODE
				, NTC.CAPTURED_DATA_XML.value('(/CapturedData/Notice/@sequence)[1]', 'varchar(2)') CD_NOTICE_SEQ
				, NTC.CAPTURED_DATA_XML.value('(/CapturedData/Notice/@name)[1]', 'varchar(50)') CD_NOTICE_NAME
				, NTC.CAPTURED_DATA_XML.value('(/CapturedData/Loan/@number)[1]', 'varchar(50)') CD_LOAN_NUMBER
				, 'N' CD_IS_LENDER_ONLY
				, NTC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@year)[1]', 'varchar(10)') CD_PROPERTY_YEAR
				, NTC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@make)[1]', 'varchar(20)') CD_PROPERTY_MAKE
				, NTC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@model)[1]', 'varchar(20)') CD_PROPERTY_MODEL
				, NTC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@VIN)[1]', 'varchar(20)') CD_PROPERTY_VIN
				, NTC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@collateralCode)[1]', 'varchar(10)') CD_PROPERTY_COL_CD
				, NTC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@secondaryClassification)[1]', 'varchar(10)') CD_PROPERTY_SEC_CLASS
				, NTC.CAPTURED_DATA_XML.value('(/CapturedData/Property/Address/@Line1)[1]', 'varchar(50)') CD_PROPERTY_LINE1
				, NTC.CAPTURED_DATA_XML.value('(/CapturedData/Property/Address/@City)[1]', 'varchar(50)') CD_PROPERTY_CITY
				, NTC.CAPTURED_DATA_XML.value('(/CapturedData/Property/Address/@State)[1]', 'varchar(50)') CD_PROPERTY_STATE
				, NTC.CAPTURED_DATA_XML.value('(/CapturedData/Property/Address/@PostalCode)[1]', 'varchar(10)') CD_PROPERTY_POSTALCODE
				, NTC.CAPTURED_DATA_XML.value('(/CapturedData/Loan/@balanceAmount)[1]', 'varchar(50)') CD_LOAN_BALANCEAMT
				, NTC.CAPTURED_DATA_XML.value('(/CapturedData/CPIQuote/@totalAmount)[1]', 'varchar(50)') CD_CPIQUOTE_TOTALAMT
				, (SELECT
						ISNULL(OWR.TAB.value('@lastName[1]', 'VARCHAR(100)'), '') + ', ' + ISNULL(OWR.TAB.value('@firstName[1]' , 'VARCHAR(100)'), '') + '\r\n'
					 FROM
						  NOTICE n
						  CROSS APPLY n.CAPTURED_DATA_XML.nodes('(/CapturedData/Owner)') OWR (TAB)
					 WHERE
						  n.ID = NTC.ID
					 FOR xml PATH (''))
					 AS CD_OWNER_NAMES
		INTO #tmpNotice
		FROM #tmpPLI tmp
			 JOIN PROCESS_LOG_ITEM PLI ON PLI.ID = tmp.PLI_ID AND PLI.RELATE_TYPE_CD = 'Allied.Unitrac.Notice'
			 JOIN NOTICE NTC ON NTC.ID = PLI.RELATE_ID AND PLI.RELATE_TYPE_CD = 'Allied.Unitrac.Notice'
			 JOIN NOTICE_REQUIRED_COVERAGE_RELATE NRCR ON NRCR.NOTICE_ID = NTC.ID
			 JOIN REQUIRED_COVERAGE RC ON RC.ID = NRCR.REQUIRED_COVERAGE_ID
			 JOIN COLLATERAL COL ON COL.PROPERTY_ID = RC.PROPERTY_ID AND COL.PRIMARY_LOAN_IN = 'Y'
			 JOIN LOAN LN ON LN.ID = COL.LOAN_ID
			 LEFT OUTER JOIN EVALUATION_EVENT EVT ON EVT.ID = PLI.EVALUATION_EVENT_ID
			 LEFT OUTER JOIN EVENT_SEQUENCE ES ON ES.ID = EVT.EVENT_SEQUENCE_ID
          LEFT OUTER JOIN EVENT_SEQUENCE ES1 ON ES1.ID = RC.LAST_EVENT_SEQ_ID
			 CROSS APPLY
			 (SELECT OVERRIDE_TYPE_CD + ',' + cast(ISNULL(cast(OVERRIDE_START_DT AS DATE), '1/1/0001') AS VARCHAR)
					+ ',' + cast(ISNULL(cast(OVERRIDE_END_DT AS DATE), '1/1/0001') AS VARCHAR) + '|' FROM IMPAIRMENT IMP
				WHERE IMP.REQUIRED_COVERAGE_ID = RC.ID AND IMP.PURGE_DT IS NULL
				AND datepart(year, END_DT) = 9999
				FOR XML PATH('')) TBLIMP (OVERRIDE_TYPE_CD)
			 CROSS APPLY
			 (SELECT count(*) DCCNT FROM DOCUMENT_CONTAINER DC WHERE DC.RELATE_ID = NTC.ID AND DC.RELATE_CLASS_NAME_TX = 'Allied.Unitrac.Notice' AND DC.PURGE_DT IS NULL) TBL
			 CROSS APPLY
			 (	SELECT LAST_NAME_TX + ', ' + FIRST_NAME_TX + '|'
				FROM OWNER OWN
					JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = LN.ID AND OWN.ID = OLR.OWNER_ID
				FOR XML PATH('')) TBLOWNER (OWNER_NAME)
		WHERE @isNotice = 'Y'
		AND LN.PURGE_DT IS NULL
		AND PLI.PURGE_DT IS NULL
		AND COL.PURGE_DT IS NULL
		AND NTC.PURGE_DT IS NULL
		AND RC.PURGE_DT IS NULL
		AND NRCR.PURGE_DT IS NULL
 	END

	--Force Placed Certificates
	IF @isISCT = 'Y'
	BEGIN
		-- Need distinct since CROSS APPLY causes duplicates if the WHERE condition satisfies more than 1 owner element.
		SELECT DISTINCT PLI.ID AS PLI_ID
		INTO #tmpISCTTemp
		FROM #tmpPLI tmp
			 JOIN PROCESS_LOG_ITEM PLI ON PLI.ID = tmp.PLI_ID AND PLI.RELATE_TYPE_CD = 'Allied.Unitrac.ForcePlacedCertificate'
			 JOIN FORCE_PLACED_CERTIFICATE FPC ON FPC.ID = PLI.RELATE_ID AND PLI.RELATE_TYPE_CD = 'Allied.Unitrac.ForcePlacedCertificate'			 
			 CROSS APPLY FPC.CAPTURED_DATA_XML.nodes('//CapturedData/Owner') as O(Tab) 	
		WHERE @isISCT = 'Y'
		AND FPC.PDF_GENERATE_CD <> 'ONHO'
		AND O.Tab.value('@generatePDF', 'nvarchar(10)') = 'true'
		AND O.Tab.value('@lender','nvarchar(10)') = 'false'
		AND FPC.PURGE_DT IS NULL
			
		SELECT tmp.WIPLIR_ID, tmp.PARENT_WORK_ITEM_ID, PLI.EVALUATION_EVENT_ID EVENT_ID, PLI.ID AS PLI_ID, PLI.RELATE_ID, PLI.RELATE_TYPE_CD, PLI.INFO_XML, PLI.STATUS_CD,
			   LN.ID AS LOAN_ID, RC.PROPERTY_ID, RC.ID RC_ID, RC.EXPOSURE_DT, 'Y' AS CAPTURED_DATA_IND, TBL.DCCNT, TBLOWNER.OWNER_NAME,
			   FPC.BILLING_STATUS_CD,
			   LN.NUMBER_TX, '' NOTICE_TYPE_CD,
			   '' AS DESCRIPTION_TX, '' AS YEAR_TX, '' AS MAKE_TX, '' AS MODEL_TX, '' AS VIN_TX,
			   RC.TYPE_CD, RC.INSURANCE_STATUS_CD, RC.INSURANCE_SUB_STATUS_CD, RC.SUMMARY_STATUS_CD, RC.SUMMARY_SUB_STATUS_CD,
			   RC.STATUS_CD RC_STATUS_CD, LN.STATUS_CD LN_STATUS_CD, COL.STATUS_CD COL_STATUS_CD,
			   '' AS SECONDARY_CLASS_CD,
			   '' AS LINE_1_TX, '' AS CITY_TX, '' AS STATE_PROV_TX, '' AS POSTAL_CODE_TX,
			   isnull(TBLIMP.OVERRIDE_TYPE_CD, '') OVERRIDE_TYPE_CD
			   , FPC.PDF_GENERATE_CD, FPC.CPI_QUOTE_ID, 0 AS TIMING_FROM_LAST_EVENT_DAYS_NO
			   , FPC.CAPTURED_DATA_XML.value('(/CapturedData/Coverage/@typeCode)[1]', 'varchar(100)') CD_TYPECODE
				, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Notice/@sequence)[1]', 'varchar(2)') CD_NOTICE_SEQ
				, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Notice/@name)[1]', 'varchar(50)') CD_NOTICE_NAME
				, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Loan/@number)[1]', 'varchar(50)') CD_LOAN_NUMBER
				, CASE
					  WHEN FPC.CAPTURED_DATA_XML.exist('/CapturedData/Owner[@generatePDF = ''true'' and @lender=''false'']') = 1 THEN 'N'
					  ELSE 'Y'
				  END AS CD_IS_LENDER_ONLY
				, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@year)[1]', 'varchar(10)') CD_PROPERTY_YEAR
				, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@make)[1]', 'varchar(20)') CD_PROPERTY_MAKE
				, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@model)[1]', 'varchar(20)') CD_PROPERTY_MODEL
				, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@VIN)[1]', 'varchar(20)') CD_PROPERTY_VIN
				, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@collateralCode)[1]', 'varchar(10)') CD_PROPERTY_COL_CD
				, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@secondaryClassification)[1]', 'varchar(10)') CD_PROPERTY_SEC_CLASS
				, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/Address/@Line1)[1]', 'varchar(50)') CD_PROPERTY_LINE1
				, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/Address/@City)[1]', 'varchar(50)') CD_PROPERTY_CITY
				, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/Address/@State)[1]', 'varchar(50)') CD_PROPERTY_STATE
				, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/Address/@PostalCode)[1]', 'varchar(10)') CD_PROPERTY_POSTALCODE
				, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Loan/@balanceAmount)[1]', 'varchar(50)') CD_LOAN_BALANCEAMT
				, FPC.CAPTURED_DATA_XML.value('(/CapturedData/CPIQuote/@totalAmount)[1]', 'varchar(50)') CD_CPIQUOTE_TOTALAMT
				, (SELECT
						ISNULL(OWR.TAB.value('@lastName[1]', 'VARCHAR(100)'), '') + ', ' + ISNULL(OWR.TAB.value('@firstName[1]' , 'VARCHAR(100)'), '') + '\r\n'
					 FROM
						  FORCE_PLACED_CERTIFICATE n
						  CROSS APPLY n.CAPTURED_DATA_XML.nodes('(/CapturedData/Owner)') OWR (TAB)
					 WHERE
						  n.ID = FPC.ID
					 FOR xml PATH (''))
					 AS CD_OWNER_NAMES
		INTO #tmpISCT
		FROM #tmpPLI tmp
			 JOIN #tmpISCTTemp tmp1 on tmp1.PLI_ID = tmp.PLI_ID
			 JOIN PROCESS_LOG_ITEM PLI ON PLI.ID = tmp.PLI_ID AND PLI.RELATE_TYPE_CD = 'Allied.Unitrac.ForcePlacedCertificate'
			 JOIN FORCE_PLACED_CERTIFICATE FPC ON FPC.ID = PLI.RELATE_ID AND PLI.RELATE_TYPE_CD = 'Allied.Unitrac.ForcePlacedCertificate'
			 JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.FPC_ID = FPC.ID AND FPCRCR.PURGE_DT IS NULL
			 JOIN REQUIRED_COVERAGE RC ON RC.ID = FPCRCR.REQUIRED_COVERAGE_ID
			 JOIN COLLATERAL COL ON COL.PROPERTY_ID = RC.PROPERTY_ID AND COL.PRIMARY_LOAN_IN = 'Y'
			 JOIN LOAN LN ON LN.ID = COL.LOAN_ID
			 CROSS APPLY
			 (SELECT OVERRIDE_TYPE_CD + ',' + cast(ISNULL(cast(OVERRIDE_START_DT AS DATE), '1/1/0001') AS VARCHAR) + ',' + cast(ISNULL(cast(OVERRIDE_END_DT AS DATE), '1/1/0001') AS VARCHAR) + '|' FROM IMPAIRMENT IMP
				WHERE IMP.REQUIRED_COVERAGE_ID = RC.ID AND IMP.PURGE_DT IS NULL
				AND datepart(year, END_DT) = 9999
				FOR XML PATH('')) TBLIMP (OVERRIDE_TYPE_CD)
			 CROSS APPLY
			 (SELECT count(*) DCCNT FROM DOCUMENT_CONTAINER DC WHERE DC.RELATE_ID = FPC.ID AND DC.RELATE_CLASS_NAME_TX = 'Allied.Unitrac.ForcePlacedCertificate' AND DC.PURGE_DT IS NULL) TBL
			 CROSS APPLY
			 (	SELECT LAST_NAME_TX + ', ' + FIRST_NAME_TX + '|'
				FROM OWNER OWN
					JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = LN.ID AND OWN.ID = OLR.OWNER_ID
				FOR XML PATH('')) TBLOWNER (OWNER_NAME)
		WHERE @isISCT = 'Y'
		AND FPC.PDF_GENERATE_CD <> 'ONHO'
		AND LN.PURGE_DT IS NULL
		AND PLI.PURGE_DT IS NULL
		AND COL.PURGE_DT IS NULL
		AND FPC.PURGE_DT IS NULL
		AND RC.PURGE_DT IS NULL
		AND FPCRCR.PURGE_DT IS NULL

	    --Force Placed Certificates for lender only if workitem is immediate.
	    --Lender only certs are only needed for immediates for Release for billing.
	    IF @isImmediate = 'YES'
	    BEGIN
			SELECT DISTINCT PLI.ID AS PLI_ID
			INTO #tmpISCTLenderTemp
			FROM #tmpPLI tmp
				 JOIN PROCESS_LOG_ITEM PLI ON PLI.ID = tmp.PLI_ID AND PLI.RELATE_TYPE_CD = 'Allied.Unitrac.ForcePlacedCertificate'
				 JOIN FORCE_PLACED_CERTIFICATE FPC ON FPC.ID = PLI.RELATE_ID AND PLI.RELATE_TYPE_CD = 'Allied.Unitrac.ForcePlacedCertificate'			 
				 CROSS APPLY FPC.CAPTURED_DATA_XML.nodes('//CapturedData/Owner') as O(Tab) 	
			WHERE @isISCT = 'Y'
			AND FPC.PDF_GENERATE_CD <> 'ONHO'
			AND O.Tab.value('@generatePDF', 'nvarchar(10)') = 'true'
			AND O.Tab.value('@lender','nvarchar(10)') = 'true'
			AND FPC.PURGE_DT IS NULL
			
			SELECT tmp.WIPLIR_ID, tmp.PARENT_WORK_ITEM_ID, PLI.EVALUATION_EVENT_ID EVENT_ID, PLI.ID AS PLI_ID, PLI.RELATE_ID, PLI.RELATE_TYPE_CD, PLI.INFO_XML, PLI.STATUS_CD,
				   LN.ID AS LOAN_ID, RC.PROPERTY_ID, RC.ID RC_ID, RC.EXPOSURE_DT, 'Y' AS CAPTURED_DATA_IND, TBL.DCCNT, TBLOWNER.OWNER_NAME,
				   FPC.BILLING_STATUS_CD,
				   LN.NUMBER_TX, '' NOTICE_TYPE_CD,
				   '' AS DESCRIPTION_TX, '' AS YEAR_TX, '' AS MAKE_TX, '' AS MODEL_TX, '' AS VIN_TX,
				   RC.TYPE_CD, RC.INSURANCE_STATUS_CD, RC.INSURANCE_SUB_STATUS_CD, RC.SUMMARY_STATUS_CD, RC.SUMMARY_SUB_STATUS_CD,
				   RC.STATUS_CD RC_STATUS_CD, LN.STATUS_CD LN_STATUS_CD, COL.STATUS_CD COL_STATUS_CD,
				   '' AS SECONDARY_CLASS_CD,
				   '' AS LINE_1_TX, '' AS CITY_TX, '' AS STATE_PROV_TX, '' AS POSTAL_CODE_TX,
				   isnull(TBLIMP.OVERRIDE_TYPE_CD, '') OVERRIDE_TYPE_CD
				   , FPC.PDF_GENERATE_CD, FPC.CPI_QUOTE_ID, 0 AS TIMING_FROM_LAST_EVENT_DAYS_NO
				   , FPC.CAPTURED_DATA_XML.value('(/CapturedData/Coverage/@typeCode)[1]', 'varchar(100)') CD_TYPECODE
					, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Notice/@sequence)[1]', 'varchar(2)') CD_NOTICE_SEQ
					, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Notice/@name)[1]', 'varchar(50)') CD_NOTICE_NAME
					, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Loan/@number)[1]', 'varchar(50)') CD_LOAN_NUMBER
					, CASE
						  WHEN FPC.CAPTURED_DATA_XML.exist('/CapturedData/Owner[@generatePDF = ''true'' and @lender=''false'']') = 1 THEN 'N'
						  ELSE 'Y'
					  END AS CD_IS_LENDER_ONLY
					, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@year)[1]', 'varchar(10)') CD_PROPERTY_YEAR
					, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@make)[1]', 'varchar(20)') CD_PROPERTY_MAKE
					, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@model)[1]', 'varchar(20)') CD_PROPERTY_MODEL
					, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@VIN)[1]', 'varchar(20)') CD_PROPERTY_VIN
					, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@collateralCode)[1]', 'varchar(10)') CD_PROPERTY_COL_CD
					, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/@secondaryClassification)[1]', 'varchar(10)') CD_PROPERTY_SEC_CLASS
					, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/Address/@Line1)[1]', 'varchar(50)') CD_PROPERTY_LINE1
					, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/Address/@City)[1]', 'varchar(50)') CD_PROPERTY_CITY
					, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/Address/@State)[1]', 'varchar(50)') CD_PROPERTY_STATE
					, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Property/Address/@PostalCode)[1]', 'varchar(10)') CD_PROPERTY_POSTALCODE
					, FPC.CAPTURED_DATA_XML.value('(/CapturedData/Loan/@balanceAmount)[1]', 'varchar(50)') CD_LOAN_BALANCEAMT
					, FPC.CAPTURED_DATA_XML.value('(/CapturedData/CPIQuote/@totalAmount)[1]', 'varchar(50)') CD_CPIQUOTE_TOTALAMT
					, (SELECT
							ISNULL(OWR.TAB.value('@lastName[1]', 'VARCHAR(100)'), '') + ', ' + ISNULL(OWR.TAB.value('@firstName[1]' , 'VARCHAR(100)'), '') + '\r\n'
						 FROM
							  FORCE_PLACED_CERTIFICATE n
							  CROSS APPLY n.CAPTURED_DATA_XML.nodes('(/CapturedData/Owner)') OWR (TAB)
						 WHERE
							  n.ID = FPC.ID
						 FOR xml PATH (''))
						 AS CD_OWNER_NAMES
			INTO #tmpISCTLenderOnly
			FROM #tmpPLI tmp
				 JOIN #tmpISCTLenderTemp tmp1 on tmp1.PLI_ID = tmp.PLI_ID
				 JOIN PROCESS_LOG_ITEM PLI ON PLI.ID = tmp.PLI_ID AND PLI.RELATE_TYPE_CD = 'Allied.Unitrac.ForcePlacedCertificate'
				 JOIN FORCE_PLACED_CERTIFICATE FPC ON FPC.ID = PLI.RELATE_ID AND PLI.RELATE_TYPE_CD = 'Allied.Unitrac.ForcePlacedCertificate'
				 JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.FPC_ID = FPC.ID AND FPCRCR.PURGE_DT IS NULL
				 JOIN REQUIRED_COVERAGE RC ON RC.ID = FPCRCR.REQUIRED_COVERAGE_ID
				 JOIN COLLATERAL COL ON COL.PROPERTY_ID = RC.PROPERTY_ID AND COL.PRIMARY_LOAN_IN = 'Y'
				 JOIN LOAN LN ON LN.ID = COL.LOAN_ID
				 LEFT OUTER JOIN #tmpISCT tmpCert on tmpCert.PLI_ID = PLI.ID
				 CROSS APPLY
				 (SELECT OVERRIDE_TYPE_CD + ',' + cast(ISNULL(cast(OVERRIDE_START_DT AS DATE), '1/1/0001') AS VARCHAR) + ',' + cast(ISNULL(cast(OVERRIDE_END_DT AS DATE), '1/1/0001') AS VARCHAR) + '|' FROM IMPAIRMENT IMP
					WHERE IMP.REQUIRED_COVERAGE_ID = RC.ID AND IMP.PURGE_DT IS NULL
					AND datepart(year, END_DT) = 9999
					FOR XML PATH('')) TBLIMP (OVERRIDE_TYPE_CD)
				 CROSS APPLY
				 (SELECT count(*) DCCNT FROM DOCUMENT_CONTAINER DC WHERE DC.RELATE_ID = FPC.ID AND DC.RELATE_CLASS_NAME_TX = 'Allied.Unitrac.ForcePlacedCertificate' AND DC.PURGE_DT IS NULL) TBL
				 CROSS APPLY
				 (	SELECT LAST_NAME_TX + ', ' + FIRST_NAME_TX + '|'
					FROM OWNER OWN
						JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = LN.ID AND OWN.ID = OLR.OWNER_ID
					FOR XML PATH('')) TBLOWNER (OWNER_NAME)					
			WHERE @isISCT = 'Y'
			AND FPC.PDF_GENERATE_CD <> 'ONHO'
			AND tmpCert.PLI_ID IS NULL
			AND LN.PURGE_DT IS NULL
			AND PLI.PURGE_DT IS NULL
			AND COL.PURGE_DT IS NULL
			AND FPC.PURGE_DT IS NULL
			AND RC.PURGE_DT IS NULL
			AND FPCRCR.PURGE_DT IS NULL
		END
				
	END

	--Outbound Calls
	IF @isOBCL = 'Y'
	BEGIN
		SELECT tmp.WIPLIR_ID, tmp.PARENT_WORK_ITEM_ID, PLI.EVALUATION_EVENT_ID EVENT_ID, PLI.ID AS PLI_ID, PLI.RELATE_ID, PLI.RELATE_TYPE_CD, PLI.INFO_XML, PLI.STATUS_CD,
			   LN.ID AS LOAN_ID, RC.PROPERTY_ID, RC.ID RC_ID, RC.EXPOSURE_DT, 'N' AS CAPTURED_DATA_IND, 0 AS DCCNT, TBLOWNER.OWNER_NAME,
			   '' AS BILLING_STATUS_CD,
			   LN.NUMBER_TX, '' NOTICE_TYPE_CD,
			   PR.DESCRIPTION_TX, PR.YEAR_TX, PR.MAKE_TX, PR.MODEL_TX, PR.VIN_TX,
			   RC.TYPE_CD, RC.INSURANCE_STATUS_CD, RC.INSURANCE_SUB_STATUS_CD, RC.SUMMARY_STATUS_CD, RC.SUMMARY_SUB_STATUS_CD,
			   RC.STATUS_CD RC_STATUS_CD, LN.STATUS_CD LN_STATUS_CD, COL.STATUS_CD COL_STATUS_CD,
			   CC.SECONDARY_CLASS_CD,
			   OWNADD.LINE_1_TX, OWNADD.CITY_TX, OWNADD.STATE_PROV_TX, OWNADD.POSTAL_CODE_TX,
			   isnull(TBLIMP.OVERRIDE_TYPE_CD, '') OVERRIDE_TYPE_CD
			   , '' AS PDF_GENERATE_CD, 0 AS CPI_QUOTE_ID, ES.TIMING_FROM_LAST_EVENT_DAYS_NO
			   , '' AS CD_TYPECODE
				, '' AS CD_NOTICE_SEQ
				, '' AS CD_NOTICE_NAME
				, '' AS CD_LOAN_NUMBER
				, 'N' AS CD_IS_LENDER_ONLY
				, '' AS CD_PROPERTY_YEAR
				, '' AS CD_PROPERTY_MAKE
				, '' AS CD_PROPERTY_MODEL
				, '' AS CD_PROPERTY_VIN
				, CC.CODE_TX AS CD_PROPERTY_COL_CD
				, '' AS CD_PROPERTY_SEC_CLASS
				, '' AS CD_PROPERTY_LINE1
				, '' AS CD_PROPERTY_CITY
				, '' AS CD_PROPERTY_STATE
				, '' AS CD_PROPERTY_POSTALCODE
				, '' AS CD_LOAN_BALANCEAMT
				, '' AS CD_CPIQUOTE_TOTALAMT
				, '' AS CD_OWNER_NAMES
		INTO #tmpOBCL
		FROM #tmpPLI tmp
			 JOIN PROCESS_LOG_ITEM PLI ON PLI.ID = tmp.PLI_ID AND PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Workflow.OutboundCallWorkItem'
			 JOIN EVALUATION_EVENT EVT ON EVT.ID = PLI.EVALUATION_EVENT_ID
			 JOIN REQUIRED_COVERAGE RC ON RC.ID = EVT.REQUIRED_COVERAGE_ID
			 JOIN PROPERTY PR ON PR.ID = RC.PROPERTY_ID
			 JOIN COLLATERAL COL ON COL.PROPERTY_ID = RC.PROPERTY_ID AND COL.PRIMARY_LOAN_IN = 'Y'
			 JOIN LOAN LN ON LN.ID = COL.LOAN_ID
			 LEFT JOIN OWNER_ADDRESS OWNADD ON OWNADD.ID = PR.ADDRESS_ID
			 LEFT JOIN COLLATERAL_CODE CC ON CC.ID = COL.COLLATERAL_CODE_ID
			 LEFT OUTER JOIN EVENT_SEQUENCE ES ON ES.ID = EVT.EVENT_SEQUENCE_ID
			 CROSS APPLY
			 (SELECT OVERRIDE_TYPE_CD + ',' + cast(ISNULL(cast(OVERRIDE_START_DT AS DATE), '1/1/0001') AS VARCHAR) + ',' + cast(ISNULL(cast(OVERRIDE_END_DT AS DATE), '1/1/0001') AS VARCHAR) + '|' FROM IMPAIRMENT IMP
				WHERE IMP.REQUIRED_COVERAGE_ID = RC.ID AND IMP.PURGE_DT IS NULL
				AND datepart(year, END_DT) = 9999
				FOR XML PATH('')) TBLIMP (OVERRIDE_TYPE_CD)
			 CROSS APPLY
			 (	SELECT ISNULL(LAST_NAME_TX,'') + ', ' + ISNULL(FIRST_NAME_TX,'') + '|'
				FROM OWNER OWN
					JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = LN.ID AND OWN.ID = OLR.OWNER_ID
               AND OWN.PURGE_DT IS NULL AND OLR.PURGE_DT IS NULL
				FOR XML PATH('')) TBLOWNER (OWNER_NAME)
		WHERE @isOBCL = 'Y'
		AND LN.PURGE_DT IS NULL
		AND PLI.PURGE_DT IS NULL
		AND COL.PURGE_DT IS NULL
		AND PR.PURGE_DT IS NULL
		AND RC.PURGE_DT IS NULL
		AND EVT.PURGE_DT IS NULL
	END

	--Automated Outbound Calls
	IF @isAOBC = 'Y'
	BEGIN
		SELECT tmp.WIPLIR_ID, tmp.PARENT_WORK_ITEM_ID, PLI.EVALUATION_EVENT_ID EVENT_ID, PLI.ID AS PLI_ID, PLI.RELATE_ID, PLI.RELATE_TYPE_CD, PLI.INFO_XML, PLI.STATUS_CD,
			   LN.ID AS LOAN_ID, RC.PROPERTY_ID, RC.ID RC_ID, RC.EXPOSURE_DT, 'N' AS CAPTURED_DATA_IND, 0 AS DCCNT, TBLOWNER.OWNER_NAME,
			   '' AS BILLING_STATUS_CD,
			   LN.NUMBER_TX, '' NOTICE_TYPE_CD,
			   PR.DESCRIPTION_TX, PR.YEAR_TX, PR.MAKE_TX, PR.MODEL_TX, PR.VIN_TX,
			   RC.TYPE_CD, RC.INSURANCE_STATUS_CD, RC.INSURANCE_SUB_STATUS_CD, RC.SUMMARY_STATUS_CD, RC.SUMMARY_SUB_STATUS_CD,
			   RC.STATUS_CD RC_STATUS_CD, LN.STATUS_CD LN_STATUS_CD, COL.STATUS_CD COL_STATUS_CD,
			   CC.SECONDARY_CLASS_CD,
			   OWNADD.LINE_1_TX, OWNADD.CITY_TX, OWNADD.STATE_PROV_TX, OWNADD.POSTAL_CODE_TX,
			   isnull(TBLIMP.OVERRIDE_TYPE_CD, '') OVERRIDE_TYPE_CD
			   , '' AS PDF_GENERATE_CD, 0 AS CPI_QUOTE_ID, 0 AS TIMING_FROM_LAST_EVENT_DAYS_NO
			   , '' AS CD_TYPECODE
				, '' AS CD_NOTICE_SEQ
				, '' AS CD_NOTICE_NAME
				, '' AS CD_LOAN_NUMBER
				, 'N' AS CD_IS_LENDER_ONLY
				, '' AS CD_PROPERTY_YEAR
				, '' AS CD_PROPERTY_MAKE
				, '' AS CD_PROPERTY_MODEL
				, '' AS CD_PROPERTY_VIN
				, CC.CODE_TX AS CD_PROPERTY_COL_CD
				, '' AS CD_PROPERTY_SEC_CLASS
				, '' AS CD_PROPERTY_LINE1
				, '' AS CD_PROPERTY_CITY
				, '' AS CD_PROPERTY_STATE
				, '' AS CD_PROPERTY_POSTALCODE
				, '' AS CD_LOAN_BALANCEAMT
				, '' AS CD_CPIQUOTE_TOTALAMT
				, '' AS CD_OWNER_NAMES
		INTO #tmpAOBC
		FROM #tmpPLI tmp
			 JOIN PROCESS_LOG_ITEM PLI ON PLI.ID = tmp.PLI_ID AND PLI.RELATE_TYPE_CD = 'Allied.UniTrac.NoticeInteraction'
			 JOIN EVALUATION_EVENT EVT ON EVT.ID = PLI.EVALUATION_EVENT_ID
			 JOIN REQUIRED_COVERAGE RC ON RC.ID = EVT.REQUIRED_COVERAGE_ID
			 JOIN PROPERTY PR ON PR.ID = RC.PROPERTY_ID
			 JOIN COLLATERAL COL ON COL.PROPERTY_ID = RC.PROPERTY_ID AND COL.PRIMARY_LOAN_IN = 'Y'
			 JOIN LOAN LN ON LN.ID = COL.LOAN_ID
			 LEFT JOIN OWNER_ADDRESS OWNADD ON OWNADD.ID = PR.ADDRESS_ID
			 LEFT JOIN COLLATERAL_CODE CC ON CC.ID = COL.COLLATERAL_CODE_ID
			 CROSS APPLY
			 (SELECT OVERRIDE_TYPE_CD + ',' + cast(ISNULL(cast(OVERRIDE_START_DT AS DATE), '1/1/0001') AS VARCHAR) + ',' + cast(ISNULL(cast(OVERRIDE_END_DT AS DATE), '1/1/0001') AS VARCHAR) + '|' FROM IMPAIRMENT IMP
				WHERE IMP.REQUIRED_COVERAGE_ID = RC.ID AND IMP.PURGE_DT IS NULL
				AND datepart(year, END_DT) = 9999
				FOR XML PATH('')) TBLIMP (OVERRIDE_TYPE_CD)
			 CROSS APPLY
			 (	SELECT ISNULL(LAST_NAME_TX,'') + ', ' + ISNULL(FIRST_NAME_TX,'') + '|'
				FROM OWNER OWN
					JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = LN.ID AND OWN.ID = OLR.OWNER_ID
               AND OWN.PURGE_DT IS NULL AND OLR.PURGE_DT IS NULL
				FOR XML PATH('')) TBLOWNER (OWNER_NAME)
		WHERE @isAOBC = 'Y'
		AND LN.PURGE_DT IS NULL
		AND PLI.PURGE_DT IS NULL
		AND COL.PURGE_DT IS NULL
		AND PR.PURGE_DT IS NULL
		AND RC.PURGE_DT IS NULL
		AND EVT.PURGE_DT IS NULL
	END

	DECLARE @sqlFinal NVARCHAR(500)
	DECLARE @sql NVARCHAR(500)
	SET @sql = ''
	SET @sqlFinal = ''

	IF @isNotice = 'Y'
	BEGIN
		SET @sql = 'SELECT * FROM #tmpNotice'
	END

	IF @isISCT = 'Y'
	BEGIN
		IF LEN(@sql) > 0
			SET @sql = @sql + ' UNION ALL'

		SET @sql = @sql + ' SELECT * FROM #tmpISCT'
	END

	IF @isOBCL = 'Y'
	BEGIN
		IF LEN(@sql) > 0
			SET @sql = @sql + ' UNION ALL'

		SET @sql = @sql + ' SELECT * FROM #tmpOBCL'
	END

	IF @isAOBC = 'Y'
	BEGIN
		IF LEN(@sql) > 0
			SET @sql = @sql + ' UNION ALL'

		SET @sql = @sql + ' SELECT * FROM #tmpAOBC'
	END

	IF LEN(@sql) > 0
	BEGIN
		IF (OBJECT_ID('tempdb..#tmpISCTLenderOnly') is not null)
		BEGIN
			SET @sqlFinal = 'SELECT * FROM #tmpISCTLenderOnly  '
			SET @sqlFinal = @sqlFinal + ' UNION ALL '
		END		
		
		SET @sqlFinal = @sqlFinal + ' SELECT * FROM (SELECT TOP (' + cast(@pageSize as varchar(10)) + ') * FROM ( ' + @sql + ') tbl ORDER BY PLI_ID ASC ) tblFinal'		
	END
	
	print @sqlFinal
	exec sp_executesql @sqlFinal

END




GO

