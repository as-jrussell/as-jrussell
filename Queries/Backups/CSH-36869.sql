USE UniTrac

IF NOT EXISTS (SELECT *
               FROM   sys.indexes
               WHERE  object_id = Object_id(N'dbo.REQUIRED_COVERAGE')
                      AND name = N'IDX_REQUIRED_PURGE_DT_LCGCT_ID_ForcedPlcyOptUseCertAuth')
  BEGIN
      CREATE NONCLUSTERED INDEX [IDX_REQUIRED_PURGE_DT_LCGCT_ID_ForcedPlcyOptUseCertAuth]
        ON [dbo].[REQUIRED_COVERAGE] ([PURGE_DT], [LCGCT_ID], [ForcedPlcyOptUseCertAuth])
        INCLUDE ([ID], [DelayedBilling]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

      PRINT 'SUCCESS: [IDX_REQUIRED_PURGE_DT_LCGCT_ID_ForcedPlcyOptUseCertAuth] ON [dbo].[REQUIRED_COVERAGE] successfully added'
  END
ELSE
  BEGIN
      PRINT 'WARNING: [IDX_REQUIRED_PURGE_DT_LCGCT_ID_ForcedPlcyOptUseCertAuth] ON [dbo].[REQUIRED_COVERAGE] was not added'
  END 

--00:40:41.236




  
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.REQUIRED_COVERAGE') AND name = N'IDX_UPDATE_DT')
BEGIN 
	
		ALTER INDEX [IDX_UPDATE_DT] ON [dbo].[REQUIRED_COVERAGE] DISABLE
		PRINT 'SUCCESS: [IDX_UPDATE_DT] ON [dbo].[REQUIRED_COVERAGE] successfully disabled'
END 
	ELSE
BEGIN
		PRINT 'WARNING: [IDX_UPDATE_DT] ON [dbo].[REQUIRED_COVERAGE] does not exist can you please check your settings'
END





IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.REQUIRED_COVERAGE') AND name = N'IDX_REQUIRED_COVERAGE_CPI_QUOTE')
BEGIN 
	
		ALTER INDEX [IDX_REQUIRED_COVERAGE_CPI_QUOTE] ON [dbo].[REQUIRED_COVERAGE] DISABLE
		PRINT 'SUCCESS: [IDX_REQUIRED_COVERAGE_CPI_QUOTE] ON [dbo].[REQUIRED_COVERAGE] successfully disabled'
END 
	ELSE
BEGIN
		PRINT 'WARNING: [IDX_REQUIRED_COVERAGE_CPI_QUOTE] ON [dbo].[REQUIRED_COVERAGE] does not exist can you please check your settings'
END