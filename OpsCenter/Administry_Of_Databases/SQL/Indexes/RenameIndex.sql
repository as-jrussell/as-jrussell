

-- Rename an index the grown-up way
USE [IQQ_TRAINING]
GO

EXEC sp_rename 
    @objname = N'dbo.PRODUCT.PRODUCT_ID_PARENT_ID',  -- e.g., dbo.Users.IX_Users_LastName
    @newname = N'IDX_PRODUCT_ID_PARENT_ID',                           -- e.g., IX_Users_LastName_Updated
    @objtype = N'INDEX';
GO
