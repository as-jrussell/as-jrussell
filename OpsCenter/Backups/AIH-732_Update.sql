USE UniTrac;
GO
BEGIN TRAN;
DECLARE @OptionMinBalDecrease AS VARCHAR(100) ='1';
DECLARE @RowsToPreseve BIGINT;
SELECT @RowsToPreseve=COUNT(OptionMinBalDecrease) --SELECT *
FROM [VUT].[dbo].[tblLenderExtract]
where OptionMinBalDecrease > @OptionMinBalDecrease

--select @RowsToPreseve

/* Replace WHERE name='DDDDDDDD' with new Product */;
IF NOT EXISTS (SELECT *
               FROM UniTracHDStorage.sys.tables
               WHERE name='CSH2244' AND type IN (N'U'))BEGIN
    SELECT *
    INTO UniTracHDStorage..CSH2244
    FROM [VUT].[dbo].[tblLenderExtract]
    where OptionMinBalDecrease > @OptionMinBalDecrease;
END;
ELSE BEGIN
    PRINT 'HD TABLE EXISTS - what are you doing?';
    COMMIT;
END;
IF(@@RowCount=@RowsToPreseve)BEGIN
    PRINT 'Performing UPDATE - Preserve Row Count = Source Row Count';
    UPDATE le
    SET OptionMinBalDecrease=@OptionMinBalDecrease, UpdateDate=GETDATE()
    FROM [VUT].[dbo].[tblLenderExtract] le
   where OptionMinBalDecrease > @OptionMinBalDecrease;
    IF(@@RowCount=@RowsToPreseve)BEGIN
        PRINT 'SUCCESS - UPDATE Row Count = Source Row Count';
        COMMIT;
    END;
    ELSE /* @@RowCount <> @SourceRowCount */
    BEGIN
        PRINT 'Performing ROLLBACKUP - Update Row Count != SourceRow Count';
        UPDATE le
        SET OptionMinBalDecrease=u.OptionMinBalDecrease, UpdateDate=u.UpdateDate
        --select le.OptionMinBalDecrease , u.OptionMinBalDecrease
        FROM [VUT].[dbo].[tblLenderExtract] le
             JOIN UniTracHDStorage..CSH2244 u ON u.LenderExtractKey=le.LenderExtractKey;
    END;
END;
ELSE BEGIN
    PRINT 'STOPPING - Preserve Row Count != Source Row Count';
    ROLLBACK;
END;
