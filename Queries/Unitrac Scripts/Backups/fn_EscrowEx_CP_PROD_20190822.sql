USE [UniTrac]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_EscrowEx_CP]    Script Date: 8/22/2019 2:24:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- CP Exception Check
-- Change in Payee  
ALTER function [dbo].[fn_EscrowEx_CP]
(
   @EscrowID bigint
)

RETURNS nvarchar(30)
AS
BEGIN

	RETURN NULL

END

