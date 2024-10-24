/*
rfpl-sql-prod.bc4aa900af54.database.windows.net
*/

USE [PRL_USERS_PROD]
GO
/****** Object:  StoredProcedure [dbo].[Report_User]    Script Date: 4/21/2022 11:44:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Report_User]') AND type in (N'P', N'PC'))
	BEGIN
		/* Create Empty Stored Procedure */
		EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Report_User] AS RETURN 0;';
	END;
	GO

ALTER PROCEDURE [dbo].[Report_User] (@reportSettingXml XML = NULL)
AS
BEGIN

	DECLARE @ClientID  BIGINT;

	IF (@reportSettingXml IS NOT NULL)
	BEGIN

	  SELECT @clientID=T.C.value('(ClientId)[1]', 'int')
	  FROM @reportSettingXml.nodes('ReportSettingsModel') T(C)

	END

	IF (@ClientID > 0)
	BEGIN

		SELECT
		    u.USER_NAME_TX AS UserName
			,p.GIVEN_NAME_TX AS GivenName
			,p.FAMILY_NAME_TX AS SurName
			,p.EMAIL_TX AS EmailAddress
			,u.ACTIVE_IN AS Enabled
			,u.CREATE_DT AS Created
			,u.UPDATE_DT AS LastModified
			,u.LAST_LOGIN_DT AS LastLogin
			,u.LAST_IP_ADDRESS_TX AS LastSeenIp
			,sg.NAME_TX AS Role,
			isnull(rd.COMMENT_TX,isnull(rd.VALUE_TX,'Unknown')) as ClientName
		FROM USERS u
		  CROSS APPLY (
            select rd.VALUE_TX, rd.COMMENT_TX
            from RELATED_DATA_DEF rdd
				INNER JOIN RELATED_DATA rd ON rdd.ID = rd.DEF_ID
				                          and rd.RELATE_ID = u.ID
			                              and rd.VALUE_TX = cast(@ClientID as nvarchar(50))
            where rdd.NAME_TX = 'CLIENT_ID'
		      and rdd.PURGE_DT is null) rd
		  LEFT JOIN PERSON p ON P.ID = U.PERSON_ID
		  OUTER APPLY (
			SELECT SG.NAME_TX
			FROM USER_SECURITY_GROUP_RELATE USGR
			  JOIN SECURITY_GROUP SG ON SG.ID = USGR.SEC_GRP_ID
			WHERE USGR.USER_ID = U.ID
			  and USGR.PURGE_DT IS NULL) sg
		WHERE u.PURGE_DT is null

	END
	ELSE
	BEGIN

		SELECT 
		     isnull(rd.COMMENT_TX,isnull(rd.VALUE_TX,'Unknown')) as ClientName
		    ,u.USER_NAME_TX AS UserName
			,p.GIVEN_NAME_TX AS GivenName
			,p.FAMILY_NAME_TX AS SurName
			,p.EMAIL_TX AS EmailAddress
			,u.ACTIVE_IN AS Enabled
			,u.CREATE_DT AS Created
			,u.UPDATE_DT AS LastModified
			,u.LAST_LOGIN_DT AS LastLogin
			,u.LAST_IP_ADDRESS_TX AS LastSeenIp
			,sg.NAME_TX AS Role
		FROM USERS u
		  OUTER APPLY (
            select rd.VALUE_TX, rd.COMMENT_TX
            from RELATED_DATA_DEF rdd
				INNER JOIN RELATED_DATA rd ON rdd.ID = rd.DEF_ID
				                          and rd.RELATE_ID = u.ID
            where rdd.NAME_TX = 'CLIENT_ID'
		      and rdd.PURGE_DT is null) rd
		  LEFT JOIN PERSON p ON P.ID = U.PERSON_ID
		  OUTER APPLY (
			SELECT SG.NAME_TX
			FROM USER_SECURITY_GROUP_RELATE USGR
			  JOIN SECURITY_GROUP SG ON SG.ID = USGR.SEC_GRP_ID
			WHERE USGR.USER_ID = U.ID
			  and USGR.PURGE_DT IS NULL) sg
		WHERE u.PURGE_DT is null

	END
END