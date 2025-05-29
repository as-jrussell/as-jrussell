USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[UT_InboundProcessing]    Script Date: 3/13/2018 9:53:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE  PROCEDURE [dbo].[UT_InboundProcessing] 

as

SET NOCOUNT ON


Declare @Code varchar(10)
Declare @NAME_TX varchar(6000)
DECLARE @Status NVARCHAR(255)
DECLARE @Inbound NVARCHAR(255)
DECLARE @ProcessType NVARCHAR(255)
Declare @body as varchar(6000)

SET @body = ''

--DROP TABLE #TMPNEWLENDERINFO
 SELECT  L.CODE_TX AS 'Lender Code' ,
        L.NAME_TX AS 'Lender Name' ,
        L.AGENCY_ID AS 'Agency' ,
        L.TAX_ID_TX AS 'Tax ID' ,
        L.CREATE_DT AS 'Create Date' ,
        L.STATUS_CD AS 'Lender Status' ,
        L.ACTIVE_DT AS 'Active Date' ,
        L.CANCEL_DT AS 'Cancelled Date' ,
        L.ID AS 'UniTrac Code' 
INTO    #TMPNEWLENDERINFO
FROM    LENDER L
JOIN dbo.LENDER_PRODUCT LP ON LP.LENDER_ID = L.ID
WHERE    L.CREATE_DT > GETDATE() -7 AND 
 L.TEST_IN = 'N' and L.PURGE_DT is null	
        AND L.STATUS_CD NOT  IN ( 'CANCEL', 'SUSPEND', 'MERGED' )
		AND LP.BASIC_TYPE_CD NOT IN ('ORDERUP', 'VSI')
ORDER BY L.CREATE_DT ,
        L.CODE_TX DESC

		--DROP TABLE #tmpLCGCTId
SELECT P.TAB.value('.', 'nvarchar(max)') AS LCGCTId, pd.ID AS ProcId
INTO #tmpLCGCTId
FROM PROCESS_DEFINITION pd 
CROSS APPLY pd.SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LenderList/LenderID') AS P (TAB)
WHERE PROCESS_TYPE_CD = 'UTLMTCHIB'
 AND ACTIVE_IN = 'Y'
AND EXECUTION_FREQ_CD != 'RUNONCE'

--drop table #process
SELECT
DISTINCT
	LDR.CODE_TX,
	LDR.NAME_TX,
	PD.ID ProcessDefID,
	pd.EXECUTION_FREQ_CD, 
	pd.FREQ_MULTIPLIER_NO,
	SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]', 'nvarchar(max)') AS ServiceName,
	PD.STATUS_CD
	INTO #process
FROM PROCESS_DEFINITION PD
JOIN #tmpLCGCTId tpc ON tpc.ProcId = PD.ID
JOIN LENDER LDR ON LDR.CODE_TX = tpc.LCGCTId
WHERE PROCESS_TYPE_CD = 'UTLMTCHIB'
 AND ACTIVE_IN = 'Y'
AND EXECUTION_FREQ_CD != 'RUNONCE'
ORDER BY [ServiceName]
	

Create Table #tmpProcess
( [Lender Code] VARCHAR(10),
[Lender Name] varchar(100),
[Lender Status] NVARCHAR(255),
 [Inbound Reprocessing] NVARCHAR(255),
 [Process Type] NVARCHAR(255)
 )

Insert  #tmpProcess ([Lender Code], [Lender Name], [Lender Status] ,[Inbound Reprocessing], [Process Type])
 SELECT T.[Lender Code], T.[Lender Name], T.[Lender Status] , 'Inbound Processing', 'UTLIBREPRC'
FROM  #TMPNEWLENDERINFO T
LEFT JOIN #Process R ON R.CODE_TX = T.[Lender Code]
WHERE R.CODE_TX IS NULL 

DECLARE CursorVar CURSOR
READ_ONLY 
FOR
Select [Lender Code], [Lender Name], [Lender Status] ,[Inbound Reprocessing], [Process Type] from #tmpProcess

OPEN CursorVar
Fetch CursorVar into 
@Code,@NAME_TX,@Status, @Inbound , @ProcessType
While @@Fetch_Status = 0
Begin
set @body = @body + ' '+  @Code+ ' '+@NAME_TX+' '+ @Status+' '+ @Inbound +' '+ @ProcessType+' '+' 
'

Fetch Next from CursorVar into @Code, @NAME_TX, @Status, @Inbound , @ProcessType 
End
Close CursorVar
DEALLOCATE CursorVar

if @body <> ''
Begin
	set @body = 'Missing Lenders from Processing: ' + char(13)+ char(10) + 
	@body + '

If you are unsure how to add the lenders the following link to assist: http://connections.alliedsolutions.net/forums/html/topic?id=a5b38271-a33c-4386-99d6-edab06f0c867&ps=100 '
           EXEC UT_Processing_Email @Body
--Print @body
end

drop table #tmpProcess


GO

