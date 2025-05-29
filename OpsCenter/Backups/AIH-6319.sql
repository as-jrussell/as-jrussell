use IQQ_TRAINING 

IF EXISTS (SELECT * FROM sys.tables WHERE [name] = 'RESPONSE_LOG')
DECLARE @retVal int

SELECT @retVal = COUNT(*)
from RESPONSE_LOG

IF (@retVal = 0)
BEGIN
		PRINT 'WARNING: RESPONSE_LOG is empty please check'
END
ELSE
BEGIN
		TRUNCATE TABLE RESPONSE_LOG 
		PRINT 'Truncate was successful'
END 
