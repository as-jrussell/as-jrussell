ALTER AVAILABILITY GROUP [OCR-PRD3-LISTEN] MODIFY REPLICA ON 'OCR-SQLPRD-08' WITH  
    (FAILOVER_MODE = AUTOMATIC);


	--FAILOVER_MODE = { AUTOMATIC | MANUAL }