use LIMC


DECLARE @1 nvarchar(255)
DECLARE @2 datetime
SELECT [Event],[Time],[Message],[UserId],[Workstation] FROM [LIMC].[dbo].[Log] [L] WHERE [UserID]=@1 AND [Time]>@2 ORDER BY [L].[Time] DESC


select top 50 * 
 FROM [LIMC].[dbo].[Log] [L]
 where Event ='ProcessAvailableBatches'


--drop INDEX [IX_Log_UserID] ON [dbo].[Log]


USE [LIMC]
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.LOG') AND name = N'IX_Log_UserID')
BEGIN

CREATE INDEX [IX_Log_UserID] ON [dbo].[Log]
(
	[UserID], [Time] ASC
)

 WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

GO