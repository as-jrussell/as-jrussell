USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[sp_AlliedPremiumCalculation]    Script Date: 1/2/2024 12:32:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_AlliedPremiumCalculation]') AND type in (N'P', N'PC'))
BEGIN
	/* Create Empty Stored Procedure */
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_AlliedPremiumCalculation] AS RETURN 0;';
END;
GO


/* Alter Stored Procedure */
ALTER PROCEDURE [dbo].[sp_AlliedPremiumCalculation] (@DryRun BIT =1)
AS

--EXEC [dbo].[sp_AlliedPremiumCalculation]

DECLARE @Count INT 
IF Object_id(N'tempdb..#Financial_Data') IS NOT NULL
  DROP TABLE #Financial_Data
SELECT Count(*)               AS 'Count',
       CASE
         WHEN 'P' = ft.TXN_TYPE_CD THEN 'Payment'
         ELSE 'Refund'
       END                    AS 'Type',
       Sum(ft.AMOUNT_NO * -1) AS '$$$'
INTO   #Financial_Data
FROM   [Unitrac].[dbo].FINANCIAL_TXN ft
       JOIN [Unitrac].[dbo].FORCE_PLACED_CERTIFICATE fpc
         ON ft.FPC_ID = fpc.ID
       JOIN [Unitrac].[dbo].LOAN l
         ON fpc.LOAN_ID = l.ID
       JOIN [Unitrac].[dbo].LENDER lend
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
( [Count] VARCHAR(40),
  [Type]  VARCHAR(40),
  [$$$] VARCHAR(100) )


  
INSERT INTO #Data
SELECT [Count], [Type],Concat('$ ',CONVERT(VARCHAR,Cast([$$$] AS MONEY), 1)) AS [$$$]
FROM   #Loss
UNION
SELECT [Count], [Type],Concat('$ ',CONVERT(VARCHAR,Cast([$$$] AS MONEY), 1)) AS [$$$]
FROM   #Payment
UNION
SELECT [Count], [Type],Concat('$ ',CONVERT(VARCHAR,Cast([$$$] AS MONEY), 1)) AS [$$$]
FROM   #CalculationsTotals
ORDER  BY Type ASC

select @Count =[Count] from #Data

IF @DryRun = 0
BEGIN
IF @Count > 0
BEGIN
						DECLARE @xml NVARCHAR(MAX)
						DECLARE @body NVARCHAR(MAX)

						SET @xml = Cast(( SELECT
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
           							@recipients = 'AlliedPremiumCalculation@alliedsolutions.net';
END
ELSE 
BEGIN
     						  EXEC msdb.dbo.sp_send_dbmail 
           							@Subject= 'AlliedPremiumCalculation',
           							@profile_name = 'Unitrac-prod',
           							@body = 'No payments or refunds recorded today',
           							@body_format ='HTML',            
           							@recipients = 'AlliedPremiumCalculation@alliedsolutions.net';
END 
END
ELSE
BEGIN

		SELECT * FROM #Data
END
