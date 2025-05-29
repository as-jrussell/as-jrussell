USE UniTrac;
GO

BEGIN TRAN;
DECLARE @OptionCurrPmtAmtChange AS VARCHAR(100) ='100';
DECLARE @RowsToPreseve BIGINT;
SELECT @RowsToPreseve=COUNT(OptionCurrPmtAmtChange) --SELECT *
FROM [VUT].[dbo].[tblLenderExtract]
where OptionCurrPmtAmtChange < @OptionCurrPmtAmtChange

--select @RowsToPreseve

/* Replace WHERE name='DDDDDDDD' with new Product */;
IF NOT EXISTS (SELECT *
               FROM UniTracHDStorage.sys.tables
               WHERE name='CSH2248' AND type IN (N'U'))BEGIN
    SELECT *
    INTO UniTracHDStorage..CSH2248
    FROM [VUT].[dbo].[tblLenderExtract]
    where OptionCurrPmtAmtChange < @OptionCurrPmtAmtChange;
END;
ELSE BEGIN
    PRINT 'HD TABLE EXISTS - what are you doing?';
    COMMIT;
END;
IF(@@RowCount=@RowsToPreseve)BEGIN
    PRINT 'Performing UPDATE - Preserve Row Count = Source Row Count';
    UPDATE le
    SET OptionCurrPmtAmtChange=@OptionCurrPmtAmtChange, UpdateDate=GETDATE()
    FROM [VUT].[dbo].[tblLenderExtract] le
   where OptionCurrPmtAmtChange < @OptionCurrPmtAmtChange;

    IF(@@RowCount=@RowsToPreseve)BEGIN
        PRINT 'SUCCESS - UPDATE Row Count = Source Row Count';
        COMMIT;
    END;
    ELSE /* @@RowCount <> @SourceRowCount */
    BEGIN
        PRINT 'Performing ROLLBACKUP - Update Row Count != SourceRow Count';
        UPDATE le
        SET OptionCurrPmtAmtChange=u.OptionCurrPmtAmtChange, UpdateDate=u.UpdateDate
        --select le.OptionCurrPmtAmtChange , u.OptionCurrPmtAmtChange
        FROM [VUT].[dbo].[tblLenderExtract] le
             JOIN UniTracHDStorage..CSH2248 u ON u.LenderExtractKey=le.LenderExtractKey;
    END;
END;


ELSE BEGIN
    PRINT 'STOPPING - Preserve Row Count != Source Row Count';
    ROLLBACK;
END;
