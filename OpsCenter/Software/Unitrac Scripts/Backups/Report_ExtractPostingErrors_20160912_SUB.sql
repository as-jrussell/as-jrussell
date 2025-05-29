USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[Report_ExtractPostingErrors]    Script Date: 9/12/2016 7:19:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Report_ExtractPostingErrors] 
(	
    @ReportType as nvarchar(50)=NULL,
	@ReportConfig as varchar(50)=NULL,
	@WorkItemID as bigint=NULL,
	@DocumentID as bigint=NULL,
	@Report_History_ID as bigint=NULL
)
AS


BEGIN

IF OBJECT_ID(N'tempdb..#tmpTable',N'U') IS NOT NULL
  DROP TABLE #tmpTable
IF OBJECT_ID(N'tempdb..#tmpfilter',N'U') IS NOT NULL
  DROP TABLE #tmpfilter
IF OBJECT_ID(N'tempdb..#tmpErrorDetails',N'U') IS NOT NULL
  DROP TABLE #tmpErrorDetails

Declare @GroupBySQL as varchar(1000)
Declare @SortBySQL as varchar(1000)
Declare @FilterBySQL as varchar(1000)
Declare @HeaderTx as varchar(1000)
Declare @FooterTx as varchar(1000)
Declare @RecordCount as bigint
Declare @sqlstring as nvarchar(3000)
DECLARE @DEBUGGING as char(1) = 'F'  

--DECLARE @WorkItemID as bigint = null
DECLARE @ApproveDt as datetime2(7)= null
DECLARE @ImportCompletedDt as datetime2(7)= null

IF (@WorkItemID IS NULL OR @WorkItemID = 0)
BEGIN
	SELECT @WorkItemID = WI.ID from DOCUMENT D
	JOIN [MESSAGE] M ON D.MESSAGE_ID = M.ID AND M.PURGE_DT IS NULL
	JOIN WORK_ITEM WI ON M.ID = WI.RELATE_ID AND WI.RELATE_TYPE_CD = 'LDHLib.Message'
	WHERE D.ID = @DocumentID
END

select @ApproveDt = CREATE_DT from WORK_ITEM_ACTION where WORK_ITEM_ID = @WorkItemID and ACTION_CD = 'Approve'
select @ImportCompletedDt = CREATE_DT from WORK_ITEM_ACTION where WORK_ITEM_ID = @WorkItemID and ACTION_CD = 'Import Completed'


CREATE TABLE [dbo].[#tmpfilter](
	[ATTRIBUTE_CD] [nvarchar](50) NULL,
	[VALUE_TX] [nvarchar](50) NULL
) ON [PRIMARY]


Insert into #tmpfilter (
	ATTRIBUTE_CD,
	VALUE_TX)
Select
RAD.ATTRIBUTE_CD,
Case
  when Custom.VALUE_TX is not NULL then Custom.VALUE_TX
  when RA.VALUE_TX is not NULL then RA.VALUE_TX
  else RAD.VALUE_TX
End as VALUE_TX
from REF_CODE RC
Join REF_CODE_ATTRIBUTE RAD on RAD.DOMAIN_CD = RC.DOMAIN_CD and RAD.REF_CD = 'DEFAULT' and RAD.ATTRIBUTE_CD like 'FIL%'
left Join REF_CODE_ATTRIBUTE RA on RA.DOMAIN_CD = RC.DOMAIN_CD and RA.REF_CD = RC.CODE_CD and RA.ATTRIBUTE_CD = RAD.ATTRIBUTE_CD
left Join
  (
  Select CODE_TX,REPORT_CD,REPORT_DOMAIN_CD,REPORT_REF_ATTRIBUTE_CD,VALUE_TX from REPORT_CONFIG RC
  Join REPORT_CONFIG_ATTRIBUTE RCA on RCA.REPORT_CONFIG_ID = RC.ID
  ) Custom
   on Custom.CODE_TX = @ReportConfig and Custom.REPORT_DOMAIN_CD = RAD.DOMAIN_CD and Custom.REPORT_REF_ATTRIBUTE_CD = RAD.ATTRIBUTE_CD --and Custom.REPORT_CD = @ReportConfig
where RC.DOMAIN_CD = 'Report_Extract' and RC.CODE_CD = @ReportType

Select @HeaderTx=HEADER_TX from REPORT_CONFIG where REPORT_DOMAIN_CD = 'Report_Extract' and CODE_TX = @ReportConfig
Select @FooterTx=FOOTER_TX from REPORT_CONFIG where REPORT_DOMAIN_CD = 'Report_Extract' and CODE_TX = @ReportConfig



CREATE TABLE [dbo].[#tmpTable](
	[POSTING_DT] datetime2(7) NULL,
	[LENDER_NAME_TX] [nvarchar](300) NULL,
	[LENDER_CODE_TX] [nvarchar](100) NULL,
	[LOAN_NUMBER_TX] [nvarchar](100) NULL,
	[ERROR_MSG_TX] [nvarchar](1000) NULL,
	[WORK_ITEM_ID] bigint NULL,
	[APPROVE_DT] datetime2(7) NULL,
	[IMPORT_COMPLETED_DT] datetime2(7) NULL,
	--PARAMETERS
	[REPORT_GROUPBY_TX] [nvarchar](1000) NULL,
	[REPORT_SORTBY_TX] [nvarchar](1000) NULL,
	[REPORT_HEADER_TX] [nvarchar](1000) NULL,
	[REPORT_FOOTER_TX] [nvarchar](1000) NULL)


      SELECT
			CAST(PLI.CREATE_DT AS date) POSTING_DT
            ,TP.EXTERNAL_ID_TX as LENDER_CD
			,TP.NAME_TX AS LENDER_NAME_TX
            ,PLI.INFO_XML.value('(/INFO_LOG/RELATE_INFO)[1]' , 'NVARCHAR(30)')       AS LOAN_NUMBER_TX
            ,PLI.INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]' , 'NVARCHAR(1000)')           AS ERROR_MSG_TX
            ,WI.ID AS WORK_ITEM_ID
            ,PLI.INFO_XML.value('(/INFO_LOG/STACK_TRACE_LOG)[1]' , 'NVARCHAR(MAX)') AS ERROR_DETAILS_TX
      INTO #tmpErrorDetails
      FROM
            WORK_ITEM WI (NOLOCK)
            CROSS APPLY WI.CONTENT_XML.nodes('/Content/Information/ProcessLogs/ProcessLog') AS P (TAB)
            JOIN PROCESS_LOG_ITEM PLI (NOLOCK) ON P.TAB.value('@Id' , 'BIGINT') = PLI.PROCESS_LOG_ID
            CROSS APPLY PLI.INFO_XML.nodes('/INFO_LOG/RELATE_INFO') AS PLI_INFO (TAB)
            JOIN [MESSAGE] M ON WI.RELATE_ID = M.id
			JOIN TRADING_PARTNER TP ON TP.id = M.RECIPIENT_TRADING_PARTNER_ID
      WHERE
            WI.ID = @WorkItemID and
            PLI.STATUS_CD = 'ERR' and
            PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan'
 
        
 INSERT INTO #tmpTable (POSTING_DT, LENDER_CODE_TX, LENDER_NAME_TX, LOAN_NUMBER_TX, ERROR_MSG_TX, WORK_ITEM_ID, APPROVE_DT, IMPORT_COMPLETED_DT)
      SELECT TED.POSTING_DT 
            ,TED.LENDER_CD
            ,TED.LENDER_NAME_TX
            ,TED.LOAN_NUMBER_TX
            ,TED.ERROR_MSG_TX
            ,TED.WORK_ITEM_ID
			,@ApproveDt AS APPROVE_DT
            ,@ImportCompletedDt AS IMPORT_COMPLETED_DT
      FROM
            #tmpErrorDetails TED
      WHERE
            (TED.ERROR_MSG_TX IS NOT NULL
            AND LEN(TED.ERROR_MSG_TX) > 0
            AND TED.ERROR_DETAILS_TX IS NOT NULL
            AND LEN(TED.ERROR_DETAILS_TX) > 0)
      ORDER BY
            TED.LOAN_NUMBER_TX

	 INSERT INTO #tmpTable (POSTING_DT, LENDER_CODE_TX, LENDER_NAME_TX, LOAN_NUMBER_TX, ERROR_MSG_TX, WORK_ITEM_ID, APPROVE_DT, IMPORT_COMPLETED_DT)
			SELECT distinct TED.POSTING_DT 
            ,TED.LENDER_CD
            ,TED.LENDER_NAME_TX
            ,TED.LOAN_NUMBER_TX
            ,TED.ERROR_MSG_TX
            ,TED.WORK_ITEM_ID
			,@ApproveDt AS APPROVE_DT
            ,@ImportCompletedDt AS IMPORT_COMPLETED_DT
      FROM
            #tmpErrorDetails TED
      WHERE
            TED.ERROR_MSG_TX IS NOT NULL
            AND LEN(TED.ERROR_MSG_TX) > 0
            AND (TED.ERROR_DETAILS_TX is NULL or LEN(TED.ERROR_DETAILS_TX) = 0)
			AND TED.LOAN_NUMBER_TX NOT IN (SELECT LOAN_NUMBER_TX from #tmpTable)
			AND  REPLACE(UPPER(LTRIM(RTRIM(TED.ERROR_MSG_TX))),CHAR(10), '')  NOT IN ('NEW', 'UPDATE') 

select @RecordCount = @@ROWCOUNT

declare @setstring nvarchar(4000) = ''

set @setstring = @setstring + CASE When ISNULL(@HeaderTx,'') <> ''
                      then case when @setstring <> '' then ',' else '' end
                          + '[REPORT_HEADER_TX] = ' + @HeaderTx
                      else '' end
set @setstring = @setstring+ CASE When ISNULL(@FooterTx,'') <> ''
                      then case when @setstring <> '' then ',' else '' end
                          + '[REPORT_FOOTER_TX] = ' + @FooterTx
                      else '' end
if @setstring <> ''
begin
	set @sqlstring = N'Update #tmpTable set ' + @setstring
	EXECUTE sp_executesql @sqlstring
end

IF @Report_History_ID IS NOT NULL
BEGIN

  Update [UNITRAC-REPORTS].[UNITRAC].DBO.REPORT_HISTORY_NOXML
  Set RECORD_COUNT_NO = @RecordCount
  where ID = @Report_History_ID

END

IF NOT @DEBUGGING = 'T'
BEGIN
	Select * from #tmpTable 
END            
END

GO

