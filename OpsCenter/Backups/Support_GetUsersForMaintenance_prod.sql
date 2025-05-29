USE [iqq_live]
GO

/****** Object:  StoredProcedure [dbo].[Support_GetUsersForMaintenance]    Script Date: 2/6/2023 11:52:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


-- DROP PROCEDURE [dbo].[Support_GetUsersForMaintenance]
CREATE PROCEDURE [dbo].[Support_GetUsersForMaintenance]
(
   @id               bigint = null,       -- get a specific user
   @active           char(1) = null,
   @username         nvarchar(50) = null, -- search param
   @securityGroupId  bigint = null,       -- get all users that belong to a security group - used in group admin screen
   @loggedInUserId   bigint = null        -- get all users that the logged-in user can administer - those users that have access to agencies that the logged-in user has access to
)
AS
BEGIN
   SET NOCOUNT ON
   IF @id = 0
   set @id = null

   IF ISNULL(@securityGroupId,0) > 0  
	   select R.[USER_ID]
	   INTO #SECTEMP
	   from USER_SECURITY_GROUP_RELATE R
	   where R.PURGE_DT is null and R.SEC_GRP_ID = @securityGroupId

   if (@id is not null)
   begin
      select
         U.ID,
         USER_NAME_TX,
         CIPHER_TX,
         ACTIVE_IN,
         LOGIN_COUNT_NO,
         LAST_LOGIN_DT,
         RELATE_CLASS_NAME_TX,
         RELATE_ID,
         AUTH_SCHEME_CLASS_NAME_TX,
         PASSWORD_UPDATE_DT,
         LOCKOUT_DT,
         INVALID_LOGIN_COUNT_NO,
         SSO_ENABLED_IN,
         IDP_ENTITY_ID_TX,
         U.CREATE_DT,
         U.UPDATE_DT,
         U.LOCK_ID,
         U.[GUID],
         FLAGS
      from USERS U
      where 
             --specific user
             U.ID = @id
      order by U.USER_NAME_TX
   end
   else
   begin

   declare @selectsql nvarchar(max) = 
      'select
         U.ID,
         USER_NAME_TX,
         CIPHER_TX,
         ACTIVE_IN,
         LOGIN_COUNT_NO,
         LAST_LOGIN_DT,
         RELATE_CLASS_NAME_TX,
         RELATE_ID,
         AUTH_SCHEME_CLASS_NAME_TX,
         PASSWORD_UPDATE_DT,
         LOCKOUT_DT,
         INVALID_LOGIN_COUNT_NO,
         SSO_ENABLED_IN,
         IDP_ENTITY_ID_TX,
         U.CREATE_DT,
         U.UPDATE_DT,
         U.LOCK_ID,
         U.[GUID],
         FLAGS
      from USERS U '

	IF @username LIKE '%''%'
		set @username = REPLACE(@username, '''', '''''')

	IF ISNULL(@securityGroupId,0) > 0 
		set @selectsql = CONCAT(@selectsql, ' JOIN #SECTEMP T ON U.ID = T.USER_ID ')

	SET @selectsql = CONCAT(@selectsql, 'WHERE USER_NAME_TX LIKE ''%@alliedsolutions.net'' AND SSO_ENABLED_IN = ''Y'' ')

	IF @active IS NOT NULL
		SET @selectsql = CONCAT(@selectsql, ' AND U.ACTIVE_IN = ', '''', @active, '''')

	IF @username IS NOT NULL
		SET @selectsql = CONCAT(@selectsql, ' AND U.USER_NAME_TX = ', '''', @username, '''')

	SET @selectsql = CONCAT(@selectsql, ' ORDER BY U.USER_NAME_TX')

	--SELECT @selectsql

	EXEC (@selectsql)

   end
END
GO

