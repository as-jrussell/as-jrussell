USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[GetPendingReportHistoryIds]    Script Date: 04/07/2015 16:04:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[GetPendingReportHistoryIds]
AS

BEGIN

declare @ReportTable TABLE (
  ID bigint,
  Report_id bigint,
  create_dt datetime,
  REPORT_DATA_XML XML )

    DECLARE @tmpSubRH TABLE (
  
   id bigint,
     status_cd nvarchar(20) )

  
DECLARE @ReportRowCount AS int

		-- Setting for MAX number of all reports to be generated in one "cycle" of the RPTGEN process
		SELECT
			@ReportRowCount = (SELECT
				MEANING_TX
			FROM REF_CODE
			WHERE CODE_CD = 'ReportRowCount'
			AND DOMAIN_CD = 'System')

			 

IF @@servername = 'Unitrac-DB01'

/******** The following INSERT INTO query is used when reporting off of the replication environment ********/
/******** uncomment these lines when switching to replication.  comment these lines when switching to the transactional db    ********/
begin
             insert INTO @tmpSubRH (id, status_cd) SELECT id, status_cd  FROM OPENQUERY(SUBSCRIBERREPORTHISTORY, 'select id, status_cd from report_history where status_cd = ''PEND'' ')
end


/******** The following INSERT INTO query replaces previous section when reporting off of transactional db, bypassing replication ********/
/******** uncomment these lines when switching to the transactional db.  comment them back when switching to replication  ********/
--begin
             --insert INTO @tmpSubRH (id, status_cd) SELECT id, status_cd FROM report_history where status_cd = 'PEND'
--end

/********************************************************************************************************/


ELSE IF @@servername = 'UTStage01'
begin
              
               insert INTO @tmpSubRH (id, status_cd) SELECT id, status_cd  from report_history where status_cd = 'PEND'
end

ELSE IF @@servername = 'UTQA-SQL'
begin
              
              insert INTO @tmpSubRH (id, status_cd) SELECT id, status_cd from report_history where status_cd = 'PEND'
end

 
ELSE
begin
     RETURN SELECT 0 


END



IF(SELECT COUNT(*) FROM report_history rh 
			JOIN @tmpSubRH sr	ON sr.ID = rh.ID
			JOIN LENDER ldr ON ldr.ID = rh.LENDER_ID AND ldr.CODE_TX IN ('2230', '016400')
				WHERE rh.STATUS_CD = 'PEND' AND sr.STATUS_CD = 'PEND') > 0
		 BEGIN 
				SELECT rh.id FROM report_history rh 
				JOIN @tmpSubRH sr	ON sr.ID = rh.ID
				JOIN LENDER ldr ON ldr.ID = rh.LENDER_ID AND ldr.CODE_TX IN ('2230', '016400')
				WHERE rh.STATUS_CD = 'PEND' AND sr.STATUS_CD = 'PEND'
		end
	


		IF DATEPART(hh, GETDATE()) > 19
			OR DATEPART(hh, GETDATE()) < 7
			BEGIN
				SELECT
				TOP (@ReportRowCount)
					sr.ID
				FROM REPORT_HISTORY rh
				JOIN @tmpSubRH sr
					ON sr.ID = rh.ID
				WHERE rh.STATUS_CD = 'PEND'
				AND sr.STATUS_CD = 'PEND'
			END

		ELSE
		BEGIN
		
				IF (select COUNT(*) FROM report_history WHERE status_cd = 'PEND' AND report_id in (48, 54, 35, 38, 47,71,32,37,46,50,51,52,53,69,58,68,80)) > 0 	
				begin						
					-- Generate all top priority reports
					insert into @ReportTable (ID, Report_id, create_dt,REPORT_DATA_XML) 											
						SELECT sr.ID, rh.Report_id, rh.create_dt,rh.REPORT_DATA_XML
						FROM REPORT_HISTORY rh
						JOIN @tmpSubRH sr ON sr.ID = rh.ID
						WHERE rh.STATUS_CD = 'PEND'
						AND sr.STATUS_CD = 'PEND'
						AND rh.PURGE_DT IS NULL
						AND rh.report_id in (48, 54, 35,38,47,71,32,37,46,50,51,52,53,69,58,68,80) 
					
					
					IF (SELECT COUNT(*) from @ReportTable)  < @ReportRowCount
					begin
							delete from @ReportTable

							  insert into @ReportTable (ID, Report_id, create_dt,REPORT_DATA_XML) 											
								SELECT top (@ReportRowCount) sr.ID, rh.Report_id, rh.create_dt,rh.REPORT_DATA_XML
								FROM REPORT_HISTORY rh
								JOIN @tmpSubRH sr ON sr.ID = rh.ID
								WHERE rh.STATUS_CD = 'PEND'
								AND sr.STATUS_CD = 'PEND'
								AND rh.PURGE_DT IS NULL
								Order by  (CASE WHEN REPORT_DATA_XML.value('(//ReportData/Report/SourceReportConfigID/@value)[1]', 'bigint') IS NULL then 0	ELSE 1 END) desc, 
								(CASE when report_id in (48) then 1 WHEN report_id in (35,54, 38, 47,71) THEN 2 
									when report_id in (32,37,58,50,51,52,53,69,68,80) then 3 
									when report_id in (45,44,46,85,75) then 4 else 5 END), ID	
					  end
					  
					  
					  	
					--This will return the report IDs and exit the query
					select ID from @ReportTable  
					Order by  (CASE WHEN REPORT_DATA_XML.value('(//ReportData/Report/SourceReportConfigID/@value)[1]', 'bigint') IS NULL then 0	ELSE 1 END) desc, 
								(CASE when report_id in (48) then 1 WHEN report_id in (35,54, 38, 47,71) THEN 2 
									when report_id in (32,37,58,50,51,52,53,69,68,80) then 3 
									when report_id in (45,44,46,85,75) then 4 else 5 END), ID	
					
					end
				ELSE
					BEGIN	   
								SELECT top (@ReportRowCount) sr.ID 
								FROM REPORT_HISTORY rh
								JOIN @tmpSubRH sr ON sr.ID = rh.ID
								WHERE rh.STATUS_CD = 'PEND'
								AND sr.STATUS_CD = 'PEND'
								AND rh.PURGE_DT IS NULL
								Order by  (CASE WHEN REPORT_DATA_XML.value('(//ReportData/Report/SourceReportConfigID/@value)[1]', 'bigint') IS NULL then 0	ELSE 1 END) desc, 
								(CASE when report_id in (48) then 1 WHEN report_id in (35, 54, 38, 47,71) THEN 2 
									when report_id in (32,37,58,50,51,52,53,69,68,80) then 3 
									when report_id in (45,44,46,85,75) then 4 else 5 END), ID	
					END
					
		
	

		end
	END



