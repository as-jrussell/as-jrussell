USE [AppLog]
GO

/****** Object:  Index [IDX_APPLOG_STARTED]    Script Date: 7/8/2022 12:12:00 PM ******/
CREATE NONCLUSTERED INDEX [IDX_APPLOG_STARTED] ON [dbo].[AppLog]
(
	[Created] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER INDEX [IDX_APPLOG_STARTED] ON [dbo].[AppLog] DISABLE
GO

