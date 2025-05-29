use unitrac

SELECT *
	FROM TRADING_PARTNER_LOG 
WHERE LOG_MESSAGE LIKE '%System.OutOfMemoryException%' 
-- and CREATE_DT >= DateAdd(MINUTE, -15, getdate())
order by CREATE_DT ASC 
