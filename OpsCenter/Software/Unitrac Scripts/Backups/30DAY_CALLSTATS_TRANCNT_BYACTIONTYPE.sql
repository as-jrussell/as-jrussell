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
      160 AS ID
      , '30 Day Call Statistics Transaction Count by Action Type'
      ,NULL
      ,'30DAY_CALLSTATS_TRANCNT_BYACTIONTYPE'
      ,'HOUR'   
      ,'<DatasourceSettings>
	<SourceData type="SQL">
		<ConnectionDescriptor>UNITRAC</ConnectionDescriptor>
		<SQLStatement>
         Select L.CODE_TX as LENDER_CODE, L.NAME_TX AS LENDER_NAME, ''Inbound Calls'' as TYPE_CD,COUNT(*) as TXN_COUNT
           from INTERACTION_HISTORY H
           join PROPERTY P on P.ID = H.PROPERTY_ID AND P.PURGE_DT IS NULL
           Join LENDER L on L.ID = P.LENDER_ID AND L.CODE_TX = ''5350''
           where H.TYPE_CD = ''INBNDCALL'' and H.PROPERTY_ID IS NOT NULL and H.CREATE_DT >= DateAdd(month,-1,getdate()) and H.PURGE_DT is NULL
           Group by L.CODE_TX, L.NAME_TX
            UNION
            Select L.CODE_TX as LENDER_CODE, L.NAME_TX AS LENDER_NAME, ''Inbound Calls'' as TYPE_CD,COUNT(*) as TXN_COUNT
           from INTERACTION_HISTORY H
           join LOAN LN on LN.ID = H.LOAN_ID AND LN.PURGE_DT IS NULL
           Join LENDER L on L.ID = LN.LENDER_ID AND L.CODE_TX = ''5350''
           where H.TYPE_CD = ''INBNDCALL'' and H.LOAN_ID IS NOT NULL and H.CREATE_DT  >= DateAdd(month,-1,getdate())  and H.PURGE_DT is NULL
           Group by L.CODE_TX, L.NAME_TX
            UNION
            Select L.CODE_TX as LENDER_CODE, L.NAME_TX AS LENDER_NAME,  ''Live Chat'' as TYPE_CD,COUNT(*) as TXN_COUNT
           from INTERACTION_HISTORY H
           join LOAN LN on LN.ID = H.LOAN_ID AND LN.PURGE_DT IS NULL
           Join LENDER L on L.ID = LN.LENDER_ID AND L.CODE_TX = ''5350''
           where H.TYPE_CD = ''INBNDCALL'' and H.LOAN_ID IS NOT NULL and H.CREATE_DT >= DateAdd(month,-1,getdate())  and H.PURGE_DT is NULL 
                 and (H.SPECIAL_HANDLING_XML.value(''(//SH/LiveChat)[1]'', ''varchar(50)'') = ''Y'')
           Group by L.CODE_TX, L.NAME_TX
            UNION
           Select L.CODE_TX as LENDER_CODE, L.NAME_TX AS LENDER_NAME, ''1 Call Resolution'' as TYPE_CD,COUNT(*) as TXN_COUNT
           from INTERACTION_HISTORY H
           join PROPERTY P on P.ID = H.PROPERTY_ID AND P.PURGE_DT IS NULL
           Join LENDER L on L.ID = P.LENDER_ID AND L.CODE_TX = ''5350''
           where H.TYPE_CD = ''INBNDCALL'' and H.PROPERTY_ID IS NOT NULL and H.CREATE_DT >= DateAdd(month,-1,getdate())  and H.PURGE_DT is NULL
                 and (H.SPECIAL_HANDLING_XML.value(''(//SH/CallerSatisfied)[1]'', ''varchar(50)'') = ''Y'')
           Group by L.CODE_TX, L.NAME_TX
              UNION
           Select L.CODE_TX as LENDER_CODE, L.NAME_TX AS LENDER_NAME,  ''1 Call Resolution'' as TYPE_CD,COUNT(*) as TXN_COUNT
           from INTERACTION_HISTORY H
           join LOAN LN on LN.ID = H.LOAN_ID AND LN.PURGE_DT IS NULL
           Join LENDER L on L.ID = LN.LENDER_ID AND L.CODE_TX = ''5350''
           where H.TYPE_CD = ''INBNDCALL'' and H.LOAN_ID IS NOT NULL and H.CREATE_DT >= DateAdd(month,-1,getdate())  and H.PURGE_DT is NULL 
                 and (H.SPECIAL_HANDLING_XML.value(''(//SH/CallerSatisfied)[1]'', ''varchar(50)'') = ''Y'')
           Group by L.CODE_TX, L.NAME_TX
            UNION
           Select L.CODE_TX as LENDER_CODE, L.NAME_TX AS LENDER_NAME, ''Outbound Calls'' as TYPE_CD,COUNT(*) as TXN_COUNT
           from INTERACTION_HISTORY H
           join PROPERTY P on P.ID = H.PROPERTY_ID AND P.PURGE_DT IS NULL
           Join LENDER L on L.ID = P.LENDER_ID AND L.CODE_TX = ''5350''
           where H.TYPE_CD = ''OUTBNDCALL'' and H.PROPERTY_ID IS NOT NULL and H.CREATE_DT >= DateAdd(month,-1,getdate())  and H.PURGE_DT is NULL               
                 and (H.SPECIAL_HANDLING_XML.value(''(//SH/WebVerification)[1]'', ''varchar(50)'') &lt;&gt; ''Y'' or H.SPECIAL_HANDLING_XML.value(''(//SH/WebVerification)[1]'', ''varchar(50)'') is NULL)
           Group by L.CODE_TX,L.NAME_TX
            UNION
           Select L.CODE_TX as LENDER_CODE, L.NAME_TX AS LENDER_NAME, ''Outbound Calls'' as TYPE_CD,COUNT(*) as TXN_COUNT
           from INTERACTION_HISTORY H
           join LOAN LN on LN.ID = H.LOAN_ID AND LN.PURGE_DT IS NULL
           Join LENDER L on L.ID = LN.LENDER_ID AND L.CODE_TX = ''5350''
           where H.TYPE_CD = ''OUTBNDCALL'' and H.LOAN_ID IS NOT NULL and H.CREATE_DT >= DateAdd(month,-1,getdate())  and H.PURGE_DT is NULL 
                 and (H.SPECIAL_HANDLING_XML.value(''(//SH/WebVerification)[1]'', ''varchar(50)'') &lt;&gt; ''Y'' or H.SPECIAL_HANDLING_XML.value(''(//SH/WebVerification)[1]'', ''varchar(50)'') is NULL)
           Group by L.CODE_TX, L.NAME_TX
            UNION
           Select L.CODE_TX as LENDER_CODE, L.NAME_TX AS LENDER_NAME, ''Web Verification'' as TYPE_CD,COUNT(*) as TXN_COUNT
           from INTERACTION_HISTORY H
           join PROPERTY P on P.ID = H.PROPERTY_ID AND P.PURGE_DT IS NULL
           Join LENDER L on L.ID = P.LENDER_ID AND L.CODE_TX = ''5350''
           where H.TYPE_CD = ''OUTBNDCALL'' and H.PROPERTY_ID IS NOT NULL and H.CREATE_DT >= DateAdd(month,-1,getdate())  and H.PURGE_DT is NULL and H.SPECIAL_HANDLING_XML.value(''(//SH/WebVerification)[1]'', ''varchar(50)'') = ''Y''
           Group by L.CODE_TX, L.NAME_TX
            UNION
           Select L.CODE_TX as LENDER_CODE, L.NAME_TX AS LENDER_NAME, ''Web Verification'' as TYPE_CD,COUNT(*) as TXN_COUNT
           from INTERACTION_HISTORY H
           join LOAN LN on LN.ID = H.LOAN_ID AND LN.PURGE_DT IS NULL
           Join LENDER L on L.ID = LN.LENDER_ID AND L.CODE_TX = ''5350''
           where H.TYPE_CD = ''OUTBNDCALL'' and H.LOAN_ID IS NOT NULL and H.CREATE_DT >= DateAdd(month,-1,getdate())  and H.PURGE_DT is NULL and H.SPECIAL_HANDLING_XML.value(''(//SH/WebVerification)[1]'', ''varchar(50)'') = ''Y''
           Group by L.CODE_TX,L.NAME_TX
             UNION
           Select L.CODE_TX as LENDER_CODE, L.NAME_TX AS LENDER_NAME, ''Web Verification'' as TYPE_CD,COUNT(*) as TXN_COUNT
           from DOCUMENT_CONTAINER D
           Join NOTICE N on N.ID = D.RELATE_ID and D.RELATE_CLASS_NAME_TX = ''Allied.UniTrac.Notice''
           Join LOAN LN on LN.ID = N.LOAN_ID
           Join LENDER L on L.ID = LN.LENDER_ID AND L.CODE_TX  in (''3400'', ''1771'', ''4286'', ''4035'', ''012800'', ''13100'', ''5350'' )
           where D.CREATE_DT >= DateAdd(month,-1,getdate())  and D.REJECT_REASON_TX = ''VerifiedCoverageWeb''
           Group by L.CODE_TX, L.NAME_TX
              </SQLStatement>
	</SourceData>
	<CacheData target="DatasourceCache" replace="true">
		<MapEntry SourceColumn="LENDER_CODE" TargetColumn="ASSOCIATION_CD"/>
		<MapEntry SourceColumn="LENDER_NAME" TargetColumn="ASSOCIATION_NAME_TX"/>
		<MapEntry SourceColumn="TYPE_CD" TargetColumn="TYPE_CD"/>
		<MapEntry SourceColumn="TXN_COUNT" TargetColumn="COUNT_NO"/>
	</CacheData>
</DatasourceSettings>'
   ,'<Cache>
      <Parameter>
         <Get id="GetCacheData">
            <Param Name="ParamName" SourceIdentifier="DataTableColumnName" DataType="System.String" DefaultValue="UNINSURED_LOANCNT_BYDIV_BYCOVSTATUS" />
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
		ACTIVE_IN					 = DATASOURCE_MERGE.ACTIVE_IN,
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


