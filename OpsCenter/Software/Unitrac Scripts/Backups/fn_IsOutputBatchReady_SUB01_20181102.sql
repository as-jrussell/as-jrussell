USE [Unitrac_Reports]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_IsOutputBatchReadyToPrint]    Script Date: 11/2/2018 12:45:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_IsOutputBatchReadyToPrint]
(
	@outputBatchId					bigint
)
RETURNS CHAR(1)
AS
BEGIN
	
	declare @BatchTypeCd as nvarchar(30)
	DECLARE @OutputTypeCd AS nvarchar(5)
	declare @NotReadyCount as integer;

	SELECT  @BatchTypeCd = oc.TYPE_CD , @OutputTypeCd = OC.OUTPUT_TYPE_CD
	FROM 
		OUTPUT_BATCH OB 
		INNER JOIN OUTPUT_CONFIGURATION OC ON OC.ID = OB.OUTPUT_CONFIGURATION_ID
	WHERE
		OB.ID = @outputBatchId
		
  -- checks if the email/fax output batches are ready 
   IF (@BatchTypeCd = 'NTC' AND @OutputTypeCd IN ('EMAIL','FAX'))
   BEGIN
   	SELECT 
			@NotReadyCount = COUNT(N.ID) 
		from
			OUTPUT_BATCH ob 
			inner join PROCESS_LOG_ITEM pli 
                     on pli.process_log_id = ob.PROCESS_LOG_ID AND 
                        pli.INFO_XML.exist ('(/INFO_LOG/OUTPUT_TYPE)[1]') = 1 AND
                        pli.INFO_XML.value ('(/INFO_LOG/OUTPUT_TYPE)[1]','nvarchar(10)') = @OutputTypeCd
			inner join NOTICE n on n.id = pli.relate_id and pli.relate_type_cd = 'Allied.UniTrac.Notice'
			left outer join DOCUMENT_CONTAINER dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'Allied.UniTrac.Notice' and dc.purge_dt is null
		where	
			n.purge_dt is null 
			and pli.purge_dt is null 			
			and pli.status_cd = 'COMP'
			and ( dc.print_status_cd is null or dc.id is null or dc.print_status_cd = 'UNRES' )
			and ob.status_cd = 'PEND' 
			and ob.id = @outputBatchId
   END
   ELSE IF (@BatchTypeCd = 'NTC' AND @OutputTypeCd = 'TXT')
   BEGIN
      declare @dw varchar(1)
      select @dw = convert(varchar(1),datepart(dw, getdate()))

   	SELECT 
			@NotReadyCount = CASE WHEN COUNT(pli.Id) > 0 THEN 0 ELSE 1 END
		from
			OUTPUT_BATCH ob 
			JOIN OUTPUT_CONFIGURATION oc on	 oc.ID = ob.OUTPUT_CONFIGURATION_ID AND oc.PURGE_DT IS NULL
			inner join PROCESS_LOG_ITEM pli 
                     on pli.process_log_id = ob.PROCESS_LOG_ID AND 
                        pli.INFO_XML.exist ('(/INFO_LOG/OUTPUT_TYPE)[1]') = 1 AND
                        pli.INFO_XML.value ('(/INFO_LOG/OUTPUT_TYPE)[1]','nvarchar(10)') = @OutputTypeCd
		where	
			pli.purge_dt is null 			
			and pli.status_cd = 'COMP'
			and ob.status_cd = 'PEND' 
			and ob.id = @outputBatchId
         and (oc.XML_CONTAINER.exist('(/OutputConfigurationSettings/DaysOfWeek)[1]') = 0
         or oc.XML_CONTAINER.value('(/OutputConfigurationSettings/DaysOfWeek)[1]', 'varchar(7)') = ''
         or oc.XML_CONTAINER.exist('(/OutputConfigurationSettings/DaysOfWeek)[contains(.,sql:variable("@dw"))]') = 1)
         and (oc.XML_CONTAINER.exist('(/OutputConfigurationSettings/StartTime)[1]') = 0
         or oc.XML_CONTAINER.value('(/OutputConfigurationSettings/StartTime)[1]', 'varchar(5)') = ''
         or oc.XML_CONTAINER.value('(/OutputConfigurationSettings/StartTime)[1]', 'time') < cast(getdate() as time))
         and (oc.XML_CONTAINER.exist('(/OutputConfigurationSettings/EndTime)[1]') = 0
         or oc.XML_CONTAINER.value('(/OutputConfigurationSettings/EndTime)[1]', 'varchar(5)') = ''
         or oc.XML_CONTAINER.value('(/OutputConfigurationSettings/EndTime)[1]', 'time') > cast(getdate() as time))
		 and (ob.NEXT_PROCESS_DT is NULL or ob.NEXT_PROCESS_DT < getdate())

   END
   ELSE IF (@BatchTypeCd = 'NTC' AND (@OutputTypeCd IN ('IH','OS','PN')))
   BEGIN   
		SELECT 
			@NotReadyCount = COUNT(N.ID) 
		from
			OUTPUT_BATCH ob 
			inner join PROCESS_LOG_ITEM pli 
                  on pli.process_log_id = ob.PROCESS_LOG_ID 
                     AND (pli.INFO_XML.exist ('(/INFO_LOG/OUTPUT_TYPE)[1]') = 0 
                     OR pli.INFO_XML.value ('(/INFO_LOG/OUTPUT_TYPE)[1]','nvarchar(10)') = @OutputTypeCd 
                     OR pli.INFO_XML.value ('(/INFO_LOG/OUTPUT_TYPE)[1]','nvarchar(10)') = '')
			inner join NOTICE n on n.id = pli.relate_id and pli.relate_type_cd = 'Allied.UniTrac.Notice'
			left outer join DOCUMENT_CONTAINER dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'Allied.UniTrac.Notice' and dc.purge_dt is null
		where	
			n.purge_dt is null 
			and pli.purge_dt is null 			
			and pli.status_cd = 'COMP'
			and ( dc.print_status_cd is null or dc.id is null or dc.print_status_cd = 'UNRES' )
			and ob.status_cd = 'PEND' 
			and ob.id = @outputBatchId
   END
   ELSE IF (@BatchTypeCd = 'RPT' )
   BEGIN   
		SELECT 
			@NotReadyCount = COUNT(RH.ID) 
		from
			OUTPUT_BATCH ob 
			inner join PROCESS_LOG_ITEM pli on pli.process_log_id = ob.process_log_id
			inner join REPORT_HISTORY rh on rh.id = pli.relate_id and pli.relate_type_cd = 'Allied.UniTrac.ReportHistory'
			left outer join DOCUMENT_CONTAINER dc on dc.id = rh.document_container_id and dc.purge_dt is null
		where	
			rh.purge_dt is null 
			and pli.purge_dt is null 
			and ( dc.print_status_cd is null or dc.id is null or dc.print_status_cd = 'UNRES' )
			and ob.status_cd = 'PEND' 
			and ob.id = @outputBatchId
   END
   ELSE IF (@BatchTypeCd = 'FPC' )
   BEGIN
		SELECT 
			@NotReadyCount = COUNT(FPC.ID) 
		from
			OUTPUT_BATCH ob 
			inner join PROCESS_LOG_ITEM pli on pli.process_log_id = ob.process_log_id
			inner join FORCE_PLACED_CERTIFICATE fpc on fpc.id = pli.relate_id and pli.relate_type_cd = 'Allied.UniTrac.ForcePlacedCertificate'
			CROSS APPLY FPC.CAPTURED_DATA_XML.nodes('//CapturedData/Owner') as O(Tab)   
			left outer join DOCUMENT_CONTAINER dc on dc.relate_id = fpc.id and dc.relate_class_name_tx = 'Allied.UniTrac.ForcePlacedCertificate' and dc.purge_dt is null
				and dc.RECIPIENT_TYPE_CD != 'LNDR'
		where	
			fpc.purge_dt is null 
			and pli.purge_dt is null 
			and pli.status_cd = 'COMP'
			and ( dc.print_status_cd is null or dc.id is null or dc.print_status_cd = 'UNRES' or fpc.PDF_GENERATE_CD in( 'PEND','RGEN','ERR'))
			and ob.status_cd = 'PEND' 
			and ob.id = @outputBatchId
			and fpc.PDF_GENERATE_CD NOT IN ('ONHO', 'VUT')
			AND O.Tab.value('@generatePDF', 'nvarchar(10)') = 'true'
			AND O.Tab.value('@lender','nvarchar(10)') = 'false'
	END	
	
	RETURN CASE WHEN @NotReadyCount=0 THEN 'Y' ELSE 'N' END
END


GO

