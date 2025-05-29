USE UniTrac;
GO

BEGIN TRAN;
DECLARE @OptionBorrowerEmailChange  AS VARCHAR(100) ='50';
DECLARE @RowsToPreseve BIGINT;
SELECT @RowsToPreseve=COUNT(OptionBorrowerEmailChange ) --SELECT *
FROM [VUT].[dbo].[tblLenderExtract]
where OptionBorrowerEmailChange  < @OptionBorrowerEmailChange 

--select @RowsToPreseve

/* Replace WHERE name='DDDDDDDD' with new Product */;
IF NOT EXISTS (SELECT *
               FROM UniTracHDStorage.sys.tables
               WHERE name='CSH2200' AND type IN (N'U'))BEGIN
    SELECT *
    INTO UniTracHDStorage..CSH2200
    FROM [VUT].[dbo].[tblLenderExtract]
    where OptionBorrowerEmailChange  < @OptionBorrowerEmailChange ;
END;
ELSE BEGIN
    PRINT 'HD TABLE EXISTS - what are you doing?';
    COMMIT;
END;
IF(@@RowCount=@RowsToPreseve)BEGIN
    PRINT 'Performing UPDATE - Preserve Row Count = Source Row Count';
    UPDATE le
    SET OptionBorrowerEmailChange =@OptionBorrowerEmailChange , UpdateDate=GETDATE()
    FROM [VUT].[dbo].[tblLenderExtract] le
   where OptionBorrowerEmailChange  < @OptionBorrowerEmailChange ;

    IF(@@RowCount=@RowsToPreseve)BEGIN
        PRINT 'SUCCESS - UPDATE Row Count = Source Row Count';
        COMMIT;
    END;
    ELSE /* @@RowCount <> @SourceRowCount */
    BEGIN
        PRINT 'Performing ROLLBACKUP - Update Row Count != SourceRow Count';
        UPDATE le
        SET OptionBorrowerEmailChange =u.OptionBorrowerEmailChange , UpdateDate=u.UpdateDate
        --select le.OptionBorrowerEmailChange  , u.OptionBorrowerEmailChange 
        FROM [VUT].[dbo].[tblLenderExtract] le
             JOIN UniTracHDStorage..CSH2200 u ON u.LenderExtractKey=le.LenderExtractKey;
    END;
END;


ELSE BEGIN
    PRINT 'STOPPING - Preserve Row Count != Source Row Count';
    ROLLBACK;
END;
