USE [DBA]
GO

DECLARE @RC int
DECLARE @TargetDB varchar(50)  = 'AccessConvert'
DECLARE @AppName varchar(50) ='SURF'
DECLARE @Dryrun bit = 0
DECLARE @Debug bit

-- TODO: Set parameter values here.

EXECUTE @RC = [deploy].[ApplicationDatabase] 
   @TargetDB
  ,@AppName
  ,@Dryrun
  ,@Debug
GO


