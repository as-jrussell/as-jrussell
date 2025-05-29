USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[UT_InboundProcessing]    Script Date: 9/25/2018 8:32:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--exec UT_InboundProcessing


ALTER  PROCEDURE [dbo].[UT_InboundProcessing] 

as

SET NOCOUNT ON

Declare @Code varchar(10)
Declare @NAME_TX varchar(6000)
Declare @body as varchar(6000)

SET @body = ''

--DROP TABLE #temp20Lenders;
SELECT rdd.ID RelatedDataId,
       l.ID LenderId
INTO #temp20Lenders
FROM RELATED_DATA_DEF rdd
    INNER JOIN LENDER l
        ON 1 = 1
WHERE rdd.NAME_TX = 'UTL2.0'
      AND l.TEST_IN = 'N'
      AND l.PURGE_DT IS NULL
	  and l.status_cd ='Active'
	  and CAST(L.CREATE_DT AS DATE) < CAST(GETDATE()-21 AS DATE);


Create Table #tmpProcess
( [Lender Code] VARCHAR(10),
[Lender Name] varchar(100))

Insert  #tmpProcess ([Lender Code], [Lender Name])
select L.CODE_TX, L.NAME_TX from #temp20Lenders T
left join RELATED_DATA rd on t.lenderid = rd.RELATE_ID AND rd.DEF_ID = '183'
join lender l on l.id = t.lenderid 
where rd.id is null 

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
	set @body = 'Lenders not yet added to the UTL 2.0: ' + char(13)+ char(10) + 
	@body + '
Please reach out to the Ins Apps team to verify if this lender needs to be added. If you unsure how to add lenders to UTL please refer to the following link in Connections:  http://connections.alliedsolutions.net/forums/html/topic?id=48071141-cd1d-45af-b4ac-0c7a692db3dc&ps=25
'
          EXEC UT_Processing_Email @Body
--Print @body
end

drop table #tmpProcess


GO

