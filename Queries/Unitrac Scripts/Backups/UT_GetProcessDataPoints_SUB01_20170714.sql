USE [Unitrac_Reports]
GO
/****** Object:  StoredProcedure [dbo].[UT_GetProcessDataPoints]    Script Date: 7/15/2017 12:22:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[UT_GetProcessDataPoints] 
(
    @LastRun AS DATETIME
)
AS
BEGIN
    Declare @StartDate as datetime
    Declare @EndDate as datetime
    declare @regionId as nvarchar(50) 

    SET NOCOUNT ON

    Set @StartDate = @LastRun
    Set @EndDate = getdate() 
    
/*
CREATE TABLE [dbo].[#tmpProcessDataPoints](
	[ProcessKey] [int] NULL,
	[PCDKey] [int] NOT NULL,
	[RegionID] [varchar](10) NULL,
	[CenterID] [varchar](10) NULL,
	[LenderID] [varchar](10) NULL,
	[BranchID] [varchar](10) NULL,
	[ContractTypeKey] [int] NOT NULL,
	[CoverageTypeKey] [int] NULL,
	[ElapsedTime] [bigint] NULL,
	[ProcessRan] [int] NULL,
	[RanInBatchTime] [int] NULL,
	[GeneratedReports] [int] NULL,
	[GeneratedNotices] [int] NULL,
	[GeneratedCerts] [int] NULL,
	[ElapsedReportRun] [int] NULL,
	[CompleteCount] [int] NULL,
	[WarningCount] [int] NULL,
	[ErrorCount] [int] NULL,
	[StatDate] [datetime] NULL
)

		Insert into #tmpProcessDataPoints (ProcessKey,PCDKey,RegionID,CenterID,LenderID,BranchID,ContractTypeKey,CoverageTypeKey,
				ElapsedTime,ProcessRan,RanInBatchTime,GeneratedReports,GeneratedNotices,GeneratedCerts,ElapsedReportRun,
				CompleteCount,WarningCount,ErrorCount,StatDate)
*/				
				
Select 
convert(int,PL.ID) as ProcessKey,7 as PCDKey,
'Unitrac' as RegionID,'Unitrac' as CenterID,max(PInfo.LENDER_TX) as LenderID,max(PInfo.BRANCH_TX) as BranchID,max(PInfo.DIVISION_TX) as ContractTypeKey,-1 as CoverageTypeKey,
isnull(DATEDIFF(SECOND,PL.START_DT,PL.END_DT),0) as ElapsedTime,1 as ProcessRan,1 as RaninBatchTime,
sum(Case when PLI.RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory' then 1 else 0 End) as GeneratedReports,
sum(Case when PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Notice' then 1 else 0 End) as GeneratedNotices,
sum(Case when PLI.RELATE_TYPE_CD = 'Allied.UniTrac.ForcePlacedCertificate' then 1 else 0 End) as GeneratedCerts,
convert(int,isnull(SUM(RH.ELAPSED_RUNTIME_NO),0)) as ElapsedReportRun,
1 as CompleteCount,0 as WarningCount,0 as ErrorCount,PL.START_DT as StatDate
from PROCESS_LOG PL
Join PROCESS_DEFINITION PD on PD.ID = PL.PROCESS_DEFINITION_ID
Join PROCESS_LOG_ITEM PLI on PLI.PROCESS_LOG_ID = PL.ID
left Join 
(
Select  distinct P.ID,L.CODE_TX as LENDER_TX,LO1.CODE_TX as DIVISION_TX,LO2.CODE_TX as BRANCH_TX
FROM   PROCESS_DEFINITION P 
CROSS APPLY SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LCGCTList/LCGCTId') as T2(Loc) 
Join LENDER_COLLATERAL_GROUP_COVERAGE_TYPE LCGCT on LCGCT.ID = T2.Loc.value('.','bigint')
Join LENDER_PRODUCT LP on LP.ID = LCGCT.LENDER_PRODUCT_ID
Join LENDER_ORGANIZATION LO1 on LO1.ID = LCGCT.DIVISION_LENDER_ORG_ID
Join LENDER_ORGANIZATION LO2 on LO2.ID = LCGCT.BRANCH_LENDER_ORG_ID
Join LENDER L on L.ID = LP.LENDER_ID
) as PInfo on PInfo.ID = PD.ID
left Join REPORT_HISTORY RH on RH.ID = PLI.RELATE_ID and PLI.RELATE_TYPE_CD = 'Allied.Unitrac.ReportHistory'
where START_DT > @StartDate and START_DT < @EndDate and PD.PROCESS_TYPE_CD = 'CYCLEPRC'
Group by PL.ID,PL.START_DT,DATEDIFF(SECOND,PL.START_DT,PL.END_DT)


/*
	select cast([ProcessKey] as int) as ProcessKey,[PCDKey],[RegionID],[CenterID],[LenderID],[BranchID],[ContractTypeKey],[CoverageTypeKey],[StatDate],
                        cast(sum([ElapsedTime]) as bigint) as ElapsedTime,sum([ProcessRan]) as ProcessRan,sum([RanInBatchTime]) as RanInBatchTime,sum([GeneratedReports]) as GeneratedReports,
                        sum([GeneratedNotices]) as GeneratedNotices,sum([GeneratedCerts]) as GeneratedCerts, cast(sum([ElapsedReportRun]) as int) as ElapsedReportRun,sum([CompleteCount]) as CompleteCount,sum([WarningCount]) as WarningCount,sum([ErrorCount]) as ErrorCount
    from #tmpProcessDataPoints
    Group by [ProcessKey],[PCDKey],[RegionID],[CenterID],[LenderID],[BranchID],[ContractTypeKey],[CoverageTypeKey],[StatDate]
*/

END


