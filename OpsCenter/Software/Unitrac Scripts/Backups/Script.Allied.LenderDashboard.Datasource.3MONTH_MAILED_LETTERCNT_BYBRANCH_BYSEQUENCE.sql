-- allow for identity specification 
SET IDENTITY_INSERT DATASOURCE ON;

WITH DATASOURCE_MERGE
(
           [ID]
           ,[NAME_TX]
           ,[AGENCY_ID]
           ,[TYPE_CD]
           ,[UPDATE_FREQUENCY_CD]
           ,[SETTINGS_XML]
           ,[PARAMETERS_XML]
           ,[CREATE_DT]
           ,[UPDATE_DT]
           ,[PURGE_DT]
           ,[UPDATE_USER_TX]
		   ,[ACTIVE_IN]
           ,[LOCK_ID]
)
AS
(
   SELECT 
      110 AS ID
      , '3 Month Mailed Letter Count by Branch and Sequence'
      ,NULL
      ,'3MONTH_MAILED_LETTERCNT_BYBRANCH_BYSEQUENCE'
      ,'DAY'   
      ,'<DatasourceSettings>
       <SourceData type="SQL">
             <ConnectionDescriptor>UNITRAC</ConnectionDescriptor>
             <SQLStatement>
               
                  IF OBJECT_ID(''tempdb..#TMP_3MONTH_MAILED_LETTERCNT_BYBRANCH_BYSEQUENCE'') IS NOT NULL
	                  DROP TABLE #TMP_3MONTH_MAILED_LETTERCNT_BYBRANCH_BYSEQUENCE

                  CREATE TABLE #TMP_3MONTH_MAILED_LETTERCNT_BYBRANCH_BYSEQUENCE (
	                  LENDER_CD NVARCHAR(50)
                  ,	LENDER_NAME NVARCHAR(500)
                  ,	BRANCH NVARCHAR(150)
                  ,	EVENT_TYPE NVARCHAR(100)
                  ,	YEAR_MONTH DATE
                  ,	NOTICE_SEQ NVARCHAR(50)
                  ,	LOAN_TYPE NVARCHAR(50)
                  ,	LOAN_ID BIGINT
                  );


                  INSERT INTO #TMP_3MONTH_MAILED_LETTERCNT_BYBRANCH_BYSEQUENCE
	                  SELECT
		                  LENDER_CD
	                  ,	LENDER_NAME
	                  ,	L_BRANCH_CODE_TX AS ''BRANCH''
	                  ,	n.NAME_TX AS ''EVENT_TYPE''
	                  ,	CAST(CONVERT(VARCHAR, DATEPART(YEAR, dc.PRINTED_DT)) + ''-'' + CONVERT(VARCHAR, DATEPART(MONTH, dc.PRINTED_DT)) + ''-01'' AS DATE) AS ''YEAR_MONTH''
	                  ,	''Notice '' + CONVERT(NVARCHAR(10), n.SEQUENCE_NO) AS ''NOTICE_SEQ''
	                  ,	LOAN_TYPE
	                  ,	l.LOAN_ID
	                  FROM DATASOURCE_CACHE_STAGING l (NOLOCK)
		                  LEFT OUTER JOIN LENDER_ORGANIZATION lo (NOLOCK) ON lo.LENDER_ID = l.LENDER_ID
				                  AND lo.CODE_TX = L_BRANCH_CODE_TX
				                  AND lo.TYPE_CD = ''BRCH''
				                  AND lo.PURGE_DT IS NULL
		                  JOIN NOTICE_REQUIRED_COVERAGE_RELATE nrcr (NOLOCK) ON nrcr.REQUIRED_COVERAGE_ID = RC_ID
				                  AND nrcr.PURGE_DT IS NULL
		                  JOIN NOTICE n (NOLOCK) ON n.LOAN_ID = l.LOAN_ID
				                  AND n.PURGE_DT IS NULL
		                  JOIN DOCUMENT_CONTAINER dc (NOLOCK) ON dc.RELATE_ID = n.ID
				                  AND dc.RELATE_CLASS_NAME_TX = ''allied.unitrac.notice''
				                  AND dc.PRINT_STATUS_CD = ''PRINTED''
				                  AND dc.PRINTED_DT &gt;= DATEADD(MONTH, -3, CAST(CONVERT(VARCHAR, DATEPART(YEAR, GETDATE())) + ''-'' + CONVERT(VARCHAR, DATEPART(MONTH, GETDATE())) + ''-01'' AS DATE))
				                  AND dc.PURGE_DT IS NULL
	                  UNION ALL
	                  SELECT
		                  LENDER_CD
	                  ,	LENDER_NAME
	                  ,	L_BRANCH_CODE_TX AS ''BRANCH''
	                  ,	''Issue Certificate'' AS ''EVENT_TYPE''
	                  ,	CAST(CONVERT(VARCHAR, DATEPART(YEAR, dc.PRINTED_DT)) + ''-'' + CONVERT(VARCHAR, DATEPART(MONTH, dc.PRINTED_DT)) + ''-01'' AS DATE) AS ''YEAR_MONTH''
	                  ,	''Issue Certificate'' AS ''NOTICE_SEQ''
	                  ,	LOAN_TYPE
	                  ,	l.LOAN_ID
	                  FROM DASHBOARD_STAGING l (NOLOCK)
		                  LEFT OUTER JOIN LENDER_ORGANIZATION lo (NOLOCK) ON lo.LENDER_ID = l.LENDER_ID
				                  AND lo.CODE_TX = L_BRANCH_CODE_TX
				                  AND lo.PURGE_DT IS NULL
		                  JOIN dbo.FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE fpcrcr (NOLOCK) ON RC_ID = fpcrcr.REQUIRED_COVERAGE_ID
				                  AND fpcrcr.PURGE_DT IS NULL
		                  JOIN dbo.FORCE_PLACED_CERTIFICATE fpc (NOLOCK) ON fpcrcr.FPC_ID = fpc.ID
		                  JOIN DOCUMENT_CONTAINER dc ON dc.RELATE_ID = fpc.ID
				                  AND dc.RELATE_CLASS_NAME_TX = ''Allied.UniTrac.ForcePlacedCertificate''
				                  AND dc.PRINT_STATUS_CD = ''PRINTED''
				                  AND dc.PRINTED_DT &gt;= DATEADD(MONTH, -3, CAST(CONVERT(VARCHAR, DATEPART(YEAR, GETDATE())) + ''-'' + CONVERT(VARCHAR, DATEPART(MONTH, GETDATE())) + ''-01'' AS DATE))
				                  AND dc.PURGE_DT IS NULL

                  SELECT
	                  tmmlbb.LENDER_CD
                  ,	tmmlbb.LENDER_NAME
                  ,	tmmlbb.BRANCH
                  ,	tmmlbb.EVENT_TYPE
                  ,	tmmlbb.YEAR_MONTH
                  ,	tmmlbb.NOTICE_SEQ
                  ,	tmmlbb.LOAN_TYPE
                  ,	COUNT(*) AS ''LETTER_COUNT''
                  FROM #TMP_3MONTH_MAILED_LETTERCNT_BYBRANCH_BYSEQUENCE tmmlbb
                  GROUP BY	tmmlbb.LENDER_CD
		                  ,	tmmlbb.LENDER_NAME
		                  ,	tmmlbb.BRANCH
		                  ,	tmmlbb.EVENT_TYPE
		                  ,	tmmlbb.YEAR_MONTH
		                  ,	tmmlbb.NOTICE_SEQ
		                  ,	tmmlbb.LOAN_TYPE
                  ORDER BY tmmlbb.LENDER_CD, tmmlbb.YEAR_MONTH, tmmlbb.LOAN_TYPE
 
			    </SQLStatement>
       </SourceData>
       <CacheData target="DatasourceCache" replace="true">
             <MapEntry SourceColumn="LENDER_CD" TargetColumn="ASSOCIATION_CD"/>
             <MapEntry SourceColumn="LENDER_NAME" TargetColumn="ASSOCIATION_NAME_TX"/>
             <MapEntry SourceColumn="BRANCH" TargetColumn="TYPE_CD"/>
             <MapEntry SourceColumn="YEAR_MONTH" TargetColumn="RECORD_DATE"/>
             <MapEntry SourceColumn="EVENT_TYPE" TargetColumn="STATUS_CD"/>
             <MapEntry SourceColumn="LETTER_COUNT" TargetColumn="COUNT_NO"/>
			    <MapEntry SourceColumn="NOTICE_SEQ" TargetColumn="SOURCE_CD"/>
             <MapEntry SourceColumn="LOAN_TYPE" TargetColumn="RESULT_CD"/>
       </CacheData>
</DatasourceSettings>'
   ,'<Cache>
      <Parameter>
         <Get id="GetCacheData">
            <Param Name="ParamName" SourceIdentifier="DataTableColumnName" DataType="System.String" DefaultValue="3MONTH_MAILED_LETTERCNT_BYBRANCH_BYSEQUENCE" />
         </Get>
         <Set id="SetCacheData">
            <Param Name="ParamName" SourceTableIdentifier="TableName" SourceColumnIdentifier="" DataType="XML" DefaultValue="" />
         </Set>
      </Parameter>
   </Cache>'
   ,getdate()
   ,getdate()
   ,null
   ,'system'
   ,'Y'
   ,1
)

-------
MERGE	DATASOURCE
USING	DATASOURCE_MERGE
ON	DATASOURCE_MERGE.TYPE_CD = DATASOURCE.TYPE_CD
WHEN MATCHED THEN
	update	set
		NAME_TX				         = DATASOURCE_MERGE.NAME_TX,
		AGENCY_ID			         = DATASOURCE_MERGE.AGENCY_ID,
		UPDATE_FREQUENCY_CD			= DATASOURCE_MERGE.UPDATE_FREQUENCY_CD,
		SETTINGS_XML		         = DATASOURCE_MERGE.SETTINGS_XML,
		PARAMETERS_XML		         = DATASOURCE_MERGE.PARAMETERS_XML,
		CREATE_DT			         = DATASOURCE_MERGE.CREATE_DT,
		UPDATE_DT			         = DATASOURCE_MERGE.UPDATE_DT,
		UPDATE_USER_TX			      = DATASOURCE_MERGE.UPDATE_USER_TX,
		ACTIVE_IN				     = DATASOURCE_MERGE.ACTIVE_IN,
		LOCK_ID				         = DATASOURCE_MERGE.LOCK_ID+1
WHEN NOT MATCHED BY TARGET THEN
	insert	(
		ID,
		NAME_TX,
      TYPE_CD,
		AGENCY_ID,
		UPDATE_FREQUENCY_CD,
		SETTINGS_XML,
		PARAMETERS_XML,
		CREATE_DT,
		UPDATE_DT,
		UPDATE_USER_TX,
		ACTIVE_IN,
		LOCK_ID
		)
	values	(
		DATASOURCE_MERGE.ID,
		DATASOURCE_MERGE.NAME_TX,
      DATASOURCE_MERGE.TYPE_CD,
		DATASOURCE_MERGE.AGENCY_ID,
		DATASOURCE_MERGE.UPDATE_FREQUENCY_CD,
		DATASOURCE_MERGE.SETTINGS_XML,
		DATASOURCE_MERGE.PARAMETERS_XML,
		DATASOURCE_MERGE.CREATE_DT,
		DATASOURCE_MERGE.UPDATE_DT,
		DATASOURCE_MERGE.UPDATE_USER_TX,
		DATASOURCE_MERGE.ACTIVE_IN,
		DATASOURCE_MERGE.LOCK_ID
		)
OUTPUT	$action, inserted.*, deleted.*;


SET IDENTITY_INSERT DATASOURCE OFF;


