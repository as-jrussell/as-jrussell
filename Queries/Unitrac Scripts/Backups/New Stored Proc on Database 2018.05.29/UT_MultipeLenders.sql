USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[UT_GoodThru]    Script Date: 5/29/2018 8:36:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





alter  PROCEDURE [dbo].[UT_MultipeLenders] 

as

SET NOCOUNT ON


Declare @Code varchar(10)
Declare @NAME_TX varchar(6000)
Declare @ID varchar(6000)
Declare @Count varchar(6000)
Declare @body as varchar(6000)

SET @body = ''



Create Table #tmpProcess
( [Lender Code] VARCHAR(10),
[Lender Name] varchar(100),
[Lender Id] varchar(100),
[Count] varchar(100)
 )

Insert  #tmpProcess ([Lender Code], [Lender Name], [Lender Id], [Count])
select  L.CODE_TX,  L.NAME_TX, L.ID,  COUNT(L.NAME_TX) [Count]
FROM RELATED_DATA rd
    INNER JOIN LENDER l
        ON l.ID = rd.RELATE_ID
           AND rd.DEF_ID = '183'
where L.PURGE_DT is NULL and L.TEST_IN = 'N' and 
rd.END_DT is  null
group by  L.NAME_TX, L.CODE_TX, L.id
having COUNT(L.NAME_TX) >= '2'


DECLARE CursorVar CURSOR
READ_ONLY 
FOR
Select [Lender Code], [Lender Name], [Lender Id], [Count] from #tmpProcess

OPEN CursorVar
Fetch CursorVar into 
@Code, @NAME_TX, @ID, @Count
While @@Fetch_Status = 0
Begin
set @body = @body + ' '+  @Code+ ' '+@ID+' '+  @Name_tx+ ' '+@Count+' 

'

Fetch Next from CursorVar into @Code, @NAME_TX, @ID, @Count
End
Close CursorVar
DEALLOCATE CursorVar

if @body <> ''
Begin
	set @body = 'Lenders that have more than one entry for UTL: ' + char(13)+ char(10) + 
	@body + '

'
+
'Please go to the following link for ways to resolve this issue: http://connections.alliedsolutions.net/forums/html/topic?id=48071141-cd1d-45af-b4ac-0c7a692db3dc'

          EXEC UT_Processing_Stored @Body
--Print @body
end

drop table #tmpProcess

