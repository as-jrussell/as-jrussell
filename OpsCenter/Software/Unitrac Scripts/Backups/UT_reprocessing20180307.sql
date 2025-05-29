USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[UT_InboundReprocessing]    Script Date: 3/7/2018 8:48:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER  PROCEDURE [dbo].[UT_InboundReprocessing] 

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
WHERE    L.CREATE_DT > GETDATE() - 7 AND 
 L.TEST_IN = 'N' and L.PURGE_DT is null	
        AND L.STATUS_CD NOT  IN ( 'CANCEL', 'SUSPEND', 'MERGED' )
ORDER BY L.CREATE_DT ,
        L.CODE_TX DESC

--DROP TABLE #tmpLCGCTIc
SELECT P.TAB.value('.', 'nvarchar(max)') AS LCGCTId, pd.ID AS ProcId
INTO #tmpLCGCTIc
FROM PROCESS_DEFINITION pd 
CROSS APPLY pd.SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LenderList/LenderID') AS P (TAB)
WHERE PROCESS_TYPE_CD = 'UTLIBREPRC'
 AND ACTIVE_IN = 'Y'
AND EXECUTION_FREQ_CD != 'RUNONCE'

--DROP TABLE #reprocess
SELECT
DISTINCT
	LDR.CODE_TX,
	LDR.NAME_TX,
	PD.ID ProcessDefID,
	pd.EXECUTION_FREQ_CD, 
	pd.FREQ_MULTIPLIER_NO,
	SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]', 'nvarchar(max)') AS ServiceName,
	PD.STATUS_CD
	INTO #reprocess
FROM PROCESS_DEFINITION PD
JOIN #tmpLCGCTIc tpc ON tpc.ProcId = PD.ID
JOIN LENDER LDR ON LDR.CODE_TX = tpc.LCGCTId
WHERE PROCESS_TYPE_CD = 'UTLIBREPRC'
 AND ACTIVE_IN = 'Y'
AND EXECUTION_FREQ_CD != 'RUNONCE'
ORDER BY ServiceName

Create Table #tmpReprocessing
( [Lender Code] VARCHAR(10),
[Lender Name] varchar(100),
[Lender Status] NVARCHAR(255),
 [Inbound Reprocessing] NVARCHAR(255),
 [Process Type] NVARCHAR(255)
 )

Insert  #tmpReprocessing ([Lender Code], [Lender Name], [Lender Status] ,[Inbound Reprocessing], [Process Type])
 SELECT T.[Lender Code], T.[Lender Name], T.[Lender Status] , 'Inbound Reprocessing', 'UTLIBREPRC'
FROM  #TMPNEWLENDERINFO T
LEFT JOIN #reprocess R ON R.CODE_TX = T.[Lender Code]
WHERE R.CODE_TX IS NULL 

DECLARE CursorVar CURSOR
READ_ONLY 
FOR
Select [Lender Code], [Lender Name], [Lender Status] ,[Inbound Reprocessing], [Process Type] from #tmpReprocessing

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
	set @body = 'Missing Lenders from Reprocessing: ' + char(13)+ char(10) + 
	@body + '

Please followup with the business to ensure that this needs to be added. If you are unsure how to add the lenders the following link to assist: http://connections.alliedsolutions.net/forums/html/topic?id=a5b38271-a33c-4386-99d6-edab06f0c867&ps=100 '
           EXEC UT_Processing_Email @Body
--Print @body
end

drop table #tmpReprocessing

GO

