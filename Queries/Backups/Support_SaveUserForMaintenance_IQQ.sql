USE [iqq_live]
GO
/****** Object:  StoredProcedure [dbo].[Support_SaveUserForMaintenance]    Script Date: 8/4/2020 8:22:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Support_SaveUserForMaintenance]
(
   @id					bigint,-- base
   @userName            nvarchar(320),
   @givenName			nvarchar(320),
   @familyName			nvarchar(320),
   @email				nvarchar(320),
   @officePhone			nvarchar(320) = null,
   @cipher              nvarchar(512) = null,
   @active              char(1),
   @loginCount          int = null,
   @lastLogin           datetime2 = null,
   @relateClassName     nvarchar(256) = null,
   @relateId            bigint = null,
   @authSchemeClassName nvarchar(256) = null,
   @passwordUpdateDate  datetime2 = null,
   @lockoutDatetime     datetime2 = null,
   @invalidLoginCount   int = null,
   @SSO_ENABLED_IN      char(1) = NULL,
   @IDP_ENTITY_ID_TX    nvarchar(60) = NULL,
   @flags               int = 0,
   @updateUser          nvarchar(320) = 'IDMMaintenanceUser',
   @lockId              int,
   -- derived
   @EMPLOYEE_CODE_TX		NVARCHAR(254)=NULL,
   @TELLER_NUMBER_TX		NVARCHAR(32)=NULL,
   @BRANCH_NUMBER_TX		NVARCHAR(32)=NULL,
   @POSITRAC_CODE_TX		NVARCHAR(32)=NULL,
   @ALLIED_SALES_REGION_CD NVARCHAR(50)=NULL,
   @PURGE					CHAR(1)=NULL,
   @CREATE_DT				datetime2 = null
)
AS
BEGIN TRY
			   
			   IF (SELECT COUNT(*) FROM IQQ_COMMON.dbo.USERS WHERE USER_NAME_TX = @userName) = 0
			   BEGIN
			   SET NOCOUNT ON
			   DECLARE @INSERT BIT=0
			   DECLARE @NEXTLOCKID TINYINT=1
			   DECLARE @NOW DATETIME=GETUTCDATE()
			   declare @purgeDate datetime
			   DECLARE @saveUserGUID uniqueidentifier = NEWID()
			   DECLARE @savePersonGUID uniqueidentifier = NEWID()
			  
			   IF(@LOCKID<255)
				  SET @NEXTLOCKID=@LOCKID+1

			   IF(@CREATE_DT IS NULL)
				 SET @CREATE_DT = @now

				if @purge = 'Y'
				  set @purgeDate = @now


   
			   EXEC SaveUser @id=@id output,@guid=@saveUserGUID,@userName=@userName,@cipher=@cipher,@active=@active,@loginCount=@loginCount,@lastLogin=@lastLogin,@relateClassName=@relateClassName,@relateId=@relateId,@authSchemeClassName=@authSchemeClassName,@passwordUpdateDate=@passwordUpdateDate,@lockoutDatetime=@lockoutDatetime,@invalidLoginCount=@invalidLoginCount,@flags=@flags,
			   @SSO_ENABLED_IN=@SSO_ENABLED_IN,@IDP_ENTITY_ID_TX=@IDP_ENTITY_ID_TX,
			   @updateUser=@updateUser,@lockId=@lockid,@CREATE_DT=@CREATE_DT,@purge=@purge

				exec SavePerson 
				@id=0,
				@givenName=@givenName,
				@familyName=@familyName,
				@type='',
				@title='',
				@email=@email,
				@officePhone=@officePhone,
				@officePhoneExt=NULL,
				@cellPhone='',
				@homePhone='',
				@fax='',@faxExt='',
				@modifyingUser=@updateUser,
				@lockId=0,
				@GUID=@savePersonGUID,
				@salutationCode=NULL,
				@losLoanAppID=NULL

				DECLARE @savePersonID BIGINT
				SELECT @savePersonID = ID FROM IQQ_COMMON.dbo.PERSON WHERE EMAIL_TX = @email



				exec SaveUserRelate @ID=0,@USER_ID=@id,
				@RELATE_ID=@savePersonID,@RELATE_CLASS_NAME_TX='Osprey.Person',
				@UPDATE_USER_TX=@updateUser,@lockId=0

				--securityGroupName grabs the "view only" security group
				DECLARE @securityGroupID BIGINT
				SELECT @securityGroupID = ID FROM SECURITY_GROUP WHERE NAME_TX = 'AlliedViewUsers'
				exec SaveUserSecurityGroupRelate @userId=@id,
				@securityGroupId=@securityGroupID,@modifyingUserName=@updateUser,@lockId=1

				--This is Allied's ORGANIZATION_GUID of 4FDE64C5-89CC-49F2-9E18-3C03611C3A31
				exec SaveOrganizationUserRelate @ID=0,@ORGANIZATION_GUID='4FDE64C5-89CC-49F2-9E18-3C03611C3A31',
				@USER_ID=@id,@UPDATE_USER_TX=@updateUser,
				@RELATE_TYPE_CD='P',@QUOTE_ALERT_ENABLED_IN='N',@LENDER_REP_ENABLED_IN='N',@lockId=0

				INSERT INTO IQQ_USER (IQQ_USER_ID,EMPLOYEE_CODE_TX,TELLER_NUMBER_TX,BRANCH_NUMBER_TX,POSITRAC_CODE_TX,ALLIED_SALES_REGION_CD)
					  VALUES (@ID,@EMPLOYEE_CODE_TX,@TELLER_NUMBER_TX,@BRANCH_NUMBER_TX,@POSITRAC_CODE_TX,@ALLIED_SALES_REGION_CD)

			   END
		   ELSE
			   BEGIN
				UPDATE IQQ_COMMON.dbo.USERS SET ACTIVE_IN = @active, PURGE_DT = GETUTCDATE() WHERE USER_NAME_TX = @userName
			   END
END TRY

		BEGIN CATCH
			SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_STATE() AS ErrorState,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage;

END CATCH
