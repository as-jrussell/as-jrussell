USE UniTrac
GO
							
		  SELECT
			getdate() as CREATE_DT
		,	ldr.ID as LENDER_ID
		,	ldr.CODE_TX AS 'LENDER_CD'
		,	ldr.NAME_TX AS 'LENDER_NAME'
		,	l.ID AS 'LOAN_ID'
 		,	l.BRANCH_CODE_TX AS L_BRANCH_CODE_TX
		,   l.DIVISION_CODE_TX as L_DIVISION_CODE_TX
		,	rc.ID as RC_ID
		,	rc.TYPE_CD as RC_TYPE_CD
		,	rc.RECORD_TYPE_CD as RC_RECORD_TYPE_CD
		,	rc.STATUS_CD as RC_STATUS_CD
		,	rc.SUMMARY_SUB_STATUS_CD as RC_SUMMARY_SUB_STATUS_CD
		,	rc.SUMMARY_STATUS_CD as RC_SUMMARY_STATUS_CD
		,	rc.EXPOSURE_DT as RC_EXPOSURE_DT
		,	rc.INSURANCE_SUB_STATUS_CD
		,   c.ID as C_ID
		,   c.PRIMARY_LOAN_IN as C_PRIMARY_LOAN_IN
		,	c.PROPERTY_ID as C_PROPERTY_ID
		,	c.STATUS_CD as C_STATUS_CD
		,   LOAN_TYPE =
			CASE
				WHEN CC.VEHICLE_LOOKUP_IN = 'Y' THEN 'Vehicle'
				WHEN CC.ADDRESS_LOOKUP_IN = 'Y' AND CC.PRIMARY_CLASS_CD <> 'COM' THEN 'Mortgage'
				WHEN CC.ADDRESS_LOOKUP_IN = 'Y' AND CC.PRIMARY_CLASS_CD = 'COM' THEN 'Commercial Mortgage'
				WHEN CC.VEHICLE_LOOKUP_IN = 'N' AND CC.ADDRESS_LOOKUP_IN = 'N' THEN 'Equipment'
			END
			INTO #tmp
		FROM dbo.LENDER ldr (NOLOCK)
         inner merge JOIN  dbo.LOAN l (NOLOCK) ON ldr.ID = l.LENDER_ID
			inner merge JOIN  dbo.COLLATERAL c (NOLOCK) ON l.ID = c.LOAN_ID
					AND c.PURGE_DT IS NULL
			inner merge JOIN  dbo.REQUIRED_COVERAGE rc (NOLOCK) ON rc.PROPERTY_ID = C.PROPERTY_ID
					AND rc.PURGE_DT IS NULL
			left outer join  dbo.COLLATERAL_CODE CC	ON CC.ID = C.COLLATERAL_CODE_ID
					AND CC.PURGE_DT IS NULL
		WHERE 
         l.RECORD_TYPE_CD IN ('G') AND ldr.CODE_TX = '6497'
			AND l.PURGE_DT IS NULL
			AND l.STATUS_CD IN ('A', 'B')




		SELECT
		LENDER_CD
	,	LENDER_NAME
	,	L_BRANCH_CODE_TX AS 'BRANCH'
	,	CAST(CONVERT(VARCHAR, DATEPART(YEAR, ee.UPDATE_DT)) + '-' + CONVERT(VARCHAR, DATEPART(MONTH, ee.UPDATE_DT)) + '-01' AS DATE) AS 'YEAR_MONTH'
	,	es.ORDER_NO AS 'es_order_no'
	,	es.EVENT_TYPE_CD
	,	es.NOTICE_SEQ_NO
	,	rces.MEANING_TX
	,	rces.MEANING_TX + ' ' + CASE
			WHEN es.EVENT_TYPE_CD = 'NTC' THEN CONVERT(NVARCHAR(10), es.NOTICE_SEQ_NO)
			ELSE ''
		END AS 'EVENT_TYPE'
	,	LOAN_TYPE
	,	ee.GROUP_ID AS 'ee_group_id'
	,	ee.ID AS 'ee_id' , 
	LOAN_ID
	INTO #ee_to_consider
	FROM #tmp l (NOLOCK)
		JOIN LENDER_ORGANIZATION lo (NOLOCK) ON lo.LENDER_ID = l.LENDER_ID
				AND lo.CODE_TX = L_DIVISION_CODE_TX
            AND lo.TYPE_CD = 'DIV'
				AND lo.purge_dt is null
		JOIN EVALUATION_EVENT ee (NOLOCK) ON ee.REQUIRED_COVERAGE_ID = l.RC_ID
				AND ee.RELATE_ID IS NOT NULL
				AND ee.STATUS_CD = 'COMP'
				AND ee.PURGE_DT IS NULL
				AND ee.UPDATE_DT >= DATEADD(MONTH, -12, CAST(CONVERT(VARCHAR, DATEPART(YEAR, GETDATE())) + '-' + CONVERT(VARCHAR, DATEPART(MONTH, GETDATE())) + '-01' AS DATE))
		JOIN EVENT_SEQUENCE es (NOLOCK) ON es.ID = ee.EVENT_SEQUENCE_ID
				AND es.PURGE_DT IS NULL
				AND es.EVENT_TYPE_CD NOT IN ('DFLT')
		JOIN EVENT_SEQ_CONTAINER esc (NOLOCK) ON esc.ID = es.EVENT_SEQ_CONTAINER_ID
				AND esc.PURGE_DT IS NULL
				AND esc.NOTICE_CYCLE_IN = 'Y'
		JOIN REF_CODE rces (NOLOCK) ON rces.DOMAIN_CD = 'EventSequenceEventType'
				AND rces.PURGE_DT IS NULL
				AND rces.CODE_CD = es.EVENT_TYPE_CD
	WHERE RC_RECORD_TYPE_CD = 'G'
		AND RC_STATUS_CD = 'A' AND EVENT_TYPE_CD = 'NTC'



--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT
        L.NUMBER_TX , E.YEAR_MONTH,
        IH.SPECIAL_HANDLING_XML.value('(/SH/Status)[1]', 'varchar (50)') [CPI Status] ,
        IH.SPECIAL_HANDLING_XML.value('(/SH/Premium)[1]', 'varchar (50)') [Premium Amount] ,
        IH.SPECIAL_HANDLING_XML.value('(/SH/PolicyNo)[1]', 'varchar (50)') [CPI Policy] ,
        RC1.DESCRIPTION_TX [Coverage Status] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,
		  RC5.DESCRIPTION_TX [Insurance Coverage Status] ,
        es.EVENT_TYPE_CD ,
        es.NOTICE_SEQ_NO INTO jcs..INC0279791_2017
FROM    #ee_to_consider E
        INNER JOIN LOAN L ON L.ID = E.LOAN_ID
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID
                                                 AND IH.TYPE_CD = 'CPI'
        INNER JOIN dbo.REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
        JOIN EVALUATION_EVENT ee ON ee.REQUIRED_COVERAGE_ID = RC.ID
        INNER JOIN EVENT_SEQUENCE es ON es.ID = ee.EVENT_SEQUENCE_ID
        INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.STATUS_CD
                                       AND RC1.DOMAIN_CD = 'RequiredCoverageStatus'
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
		INNER JOIN dbo.REF_CODE RC5 ON RC5.CODE_CD = RC.INSURANCE_STATUS_CD
                                       AND RC5.DOMAIN_CD = 'RequiredCoverageInsStatus'
WHERE   IH.SPECIAL_HANDLING_XML.value('(/SH/PolicyNo)[1]', 'varchar (50)') IS NOT NULL
        AND E.EVENT_TYPE_CD = 'NTC' AND E.NOTICE_SEQ_NO IN ('1' , '2')
		AND YEAR_MONTH LIKE '2017%'



		SELECT DISTINCT * FROM jcs..INC0279791
		WHERE EVENT_TYPE_CD = 'NTC' AND NOTICE_SEQ_NO IN ('1' , '2')
		AND [Insurance Coverage Status] <> 'In Force'


		SELECT * FROM dbo.REF_CODE
		WHERE DOMAIN_CD = 'RequiredCoverageInsStatus'
