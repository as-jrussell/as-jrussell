

SELECT * FROM vut..tbllender
WHERE lenderkey = 2283 

SELECT * FROM vut.dbo.scanbatch
WHERE lenderkey = 2283 AND intftpkey IN (51,52,53,54,55) AND batchdate >= '2018-05-02'
	  


	  SELECT * FROM vut.dbo.tblImageQueue
WHERE BatchID= 'PL48122094258'





USE OCR

SELECT * FROM dbo.ImportImages
WHERE BatchID = 'PL48122094258'
