USE UniTrac;
GO

BEGIN TRAN;
DECLARE @OptionFloodZoneChange    AS VARCHAR(100) ='5';
DECLARE @RowsToPreseve BIGINT;
SELECT @RowsToPreseve=COUNT(OptionFloodZoneChange   ) --SELECT *
FROM [VUT].[dbo].[tblLenderExtract]
where OptionFloodZoneChange    < @OptionFloodZoneChange   

--select @RowsToPreseve

/* Replace WHERE name='DDDDDDDD' with new Product */;
IF NOT EXISTS (SELECT *
               FROM UniTracHDStorage.sys.tables
               WHERE name='CSH2196' AND type IN (N'U'))BEGIN
    SELECT *
    INTO UniTracHDStorage..CSH2196
    FROM [VUT].[dbo].[tblLenderExtract]
    where OptionFloodZoneChange   < @OptionFloodZoneChange   ;
END;
ELSE BEGIN
    PRINT 'HD TABLE EXISTS - what are you doing?';
    COMMIT;
END;
IF(@@RowCount=@RowsToPreseve)BEGIN
    PRINT 'Performing UPDATE - Preserve Row Count = Source Row Count';
    UPDATE le
    SET OptionFloodZoneChange   =@OptionFloodZoneChange   , UpdateDate=GETDATE()
    FROM [VUT].[dbo].[tblLenderExtract] le
   where OptionFloodZoneChange    < @OptionFloodZoneChange   ;

    IF(@@RowCount=@RowsToPreseve)BEGIN
        PRINT 'SUCCESS - UPDATE Row Count = Source Row Count';
        COMMIT;
    END;
    ELSE /* @@RowCount <> @SourceRowCount */
    BEGIN
        PRINT 'Performing ROLLBACKUP - Update Row Count != SourceRow Count';
        UPDATE le
        SET OptionFloodZoneChange   =u.OptionFloodZoneChange   , UpdateDate=u.UpdateDate
        --select le.OptionFloodZoneChange    , u.OptionFloodZoneChange   
        FROM [VUT].[dbo].[tblLenderExtract] le
             JOIN UniTracHDStorage..CSH2196 u ON u.LenderExtractKey=le.LenderExtractKey;
    END;
END;


ELSE BEGIN
    PRINT 'STOPPING - Preserve Row Count != Source Row Count';
    ROLLBACK;
END;
