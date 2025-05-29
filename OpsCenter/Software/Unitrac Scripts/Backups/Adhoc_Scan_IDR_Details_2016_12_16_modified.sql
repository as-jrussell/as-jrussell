USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[Adhoc_Scan_IDR_Details]    Script Date: 12/19/2016 4:51:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER    procedure [dbo].[Adhoc_Scan_IDR_Details] 
(
@md AS nVARCHAR(10)='Day', 
@Increment AS INT= 1
)

AS



--Get rid of residual #temp tables
IF OBJECT_ID(N'tempdb..#tmpScan',N'U') IS NOT NULL
  DROP TABLE #tmpScan
--Get rid of residual #temp tables
IF OBJECT_ID(N'tempdb..#tmpScanCount',N'U') IS NOT NULL
  DROP TABLE #tmpScanCount
  
--if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[#tmpScan]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
--drop table #tmpScan

--if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[#tmpScanCount]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
--drop table #tmpScanCount

--Declare @md as varchar(10)
--set @md = 'Day'
--set @md = 'Week'
--set @md = 'Month'
Set nocount on

--Need to Add lkuScanQueueTypes (FaxQueue) and also on the insert into ScanBatch
Select ScanBatch.LenderKey,isnull(FTPDescription,isnull(lkuScanQueueTypes.Description,'FaxQueue')) as FTPDescription,sum(isnull(ScannedDocumentCount,0)) as SubTotal into #tmpScanCount 
from vut..ScanBatch
left Join vut..lkuScanQueueTypes on lkuScanQueueTypes.QueueType = ScanBatch.QueueType
Left Join vut..tblScanOptions on intkey = intftpkey
where Scanbatch.BatchType = 3  and 
(@md = 'Day' and datediff(d,batchdate,getdate()) = @Increment)		--0
or
(@md = 'Week' and datediff(wk,batchdate,getdate()) = @Increment)		--1
or
(@md = 'Month' and datediff(mm,batchdate,getdate()) = @Increment)	--1
Group by ScanBatch.LenderKey,FTPDescription,isnull(FTPDescription,isnull(lkuScanQueueTypes.Description,'FaxQueue'))

Select LenderKey,sum(ScannedDocumentCount) as SubTotal into #tmpScan from vut..ScanBatch
where ScanBatch.BatchType = 3 and 
(@md = 'Day' and datediff(d,batchdate,getdate()) = @Increment)			--0
or
(@md = 'Week' and datediff(wk,batchdate,getdate()) = @Increment)			--1
or
(@md = 'Month' and datediff(mm,batchdate,getdate()) = @Increment)		--1
Group by ScanBatch.LenderKey

--Select * from #tmpScan	--TEST

DECLARE CursorVar CURSOR
FAST_FORWARD 
FOR
Select distinct REPLACE(REPLACE(isnull(FTPDescription,isnull(Description,'FaxQueue')),' ','_'),'-','_') as FTPDescription from vut..ScanBatch 
left Join vut..tblScanOptions on intftpkey=intkey
left Join vut..lkuScanQueueTypes on lkuScanQueueTypes.QueueType = ScanBatch.QueueType
where Scanbatch.BatchType = 3 and
(@md = 'Day' and datediff(d,batchdate,getdate()) = 0)
or
(@md = 'Week' and datediff(wk,batchdate,getdate()) = 1)
or
(@md = 'Month' and datediff(mm,batchdate,getdate()) = 6)		--1

Declare @OutSourcer as varchar(30)
Declare @sqlq as nvarchar(300)
OPEN CursorVar
Fetch CursorVar into @OutSourcer

While @@Fetch_Status = 0
Begin
  Set @sqlq = 'ALTER TABLE #tmpScan ADD [' + @OutSourcer + '] int NULL'
--print @sqlq
  EXECUTE sp_executesql @sqlq
  
  Set @sqlq = 'Update #tmpScan 
Set [' + @OutSourcer + '] = (Select Top 1 SubTotal from #tmpScanCount where SubTotal > 0 and FTPDescription = ''' + @Outsourcer + ''' and #tmpScanCount.LenderKey=#tmpScan.LenderKey)'
  Execute sp_executesql @sqlq
  
  Set @sqlq = 'Update #tmpScan Set [' + @OutSourcer + '] = 0 where [' + @OutSourcer + '] is NULL'
  EXECUTE sp_executesql @sqlq
    
 --print @sqlq
Fetch Next from CursorVar into @OutSourcer
End
Close CursorVar
DEALLOCATE CursorVar

--Select tblLender.LenderID,tblLender.LenderName,#tmpScan.* 
Select tblLender.LenderID,tblLender.LenderName,#tmpScan.LenderKey, #tmpScan.SubTotal--, #tmpScan.ATP_Queue, #tmpScan.VehorMtg2, #tmpScan.Mortgage_Work_Queue, #tmpScan.Fax_Queue, #tmpScan.Escrow_Work_Queue, #tmpScan.HDK_Vehicle, #tmpScan.FoerVehP2, #tmpScan.VehorMtg1, #tmpScan.FaxVehP2, #tmpScan.FoerMtgP2, #tmpScan.X_Queue, #tmpScan.EDMVehP3, #tmpScan.FoerMtgP3, #tmpScan.FoerVehP3, #tmpScan.FoerVehP1, #tmpScan.FaxMtgP2, #tmpScan.Work_Queue, #tmpScan.Online_Work_Queue
from #tmpScan
Join vut..tblLender on tblLender.LenderKey = #tmpScan.LenderKey
Order by #tmpScan.LenderKey


GO

