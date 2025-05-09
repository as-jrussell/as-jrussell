USE [Unitrac_Reports]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetPropertyDescriptionForReports]    Script Date: 7/14/2017 1:16:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER FUNCTION [dbo].[fn_GetPropertyDescriptionForReports] (
@COLLATERAL_ID bigint)
RETURNS nvarchar(100)

BEGIN

   DECLARE @propertyDesc nvarchar(100)

   SET @propertyDesc= (SELECT [dbo].[fn_GetPropertyDescription] (@COLLATERAL_ID , 'Y'))	

	-- return property description
	RETURN @propertyDesc
END
