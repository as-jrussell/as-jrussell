--------- See which batches are running now
SELECT * FROM scanbatch WHERE BatchType = 1
ORDER BY BatchDate DESC 

SELECT  *
FROM    VUT..scanbatch
WHERE   batchid IN ( 'AS65170140632' );
                     
------ restart tempestupload and ftpqservice after setting batch to error status
UPDATE  VUT..ScanBatch
SET     BatchType = -5
WHERE   BatchID IN ( 'AS65170140632' );   
                    
------ send image of bad batch to IDR Team afterwards
SELECT  *
FROM    VUT..scanbatch
WHERE   batchid IN ( 'AS65170140632' );
                                  