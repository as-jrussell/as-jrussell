USE [UiPath]
GO

/****** Object:  Index [IX_OData_EndProcessing]    Script Date: 7/8/2021 3:33:26 PM ******/
CREATE NONCLUSTERED INDEX [IX_OData_EndProcessing] ON [dbo].[QueueItems]
(
	[EndProcessing] ASC,
	[OrganizationUnitId] ASC,
	[TenantId] ASC,
	[QueueDefinitionId] ASC,
	[Status] ASC,
	[ReviewStatus] ASC,
	[ProcessingExceptionType] ASC,
	[Priority] ASC,
	[RobotId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO




USE [UiPath]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_OData_Reference]    Script Date: 7/8/2021 3:33:36 PM ******/
CREATE NONCLUSTERED INDEX [IX_OData_Reference] ON [dbo].[QueueItems]
(
	[QueueDefinitionId] ASC,
	[Reference] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO




USE [UiPath]
GO

/****** Object:  Index [IX_OData_StartProcessing]    Script Date: 7/8/2021 3:33:46 PM ******/
CREATE NONCLUSTERED INDEX [IX_OData_StartProcessing] ON [dbo].[QueueItems]
(
	[StartProcessing] ASC,
	[OrganizationUnitId] ASC,
	[TenantId] ASC,
	[QueueDefinitionId] ASC,
	[Status] ASC,
	[ReviewStatus] ASC,
	[ProcessingExceptionType] ASC,
	[Priority] ASC,
	[RobotId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


USE [UiPath]
GO

/****** Object:  Index [IX_OData_Unsorted]    Script Date: 7/8/2021 3:33:58 PM ******/
CREATE NONCLUSTERED INDEX [IX_OData_Unsorted] ON [dbo].[QueueItems]
(
	[Id] ASC,
	[OrganizationUnitId] ASC,
	[TenantId] ASC,
	[QueueDefinitionId] ASC,
	[Status] ASC,
	[ReviewStatus] ASC,
	[ProcessingExceptionType] ASC,
	[Priority] ASC,
	[RobotId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

USE [UiPath]
GO

/****** Object:  Index [IX_QueueDefinitionId_EndProcessing_DueDate]    Script Date: 7/8/2021 3:34:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_QueueDefinitionId_EndProcessing_DueDate] ON [dbo].[QueueItems]
(
	[QueueDefinitionId] ASC,
	[EndProcessing] ASC,
	[DueDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

USE [UiPath]
GO

/****** Object:  Index [IX_QueueItems_AncestorId]    Script Date: 7/8/2021 3:34:21 PM ******/
CREATE NONCLUSTERED INDEX [IX_QueueItems_AncestorId] ON [dbo].[QueueItems]
(
	[AncestorId] ASC
)
WHERE ([AncestorId] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


USE [UiPath]
GO

/****** Object:  Index [IX_QueueItems_GetNextItem]    Script Date: 7/8/2021 3:34:33 PM ******/
CREATE NONCLUSTERED INDEX [IX_QueueItems_GetNextItem] ON [dbo].[QueueItems]
(
	[QueueDefinitionId] ASC,
	[Status] ASC,
	[HasDueDate] DESC,
	[Priority] ASC,
	[DueDate] ASC,
	[Id] ASC
)
INCLUDE([DeferDate],[RobotId],[StartProcessing],[RiskSlaDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


USE [UiPath]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_QueueItems_GetNextItemByReference]    Script Date: 7/8/2021 3:34:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_QueueItems_GetNextItemByReference] ON [dbo].[QueueItems]
(
	[QueueDefinitionId] ASC,
	[Reference] ASC,
	[Status] ASC,
	[HasDueDate] DESC,
	[Priority] ASC,
	[DueDate] ASC,
	[DeferDate] ASC,
	[Id] ASC
)
INCLUDE([RobotId],[StartProcessing]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

USE [UiPath]
GO

/****** Object:  Index [IX_Reports]    Script Date: 7/8/2021 3:35:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_Reports] ON [dbo].[QueueItems]
(
	[QueueDefinitionId] ASC,
	[EndProcessing] ASC
)
INCLUDE([StartProcessing],[Status],[AncestorId],[ProcessingExceptionType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

USE [UiPath]
GO

/****** Object:  Index [IX_ReviewerUserId]    Script Date: 7/8/2021 3:35:12 PM ******/
CREATE NONCLUSTERED INDEX [IX_ReviewerUserId] ON [dbo].[QueueItems]
(
	[ReviewerUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

USE [UiPath]
GO

/****** Object:  Index [IX_Status_TenantId_DeferDate_DueDate_HasDueDate]    Script Date: 7/8/2021 3:35:22 PM ******/
CREATE NONCLUSTERED INDEX [IX_Status_TenantId_DeferDate_DueDate_HasDueDate] ON [dbo].[QueueItems]
(
	[Status] ASC,
	[TenantId] ASC,
	[DeferDate] ASC,
	[DueDate] ASC,
	[HasDueDate] ASC
)
INCLUDE([Priority],[QueueDefinitionId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

USE [UiPath]
GO

/****** Object:  Index [IX_TenantId_INCLUDES]    Script Date: 7/8/2021 3:35:33 PM ******/
CREATE NONCLUSTERED INDEX [IX_TenantId_INCLUDES] ON [dbo].[QueueItems]
(
	[TenantId] ASC
)
INCLUDE([QueueDefinitionId],[Status],[CreationTime],[EndProcessing],[ProcessingExceptionType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

USE [UiPath]
GO

/****** Object:  Index [IX_TenantId_Status_QueueDefinitionId]    Script Date: 7/8/2021 3:35:43 PM ******/
CREATE NONCLUSTERED INDEX [IX_TenantId_Status_QueueDefinitionId] ON [dbo].[QueueItems]
(
	[TenantId] ASC,
	[Status] ASC,
	[QueueDefinitionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

USE [UiPath]
GO

/****** Object:  Index [PK_dbo.QueueItems]    Script Date: 7/8/2021 3:35:52 PM ******/
ALTER TABLE [dbo].[QueueItems] ADD  CONSTRAINT [PK_dbo.QueueItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO







