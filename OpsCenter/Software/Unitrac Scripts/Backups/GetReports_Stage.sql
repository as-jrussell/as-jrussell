USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[GetReports]    Script Date: 6/23/2016 4:58:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetReports]
(
	@userId BIGINT = NULL,
	@securityGroupId BIGINT = NULL,
	@active char(1),
	@dashboard char(1),
	@rolledUp char(1) = 'N',
   @agencyId bigint = NULL
)
AS
BEGIN

   SET NOCOUNT ON

	IF @active = '' 
		SET @active = '%'
	IF @dashboard = '' 
		SET @dashboard = '%'
	IF (@userId IS NOT NULL AND @userId > 0 and @rolledUp = 'N')
	BEGIN
		SELECT
			R.ID,
			R.NAME_TX,
			R.DISPLAY_NAME_TX,
			R.DESCRIPTION_TX,
			R.CATEGORY_CD,
			R.SUB_CATEGORY_CD,
			R.ACTIVE_IN,
			R.DASHBOARD_IN,
			R.SERVER_PATH_TX, 
			R.CREATE_DT,
			R.UPDATE_DT,
			R.LOCK_ID,
			R.RENDER_TYPE_CD,
		    R.RENDER_SPROC_TX,
		    R.RENDER_XSLT_XML,
			SC.ID,
			SC.ATTRIBUTE_1_IN,
			SC.ATTRIBUTE_2_IN,
			SC.ATTRIBUTE_3_IN,
			SC.ATTRIBUTE_4_IN,
			SC.ATTRIBUTE_5_IN,
			SC.SECURITY_FUNC_ID,
			SC.Security_Grp_Id,
			SC.[USER_ID],
         SC.AGENCY_ID,
			SC.CREATE_DT,
			SC.UPDATE_DT,
			SC.LOCK_ID
			
		FROM REPORT R
			INNER JOIN REPORT_SECURITY_CONTAINER_RELATE RSCR ON RSCR.REPORT_ID = R.ID
			INNER JOIN SECURITY_CONTAINER SC ON SC.ID = RSCR.SEC_CON_ID AND SC.[USER_ID] = @userId
                                          and (isnull(@agencyId, 0) = 0 OR SC.[agency_id] = @agencyId)
		WHERE R.PURGE_DT IS NULL
			AND SC.PURGE_DT IS NULL
			AND R.ACTIVE_IN LIKE @active
			AND R.DASHBOARD_IN LIKE @dashboard
		ORDER BY R.DISPLAY_NAME_TX
	END
	ELSE IF (@securityGroupId IS NOT NULL AND @securityGroupId > 0 AND @rolledUp = 'N')
	BEGIN
		SELECT
			R.ID,
			R.NAME_TX,
			R.DISPLAY_NAME_TX,
			R.DESCRIPTION_TX,
			R.CATEGORY_CD,
			R.SUB_CATEGORY_CD,
			R.ACTIVE_IN,
			R.DASHBOARD_IN,
			R.SERVER_PATH_TX, 
			R.CREATE_DT,
			R.UPDATE_DT,
			R.LOCK_ID,
			R.RENDER_TYPE_CD,
		    R.RENDER_SPROC_TX,
		    R.RENDER_XSLT_XML,
			SC.ID,
			SC.ATTRIBUTE_1_IN,
			SC.ATTRIBUTE_2_IN,
			SC.ATTRIBUTE_3_IN,
			SC.ATTRIBUTE_4_IN,
			SC.ATTRIBUTE_5_IN,
			SC.SECURITY_FUNC_ID,
			SC.Security_Grp_Id,
			SC.[USER_ID],
         SC.AGENCY_ID,
			SC.CREATE_DT,
			SC.UPDATE_DT,
			SC.LOCK_ID
		FROM REPORT R
			INNER JOIN REPORT_SECURITY_CONTAINER_RELATE RSCR ON RSCR.REPORT_ID = R.ID
			INNER JOIN SECURITY_CONTAINER SC ON SC.ID = RSCR.SEC_CON_ID AND SC.[Security_Grp_Id] = @securityGroupId
                                          and (isnull(@agencyId, 0) = 0 OR SC.[agency_id] = @agencyId)
		WHERE R.PURGE_DT IS NULL
			AND SC.PURGE_DT IS NULL
			AND R.ACTIVE_IN LIKE @active
			AND R.DASHBOARD_IN LIKE @dashboard
		ORDER BY R.DISPLAY_NAME_TX
	END		
	ELSE IF (@userId IS NOT NULL AND @userId > 0 and @rolledUp = 'Y')
	BEGIN
	   WITH SecurityGroups([sec_grp_id], [level])
      AS
      (
         select SEC_GRP_ID, 0 as [level] 
         from USER_SECURITY_GROUP_RELATE R
            inner join SECURITY_GROUP G ON R.SEC_GRP_ID = G.ID 
         where USER_ID = @userId and R.PURGE_DT is null
            and (isnull(@agencyId, 0) = 0 OR G.[agency_id] = @agencyId)
         
         UNION ALL
         
         select sgr.SEC_GRP_ID, [level] + 1
         from SECURITY_GROUP sg
            inner join SECURITY_GROUP_RELATE sgr on sg.ID = sgr.SEC_GRP_ID
            inner join SecurityGroups sgs on sgr.SEC_GRP_PARENT_ID = sgs.[sec_grp_id]
         where sg.PURGE_DT is null
            and (isnull(@agencyId, 0) = 0 OR sg.[agency_id] = @agencyId)
      )

      select distinct R.ID,
			R.NAME_TX,
			R.DISPLAY_NAME_TX,
			R.DESCRIPTION_TX,
			R.CATEGORY_CD,
			R.SUB_CATEGORY_CD,
			R.ACTIVE_IN,
			R.DASHBOARD_IN,
			R.SERVER_PATH_TX,
			R.CREATE_DT,
			R.UPDATE_DT,
			R.LOCK_ID, 
			R.RENDER_TYPE_CD,
		    R.RENDER_SPROC_TX,
			null,
			SC.ID,
			SC.ATTRIBUTE_1_IN,
			SC.ATTRIBUTE_2_IN,
			SC.ATTRIBUTE_3_IN,
			SC.ATTRIBUTE_4_IN,
			SC.ATTRIBUTE_5_IN,
			SC.SECURITY_FUNC_ID,
			SC.Security_Grp_Id,
			SC.[USER_ID],
         SC.AGENCY_ID,
			SC.CREATE_DT,
			SC.UPDATE_DT,
			SC.LOCK_ID			
      from Report R 
         inner join REPORT_SECURITY_CONTAINER_RELATE RSCR on RSCR.REPORT_ID = R.ID
         INNER JOIN SECURITY_CONTAINER SC ON SC.ID = RSCR.SEC_CON_ID 
                                          and (isnull(@agencyId, 0) = 0 OR SC.[agency_id] = @agencyId)
      WHERE RSCR.SEC_CON_ID in (select ID 
                              from SECURITY_CONTAINER SC 
                              where SC.PURGE_DT IS NULL 
                                 AND (SC.Security_Grp_Id IN (select [sec_grp_id] from SecurityGroups)
                                       or SC.[USER_ID] = @userId)
                              )
            and R.PURGE_DT IS NULL
			   AND R.ACTIVE_IN LIKE @active
			   AND R.DASHBOARD_IN LIKE @dashboard
      ORDER BY DISPLAY_NAME_TX
   
	END
   ELSE 
	BEGIN
	   SELECT
		   R.ID,
		   R.NAME_TX,
		   R.DISPLAY_NAME_TX,
		   R.DESCRIPTION_TX,
		   R.CATEGORY_CD,
		   R.SUB_CATEGORY_CD,
		   R.ACTIVE_IN,
		   R.DASHBOARD_IN,
		   R.SERVER_PATH_TX,
		   R.CREATE_DT,
		   R.UPDATE_DT,
		   R.LOCK_ID,
		   R.RENDER_TYPE_CD,
		   R.RENDER_SPROC_TX,
		   R.RENDER_XSLT_XML 
	   FROM REPORT R
	   WHERE R.PURGE_DT IS NULL
		   AND R.ACTIVE_IN LIKE @active
		   AND R.DASHBOARD_IN LIKE @dashboard
	   ORDER BY DISPLAY_NAME_TX
   END
END

GO

