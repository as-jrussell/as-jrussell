use OCR
GO

SET STATISTICS IO on 
GO

select * 
from ReRoutedImages
where status = 'COMP'


--Table 'ReRoutedImages'. Scan count 1, logical reads 24964, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.


