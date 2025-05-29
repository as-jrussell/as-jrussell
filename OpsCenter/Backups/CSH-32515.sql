use UniTrac



IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.PROPERTY') AND name = N'IDX_PROPERTY_VIN')
BEGIN 
		DROP INDEX [IDX_PROPERTY_VIN] ON [dbo].[PROPERTY]
		PRINT 'SUCCESS: [IDX_PROPERTY_VIN] ON [dbo].[PROPERTY] successfully dropped'
END 
	ELSE
BEGIN
		PRINT 'WARNING: [IDX_PROPERTY_VIN] ON [dbo].[PROPERTY] does not exist can you please check your settings'
END



IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.PROPERTY') AND name = N'IDX_UPDATE_DT')
BEGIN 

		ALTER INDEX [IDX_UPDATE_DT] ON [dbo].[PROPERTY] DISABLE;
		PRINT 'SUCCESS: [IDX_UPDATE_DT] ON [dbo].[PROPERTY] successfully disabled'
END 
	ELSE
BEGIN
		PRINT 'WARNING: [IDX_UPDATE_DT] ON [dbo].[PROPERTY] does not exist can you please check your settings'
END
