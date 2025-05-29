
/****** Object:  StoredProcedure [dbo].[GetLenderCycleInfo]    Script Date: 02/03/2012 14:43:21 ******/
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = object_id(N'[dbo].[GetLenderCycleInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1) 
BEGIN
	DROP PROCEDURE [dbo].[GetLenderCycleInfo]
END
GO

/****** Object:  StoredProcedure [dbo].[GetLenderCycleInfo]    Script Date: 02/03/2012 14:43:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetLenderCycleInfo]
(
	@LenderKey bigint,
	@pcdkey int	
)
AS
BEGIN
	--Default to cycle
	if @pcdkey = 0
		set @pcdkey = 7 
		
	select 
		max(pd.NextRunTime) as 'NextCycle',
		max(ph.StartDateTime) as 'LastCycle'
		--* 
	from tblProcessDefinitions pd
	left outer join tblProcessHistory ph on ph.processkey = pd.processkey 
	where 
		pd.lenderkey = @LenderKey and 
		pd.pcdkey = @pcdkey
	
END
GO


