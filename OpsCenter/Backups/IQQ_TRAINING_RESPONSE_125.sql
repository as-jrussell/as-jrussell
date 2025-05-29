
DECLARE	  @rowNumR INT = NULL
		, @sqlR NVARCHAR(500) = NULL
		, @purgeDate DATETIME2 = DATEADD(DAY, -125, GETUTCDATE());

SELECT @rowNumR = COUNT(R.ID)
FROM [iqq_training].[dbo].[RESPONSE]  R 
WHERE R.CREATE_DT < @purgeDate ;

WHILE (@rowNumR > 0)
BEGIN
	SET @sqlR = '/*PURGE DATA OLDER THAN 90 DAYS FROM RESPONSE TABLE*/
	DELETE TOP(5000) R 
	--	select *
	FROM [iqq_training].[dbo].[RESPONSE]  R 
	WHERE R.CREATE_DT < ''' + CONVERT(VARCHAR(34), @purgeDate, 23) + ''' ; ';

	EXEC SP_EXECUTESQL @sqlR;

	SET @rowNumR = @rowNumR - 5000;
END
GO