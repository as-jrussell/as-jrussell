USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[SaveOwner]    Script Date: 7/25/2017 4:47:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SaveOwner](
      @ID bigint,
      @PREFERRED_CUSTOMER_IN char,
      @SPECIAL_PERSON_IN char,
      @ADDRESS_ID bigint,
      @UPDATE_USER_TX nvarchar(15),
      @lockId tinyint,
      @purge char(1) = null,
      @NAME_TX nvarchar(50) = null,
      @LAST_NAME_TX nvarchar(30) = null,
      @FIRST_NAME_TX nvarchar(30) = null,
      @MIDDLE_INITIAL_TX char = null,
      @CREDIT_SCORE_TX nvarchar(20) = null,
      @HOME_PHONE_TX nvarchar(20) = null,
      @WORK_PHONE_TX nvarchar(20) = null,
      @CELL_PHONE_TX nvarchar(20) = null,
      @EMAIL_TX nvarchar(100) = null,
      @ALLOW_EMAIL_IN char = null,
      @CUSTOMER_NUMBER_TX nvarchar(18) = null,
      @FIELD_PROTECTION_XML xml = null,
      @SPECIAL_HANDLING_XML xml = null,
      @REO_IN char = null,
      @TEXT_NOTIFICATION_STATUS_CD varchar(6) = 'NS',
      @TEXT_SUBSCRIBE_STATUS_CD varchar(6) = 'NS',
      @CELLPHONE_VALIDATION_STATUS_CD varchar(6) = 'NS',
		@BIRTH_DT datetime = null,
      @DO_NOT_USE_EMAIL_IN char = 'N'
)
AS
BEGIN
   SET NOCOUNT ON
   declare @now datetime
   declare @rwcnt integer
   set @now = getdate()
   set @rwcnt = 0

   declare @purgeDate datetime
   if @purge = 'Y'
      set @purgeDate = @now

   declare @nextLockId int
   set @nextLockId = 1

   if @id = 0
   begin
      INSERT INTO OWNER
      (
      PREFERRED_CUSTOMER_IN,
      SPECIAL_PERSON_IN,
      ADDRESS_ID,
      CREATE_DT,
      UPDATE_DT,
      UPDATE_USER_TX,
      LOCK_ID,
      NAME_TX,
      LAST_NAME_TX,
      FIRST_NAME_TX,
      MIDDLE_INITIAL_TX,
      CREDIT_SCORE_TX,
      HOME_PHONE_TX,
      WORK_PHONE_TX,
      CELL_PHONE_TX,
      EMAIL_TX,
      ALLOW_EMAIL_IN,
      CUSTOMER_NUMBER_TX,
      FIELD_PROTECTION_XML,
      SPECIAL_HANDLING_XML,
      REO_IN,
      TEXT_NOTIFICATION_STATUS_CD,
      TEXT_SUBSCRIBE_STATUS_CD,
      CELLPHONE_VALIDATION_STATUS_CD,
		BIRTH_DT,
      DO_NOT_USE_EMAIL_IN
      )
      values
      (
      @PREFERRED_CUSTOMER_IN,
      @SPECIAL_PERSON_IN,
      @ADDRESS_ID,
      @now,
      @now,
      @UPDATE_USER_TX,
      @nextLockId,
      @NAME_TX,
      @LAST_NAME_TX,
      @FIRST_NAME_TX,
      @MIDDLE_INITIAL_TX,
      @CREDIT_SCORE_TX,
      @HOME_PHONE_TX,
      @WORK_PHONE_TX,
      @CELL_PHONE_TX,
      @EMAIL_TX,
      @ALLOW_EMAIL_IN,
      @CUSTOMER_NUMBER_TX,
      @FIELD_PROTECTION_XML,
      @SPECIAL_HANDLING_XML,
      @REO_IN,
      @TEXT_NOTIFICATION_STATUS_CD,
      @TEXT_SUBSCRIBE_STATUS_CD,
      @CELLPHONE_VALIDATION_STATUS_CD,
		@BIRTH_DT,
      @DO_NOT_USE_EMAIL_IN
      )
      set @rwcnt = @@ROWCOUNT
      set @id = SCOPE_IDENTITY()
   end
   else
   begin
      if @lockId < 255
         set @nextLockId = @lockId +1

      UPDATE OWNER 
      set
      PREFERRED_CUSTOMER_IN = @PREFERRED_CUSTOMER_IN,
      SPECIAL_PERSON_IN = @SPECIAL_PERSON_IN,
      ADDRESS_ID = @ADDRESS_ID,
      UPDATE_DT = @now,
      UPDATE_USER_TX = @UPDATE_USER_TX,
      LOCK_ID = @nextLockId,
      PURGE_DT = @purgeDate,
      NAME_TX = @NAME_TX,
      LAST_NAME_TX = @LAST_NAME_TX,
      FIRST_NAME_TX = @FIRST_NAME_TX,
      MIDDLE_INITIAL_TX = @MIDDLE_INITIAL_TX,
      CREDIT_SCORE_TX = @CREDIT_SCORE_TX,
      HOME_PHONE_TX = @HOME_PHONE_TX,
      WORK_PHONE_TX = @WORK_PHONE_TX,
      CELL_PHONE_TX = @CELL_PHONE_TX,
      EMAIL_TX = @EMAIL_TX,
      ALLOW_EMAIL_IN = @ALLOW_EMAIL_IN,
      CUSTOMER_NUMBER_TX = @CUSTOMER_NUMBER_TX,
      FIELD_PROTECTION_XML = @FIELD_PROTECTION_XML,
      SPECIAL_HANDLING_XML = @SPECIAL_HANDLING_XML,
      REO_IN = @REO_IN,
      TEXT_NOTIFICATION_STATUS_CD = @TEXT_NOTIFICATION_STATUS_CD,
      TEXT_SUBSCRIBE_STATUS_CD = @TEXT_SUBSCRIBE_STATUS_CD,
      CELLPHONE_VALIDATION_STATUS_CD = @CELLPHONE_VALIDATION_STATUS_CD,
		BIRTH_DT = @BIRTH_DT,
      DO_NOT_USE_EMAIL_IN = @DO_NOT_USE_EMAIL_IN
      WHERE ID = @ID AND LOCK_ID = @lockId
      
      set @rwcnt = @@ROWCOUNT
           
   end
   
   if @purge = 'Y' and @rwcnt > 0
     update OWNER_LOAN_RELATE
     set PURGE_DT = @purgeDate,
         UPDATE_USER_TX = @UPDATE_USER_TX
     where OWNER_ID = @ID and PURGE_DT is null

   select @id, @nextLockId, @now, @rwcnt
END
