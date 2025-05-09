USE [UniTrac]
GO
DECLARE
	@id  bigint = null,
	@workQueueId bigint = null,
    @workItemId bigint = null

   if @id = 0
      set @id = null

	IF @id IS NOT NULL
	BEGIN
		SELECT
		  ID,
		  WORK_QUEUE_ID,
		  WORK_ITEM_ID,
		  PRIORITY1_NO,
		  PRIORITY2_NO,
		  PRIORITY3_NO,
		  PRIORITY4_NO,
		  SLA_LEVEL_NO,
		  CROSS_QUEUE_COUNT_IND,
		  LOCK_ID
		FROM WORK_QUEUE_WORK_ITEM_RELATE
		WHERE
		ID = @id
	END
	ELSE IF @workQueueId IS NOT NULL AND @workItemId IS NOT NULL
	BEGIN
		SELECT
		  ID,
		  WORK_QUEUE_ID,
		  WORK_ITEM_ID,
		  PRIORITY1_NO,
		  PRIORITY2_NO,
		  PRIORITY3_NO,
		  PRIORITY4_NO,
		  SLA_LEVEL_NO,
		  CROSS_QUEUE_COUNT_IND,
		  LOCK_ID
		FROM WORK_QUEUE_WORK_ITEM_RELATE
		WHERE
		WORK_QUEUE_ID = @workQueueId
		AND WORK_ITEM_ID = @workItemId
      and PURGE_DT is null
	END
	ELSE IF @workQueueId IS NOT NULL 
	BEGIN
		SELECT
		  ID,
		  WORK_QUEUE_ID,
		  WORK_ITEM_ID,
		  PRIORITY1_NO,
		  PRIORITY2_NO,
		  PRIORITY3_NO,
		  PRIORITY4_NO,
		  SLA_LEVEL_NO,
		  CROSS_QUEUE_COUNT_IND,
		  LOCK_ID
		FROM WORK_QUEUE_WORK_ITEM_RELATE
		WHERE
		WORK_QUEUE_ID = @workQueueId
      and PURGE_DT is null
  	END
	ELSE IF @workItemId IS NOT NULL
	BEGIN
		SELECT
		  ID,
		  WORK_QUEUE_ID,
		  WORK_ITEM_ID,
		  PRIORITY1_NO,
		  PRIORITY2_NO,
		  PRIORITY3_NO,
		  PRIORITY4_NO,
		  SLA_LEVEL_NO,
		  CROSS_QUEUE_COUNT_IND,
		  LOCK_ID
		FROM WORK_QUEUE_WORK_ITEM_RELATE
		WHERE
		WORK_ITEM_ID = @workItemId 
      and PURGE_DT is null
	END
