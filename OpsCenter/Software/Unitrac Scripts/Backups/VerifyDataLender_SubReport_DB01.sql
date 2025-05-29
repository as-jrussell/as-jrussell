USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[Report_VerifyDataLender_SubReport]    Script Date: 4/7/2016 10:42:55 AM ******/
DROP PROCEDURE [dbo].[Report_VerifyDataLender_SubReport]
GO

/****** Object:  StoredProcedure [dbo].[Report_VerifyDataLender_SubReport]    Script Date: 4/7/2016 10:42:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Report_VerifyDataLender_SubReport]		
	(@WorkItemID as bigint=NULL)
AS
BEGIN

Select 'Verify ' + T2.Loc.value('@FieldDisplayName[1]','nvarchar(500)') as ActionNeeded,
		'' as VerifyDataComment,
		T2.Loc.value('@UTValue[1]','nvarchar(500)') as CurrentValue
from WORK_ITEM 
CROSS APPLY CONTENT_XML.nodes('/Content/VerifyData/Detail') as T2(Loc) 
where ID = @WorkItemID
	
END


GO

