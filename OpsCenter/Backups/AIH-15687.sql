USE [CenterPointSecurity]
GO

SET ANSI_PADDING ON
GO


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.AspNetUserRoles') AND name = N'IX_RoleId')
BEGIN
    BEGIN TRY   
		CREATE NONCLUSTERED INDEX [IX_RoleId] ON [dbo].[AspNetUserRoles] ([RoleId] ASC)
		WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		  END TRY  
    BEGIN CATCH  
		PRINT 'WARNING: [IX_RoleId] ON [dbo].[AspNetUserRoles] was not added either not in the correct database or index itself failed.'
   RETURN
    END CATCH  

PRINT 'SUCCESS:  [IX_RoleId] ON [dbo].[AspNetUserRoles] successfully added'
END
	ELSE
BEGIN
		PRINT 'WARNING: [IX_RoleId] ON [dbo].[AspNetUserRoles] was not added either table does not exist or index already exists'
END







IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.AspNetUserRoles') AND name = N'IX_UserId')
BEGIN
    BEGIN TRY   
		CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserRoles] ([UserId] ASC)
		WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		  END TRY  
    BEGIN CATCH  
		PRINT 'WARNING: [IX_UserId] ON [dbo].[AspNetUserRoles] was not added either not in the correct database or index itself failed.'
   RETURN
    END CATCH  

PRINT 'SUCCESS:  [IX_UserId] ON [dbo].[AspNetUserRoles] successfully added'
END
	ELSE
BEGIN
		PRINT 'WARNING: [IX_UserId] ON [dbo].[AspNetUserRoles] was not added either table does not exist or index already exists'
END



