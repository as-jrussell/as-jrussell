



use ocr 

--CREATE NONCLUSTERED INDEX IX_ImportId_Status ON dbo.ReRoutedImages (BatchId) INCLUDE ([Status], ImportID, ImportTime )
--Table 'ReRoutedImages'. Scan count 1, logical reads 24964, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.  00:00:21.808 ; 00:00:35.779; 00:00:32.404



--00:00:23.303;00:00:28.241 ;00:00:26.207

--CREATE NONCLUSTERED INDEX IX_ImportId_Status ON dbo.ReRoutedImages (ImportID) INCLUDE ([Status], ImportTime )
--Table 'ReRoutedImages'. Scan count 1, logical reads 24964, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.  00:00:18.392 ; 00:00:25.472; 00:00:21.599

--00:00:20.139; 00:00:24.022; 00:00:18.761; 00:00:27.936

--CREATE NONCLUSTERED INDEX IX_ImportId_Status ON dbo.ReRoutedImages ([Status]) INCLUDE (ImportID, ImportTime )
--Table 'ReRoutedImages'. Scan count 1, logical reads 24964, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0. 00:00:32.421;  00:00:19.101; 00:00:16.332



--drop INDEX IX_ImportId_Status ON dbo.ReRoutedImages 


