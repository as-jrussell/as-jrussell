USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[UT_GoodThru]    Script Date: 5/29/2018 8:36:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER  PROCEDURE [dbo].[UT_GoodThru] 

as

SET NOCOUNT ON


Declare @Code varchar(10)
Declare @NAME_TX varchar(6000)
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
WHERE   L.TEST_IN = 'N' and L.PURGE_DT is null	
        AND L.STATUS_CD NOT  IN ( 'CANCEL', 'SUSPEND', 'MERGED' )
ORDER BY L.CREATE_DT ,
        L.CODE_TX DESC

		--DROP TABLE #tmpLCGCTId
SELECT 
 P.SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]',
                              'nvarchar(max)') [LenderCode],  *
INTO #GoodTHruPD
FROM  dbo.PROCESS_DEFINITION P
WHERE P.PROCESS_TYPE_CD = 'GOODTHRUDT'
AND P.LOAD_BALANCE_IN = 'Y'
AND P.PURGE_DT is null


	

Create Table #tmpProcess
( [Lender Code] VARCHAR(10),
[Lender Name] varchar(100)
 )

Insert  #tmpProcess ([Lender Code], [Lender Name])
SELECT [Lender Code], [Lender Name]
 FROM #TMPNEWLENDERINFO T
LEFT JOIN #GoodTHruPD G ON T.[Lender Code] = G.LenderCode
WHERE G.ID IS NULL 

DECLARE CursorVar CURSOR
READ_ONLY 
FOR
Select [Lender Code], [Lender Name] from #tmpProcess

OPEN CursorVar
Fetch CursorVar into 
@Code,@NAME_TX
While @@Fetch_Status = 0
Begin
set @body = @body + ' '+  @Code+ ' '+@NAME_TX+' 

'

Fetch Next from CursorVar into @Code, @NAME_TX
End
Close CursorVar
DEALLOCATE CursorVar

if @body <> ''
Begin
	set @body = 'Lenders that need to be added to GoodThru: ' + char(13)+ char(10) + 
	@body + '

'
          EXEC UT_Processing_GoodThru @Body
--Print @body
end

drop table #tmpProcess

