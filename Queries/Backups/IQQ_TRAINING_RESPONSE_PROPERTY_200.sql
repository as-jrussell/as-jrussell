-- IQQ_TRAINING: PURGE DATA LESS THAN 1000 DAYS  
--October 25, 2018


USE IQQ_TRAINING;	


DECLARE	  @rowNumRP INT = NULL
		, @sqlRP NVARCHAR(500) = NULL
		, @purgeDate DATETIME2 = DATEADD(DAY, -200, GETUTCDATE());

SELECT @rowNumRP = COUNT(RP.RESPONSE_ID)
FROM [iqq_training].[dbo].[RESPONSE_PROPERTY] RP 
WHERE RP.CREATE_DT < @purgeDate ;

WHILE (@rowNumRP > 0)
BEGIN
	SET @sqlRP = '/*PURGE DATA OLDER THAN 90 DAYS FROM RESPONSE_PROPERTY TABLE*/
	DELETE TOP(5000) RP 
	--select *
	FROM [iqq_training].[dbo].[RESPONSE_PROPERTY] RP 
	JOIN [iqq_training].[dbo].[RESPONSE] R ON R.ID = RP.RESPONSE_ID 
	WHERE R.CREATE_DT < ''' + CONVERT(VARCHAR(34), @purgeDate, 23) + ''' ; ';

	EXEC SP_EXECUTESQL @sqlRP;
		
	SET @rowNumRP = @rowNumRP - 5000;
END
GO