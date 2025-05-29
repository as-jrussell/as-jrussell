use OCR


IF NOT EXISTS (SELECT  1 FROM OCR.sys.indexes  -- Someday this will be the standard 
               WHERE name ='IX_ImportId_Status' and OBJECT_NAME(object_id) = 'ReRoutedImages')
BEGIN 

		CREATE CLUSTERED INDEX IX_ImportId_Status ON dbo.ReRoutedImages (ImportID)

END 

ELSE 

BEGIN 
		PRINT 'IX_ImportId_Status has been created please check the Indexes on dbo.ReRoutedImages'

END
