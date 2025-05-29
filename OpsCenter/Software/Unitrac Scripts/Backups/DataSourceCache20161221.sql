USE [OspreyDashboard]
GO

/****** Object:  StoredProcedure [dbo].[GetDatasourceCache]    Script Date: 12/21/2016 2:46:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetDatasourceCache](@id   bigint = null, @datasourceId bigint = null)
AS
BEGIN
   SET NOCOUNT ON
   if @id = 0
      set @id = null

   if @datasourceId = 0
      set @datasourceId = null

   if (@id > 0)
   BEGIN
      SELECT
         ID,
         DATASOURCE_ID,
         LOCK_ID,
         RECORD_DATE,
         RECORD_YEAR,
         RECORD_MONTH,
         RECORD_DAY,
         ASSOCIATION_CD,
         ASSOCATION_NAME_TX,
         COUNT_NO,
         AMOUNT_NO,
         TYPE_CD,
         SOURCE_CD,
         RESULT_CD,
         STATUS_CD
      FROM DATASOURCE_CACHE
      WHERE
         ID = @id
   END
   ELSE IF (@datasourceId > 0)
   BEGIN
      SELECT
         ID,
         DATASOURCE_ID,
         LOCK_ID,
         RECORD_DATE,
         RECORD_YEAR,
         RECORD_MONTH,
         RECORD_DAY,
         ASSOCIATION_CD,
         ASSOCATION_NAME_TX,
         COUNT_NO,
         AMOUNT_NO,
         TYPE_CD,
         SOURCE_CD,
         RESULT_CD,
         STATUS_CD
      FROM DATASOURCE_CACHE
      WHERE
         DATASOURCE_ID = @datasourceId
         and PURGE_DT is null
   END
END
GO

