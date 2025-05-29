USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[GetBorrowerInsuranceAgencies]    Script Date: 9/18/2017 10:44:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetBorrowerInsuranceAgencies]
(
   @id   bigint = null,
   @agencyId bigint = null,
   @name varchar(100) = null,
   @includeInactive char(1) = 'N',
   @phone varchar(10) = null,
   @remitAddrId bigint = null,
   @remitAddr char(1) = 'N',
   @agencyCode nvarchar(20) = null,
   @agentName nvarchar(20) = null
)
AS
BEGIN

   SET NOCOUNT ON

   if @id = 0
      set @id = NULL

    IF @agencyId = 0
		SET @agencyId = NULL

	IF @id is not null
      SELECT
         ID,
         NAME_TX,
         AGENT_TX,
         ACTIVE_IN,
         CREATE_DT,
         LOCK_ID,
         AGENCY_ID,
         ESCROW_REMITTANCE_ADDRESS_ID,
         UPDATE_USER_TX,
         PHONE_TX,
         PHONE_EXT_TX,
         FAX_TX,
         FAX_EXT_TX,
         EMAIL_TX,
         WEB_ADDRESS_TX,
         ADDRESS_ID,
         DO_NOT_EMAIL_IN,
         DO_NOT_FAX_IN,
         AGENCY_CODE_TX
      FROM BORROWER_INSURANCE_AGENCY
      WHERE ID = @id

	ELSE IF @agencyId IS NOT NULL AND @remitAddrId IS NOT NULL
      SELECT
         ID,
         NAME_TX,
         AGENT_TX,
         ACTIVE_IN,
         CREATE_DT,
         LOCK_ID,
         AGENCY_ID,
         ESCROW_REMITTANCE_ADDRESS_ID,
         UPDATE_USER_TX,
         PHONE_TX,
         PHONE_EXT_TX,
         FAX_TX,
         FAX_EXT_TX,
         EMAIL_TX,
         WEB_ADDRESS_TX,
         ADDRESS_ID,
         DO_NOT_EMAIL_IN,
         DO_NOT_FAX_IN,
         AGENCY_CODE_TX
      FROM BORROWER_INSURANCE_AGENCY WITH (index = [IDX_BIA_AGENCYID_PURGEDT])
         WHERE AGENCY_ID = @agencyId
	            AND ESCROW_REMITTANCE_ADDRESS_ID = @remitAddrId
	            AND PURGE_DT IS NULL

	ELSE IF @agencyId IS NULL
		 RAISERROR(N'AgencyId is not provided',1,1)

   ELSE IF @agencyCode is not null
      SELECT
         ID,
         NAME_TX,
         AGENT_TX,
         ACTIVE_IN,
         CREATE_DT,
         LOCK_ID,
         AGENCY_ID,
         ESCROW_REMITTANCE_ADDRESS_ID,
         UPDATE_USER_TX,
         PHONE_TX,
         PHONE_EXT_TX,
         FAX_TX,
         FAX_EXT_TX,
         EMAIL_TX,
         WEB_ADDRESS_TX,
         ADDRESS_ID,
         DO_NOT_EMAIL_IN,
         DO_NOT_FAX_IN,
         AGENCY_CODE_TX
      FROM BORROWER_INSURANCE_AGENCY WITH (INDEX = [IDX_BIA_AGENCYCODE_AGENCYID])
         WHERE AGENCY_CODE_TX = @agencyCode
               AND PURGE_DT IS NULL
               AND AGENCY_ID = @agencyId
               AND (ACTIVE_IN = 'Y' or (@includeInactive = 'Y' and ACTIVE_IN = 'N'))
               
   ELSE IF @agentName is not null
      SELECT
         ID,
         NAME_TX,
         AGENT_TX,
         ACTIVE_IN,
         CREATE_DT,
         LOCK_ID,
         AGENCY_ID,
         ESCROW_REMITTANCE_ADDRESS_ID,
         UPDATE_USER_TX,
         PHONE_TX,
         PHONE_EXT_TX,
         FAX_TX,
         FAX_EXT_TX,
         EMAIL_TX,
         WEB_ADDRESS_TX,
         ADDRESS_ID,
         DO_NOT_EMAIL_IN,
         DO_NOT_FAX_IN,
         AGENCY_CODE_TX
      FROM BORROWER_INSURANCE_AGENCY WITH (INDEX = [IDX_BIA_AGENTNAME_AGENCYID])
         WHERE AGENT_TX LIKE @agentName + '%'
               AND PURGE_DT IS NULL
               AND AGENCY_ID = @agencyId
               AND (ACTIVE_IN = 'Y' or (@includeInactive = 'Y' and ACTIVE_IN = 'N'))
               
	ELSE IF @phone IS NOT NULL
   BEGIN
   
      SELECT
         ID,
         NAME_TX,
         AGENT_TX,
         ACTIVE_IN,
         CREATE_DT,
         LOCK_ID,
         AGENCY_ID,
         ESCROW_REMITTANCE_ADDRESS_ID,
         UPDATE_USER_TX,
         PHONE_TX,
         PHONE_EXT_TX,
         FAX_TX,
         FAX_EXT_TX,
         EMAIL_TX,
         WEB_ADDRESS_TX,
         ADDRESS_ID,
         DO_NOT_EMAIL_IN,
         DO_NOT_FAX_IN,
         AGENCY_CODE_TX
      FROM BORROWER_INSURANCE_AGENCY WITH (INDEX = [IDX_BIA_PHONE_AGENCYID])
         WHERE PHONE_TX = @phone
               AND PURGE_DT is NULL
               AND AGENCY_ID = @agencyId
		         AND (ACTIVE_IN = 'Y' or (@includeInactive = 'Y' and ACTIVE_IN = 'N'))

      if @remitAddr = 'Y'
   
         SELECT
            ID,
            NAME_TX,
            AGENT_TX,
            ACTIVE_IN,
            CREATE_DT,
            LOCK_ID,
            AGENCY_ID,
            ESCROW_REMITTANCE_ADDRESS_ID,
            UPDATE_USER_TX,
            PHONE_TX,
            PHONE_EXT_TX,
            FAX_TX,
            FAX_EXT_TX,
            EMAIL_TX,
            WEB_ADDRESS_TX,
            ADDRESS_ID,
            DO_NOT_EMAIL_IN,
            DO_NOT_FAX_IN,
            AGENCY_CODE_TX
         FROM BORROWER_INSURANCE_AGENCY WITH (INDEX = [IDX_BIA_PHONE_AGENCYID])
            WHERE PHONE_TX = @phone
                  AND PURGE_DT is NULL
                  AND AGENCY_ID = @agencyId
		            AND (ACTIVE_IN = 'Y' or (@includeInactive = 'Y' and ACTIVE_IN = 'N'))
                  AND ISNULL(ESCROW_REMITTANCE_ADDRESS_ID,0) > 0

   END
   else if @remitAddr = 'Y'

      SELECT
         ID,
         NAME_TX,
         AGENT_TX,
         ACTIVE_IN,
         CREATE_DT,
         LOCK_ID,
         AGENCY_ID,
         ESCROW_REMITTANCE_ADDRESS_ID,
         UPDATE_USER_TX,
         PHONE_TX,
         PHONE_EXT_TX,
         FAX_TX,
         FAX_EXT_TX,
         EMAIL_TX,
         WEB_ADDRESS_TX,
         ADDRESS_ID,
         DO_NOT_EMAIL_IN,
         DO_NOT_FAX_IN,
         AGENCY_CODE_TX
      FROM BORROWER_INSURANCE_AGENCY WITH (index = [IDX_BIA_AGENCYID_PURGEDT])
      WHERE AGENCY_ID = @agencyId and
          (ACTIVE_IN = 'Y' or (@includeInactive = 'Y' and ACTIVE_IN = 'N')) and
          ISNULL(ESCROW_REMITTANCE_ADDRESS_ID,0) > 0 and
          PURGE_DT is NULL

   else
      SELECT
         ID,
         NAME_TX,
         AGENT_TX,
         ACTIVE_IN,
         CREATE_DT,
         LOCK_ID,
         AGENCY_ID,
         ESCROW_REMITTANCE_ADDRESS_ID,
         UPDATE_USER_TX,
         PHONE_TX,
         PHONE_EXT_TX,
         FAX_TX,
         FAX_EXT_TX,
         EMAIL_TX,
         WEB_ADDRESS_TX,
         ADDRESS_ID,
         DO_NOT_EMAIL_IN,
         DO_NOT_FAX_IN,
         AGENCY_CODE_TX
      FROM BORROWER_INSURANCE_AGENCY
      WHERE  (@name is null or NAME_TX LIKE @name + '%')
         and AGENCY_ID = @agencyId
         and (@remitAddrId is null or ESCROW_REMITTANCE_ADDRESS_ID = @remitAddrId)
         and (@phone is NULL or PHONE_TX = @phone)
         and PURGE_DT is NULL
         and (ACTIVE_IN = 'Y' or (@includeInactive = 'Y' and ACTIVE_IN = 'N'))
   
END

GO

