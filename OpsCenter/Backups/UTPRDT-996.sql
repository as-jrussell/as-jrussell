USE UTL 

IF NOT EXISTS (SELECT *
               FROM   sys.indexes
               WHERE  object_id = Object_id(N'dbo.LENDER')
                      AND name = N'IDX_LENDER')
BEGIN
    BEGIN TRY   
		  CREATE NONCLUSTERED INDEX [IDX_LENDER]
        ON [dbo].[LENDER] ( [ENABLE_MATCHING_IN] ASC, [PURGE_DT] ASC )
        INCLUDE([ID], [CODE_TX], [LAST_SYNC_DT]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		  END TRY  
    BEGIN CATCH  
		PRINT 'WARNING: [IDX_LENDER] ON [dbo].[LENDER] was not added, please check the settings!'
   RETURN
    END CATCH  

PRINT 'SUCCESS: [IDX_LENDER] ON [dbo].[LENDER] successfully added'
END
	ELSE
BEGIN
		PRINT 'WARNING: [IDX_LENDER] ON [dbo].[LENDER] was not added, please check the settings!'
END

