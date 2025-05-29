USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[SaveCurrentOwnerPolicy]    Script Date: 8/11/2017 11:21:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SaveCurrentOwnerPolicy](
      @ID bigint,
      @OWNER_POLICY_ID bigint,
      @REQUIRED_COVERAGE_ID bigint,
      @UPDATE_USER_TX nvarchar(15),
      @lockId tinyint,
      @purge char(1) = null
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
      INSERT INTO CURRENT_OWNER_POLICY
      (
      OWNER_POLICY_ID,
      REQUIRED_COVERAGE_ID,
      CREATE_DT,
      UPDATE_DT,
      UPDATE_USER_TX,
      LOCK_ID
      )
      values
      (
      @OWNER_POLICY_ID,
      @REQUIRED_COVERAGE_ID,
      @now,
      @now,
      @UPDATE_USER_TX,
      @nextLockId
      )
      set @id = SCOPE_IDENTITY()
   end
   else
   begin
      if @lockId < 255
         set @nextLockId = @lockId +1

      UPDATE CURRENT_OWNER_POLICY 
      set
      OWNER_POLICY_ID = @OWNER_POLICY_ID,
      REQUIRED_COVERAGE_ID = @REQUIRED_COVERAGE_ID,
      UPDATE_USER_TX = @UPDATE_USER_TX,
      LOCK_ID = @nextLockId,
      PURGE_DT = @purgeDate
      WHERE ID = @ID AND LOCK_ID = @lockId
   end

   select @id, @nextLockId, @now, @@ROWCOUNT
END

GO

