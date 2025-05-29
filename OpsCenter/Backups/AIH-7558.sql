use KAFC_Data

select * 
into HDTStorage..AIH7558_batchprocess
from batchprocess


select * 
into HDTStorage..AIH7558_documentprocess
from dbo.documentprocess




truncate table KAFC_Data.dbo.batchprocess 

truncate table KAFC_Data.dbo.documentprocess  



/*

USE [KAFC_Data]
GO

INSERT INTO [dbo].[BatchProcess]
           ([__ProcessInstanceId]
           ,[__Ordinal]
           ,[__IsReopened]
           ,[__FullPath]
           ,[__CollapsedPath]
           ,[Violator]
           ,[IsFinished]
           ,[CreationTime]
           ,[LastModificationTime]
           ,[CurrentStep]
           ,[ProcessID]
           ,[BatchClassName]
           ,[SiteName]
           ,[Priority]
           ,[ModuleName])
   	 select [__ProcessInstanceId]
           ,[__Ordinal]
           ,[__IsReopened]
           ,[__FullPath]
           ,[__CollapsedPath]
           ,[Violator]
           ,[IsFinished]
           ,[CreationTime]
           ,[LastModificationTime]
           ,[CurrentStep]
           ,[ProcessID]
           ,[BatchClassName]
           ,[SiteName]
           ,[Priority]
           ,[ModuleName]
		   from  HDTStorage..AIH7558_batchprocess

INSERT INTO [dbo].[DocumentProcess]
           ([__ProcessInstanceId]
           ,[__Ordinal]
           ,[__IsReopened]
           ,[__FullPath]
           ,[__CollapsedPath]
           ,[Violator]
           ,[IsFinished]
           ,[CreationTime]
           ,[LastModificationTime]
           ,[CurrentStep]
           ,[ProcessID]
           ,[BatchClassName]
           ,[DocType]
           ,[Priority]
           ,[SiteName]
           ,[Vendor])
     SELECT 
	 [__ProcessInstanceId]
           ,[__Ordinal]
           ,[__IsReopened]
           ,[__FullPath]
           ,[__CollapsedPath]
           ,[Violator]
           ,[IsFinished]
           ,[CreationTime]
           ,[LastModificationTime]
           ,[CurrentStep]
           ,[ProcessID]
           ,[BatchClassName]
           ,[DocType]
           ,[Priority]
           ,[SiteName]
           ,[Vendor]
		FROM HDTStorage..AIH7558_documentprocess
GO


*/