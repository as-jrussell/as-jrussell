USE [Unitrac_Reports]
GO
/****** Object:  StoredProcedure [dbo].[UT_GetNoticeDataPoints]    Script Date: 7/15/2017 12:22:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[UT_GetNoticeDataPoints] 
(
	@LastRun as datetime
)
AS
BEGIN
	Declare @StartDate as datetime
	Declare @EndDate as datetime

	SET NOCOUNT ON

    Set @StartDate = @LastRun
    Set @EndDate = getdate()
    
    (Select		  N.ID as NoticeKey
				  ,'UNITRAC' as RegionID
				  ,'Center' as CenterID
				  ,LDR.CODE_TX as  LenderID
				  ,BRANCH_CODE_TX as BranchID
    			  , '' as TempestID
				  , 0 as ProcessKey
				  , L.DIVISION_CODE_TX as ContractTypeKey
				  , CD.COVERAGE_CD as CoverageTypeKey
				  , Case 
				      when DC.PRINT_STATUS_CD='Printed' then 1
				      else 0
			        End as PrintAssigned
				  , 0 AS Generated
				  , Case 
			          when DC.OUTPUT_CONFIGURATION_XML.value('(//OutputConfigurationSettings/@OutputTypeCd)[1]','varchar(5)') = 'OS' then 1
			          else 0
			        End AS [Outsourced]
				  , Case 
					  when DC.PRINT_STATUS_CD='Reject' then 1
					  else 0
					End AS Rejected
				  , DC.PRINT_STATUS_ASSIGNED_DT AS StatDate
	from NOTICE N
		Join LOAN L on L.ID = N.LOAN_ID
		Join LENDER LDR on LDR.ID = L.LENDER_ID
		Join NOTICE_REQUIRED_COVERAGE_RELATE NRCR on NRCR.NOTICE_ID = N.ID
 	    JOIN REQUIRED_COVERAGE RC on RC.ID = NRCR.REQUIRED_COVERAGE_ID
		LEFT JOIN UniTrac_DW.dbo.COVERAGE_DIM CD on CD.CONTRACT_CD = L.DIVISION_CODE_TX and CD.COVERAGE_TYPE_CD = RC.TYPE_CD		
		Join DOCUMENT_CONTAINER DC on DC.RELATE_CLASS_NAME_TX = 'Allied.Unitrac.Notice' and DC.RELATE_ID = N.ID
    WHERE 
	    N.PURGE_DT is NULL
		and
		DC.PRINT_STATUS_ASSIGNED_DT >= @StartDate 
		and 
		DC.PRINT_STATUS_ASSIGNED_DT <= @EndDate
    )
	Union
	(
	Select 0,'UNITRAC', 'Center',NULL,NULL,'' as TempestID
				  , 0 as ProcessKey
				  , NULL as ContractTypeKey
				  , NULL as CoverageTypeKey
				  , 0 as PrintAssigned
				  , 0 AS Generated
				  , 0 AS [Outsourced]
				  , sum(Case when XML_Container.value('(//ConsolidateStatus/TotalNotices)[1]', 'varchar(50)') > 0 then XML_Container.value('(//ConsolidateStatus/Rejects)[1]', 'varchar(50)') 
                         else 0 End) AS Rejected
				  , convert(varchar(50),CREATE_DT,101) AS StatDate
      from OUTPUT_BATCH_LOG 
      where LOG_TXN_TYPE_CD = 'Consolidate' and XML_Container.value('(//ConsolidateStatus/Rejects)[1]', 'varchar(50)') > 0
      and CREATE_DT >= @StartDate and CREATE_DT < @EndDate
	  Group by convert(varchar(50),CREATE_DT,101)
	 )	
END

