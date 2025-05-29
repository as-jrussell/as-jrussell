SELECT CONVERT(date, CreationTime), COUNT(*)
FROM UiPath.DBO.LEDGER 
WHERE  CONVERT(date, CreationTime) between '2022-04-01' and '2022-04-26' 
GROUP BY CONVERT(date, CreationTime)
ORDER BY CONVERT(date, CreationTime) DESC








SELECT CONVERT(date, CreationTime) [Date], EntityName, COUNT(*) [Count]
FROM UiPath.DBO.LEDGER 
WHERE  CONVERT(date, CreationTime) between '2022-04-10' and '2022-04-14' 
GROUP BY CONVERT(date, CreationTime),EntityName 
ORDER BY CONVERT(date, CreationTime) DESC