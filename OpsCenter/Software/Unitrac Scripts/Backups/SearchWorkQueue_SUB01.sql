USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[SearchWorkQueue]    Script Date: 11/18/2015 5:55:10 PM ******/
DROP PROCEDURE [dbo].[SearchWorkQueue]
GO

/****** Object:  StoredProcedure [dbo].[SearchWorkQueue]    Script Date: 11/18/2015 5:55:10 PM ******/
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

	declare @tpTrackingSourceDefId bigint
	
	select @tpTrackingSourceDefId = Id
	from RELATED_DATA_DEF
	where RELATE_CLASS_NM = 'TradingPartner' and NAME_TX = 'TrackingSource'				
	
   --VUT Tracking Source TP
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
			 CONVERT(VARCHAR(10),wia.CREATE_DT, 101) AS 'DateOfLastAction',
			 tp.NAME_TX AS 'Lender',
			 tp.EXTERNAL_ID_TX AS 'Loan',
			 rd7.VALUE_TX as 'LoanType',
			 'HotWatch' =
			 CASE
				WHEN rd8.VALUE_TX = 1 
				THEN 'Y' 
				ELSE '' 
				END
			 ,rd13.VALUE_TX as 'FileAlert'
		    ,'Highlight1' =
			CASE 
				  WHEN DATEDIFF(day, convert(varchar(20),convert(datetime,rd9.VALUE_TX),101), GETDATE()) > isNull(rd10.VALUE_TX,15) - 1 THEN 
				  'Y'
				  ELSE
					  'N'
				  END
		   ,'Highlight2' =
			   CASE 
				   WHEN DATEDIFF(day, convert(varchar(20),convert(datetime,rd9.VALUE_TX),101), GETDATE()) > isNull(rd11.VALUE_TX,2) - 1 and
				   convert(varchar(20),convert(datetime,rd6.VALUE_TX),101) < convert(varchar(20),convert(datetime,rd9.VALUE_TX),101)
				THEN 
					   'Y'
				   ELSE
					   'N'
				   END
		 ,'Highlight3' =
			   CASE 
				   WHEN DATEDIFF(day, convert(varchar(20),convert(datetime,rd6.VALUE_TX),101), GETDATE()) > isNull(rd12.VALUE_TX,5) - 1 THEN 
				  'Y'
				   ELSE
					   'N'
				   END,
	   wq.ID as 'CurrentQueueId'
      ,'Import' as 'FileType' --VUT only had extracts
	  , wi.CONTENT_XML.value('(/Content/Lender/NextCycleDate)[1]','datetime') as NextCycleDate
	FROM WORK_ITEM AS wi
		left outer join WORK_QUEUE wq ON wi.CURRENT_QUEUE_ID = wq.ID
		left outer join WORKFLOW_DEFINITION wd ON wi.WORKFLOW_DEFINITION_ID = wd.ID
		left outer join WORK_ITEM_ACTION wia ON wi.LAST_WORK_ITEM_ACTION_ID = wia.ID
		left outer join USERS u ON wi.CURRENT_OWNER_ID = u.ID
		left outer join REF_CODE rc ON (rc.DOMAIN_CD = 'ExtractWorkItemStatus' and rc.CODE_CD = wi.STATUS_CD)
		left outer join MESSAGE m on (wi.RELATE_ID = m.ID and wi.RELATE_TYPE_CD = 'LDHLib.Message')
		left outer join (select tp1.* 
                        from TRADING_PARTNER tp1 
                           left outer join RELATED_DATA rd0 ON rd0.DEF_ID = @tpTrackingSourceDefId and rd0.RELATE_ID = tp1.ID
                        where rd0.VALUE_TX is null or rd0.VALUE_TX = 'Vut') tp
                  ON tp.ID = m.RECEIVED_FROM_TRADING_PARTNER_ID
		left outer join RELATED_DATA_DEF rdd6 ON (rdd6.RELATE_CLASS_NM = 'DeliveryInfo' and rdd6.NAME_TX = 'LastMsgImported')
		left outer join RELATED_DATA rd6 ON (rd6.DEF_ID = rdd6.ID and rd6.RELATE_ID = m.DELIVERY_INFO_ID)
		left outer join DELIVERY_INFO di ON (di.ID = m.DELIVERY_INFO_ID)
		left outer join RELATED_DATA_DEF rdd7 ON (rdd7.RELATE_CLASS_NM = 'LenderExtractWorkItem' and rdd7.NAME_TX = 'DeliveryInfoDocType')
		left outer join RELATED_DATA rd7 ON (rd7.DEF_ID = rdd7.ID and rd7.RELATE_ID = wi.ID)
	   LEFT OUTER JOIN RELATED_DATA_DEF rdd8 ON (rdd8.RELATE_CLASS_NM = 'DeliveryInfo' and rdd8.NAME_TX = 'HotWatch')
		LEFT OUTER JOIN RELATED_DATA rd8 ON (rd8.DEF_ID = rdd8.ID and rd8.RELATE_ID = m.DELIVERY_INFO_ID)
	  
	  LEFT OUTER JOIN RELATED_DATA_DEF rdd9 ON (rdd9.RELATE_CLASS_NM = 'DeliveryInfo' and rdd9.NAME_TX = 'LastMsgReceived')
	  LEFT OUTER JOIN RELATED_DATA rd9 ON (rd9.DEF_ID = rdd9.ID and rd9.RELATE_ID=m.DELIVERY_INFO_ID)  

	  LEFT OUTER JOIN RELATED_DATA_DEF rdd10 ON (rdd10.RELATE_CLASS_NM = 'DeliveryInfo' and rdd10.NAME_TX = 'LateFileMaint')
	  LEFT OUTER JOIN RELATED_DATA rd10 ON (rd10.DEF_ID = rdd10.ID and rd10.RELATE_ID=m.DELIVERY_INFO_ID) 
		
	  LEFT OUTER JOIN RELATED_DATA_DEF rdd11 ON (rdd11.RELATE_CLASS_NM = 'DeliveryInfo' and rdd11.NAME_TX = 'LateImported')
	  LEFT OUTER JOIN RELATED_DATA rd11 ON (rd11.DEF_ID = rdd11.ID and rd11.RELATE_ID=m.DELIVERY_INFO_ID)   

	  LEFT OUTER JOIN RELATED_DATA_DEF rdd12 ON (rdd12.RELATE_CLASS_NM = 'DeliveryInfo' and rdd12.NAME_TX = 'LateDataMaint')
	  LEFT OUTER JOIN RELATED_DATA rd12 ON (rd12.DEF_ID = rdd12.ID and rd12.RELATE_ID=m.DELIVERY_INFO_ID)   

	  LEFT OUTER JOIN RELATED_DATA_DEF rdd13 ON (rdd13.RELATE_CLASS_NM = 'DeliveryInfo' and rdd12.NAME_TX = 'FileAlert')
	  LEFT OUTER JOIN RELATED_DATA rd13 ON (rd13.DEF_ID = rdd13.ID and rd13.RELATE_ID=m.DELIVERY_INFO_ID)   

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
    and (@lateCyclesOnly = 0 or DATEDIFF(day, wi.CONTENT_XML.value('(/Content/Lender/NextCycleDate)[1]','datetime') , GETDATE()) >= 0 )
	 
	 UNION

    --UniTrac Tracking Source TP
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
			 CONVERT(VARCHAR(10),wia.CREATE_DT, 101) AS 'DateOfLastAction',
			 tp.NAME_TX AS 'Lender',
			 tp.EXTERNAL_ID_TX AS 'Loan',
			 --rd7.VALUE_TX as 'LoanType',
          div.name_tx as 'LoanType',
			 'HotWatch' =
			 CASE
				WHEN rd8.VALUE_TX = 1 
				THEN 'Y' 
				ELSE '' 
				END
			, rd14.VALUE_TX as 'FileAlert'
		   ,'Highlight1' =
			CASE 
				  WHEN DATEDIFF(day, convert(varchar(20),convert(datetime,rd9.VALUE_TX),101), GETDATE()) > isNull(rd10.VALUE_TX,15) - 1 THEN 
				  'Y'
				  ELSE
					  'N'
				  END
		   ,'Highlight2' =
			   CASE 
				   WHEN DATEDIFF(day, convert(varchar(20),convert(datetime,rd9.VALUE_TX),101), GETDATE()) > isNull(rd11.VALUE_TX,2) - 1 and
				   convert(varchar(20),convert(datetime,rd6.VALUE_TX),101) < convert(varchar(20),convert(datetime,rd9.VALUE_TX),101)
				THEN 
					   'Y'
				   ELSE
					   'N'
				   END
		 ,'Highlight3' =
			   CASE 
				   WHEN DATEDIFF(day, convert(varchar(20),convert(datetime,rd6.VALUE_TX),101), GETDATE()) > isNull(rd12.VALUE_TX,5) - 1 THEN 
				  'Y'
				   ELSE
					   'N'
				   END,
	   wq.ID as 'CurrentQueueId'
      ,rc13.meaning_tx as 'FileType'
	  , wi.CONTENT_XML.value('(/Content/Lender/NextCycleDate)[1]','datetime') as NextCycleDate
	FROM WORK_ITEM AS wi
		left outer join WORK_QUEUE wq ON wi.CURRENT_QUEUE_ID = wq.ID
		left outer join WORKFLOW_DEFINITION wd ON wi.WORKFLOW_DEFINITION_ID = wd.ID
		left outer join WORK_ITEM_ACTION wia ON wi.LAST_WORK_ITEM_ACTION_ID = wia.ID
		left outer join USERS u ON wi.CURRENT_OWNER_ID = u.ID
		left outer join REF_CODE rc ON (rc.DOMAIN_CD = 'ExtractWorkItemStatus' and rc.CODE_CD = wi.STATUS_CD)
		left outer join MESSAGE m on (wi.RELATE_ID = m.ID and wi.RELATE_TYPE_CD = 'LDHLib.Message')
      left outer join  related_data rd0 on m.id = rd0.relate_id and rd0.def_id = (select id from related_data_def rdd0 where rdd0.RELATE_CLASS_NM = 'Message' and rdd0.NAME_TX = 'ExtractConfiguration')
      left outer join VUT.dbo.tblLenderExtract le on rd0.value_tx = le.LenderExtractKey
      left outer join lender_organization div on le.contracttypekey = div.id
		left outer join (select tp1.* 
                        from TRADING_PARTNER tp1 
                           left outer join RELATED_DATA rd0 ON rd0.DEF_ID = @tpTrackingSourceDefId and rd0.RELATE_ID = tp1.ID
                        where rd0.VALUE_TX is not null and rd0.VALUE_TX = 'Unitrac') tp 
                  ON tp.ID = m.RECEIVED_FROM_TRADING_PARTNER_ID
		left outer join RELATED_DATA_DEF rdd6 ON (rdd6.RELATE_CLASS_NM = 'DeliveryInfo' and rdd6.NAME_TX = 'LastMsgImported')
		left outer join RELATED_DATA rd6 ON (rd6.DEF_ID = rdd6.ID and rd6.RELATE_ID = m.DELIVERY_INFO_ID)
		left outer join DELIVERY_INFO di ON (di.ID = m.DELIVERY_INFO_ID)
		left outer join RELATED_DATA_DEF rdd7 ON (rdd7.RELATE_CLASS_NM = 'LenderExtractWorkItem' and rdd7.NAME_TX = 'DeliveryInfoDocType')
		left outer join RELATED_DATA rd7 ON (rd7.DEF_ID = rdd7.ID and rd7.RELATE_ID = wi.ID)
	   LEFT OUTER JOIN RELATED_DATA_DEF rdd8 ON (rdd8.RELATE_CLASS_NM = 'DeliveryInfo' and rdd8.NAME_TX = 'HotWatch')
		LEFT OUTER JOIN RELATED_DATA rd8 ON (rd8.DEF_ID = rdd8.ID and rd8.RELATE_ID = m.DELIVERY_INFO_ID)
	  
	  LEFT OUTER JOIN RELATED_DATA_DEF rdd9 ON (rdd9.RELATE_CLASS_NM = 'DeliveryInfo' and rdd9.NAME_TX = 'LastMsgReceived')
	  LEFT OUTER JOIN RELATED_DATA rd9 ON (rd9.DEF_ID = rdd9.ID and rd9.RELATE_ID=m.DELIVERY_INFO_ID)  

	  LEFT OUTER JOIN RELATED_DATA_DEF rdd10 ON (rdd10.RELATE_CLASS_NM = 'DeliveryInfo' and rdd10.NAME_TX = 'LateFileMaint')
	  LEFT OUTER JOIN RELATED_DATA rd10 ON (rd10.DEF_ID = rdd10.ID and rd10.RELATE_ID=m.DELIVERY_INFO_ID) 
		
	  LEFT OUTER JOIN RELATED_DATA_DEF rdd11 ON (rdd11.RELATE_CLASS_NM = 'DeliveryInfo' and rdd11.NAME_TX = 'LateImported')
	  LEFT OUTER JOIN RELATED_DATA rd11 ON (rd11.DEF_ID = rdd11.ID and rd11.RELATE_ID=m.DELIVERY_INFO_ID)   

	  LEFT OUTER JOIN RELATED_DATA_DEF rdd12 ON (rdd12.RELATE_CLASS_NM = 'DeliveryInfo' and rdd12.NAME_TX = 'LateDataMaint')
	  LEFT OUTER JOIN RELATED_DATA rd12 ON (rd12.DEF_ID = rdd12.ID and rd12.RELATE_ID=m.DELIVERY_INFO_ID)   

      LEFT OUTER JOIN RELATED_DATA_DEF rdd13	ON (rdd13.RELATE_CLASS_NM = 'DeliveryInfo' and rdd13.NAME_TX = 'UniTracDeliveryType')
		LEFT OUTER JOIN RELATED_DATA rd13		ON (rd13.DEF_ID = rdd13.ID and rd13.RELATE_ID = di.ID)
      LEFT OUTER JOIN REF_CODE rc13				on (rc13.DOMAIN_CD = 'DeliveryType' and rc13.CODE_CD = rd13.value_tx and rc13.active_in = 'Y' and rc13.purge_dt is null)

	  LEFT OUTER JOIN RELATED_DATA_DEF rdd14 ON (rdd14.RELATE_CLASS_NM = 'DeliveryInfo' and rdd14.NAME_TX = 'FileAlert')
	  LEFT OUTER JOIN RELATED_DATA rd14 ON (rd14.DEF_ID = rdd14.ID and rd14.RELATE_ID=m.DELIVERY_INFO_ID)   

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
    and (@lateCyclesOnly = 0 or DATEDIFF(day, wi.CONTENT_XML.value('(/Content/Lender/NextCycleDate)[1]','datetime') , GETDATE()) >= 0 )

    UNION
	 
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
			 CONVERT(VARCHAR(10),wia.CREATE_DT, 101) AS 'DateOfLastAction',
			 T1.LenderName.value('text()[1]', 'VARCHAR(40)') 'Lender',
			 T2.LenderCode.value('text()[1]', 'VARCHAR(10)')  AS 'Loan',
			 '' 'LoanType',
			 '' HotWatch,
			 '' FileAlert,
		     '' Highlight1,			
		     '' Highlight2,
			 '' Highlight3,
	   wq.ID as 'CurrentQueueId'
      ,'' as 'FileType'			   
	  , wi.CONTENT_XML.value('(/Content/Lender/NextCycleDate)[1]','datetime') as NextCycleDate
	FROM WORK_ITEM AS wi
		left outer join WORK_QUEUE wq ON wi.CURRENT_QUEUE_ID = wq.ID
		left outer join WORKFLOW_DEFINITION wd ON wi.WORKFLOW_DEFINITION_ID = wd.ID
		left outer join WORK_ITEM_ACTION wia ON wi.LAST_WORK_ITEM_ACTION_ID = wia.ID
		left outer join USERS u ON wi.CURRENT_OWNER_ID = u.ID
		left outer join REF_CODE rc ON (rc.DOMAIN_CD = 'ExtractWorkItemStatus' and rc.CODE_CD = wi.STATUS_CD)
		OUTER APPLY wi.CONTENT_XML.nodes('/Content/Lender/Name') AS T1(LenderName)
		OUTER APPLY wi.CONTENT_XML.nodes('/Content/Lender/Code') AS T2(LenderCode)
	 WHERE wi.PURGE_DT is NULL
	 and (@lenderCode is null or T2.LenderCode.value('text()[1]', 'VARCHAR(10)') = @lenderCode)
	 and (@queueId is null or wq.ID = @queueId)
	 and (@workflowId is null or wd.ID = @workflowId)
	 and (@userId is null or u.ID = @userId)
	 and (@statusCd is null or rc.CODE_CD = @statusCd)
	 and (@lastActionCd is null or wia.ACTION_CD = @lastActionCd)
	 and (@queueAge is null or DATEDIFF(day, wi.CREATE_DT, GETDATE()) <= @queueAge)
	 and (@actionAge is null or DATEDIFF(day, wia.CREATE_DT, GETDATE()) <= @actionAge)
	 and (@excludeComplete = 0 or wi.status_cd not in ( 'Complete') )
    and (@excludeWithdrawn = 0 or wi.status_cd not in ( 'Withdrawn' ) )
    and (@lateCyclesOnly = 0 or DATEDIFF(day, wi.CONTENT_XML.value('(/Content/Lender/NextCycleDate)[1]','datetime') , GETDATE()) >= 0 )
    and wd.WORKFLOW_TYPE_CD <> 'LenderExtract'
END

GO

