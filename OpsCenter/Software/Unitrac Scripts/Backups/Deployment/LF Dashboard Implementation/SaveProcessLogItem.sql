IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SaveProcessLogItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SaveProcessLogItem]
GO


CREATE PROCEDURE [dbo].[SaveProcessLogItem](
      @ID bigint,
      @PROCESS_LOG_ID bigint,
      @UPDATE_USER_TX nvarchar(15),
      @STATUS_CD nvarchar(20),
      @lockId tinyint,
      @INFO_XML xml = null,
      @purge char(1) = null,
      @EVALUATION_EVENT_ID bigint = null,
      @RELATE_ID bigint = null,
      @RELATE_TYPE_CD nvarchar(100) = null,
      @SEARCH_TX nvarchar(4000) = null
)
AS
BEGIN
   SET NOCOUNT ON
   declare @now datetime
   set @now = getdate()

   declare @purgeDate datetime
   if @purge = 'Y'
      set @purgeDate = @now

   declare @nextLockId int
   set @nextLockId = 1

   if @id = 0
   begin
      INSERT INTO PROCESS_LOG_ITEM
      (
      PROCESS_LOG_ID,
      CREATE_DT,
      UPDATE_DT,
      UPDATE_USER_TX,
      STATUS_CD,
      LOCK_ID,
      INFO_XML,
      EVALUATION_EVENT_ID,
      RELATE_ID,
      RELATE_TYPE_CD
      )
      values
      (
      @PROCESS_LOG_ID,
      @now,
      @now,
      @UPDATE_USER_TX,
      @STATUS_CD,
      @nextLockId,
      @INFO_XML,
      @EVALUATION_EVENT_ID,
      @RELATE_ID,
      @RELATE_TYPE_CD
      )
      set @id = SCOPE_IDENTITY()
   end
   else
   begin
      if @lockId < 255
         set @nextLockId = @lockId +1

      UPDATE PROCESS_LOG_ITEM 
      set
      PROCESS_LOG_ID = @PROCESS_LOG_ID,
      UPDATE_DT = @now,
      UPDATE_USER_TX = @UPDATE_USER_TX,
      STATUS_CD = @STATUS_CD,
      LOCK_ID = @nextLockId,
      INFO_XML = @INFO_XML,
      PURGE_DT = @purgeDate,
      EVALUATION_EVENT_ID = @EVALUATION_EVENT_ID,
      RELATE_ID = @RELATE_ID,
      RELATE_TYPE_CD = @RELATE_TYPE_CD
      WHERE ID = @ID AND LOCK_ID = @lockId
   end

   select @id, @nextLockId, @now, @@ROWCOUNT
END
GO