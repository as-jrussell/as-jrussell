USE UniTrac

IF Object_id(N'tempdb..#Financial_Data') IS NOT NULL
  DROP TABLE #Financial_Data
SELECT Count(*)               AS 'Count',
       CASE
         WHEN 'P' = ft.TXN_TYPE_CD THEN 'Payment'
         ELSE 'Refund'
       END                    AS 'Type',
       Sum(ft.AMOUNT_NO * -1) AS '$$$'
INTO   #Financial_Data
FROM   FINANCIAL_TXN ft
       JOIN FORCE_PLACED_CERTIFICATE fpc
         ON ft.FPC_ID = fpc.ID
       JOIN LOAN l
         ON fpc.LOAN_ID = l.ID
       JOIN LENDER lend
         ON l.LENDER_ID = lend.ID
            AND lend.AGENCY_ID = 1
WHERE  ft.TXN_DT >= Dateadd(month, Datediff(month, 0, Getdate()), 0)
       AND ft.TXN_DT < Dateadd(mm, Datediff(m, 0, Getdate()) + 1, 0)
       AND ft.PURGE_DT IS NULL
       AND ft.TXN_TYPE_CD IN ( 'P', 'CP' )
GROUP  BY ft.TXN_TYPE_CD

IF Object_id(N'tempdb..#Loss') IS NOT NULL
  DROP TABLE #Loss
SELECT *
INTO   #Loss
FROM   #Financial_Data
WHERE  Type = 'Refund'

IF Object_id(N'tempdb..#Payment') IS NOT NULL
  DROP TABLE #Payment
SELECT *
INTO   #Payment
FROM   #Financial_Data
WHERE  Type = 'Payment'

IF Object_id(N'tempdb..#CalculationsTotals') IS NOT NULL
  DROP TABLE #CalculationsTotals
SELECT DISTINCT (SELECT #Payment.Count + #loss.Count
                 FROM   #Loss
                        CROSS APPLY #Payment) [Count],
                'Total'                       AS [Type],
                (SELECT  #Payment.[$$$] + #loss.[$$$]
                 FROM   #Loss
                        CROSS APPLY #Payment) AS [$$$]
INTO   #CalculationsTotals
FROM   #Financial_Data

IF Object_id(N'tempdb..#Data') IS NOT NULL
  DROP TABLE #Data

  CREATE TABLE #Data
( [Count] varchar(40),
  [Type]  varchar(40),
  [$$$] varchar(100) )


  
INSERT INTO #Data
SELECT [Count], [Type],CONCAT('$ ',convert(varchar,cast([$$$] as money), 1)) AS [$$$]
FROM   #Loss
UNION
SELECT [Count], [Type],CONCAT('$ ',convert(varchar,cast([$$$] as money), 1)) AS [$$$]
FROM   #Payment
UNION
SELECT [Count], [Type],CONCAT('$ ',convert(varchar,cast([$$$] as money), 1)) AS [$$$]
FROM   #CalculationsTotals
ORDER  BY Type ASC 

DECLARE @xml NVARCHAR(MAX)
DECLARE @body NVARCHAR(MAX)

SET @xml = CAST(( SELECT
[Count] AS 'td','',
[Type] AS 'td','',
[$$$] AS 'td',''

FROM #Data 
ORDER  BY Type ASC 
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))

SET @body ='<html><body><H3>AlliedPremiumCalculation</H3>
<table border = 1> 
<tr>
<th> Count</th> <th>Type</th><th>$$$</th>'    

SET @body = @body + @xml +'</table></body></html>'


            EXEC msdb.dbo.sp_send_dbmail 
			@Subject= 'AlliedPremiumCalculation',
			@profile_name = 'Unitrac-prod',
			@body = @body,
			@body_format ='HTML',			
            @recipients = '';
			
