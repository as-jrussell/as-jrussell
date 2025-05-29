USE UniTrac;
GO

BEGIN TRAN;
DECLARE @OptionBalDecrChange   AS VARCHAR(100) ='90';
DECLARE @RowsToPreseve BIGINT;
SELECT @RowsToPreseve=COUNT(OptionBalDecrChange  ) --SELECT *
FROM [VUT].[dbo].[tblLenderExtract]
where OptionBalDecrChange   < @OptionBalDecrChange  

select @RowsToPreseve

/* Replace WHERE name='DDDDDDDD' with new Product */;
IF NOT EXISTS (SELECT *
               FROM UniTracHDStorage.sys.tables
               WHERE name='CSH2198' AND type IN (N'U'))BEGIN
    SELECT *
    INTO UniTracHDStorage..CSH2198
    FROM [VUT].[dbo].[tblLenderExtract]
    where OptionBalDecrChange  < @OptionBalDecrChange  ;
END;
ELSE BEGIN
    PRINT 'HD TABLE EXISTS - what are you doing?';
    COMMIT;
END;
IF(@@RowCount=@RowsToPreseve)BEGIN
    PRINT 'Performing UPDATE - Preserve Row Count = Source Row Count';
    UPDATE le
    SET OptionBalDecrChange  =@OptionBalDecrChange  , UpdateDate=GETDATE()
    FROM [VUT].[dbo].[tblLenderExtract] le
   where OptionBalDecrChange   < @OptionBalDecrChange  ;

    IF(@@RowCount=@RowsToPreseve)BEGIN
        PRINT 'SUCCESS - UPDATE Row Count = Source Row Count';
        COMMIT;
    END;
    ELSE /* @@RowCount <> @SourceRowCount */
    BEGIN
        PRINT 'Performing ROLLBACKUP - Update Row Count != SourceRow Count';
        UPDATE le
        SET OptionBalDecrChange  =u.OptionBalDecrChange  , UpdateDate=u.UpdateDate
        --select le.OptionBalDecrChange   , u.OptionBalDecrChange  
        FROM [VUT].[dbo].[tblLenderExtract] le
             JOIN UniTracHDStorage..CSH2198 u ON u.LenderExtractKey=le.LenderExtractKey;
    END;
END;


ELSE BEGIN
    PRINT 'STOPPING - Preserve Row Count != Source Row Count';
    ROLLBACK;
END;
