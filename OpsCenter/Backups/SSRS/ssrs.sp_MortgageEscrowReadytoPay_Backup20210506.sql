USE [UiPath]
GO

/****** Object:  StoredProcedure [dbo].[ssrs.sp_MortgageEscrowReadytoPay]    Script Date: 5/6/2021 9:32:28 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



alter PROCEDURE [dbo].[ssrs.sp_MortgageEscrowReadytoPay] ( @name nvarchar(255))
as
SET NOCOUNT ON

SELECT 
   	JSON_Value([SpecificData],'$.DynamicProperties.Lender_') AS [Lender]
	,JSON_Value(qi.[SpecificData],'$.DynamicProperties.LenderNumber_') AS [Lender #]
    ,JSON_Value(qi.[SpecificData],'$.DynamicProperties.Service_') AS [Service]
    ,JSON_Value(qi.[SpecificData],'$.DynamicProperties.EscrowFlowType_') AS [Escrow Flow Type]
	,JSON_Value(qi.[SpecificData],'$.DynamicProperties.AdministratorsEmail_') AS [Administator's Email]
    ,JSON_Value(qi.[SpecificData],'$.DynamicProperties.DayReportedToLender_') AS [Day Reported To Lender]
	,JSON_Value(qi.[SpecificData],'$.DynamicProperties.LenderEmail_') AS [Lender Email]
	,JSON_Value(qi.[SpecificData],'$.DynamicProperties.TransactionTimePeriod_') AS [Transaction Time Period]
	,JSON_Value(qi.[SpecificData],'$.DynamicProperties.DailyTransactionLimit_') AS [Daily Transaction Limit]
	,JSON_Value(qi.[SpecificData],'$.DynamicProperties.TransactionCount_') AS [Transaction Count]
	,JSON_Value(qi.[SpecificData],'$.DynamicProperties.Transactions_') AS [Transactions]	
    ,[IsDeleted]
	,CASE CAST([Status] AS VARCHAR(2)) 
	        WHEN '0' then 'New' 
	        WHEN '1' then 'In Progress' 
	        WHEN '2' then 'Retried' 
	        WHEN '3' then 'Successful' 
			WHEN '4' then 'Abandoned'
	        WHEN '5' THEN 'Failed' 
			WHEN '6' THEN 'Deleted' 	
			ELSE CAST([Status] AS VARCHAR(2)) END AS [Status]
    ,Reference
	,ProcessingExceptionDetails AS [Exception]
	,ProcessingExceptionReason AS [Exception Reason]
	,StartProcessing AS [Start Date]
    ,EndProcessing AS [End Date]
  FROM [UiPath].[dbo].[QueueDefinitions] qd
  JOIN QueueItems qi ON qd.[Id] = qi.QueueDefinitionId
 WHERE  qd.[Id] IN (SELECT QueueDefinitionId FROM QueueItems) and
 Name = @name
 AND [IsDeleted] = 0
GO

