USE UniTrac	

-- 

SELECT * FROM dbo.LENDER_PRODUCT LP
JOIN dbo.EVENT_SEQ_CONTAINER ESC ON LP.ID = ESC.LENDER_PRODUCT_ID
JOIN dbo.EVENT_SEQUENCE ES ON ESC.ID = ES.EVENT_SEQ_CONTAINER_ID
JOIN dbo.LENDER L ON L.ID = LP.LENDER_ID
WHERE  ESC.PURGE_DT IS NULL AND es.PURGE_DT IS NULL AND LP.PURGE_DT IS NULL