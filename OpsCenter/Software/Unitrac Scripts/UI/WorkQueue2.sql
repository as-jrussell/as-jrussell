USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[GetWorkQueue]    Script Date: 1/18/2016 8:54:45 AM ******/
DROP PROCEDURE [dbo].[GetWorkQueue]
GO

/****** Object:  StoredProcedure [dbo].[GetWorkQueue]    Script Date: 1/18/2016 8:54:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetWorkQueue](@id   bigint = null,
									  @name nvarchar(30) = null,
									  @statusCd nvarchar(20) = null,
									  @filterUserId bigint = null,
									  @filterLenderId bigint = null,
									  @filterWorkItemType varchar(50) = null, 
                             @ignoreWorkItemType varchar(50) = null,
                             @includeInactive char(1) = null,
                             @includeWebEnabled char(1) = null,
							 @userId bigint = null )
AS
BEGIN
   SET NOCOUNT ON
   if @id = 0
      set @id = null
   if @filterUserId = 0
      set @filterUserId = null
   if @filterLenderId = 0
      set @filterLenderId = null
   if @name is not null
	  set @name = @name+'%'
   if @ignoreWorkItemType is null
     set @ignoreWorkItemType = ''
   if @includeInactive is null
      set @includeInactive = 'N';
  
         
	if @id is not null
	BEGIN
		  SELECT
			(SELECT SETTINGS_XML.value('(/WorkFlowDefinitionSettings/WorkQueueSettings/BaseType)[1]','varchar(100)') FROM WORKFLOW_DEFINITION WHERE ID = WORKFLOW_DEFINITION_ID),
			 ID,
			 NAME_TX,
			 ACTIVE_IN,
			 DESCRIPTION_TX,
			 STATUS_CD,
			 CREATE_DT,
			 UPDATE_DT,
			 PURGE_DT,
			 UPDATE_USER_TX,
			 LOCK_ID,
			 EXCLUSIVE_IN,
			 EVALUATION_ORDER_NO,
			 FILTER_XML,
			 WORK_ORDER_XML,
			 SLA_DEFINITION_XML,
			 ASSIGNABLE_QUEUE_XML,
			 WORKFLOW_DEFINITION_ID,
			 WEB_IN
		  FROM WORK_QUEUE (nolock)
		  WHERE
			 ID = @id

		  RETURN
	END


    DECLARE @tempWQs TABLE
   (
		 BaseType varchar(100),
		 ID bigint,
         NAME_TX nvarchar(30),
         ACTIVE_IN char(1),
         DESCRIPTION_TX nvarchar(80),
         STATUS_CD nvarchar(20),
         CREATE_DT datetime,
         UPDATE_DT datetime,
         PURGE_DT datetime,
         UPDATE_USER_TX nvarchar(15),
         LOCK_ID tinyint,
		 EXCLUSIVE_IN char(1),
		 EVALUATION_ORDER_NO decimal(10,2),
		 FILTER_XML xml,
		 WORK_ORDER_XML xml,
		 SLA_DEFINITION_XML xml,
		 ASSIGNABLE_QUEUE_XML xml,
		 WORKFLOW_DEFINITION_ID bigint,
		 WEB_IN char(1)
   )

    if (@filterLenderId is not null)
	BEGIN
			if (@filterUserId is not null)
			BEGIN
			  INSERT INTO @tempWQs
			  SELECT
				(SELECT SETTINGS_XML.value('(/WorkFlowDefinitionSettings/WorkQueueSettings/BaseType)[1]','varchar(100)') FROM WORKFLOW_DEFINITION WHERE ID = WORKFLOW_DEFINITION_ID),
				 wq.ID,
				 wq.NAME_TX,
				 wq.ACTIVE_IN,
				 wq.DESCRIPTION_TX,
				 wq.STATUS_CD,
				 wq.CREATE_DT,
				 wq.UPDATE_DT,
				 wq.PURGE_DT,
				 wq.UPDATE_USER_TX,
				 wq.LOCK_ID,
 				 wq.EXCLUSIVE_IN,
				 wq.EVALUATION_ORDER_NO,
				 wq.FILTER_XML,
				 wq.WORK_ORDER_XML,
				 wq.SLA_DEFINITION_XML,
				 wq.ASSIGNABLE_QUEUE_XML,
				 wq.WORKFLOW_DEFINITION_ID,
				 wq.WEB_IN
			  FROM WORK_QUEUE wq (nolock) LEFT OUTER JOIN USER_WORK_QUEUE_RELATE uwqRelate (nolock) ON uwqRelate.WORK_QUEUE_ID = wq.ID
					LEFT OUTER JOIN WORKFLOW_DEFINITION wfd (nolock) ON wfd.ID = wq.WORKFLOW_DEFINITION_ID
			  WHERE
				 wq.ID = isnull(@id, wq.ID) 
				 and wq.NAME_TX like isnull(@name, wq.NAME_TX) 
				 and wq.STATUS_CD = ISNULL(@statusCd, wq.STATUS_CD)
				 and uwqRelate.USER_ID = ISNULL(@filterUserId, uwqRelate.USER_ID)
				 and wfd.WORKFLOW_TYPE_CD = ISNULL(@filterWorkItemType, wfd.WORKFLOW_TYPE_CD)
				 and wfd.WORKFLOW_TYPE_CD <> @ignoreWorkItemType
				 and wq.PURGE_DT IS NULL
				 and uwqRelate.PURGE_DT is NULL
				 AND wfd.PURGE_DT IS NULL
				 and (wq.ACTIVE_IN = 'Y' or @includeInactive = 'Y')
				 and wq.WEB_IN = ISNULL(@includeWebEnabled, wq.WEB_IN)
		    END
			else
			BEGIN
				INSERT INTO @tempWQs
				SELECT
				(SELECT SETTINGS_XML.value('(/WorkFlowDefinitionSettings/WorkQueueSettings/BaseType)[1]','varchar(100)') FROM WORKFLOW_DEFINITION WHERE ID = WORKFLOW_DEFINITION_ID),
				 wq.ID,
				 wq.NAME_TX,
				 wq.ACTIVE_IN,
				 wq.DESCRIPTION_TX,
				 wq.STATUS_CD,
				 wq.CREATE_DT,
				 wq.UPDATE_DT,
				 wq.PURGE_DT,
				 wq.UPDATE_USER_TX,
				 wq.LOCK_ID,
 				 wq.EXCLUSIVE_IN,
				 wq.EVALUATION_ORDER_NO,
				 wq.FILTER_XML,
				 wq.WORK_ORDER_XML,
				 wq.SLA_DEFINITION_XML,
				 wq.ASSIGNABLE_QUEUE_XML,
				 wq.WORKFLOW_DEFINITION_ID,
				 wq.WEB_IN
			  FROM WORK_QUEUE wq (nolock) LEFT OUTER JOIN WORKFLOW_DEFINITION wfd (nolock) ON wfd.ID = wq.WORKFLOW_DEFINITION_ID
			  WHERE
				 wq.ID = isnull(@id, wq.ID) 
				 and wq.NAME_TX like isnull(@name, wq.NAME_TX) 
				 and wq.STATUS_CD = ISNULL(@statusCd, wq.STATUS_CD)
				 and wfd.WORKFLOW_TYPE_CD = ISNULL(@filterWorkItemType, wfd.WORKFLOW_TYPE_CD)
				 and wfd.WORKFLOW_TYPE_CD <> @ignoreWorkItemType
				 and ((wq.Filter_xml.exist('//Filters/Filter[@Id = sql:variable("@filterLenderId")]') = 1) OR ((wq.Filter_xml.exist('//Filters/Filter[@Id = sql:variable("@filterLenderId")]') = 0) AND (@includeWebEnabled = 'Y')))
				 and wq.PURGE_DT IS NULL
				 AND wfd.PURGE_DT IS NULL
				 and (wq.ACTIVE_IN = 'Y' or @includeInactive = 'Y')
				 and wq.WEB_IN = ISNULL(@includeWebEnabled, wq.WEB_IN)
		    END
	END
    else if (@filterUserId is not null)
    BEGIN
		INSERT INTO @tempWQs
		SELECT
		(SELECT SETTINGS_XML.value('(/WorkFlowDefinitionSettings/WorkQueueSettings/BaseType)[1]','varchar(100)') FROM WORKFLOW_DEFINITION WHERE ID = WORKFLOW_DEFINITION_ID),
         wq.ID,
         wq.NAME_TX,
         wq.ACTIVE_IN,
         wq.DESCRIPTION_TX,
         wq.STATUS_CD,
         wq.CREATE_DT,
         wq.UPDATE_DT,
         wq.PURGE_DT,
         wq.UPDATE_USER_TX,
         wq.LOCK_ID,
 		 wq.EXCLUSIVE_IN,
		 wq.EVALUATION_ORDER_NO,
		 wq.FILTER_XML,
		 wq.WORK_ORDER_XML,
		 wq.SLA_DEFINITION_XML,
		 wq.ASSIGNABLE_QUEUE_XML,
		 wq.WORKFLOW_DEFINITION_ID,
		 wq.WEB_IN
      FROM WORK_QUEUE wq (nolock) LEFT OUTER JOIN USER_WORK_QUEUE_RELATE uwqRelate (nolock) ON uwqRelate.WORK_QUEUE_ID = wq.ID
			LEFT OUTER JOIN WORKFLOW_DEFINITION wfd (nolock) ON wfd.ID = wq.WORKFLOW_DEFINITION_ID
      WHERE
         wq.ID = isnull(@id, wq.ID) 
	     and wq.NAME_TX like isnull(@name, wq.NAME_TX) 
         and wq.STATUS_CD = ISNULL(@statusCd, wq.STATUS_CD)
         and uwqRelate.USER_ID = ISNULL(@filterUserId, uwqRelate.USER_ID)
         and wfd.WORKFLOW_TYPE_CD = ISNULL(@filterWorkItemType, wfd.WORKFLOW_TYPE_CD)
         and wfd.WORKFLOW_TYPE_CD <> @ignoreWorkItemType
         and wq.PURGE_DT IS NULL
		 and uwqRelate.PURGE_DT is NULL
         AND wfd.PURGE_DT IS NULL
         and (wq.ACTIVE_IN = 'Y' or @includeInactive = 'Y')
         and wq.WEB_IN = ISNULL(@includeWebEnabled, wq.WEB_IN)
	END
	else
	BEGIN
	    INSERT INTO @tempWQs
		SELECT
			(SELECT SETTINGS_XML.value('(/WorkFlowDefinitionSettings/WorkQueueSettings/BaseType)[1]','varchar(100)') FROM WORKFLOW_DEFINITION WHERE ID = WORKFLOW_DEFINITION_ID),
			 wq.ID,
			 wq.NAME_TX,
			 wq.ACTIVE_IN,
			 wq.DESCRIPTION_TX,
			 wq.STATUS_CD,
			 wq.CREATE_DT,
			 wq.UPDATE_DT,
			 wq.PURGE_DT,
			 wq.UPDATE_USER_TX,
			 wq.LOCK_ID,
 			 wq.EXCLUSIVE_IN,
			 wq.EVALUATION_ORDER_NO,
			 wq.FILTER_XML,
			 wq.WORK_ORDER_XML,
			 wq.SLA_DEFINITION_XML,
			 wq.ASSIGNABLE_QUEUE_XML,
			 wq.WORKFLOW_DEFINITION_ID,
			 wq.WEB_IN
		  FROM WORK_QUEUE wq (nolock) LEFT OUTER JOIN WORKFLOW_DEFINITION wfd (nolock) ON wfd.ID = wq.WORKFLOW_DEFINITION_ID
		  WHERE
			 wq.ID = isnull(@id, wq.ID) 
			 and wq.NAME_TX like isnull(@name, wq.NAME_TX) 
			 and wq.STATUS_CD = ISNULL(@statusCd, wq.STATUS_CD)
			 and wfd.WORKFLOW_TYPE_CD = ISNULL(@filterWorkItemType, wfd.WORKFLOW_TYPE_CD)
			 and wfd.WORKFLOW_TYPE_CD <> @ignoreWorkItemType
			 and wq.PURGE_DT IS NULL 
			 AND wfd.PURGE_DT IS NULL            
			 and (wq.ACTIVE_IN = 'Y' or @includeInactive = 'Y')
			 and wq.WEB_IN = ISNULL(@includeWebEnabled, wq.WEB_IN)
	END

	IF @userId IS NULL
	BEGIN
		SELECT * FROM @tempWQs
	END
	ELSE
	BEGIN

	    --added as per the bug 29730
		--getting all workqueues with the agency filter condition as a queue rule

		DECLARE @WQWithAgencyIdRule TABLE
		(
			ID bigint,
			AGENCY_ID bigint
		)

		--added as per the bug 29730
		--getting all workqueues with the agency filter condition as a queue rule
		INSERT INTO @WQWithAgencyIdRule
		SELECT distinct WQ.ID,  CONVERT(bigint,RCB.RULE_CONDITION_XML.value('(/ValueRuleConditionPropertyType/RParamValue)[1]','nvarchar(2)')) as AGENCY_ID
		FROM
			BUSINESS_OPTION_GROUP BOP
				JOIN BUSINESS_RULE_BASE BRB ON BRB.BUSINESS_OPTION_GROUP_ID = BOP.ID and BRB.PURGE_DT is null
				JOIN RULE_CONDITION_BASE RCB ON RCB.BUSINESS_RULE_BASE_ID = BRB.ID and RCB.PURGE_DT is null
				JOIN @tempWQs WQ ON BOP.RELATE_ID = WQ.ID AND BOP.RELATE_CLASS_NM = 'UnitracWorkQueue'
		WHERE 
			RCB.RULE_CONDITION_XML.value('(/ValueRuleConditionPropertyType/LParamClassName)[1]','nvarchar(200)') = 'Allied.UniTrac.Agency'
			AND RCB.RULE_CONDITION_XML.value('(/ValueRuleConditionPropertyType/LParamProperty)[1]','nvarchar(20)') = 'Id'
			AND BOP.PURGE_DT is null
		
		-- added as per the bug 29730	
		-- getting all workqueues where there is no agency filter condition on workqueue.
		SELECT 
			twq.* 
		FROM 
			@tempWQs twq 
		WHERE 
			twq.ID NOT IN (SELECT ID FROM @WQWithAgencyIdRule)

		UNION ALL
	
		-- added as per the bug 29730
		--getting workqueues where user's allowed agencies are in queue filter conditions.

		SELECT
			wq.*
		FROM
			@tempWQs wq
				JOIN @WQWithAgencyIdRule twq ON twq.ID = wq.ID
				JOIN AGENCY_USER_RELATE AUR ON AUR.AGENCY_ID = twq.AGENCY_ID AND AUR.USER_ID = @userId AND AUR.PURGE_DT IS NULL
	END
END



GO

