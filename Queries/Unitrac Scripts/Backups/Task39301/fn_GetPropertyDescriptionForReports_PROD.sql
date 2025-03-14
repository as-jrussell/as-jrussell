USE [UniTrac]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetPropertyDescriptionForReports]    Script Date: 10/23/2016 6:46:53 PM ******/
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
RETURNS nvarchar(max)

BEGIN

   DECLARE @propertyDesc nvarchar(max)

   SET @propertyDesc= (SELECT [dbo].[fn_GetPropertyDescription] (@COLLATERAL_ID , 'Y'))	

	-- return property description
	RETURN @propertyDesc
END
