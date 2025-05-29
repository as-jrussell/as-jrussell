USE [TfsIntegration]
GO

DECLARE @RC int
DECLARE @expanded_members int

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[prc_security_read_identity] 
   @expanded_members
GO

