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
      150 AS ID
      , '30 Day Processed Document Transaction Count by Branch'
      ,NULL
      ,'30DAY_DOCUMENT_TRANCNT_BYDIV_BYBRCH'
      ,'4HOUR'   
      ,'<DatasourceSettings>
	<SourceData type="StoredProcedure">
		<ConnectionDescriptor>UNITRAC</ConnectionDescriptor>
		<SQLStatement>
		30DayDocumentCount
	</SQLStatement>
	</SourceData>
	<CacheData target="DatasourceCache" replace="true">
		<MapEntry SourceColumn="LENDER_CD" TargetColumn="ASSOCIATION_CD"/>
		<MapEntry SourceColumn="LENDER_NAME" TargetColumn="ASSOCIATION_NAME_TX"/>
		<MapEntry SourceColumn="HOURS_TO_WORK" TargetColumn="STATUS_CD"/>
		<MapEntry SourceColumn="TXN_COUNT" TargetColumn="COUNT_NO"/>
	</CacheData>
</DatasourceSettings>'
   ,'<Cache>
      <Parameter>
		 <Param name="lenderCodes" value="3400,1771,4286,4035,012800,13100,5350"/>
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


