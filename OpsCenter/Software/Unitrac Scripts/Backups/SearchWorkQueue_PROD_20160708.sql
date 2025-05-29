USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[SearchWorkQueue]    Script Date: 7/8/2016 12:44:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SearchWorkQueue]
(
	@id bigint = null, --LenderId
	@lenderCode nvarchar(100) = NULL,
	@queueId bigint = NULL,
	@workflowId bigint = NULL,
	@userId bigint = NULL,
	@statusCd nvarchar(30) = NULL,
	@lastActionCd nvarchar(30) = NULL,
	@queueAge int = NULL,
	@actionAge int = NULL, 
   @excludeComplete int = 0,
   @excludeWithdrawn int = 0,
   @lateCyclesOnly int = 0
)
AS
BEGIN
	  
	SET NOCOUNT ON
	
	-- WorkQueue search page will send TradingPartnerId instead of LenderId 
	IF  @id = 0
		SET @id = NULL

	create table #tmp
	(
		ID bigint,
		CreateDate datetime,
		Owner nvarchar(100) null,
		Workflow nvarchar(100),
		Status nvarchar(50),
		StatusColor nvarchar(30),
		CurrentQueue nvarchar(100),
		QueueAge float,
		ActionAge float,
		LastAction nvarchar(30),
		DateOfLastAction datetime,
		Lender nvarchar(100),
		Loan nvarchar(30),
		LoanType nvarchar(100),
		HotWatch nvarchar(30),
		FileAlert nvarchar(30),
		Highlight1 nvarchar(30),
		Highlight2 nvarchar(30),
		Highlight3 nvarchar(30),
		CurrentQueueId bigint,
		FileType nvarchar(30),
		NextCycleDate datetime
	)
	
	if @workflowId = 1 or @workflowId = 13 or @workflowId is null
	begin

		declare @extractConfigDefId bigint
		select @extractConfigDefId = Id from related_data_def rdd0 where rdd0.RELATE_CLASS_NM = 'Message' and rdd0.NAME_TX = 'ExtractConfiguration'

		declare @lastMsgImportedDefId bigint
		select @lastMsgImportedDefId = id from related_data_DEF rdd6 where (rdd6.RELATE_CLASS_NM = 'DeliveryInfo' and rdd6.NAME_TX = 'LastMsgImported')

		declare @deliveryInfoDocTypeDefId bigint
		select @deliveryInfoDocTypeDefId = id from RELATED_DATA_DEF rdd7 where rdd7.RELATE_CLASS_NM = 'LenderExtractWorkItem' and rdd7.NAME_TX = 'DeliveryInfoDocType'

		declare @hotWatchDefId bigint
		select @hotWatchDefId = id from RELATED_DATA_DEF rdd8 where rdd8.RELATE_CLASS_NM = 'DeliveryInfo' and rdd8.NAME_TX = 'HotWatch'

		declare @lastMsgReceivedDefId bigint
		select @lastMsgReceivedDefId = id from RELATED_DATA_DEF rdd9 where rdd9.RELATE_CLASS_NM = 'DeliveryInfo' and rdd9.NAME_TX = 'LastMsgReceived'

		declare @lateFileMaintDefId bigint
		select @lateFileMaintDefId = id from RELATED_DATA_DEF rdd10 where rdd10.RELATE_CLASS_NM = 'DeliveryInfo' and rdd10.NAME_TX = 'LateFileMaint'

		declare @lateImportedDefId bigint
		select @lateImportedDefId = id from RELATED_DATA_DEF rdd11 where rdd11.RELATE_CLASS_NM = 'DeliveryInfo' and rdd11.NAME_TX = 'LateImported'

		declare @lateDataMaintDefId bigint
		select @lateDataMaintDefId = id from RELATED_DATA_DEF rdd12 where rdd12.RELATE_CLASS_NM = 'DeliveryInfo' and rdd12.NAME_TX = 'LateDataMaint'

		declare @unitracDeliveryTypeDefId bigint
		select @unitracDeliveryTypeDefId = id from RELATED_DATA_DEF rdd13 where rdd13.RELATE_CLASS_NM = 'DeliveryInfo' and rdd13.NAME_TX = 'UniTracDeliveryType'

		declare @fileAlertDefId bigint
		select @fileAlertDefId = id from RELATED_DATA_DEF rdd14 where rdd14.RELATE_CLASS_NM = 'DeliveryInfo' and rdd14.NAME_TX = 'FileAlert'

		--UniTrac Tracking Source TP
		insert into #tmp
		SELECT  
			wi.ID,
			wi.CREATE_DT AS 'CreateDate', 
			u.FAMILY_NAME_TX + ', ' + u.GIVEN_NAME_TX AS 'Owner', 
			wd.DESCRIPTION_TX AS 'Workflow', 
			rc.MEANING_TX AS 'Status',
			wi.STATUS_CD as 'StatusColor',
			wq.DESCRIPTION_TX AS 'CurrentQueue',
			'QueueAge' = CEILING(CAST((GETDATE() - wi.CREATE_DT) as Float)),
			'ActionAge' = CEILING(CAST((GETDATE() - wia.CREATE_DT) as Float)),
			wia.ACTION_CD AS 'LastAction',
			CONVERT(VARCHAR(10),isnull(wia.CREATE_DT, '1/1/1900'), 101) AS 'DateOfLastAction',
			tp.NAME_TX AS 'Lender',
			tp.EXTERNAL_ID_TX AS 'Loan',
			div.name_tx as 'LoanType',
			'HotWatch' =
				 CASE
					WHEN rd8.VALUE_TX = 1 
					THEN 'Y' 
					ELSE '' 
					END
				, rd14.VALUE_TX as 'FileAlert'
			   ,
			'Highlight1' =
				CASE 
					  WHEN DATEDIFF(day, convert(varchar(20),convert(datetime,rd9.VALUE_TX),101), GETDATE()) > isNull(rd10.VALUE_TX,15) - 1 THEN 
					  'Y'
					  ELSE
						  'N'
					  END
			   ,
			'Highlight2' =
				   CASE 
					   WHEN DATEDIFF(day, convert(varchar(20),convert(datetime,rd9.VALUE_TX),101), GETDATE()) > isNull(rd11.VALUE_TX,2) - 1 and
					   convert(varchar(20),convert(datetime,rd6.VALUE_TX),101) < convert(varchar(20),convert(datetime,rd9.VALUE_TX),101)
					THEN 
						   'Y'
					   ELSE
						   'N'
					   END
			 ,
			'Highlight3' =
				   CASE 
					   WHEN DATEDIFF(day, convert(varchar(20),convert(datetime,rd6.VALUE_TX),101), GETDATE()) > isNull(rd12.VALUE_TX,5) - 1 THEN 
					  'Y'
					   ELSE
						   'N'
					   END,
			wq.ID as 'CurrentQueueId',
			rc13.meaning_tx as 'FileType', 
			wi.CONTENT_XML.value('(/Content/Lender/NextCycleDate)[1]','datetime') as NextCycleDate
		FROM 
			WORK_ITEM AS wi
			left outer join WORK_QUEUE wq ON wi.CURRENT_QUEUE_ID = wq.ID
			left outer join WORKFLOW_DEFINITION wd ON wi.WORKFLOW_DEFINITION_ID = wd.ID
			left outer join WORK_ITEM_ACTION wia ON wi.LAST_WORK_ITEM_ACTION_ID = wia.ID
			left outer join USERS u ON wi.CURRENT_OWNER_ID = u.ID
			left outer join REF_CODE rc ON (rc.DOMAIN_CD = 'ExtractWorkItemStatus' and rc.CODE_CD = wi.STATUS_CD)
			left outer join MESSAGE m on (wi.RELATE_ID = m.ID and wi.RELATE_TYPE_CD = 'LDHLib.Message')
			left outer join  related_data rd0 on m.id = rd0.relate_id and rd0.def_id = @extractConfigDefId
			left outer join VUT.dbo.tblLenderExtract le on rd0.value_tx = le.LenderExtractKey
			left outer join lender_organization div on le.contracttypekey = div.id
			left outer join TRADING_PARTNER tp ON tp.ID = m.RECEIVED_FROM_TRADING_PARTNER_ID
			left outer join RELATED_DATA rd6 ON (rd6.DEF_ID = @lastMsgImportedDefId and rd6.RELATE_ID = m.DELIVERY_INFO_ID)
			left outer join DELIVERY_INFO di ON (di.ID = m.DELIVERY_INFO_ID)
			left outer join RELATED_DATA rd7 ON (rd7.DEF_ID = @deliveryInfoDocTypeDefId and rd7.RELATE_ID = wi.ID)
			LEFT OUTER JOIN RELATED_DATA rd8 ON (rd8.DEF_ID = @hotWatchDefId and rd8.RELATE_ID = m.DELIVERY_INFO_ID)
			LEFT OUTER JOIN RELATED_DATA rd9 ON (rd9.DEF_ID = @lastMsgReceivedDefId and rd9.RELATE_ID=m.DELIVERY_INFO_ID)  
			LEFT OUTER JOIN RELATED_DATA rd10 ON (rd10.DEF_ID = @lateFileMaintDefId and rd10.RELATE_ID=m.DELIVERY_INFO_ID) 
			LEFT OUTER JOIN RELATED_DATA rd11 ON (rd11.DEF_ID = @lateImportedDefId and rd11.RELATE_ID=m.DELIVERY_INFO_ID)   
			LEFT OUTER JOIN RELATED_DATA rd12 ON (rd12.DEF_ID = @lateDataMaintDefId and rd12.RELATE_ID=m.DELIVERY_INFO_ID)   
			LEFT OUTER JOIN RELATED_DATA rd13		ON (rd13.DEF_ID = @unitracDeliveryTypeDefId and rd13.RELATE_ID = di.ID)
			LEFT OUTER JOIN REF_CODE rc13				on (rc13.DOMAIN_CD = 'DeliveryType' and rc13.CODE_CD = rd13.value_tx and rc13.active_in = 'Y' and rc13.purge_dt is null)
			LEFT OUTER JOIN RELATED_DATA rd14 ON (rd14.DEF_ID = @fileAlertDefId and rd14.RELATE_ID=m.DELIVERY_INFO_ID)   
		 WHERE wi.PURGE_DT is NULL
		 and (@lenderCode is null or tp.EXTERNAL_ID_TX = @lenderCode)
		 and (tp.ID = ISNULL(@id, tp.ID))
		 and (tp.TYPE_CD = 'LFP_TP')
		 and (@queueId is null or wq.ID = @queueId)
		 and (@workflowId is null or wd.ID = @workflowId)
		 and (@userId is null or u.ID = @userId)
		 and (@statusCd is null or rc.CODE_CD = @statusCd)
		 and (@lastActionCd is null or wia.ACTION_CD = @lastActionCd)
		 and (@queueAge is null or DATEDIFF(day, wi.CREATE_DT, GETDATE()) <= @queueAge)
		 and (@actionAge is null or DATEDIFF(day, wia.CREATE_DT, GETDATE()) <= @actionAge)
		 and (@excludeComplete = 0 or wi.status_cd not in ( 'Complete') )
		and (@excludeWithdrawn = 0 or wi.status_cd not in ( 'Withdrawn' ) )
		--and (@lateCyclesOnly = 0 or DATEDIFF(day, wi.CONTENT_XML.value('(/Content/Lender/NextCycleDate)[1]','datetime') , GETDATE()) >= 0 )

	end

	if @workflowId not in ( 1, 13 )  or @workflowId is null
	begin

--	UNION
		declare @lenderId bigint
		if @lenderCode is not null
			select @lenderId = id from lender where code_tx = @lenderCode
		else
			set @lenderId = null

		insert into #tmp	 
		SELECT  wi.ID,
			wi.CREATE_DT AS 'CreateDate', 
			u.FAMILY_NAME_TX + ', ' + u.GIVEN_NAME_TX AS 'Owner', 
			wd.DESCRIPTION_TX AS 'Workflow', 
			rc.MEANING_TX AS 'Status',
			wi.STATUS_CD as 'StatusColor',
			wq.DESCRIPTION_TX AS 'CurrentQueue',
			'QueueAge' = CEILING(CAST((GETDATE() - wi.CREATE_DT) as Float)),
			'ActionAge' = CEILING(CAST((GETDATE() - wia.CREATE_DT) as Float)),
			wia.ACTION_CD AS 'LastAction',
			CONVERT(VARCHAR(10),isnull(wia.CREATE_DT, '1/1/1900'), 101) AS 'DateOfLastAction',
			ldr.NAME_TX as 'Lender',
			ldr.CODE_TX  AS 'Loan',
			'' 'LoanType',
			'' HotWatch,
			'' FileAlert,
			'' Highlight1,			
			'' Highlight2,
			'' Highlight3,
			wq.ID as 'CurrentQueueId',
			'' as 'FileType',
			wi.CONTENT_XML.value('(/Content/Lender/NextCycleDate)[1]','datetime') as NextCycleDate
		FROM 
			WORK_ITEM AS wi
			JOIN LENDER LDR ON LDR.ID = @lenderId
			left outer join WORK_QUEUE wq ON wi.CURRENT_QUEUE_ID = wq.ID
			left outer join WORKFLOW_DEFINITION wd ON wi.WORKFLOW_DEFINITION_ID = wd.ID
			left outer join WORK_ITEM_ACTION wia ON wi.LAST_WORK_ITEM_ACTION_ID = wia.ID
			left outer join USERS u ON wi.CURRENT_OWNER_ID = u.ID
			left outer join REF_CODE rc ON (rc.DOMAIN_CD = 'ExtractWorkItemStatus' and rc.CODE_CD = wi.STATUS_CD)
			OUTER APPLY wi.CONTENT_XML.nodes('/Content/Lender') AS T(Lender)
		WHERE 
			wi.PURGE_DT is NULL
			and (@lenderId is null or T.Lender.value('(./Id)[1]', 'bigint') = @lenderId)
			and (@queueId is null or wq.ID = @queueId)
			and (@workflowId is null or wd.ID = @workflowId)
			and (@userId is null or u.ID = @userId)
			and (@statusCd is null or rc.CODE_CD = @statusCd)
			and (@lastActionCd is null or wia.ACTION_CD = @lastActionCd)
			and (@queueAge is null or DATEDIFF(day, wi.CREATE_DT, GETDATE()) <= @queueAge)
			and (@actionAge is null or DATEDIFF(day, wia.CREATE_DT, GETDATE()) <= @actionAge)
			and (@excludeComplete = 0 or wi.status_cd not in ( 'Complete') )
			and (@excludeWithdrawn = 0 or wi.status_cd not in ( 'Withdrawn' ) )
			--and (@lateCyclesOnly = 0 or DATEDIFF(day, wi.CONTENT_XML.value('(/Content/Lender/NextCycleDate)[1]','datetime') , GETDATE()) >= 0 )
			and wd.id not in (1,13)
	end

		select * from #tmp order by workflow
		
END

GO

