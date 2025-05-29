USE UniTrac

SELECT [Expiration Date], * FROM UniTracHDStorage..[HomeStreetUpdate]
WHERE [Policy Number] = '41lx027559735'


SELECT DISTINCT op.update_user_tx
FROM dbo.OWNER_POLICY OP
JOIN UniTracHDStorage..[HomeStreetUpdate] J ON OP.ID = J.[Owner Policy ID]
JOIN dbo.POLICY_COVERAGE PC ON PC.ID = J.[Policy Coverage ID]


SELECT PC.* INTO UniTracHDStorage..INC0330207_PC
FROM dbo.POLICY_COVERAGE PC
JOIN UniTracHDStorage..[HomeStreetUpdate] J ON PC.ID = J.[Policy Coverage ID]

SELECT OP.* INTO UniTracHDStorage..INC0330207_OP
FROM dbo.OWNER_POLICY OP
JOIN UniTracHDStorage..[HomeStreetUpdate] J ON OP.ID = J.[Owner Policy ID]

UPDATE OP
SET OP.EFFECTIVE_DT = J.[New Effective Date], OP.MOST_RECENT_EFFECTIVE_DT = J.[New Effective Date],
 op.UPDATE_DT = GETDATE(), op.UPDATE_USER_TX = 'INC0330207', op.LOCK_ID = CASE WHEN op.LOCK_ID >= 255 THEN 1 ELSE op.LOCK_ID END, OP.EXPIRATION_DT = J.[Expiration Date]
--SELECT OP.EFFECTIVE_DT ,OP.MOST_RECENT_EFFECTIVE_DT , J.[New Effective Date],* 
FROM dbo.OWNER_POLICY OP
JOIN UniTracHDStorage..[HomeStreetUpdate] J ON OP.ID = J.[Owner Policy ID]
WHERE OP.POLICY_NUMBER_TX = '41lx027559735'



UPDATE PC SET PC.START_DT = J.[New Effective Date], PC.UPDATE_DT = GETDATE(), 
PC.UPDATE_USER_TX = 'INC0330207', PC.LOCK_ID = CASE WHEN PC.LOCK_ID >= 255 THEN 1 ELSE PC.LOCK_ID END, PC.END_DT = J.[Expiration Date]
--SELECT  J.[New Effective Date],J.* 
FROM dbo.POLICY_COVERAGE PC
JOIN UniTracHDStorage..[HomeStreetUpdate] J ON PC.ID = J.[Policy Coverage ID]
JOIN UniTracHDStorage..INC0330207_PC P ON P.ID = PC.ID
WHERE PC.OWNER_POLICY_ID IN ('202423991', '202437997')


