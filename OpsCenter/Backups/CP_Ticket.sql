USE CenterPointSecurity 

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.CP_UserProfile') AND name = N'IX_CP_UserProfile_UserID')
BEGIN 
		CREATE NONCLUSTERED INDEX [IX_CP_UserProfile_UserID] ON [dbo].[CP_UserProfile] ([UserID])
		WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF,  ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


		PRINT 'SUCCESS: [IX_CP_UserProfile_UserID] ON [dbo].[CP_UserProfile] successfully added'
END
	ELSE
BEGIN
		PRINT 'WARNING: [IX_CP_UserProfile_UserID] ON [dbo].[CP_UserProfile] was not added'
END
