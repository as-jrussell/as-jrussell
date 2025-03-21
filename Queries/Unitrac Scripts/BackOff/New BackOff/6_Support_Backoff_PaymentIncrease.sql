USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[Support_Backoff_PaymentIncrease]    Script Date: 12/19/2017 7:27:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DECLARE

@workitemid as bigint

	
	SET NOCOUNT ON
	
    Declare @processLogId as bigint
    Declare @processDefinitionsId as bigint
    Declare @processDate as datetime

SET @workitemid =  
    
    SELECT @processLogId = WI.RELATE_ID , 
    @processDefinitionsId = PL.PROCESS_DEFINITION_ID ,
    @processDate = CONVERT(VARCHAR(10), PL.START_DT , 101 )
    FROM WORK_ITEM WI JOIN PROCESS_LOG PL ON PL.ID = WI.RELATE_ID
    WHERE WI.ID = @workitemid
    
    IF OBJECT_ID(N'tempdb..#tmpLCGCT',N'U') IS NOT NULL
       DROP TABLE #tmpLCGCT   
       
	Create Table #tmpLCGCT
	(	
	  LCGCTId bigint
    )
    
    Insert into #tmpLCGCT (LCGCTId)
	select Cycle.Col.value('.','bigint') as LCGCTId 
	FROM PROCESS_DEFINITION PD
	CROSS APPLY PD.SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LCGCTList/LCGCTId') as Cycle(Col)	
	where PD.ID = @processDefinitionsId
	
	update fpc set PIR_DT = NULL , UPDATE_DT = GETDATE(), 
	UPDATE_USER_TX = 'CYCBACKOFF' , LOCK_ID = (fpc.LOCK_ID % 255) + 1
	--SELECT lcgct.* 
	from FORCE_PLACED_CERTIFICATE fpc
    join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE rel on rel.FPC_ID = fpc.ID
    and fpc.PURGE_DT is null and rel.PURGE_DT is null
    join REQUIRED_COVERAGE rc on rc.ID = rel.REQUIRED_COVERAGE_ID
    and rc.PURGE_DT is null 
    join #tmpLCGCT lcgct on lcgct.LCGCTId = rc.LCGCT_ID
    where fpc.PIR_DT >= @processDate
    
    IF OBJECT_ID(N'tempdb..#tmpFPC',N'U') IS NOT NULL
       DROP TABLE #tmpFPC   
       
	Create Table #tmpFPC
	(	
	  FPC_ID bigint
    )
    
    Insert into #tmpFPC
    (
      FPC_ID
    )
    select fpc.ID
    from FORCE_PLACED_CERTIFICATE fpc
    join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE rel on rel.FPC_ID = fpc.ID
    and fpc.PURGE_DT is null and rel.PURGE_DT is null
    join REQUIRED_COVERAGE rc on rc.ID = rel.REQUIRED_COVERAGE_ID
    and rc.PURGE_DT is null 
    join #tmpLCGCT lcgct on lcgct.LCGCTId = rc.LCGCT_ID
    where fpc.PAYMENT_REPORT_DT >= @processDate
    
    Update fpc set PAYMENT_REPORT_CD = NULL , PAYMENT_REPORT_DT = NULL , 
    UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'UNITRAC' , 
    LOCK_ID = (fpc.LOCK_ID % 255) + 1
   	--SELECT #tmpFPC.* 
    from FORCE_PLACED_CERTIFICATE fpc join #tmpFPC on 
    #tmpFPC.FPC_ID = fpc.ID where fpc.PAYMENT_REPORT_CD in ('I' , 'B' , 'X' )
    
    Update fpc set PAYMENT_REPORT_CD = 'I' , PAYMENT_REPORT_DT = fpc.ISSUE_DT , 
    UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'UNITRAC' , 
    LOCK_ID = (fpc.LOCK_ID % 255) + 1
	--SELECT #tmpFPC.* 
    from FORCE_PLACED_CERTIFICATE fpc join #tmpFPC on 
    #tmpFPC.FPC_ID = fpc.ID where fpc.PAYMENT_REPORT_CD = 'C'
    


