USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[SaveSFInvoiceItemConfig]    Script Date: 12/14/2015 2:52:39 PM ******/
DROP PROCEDURE [dbo].[SaveSFInvoiceItemConfig]
GO

/****** Object:  StoredProcedure [dbo].[SaveSFInvoiceItemConfig]    Script Date: 12/14/2015 2:52:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SaveSFInvoiceItemConfig](
      @ID bigint,
      @SFIC_ID bigint,
      @NAME_TX nvarchar(100),
      @ACTIVE_IN char,
      @UNIT_TYPE_CD nvarchar(30),
      @MIN_UNIT_COUNT_NO int,
      @MIN_BILL_AMOUNT_NO decimal(18,2),
      @START_DT datetime,
      @END_DT datetime,
      @UPDATE_USER_TX nvarchar(15),
      @lockId tinyint,
      @BUSINESS_RULE_ID bigint,
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
      INSERT INTO SERVICE_FEE_INVOICE_ITEM_CONFIG
      (
      SFIC_ID,
      NAME_TX,
      ACTIVE_IN,
      UNIT_TYPE_CD,
      MIN_UNIT_COUNT_NO,
      MIN_BILL_AMOUNT_NO,
      START_DT,
      END_DT,
      CREATE_DT,
      UPDATE_DT,
      UPDATE_USER_TX,
      LOCK_ID,
      BUSINESS_RULE_ID
      )
      values
      (
      @SFIC_ID,
      @NAME_TX,
      @ACTIVE_IN,
      @UNIT_TYPE_CD,
      @MIN_UNIT_COUNT_NO,
      @MIN_BILL_AMOUNT_NO,
      @START_DT,
      @END_DT,
      @now,
      @now,
      @UPDATE_USER_TX,
      @nextLockId,
      @BUSINESS_RULE_ID
      )
      set @id = SCOPE_IDENTITY()
   end
   else
   begin
      if @lockId < 255
         set @nextLockId = @lockId +1

      UPDATE SERVICE_FEE_INVOICE_ITEM_CONFIG
      set
      SFIC_ID = @SFIC_ID,
      NAME_TX = @NAME_TX,
      ACTIVE_IN = @ACTIVE_IN,
      UNIT_TYPE_CD = @UNIT_TYPE_CD,
      MIN_UNIT_COUNT_NO = @MIN_UNIT_COUNT_NO,
      MIN_BILL_AMOUNT_NO = @MIN_BILL_AMOUNT_NO,
      START_DT = @START_DT,
      END_DT = @END_DT,
      UPDATE_DT = @now,
      UPDATE_USER_TX = @UPDATE_USER_TX,
      LOCK_ID = @nextLockId,
      BUSINESS_RULE_ID = @BUSINESS_RULE_ID,
      PURGE_DT = @purgeDate
      WHERE ID = @ID AND LOCK_ID = @lockId
   end

   select @id, @nextLockId, @now, @@ROWCOUNT
END

GO

