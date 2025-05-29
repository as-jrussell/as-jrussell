USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[UT_Active_Reports_Complete]    Script Date: 9/18/2017 7:43:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[UT_Active_Reports_Complete] 

as

SET NOCOUNT ON


Declare @ID varchar(10)
Declare @NAME_TX varchar(100)
DECLARE @PendingCount NVARCHAR(255)
Declare @body as varchar(6000)

Set @body = ''

SELECT DISTINCT
	REPORT_ID,
	REPORT_DOMAIN_CD INTO #tmptable
FROM REPORT_CONFIG  

Create Table #tmpReport
(ID varchar(10),
NAME_TX varchar(100),
 PendingCount NVARCHAR(255))

Insert  #tmpReport (ID, NAME_TX, PendingCount)
SELECT rh.REPORT_ID, tt.REPORT_DOMAIN_CD, COUNT(*) PendingCount FROM REPORT_HISTORY rh 
JOIN #tmptable tt	ON rh.REPORT_ID = tt.REPORT_ID WHERE STATUS_CD = 'COMP'  AND 
CAST(rh.UPDATE_DT AS DATE) >= CAST(GETDATE() AS DATE)  AND rh.GENERATION_SOURCE_CD = 'u'
GROUP BY rh.REPORT_ID,tt.REPORT_DOMAIN_CD 



DECLARE CursorVar CURSOR
READ_ONLY 
FOR
Select NAME_TX,  PendingCount from #tmpReport

OPEN CursorVar
Fetch CursorVar into @NAME_TX,@PendingCount

While @@Fetch_Status = 0
Begin
set @body = @body + ' '+@NAME_TX+', '+@PendingCount+ char(13)+ char(10)

Fetch Next from CursorVar into @NAME_TX,@PendingCount
End
Close CursorVar
DEALLOCATE CursorVar

if @body <> ''
Begin
	set @body = 'Report_Name/Count in Staging (Complete): ' + char(13)+ char(10) + 
	@body 
           EXEC UT_Reports_Email @Body
--Print @body
end

drop table #tmpReport
GO

