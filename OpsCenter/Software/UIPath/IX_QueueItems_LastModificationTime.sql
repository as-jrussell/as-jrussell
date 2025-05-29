IF NOT EXISTS (SELECT * FROM sys.indexes WHERE [name] = 'IX_QueueItems_LastModificationTime')
    BEGIN
        CREATE NONCLUSTERED INDEX IX_QueueItems_LastModificationTime ON dbo.QueueItems (LastModificationTime)
            WITH (ONLINE = ON, SORT_IN_TEMPDB = ON);
    END;