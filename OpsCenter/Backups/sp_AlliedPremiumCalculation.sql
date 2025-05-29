USE [Unitrac]

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[dbo].[sp_AlliedPremiumCalculation]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [dbo].[sp_AlliedPremiumCalculation] AS RETURN 0;';
  END;

GO

ALTER PROCEDURE [dbo].[sp_AlliedPremiumCalculation] (@DryRun INT =1)
AS

--EXEC [dbo].[sp_AlliedPremiumCalculation] Displays the information
--EXEC [dbo].[sp_AlliedPremiumCalculation] @DryRun = 0 send the email to the users displayed in the stored proc 

/*
Create the data from production into a temp table.

*/
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

/*
Taking from the temp and extract the Refunds
and creates a temp table
*/

IF Object_id(N'tempdb..#Loss') IS NOT NULL
  DROP TABLE #Loss
SELECT *
INTO   #Loss
FROM   #Financial_Data
WHERE  Type = 'Refund'

/*
Taking from the temp and extract the Payments
and creates a temp table
*/ 

IF Object_id(N'tempdb..#Payment') IS NOT NULL
  DROP TABLE #Payment
SELECT *
INTO   #Payment
FROM   #Financial_Data
WHERE  Type = 'Payment'

/*
From the two tables does totals and create a total temp table
*/ 


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


/*
Create the presentable data temp table with 
the three temp tables created in unions
*/ 
IF Object_id(N'tempdb..#Data') IS NOT NULL
  DROP TABLE #Data

  CREATE TABLE #Data
( [Count] VARCHAR(40),
  [Type]  VARCHAR(40),
  [$$$] VARCHAR(100) )


  
INSERT INTO #Data
SELECT [Count], [Type],FORMAT([$$$], '#,#;($#,#.##)')  AS [$$$]
FROM   #Loss
UNION
SELECT [Count], [Type],Concat('$ ',CONVERT(VARCHAR,Cast([$$$] AS MONEY), 1)) AS [$$$]
FROM   #Payment
UNION
SELECT [Count], [Type],Concat('$ ',CONVERT(VARCHAR,Cast([$$$] AS MONEY), 1)) AS [$$$]
FROM   #CalculationsTotals
ORDER  BY Type ASC



/*
IF @DryRun = 0 then the email will be sent to the users 
IF @DryRun = 1 (or without the @DryRun added which is this set as the default)  
then the data will be displayed for users to see in SSMS
*/ 


						DECLARE @xml NVARCHAR(MAX)
						DECLARE @body NVARCHAR(MAX)
						DECLARE @profile_name NVARCHAR(255)
						DECLARE @recipients NVARCHAR(255)

						SELECT top 1  @profile_name = name FROM msdb.dbo.sysmail_profile mp

					SELECT @recipients =CASE WHEN (select ServerEnvironment from DBA.info.Instance) = 
					'DEV'THEN   'joseph.russell@alliedsolutions.neT; ITAdmins-UniTrac@alliedsolutions.net'
				WHEN (select ServerEnvironment from DBA.info.Instance) = 	'TST'THEN   'ITAdmins-UniTrac@alliedsolutions.net'
				WHEN (select ServerEnvironment from DBA.info.Instance) = 	'STG'THEN   'ITAdmins-UniTrac@alliedsolutions.net'
				WHEN (select ServerEnvironment from DBA.info.Instance) = 	'PRD'THEN   'AlliedPremiumCalculation@alliedsolutions.net'
				WHEN (select ServerEnvironment from DBA.info.Instance) = 	'PROD' THEN   'AlliedPremiumCalculation@alliedsolutions.net'
					ELSE  'ITAdmins-UniTrac@alliedsolutions.net'
						END

IF (select count(*) from #Data) >= 1
BEGIN
IF @DryRun = 0
BEGIN


						SET @xml = Cast(( SELECT
						[Count] AS 'td',' ',
						[Type] AS 'td',' ',
						[$$$] AS 'td',' '

						FROM #Data
						ORDER  BY Type ASC
						FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))

						SET @body ='<html><body><H3>AlliedPremiumCalculation</H3>
						<table border = 1> 
						<tr>
						<th>&nbsp&nbsp&nbspCount&nbsp&nbsp&nbsp</th><th>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbspType&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</th><th>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp$$$&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</th>'

						SET @body = @body + @xml +'</table></body> </html>'

     						  EXEC msdb.dbo.sp_send_dbmail 
           							@Subject= 'AlliedPremiumCalculation',
           							@profile_name = @profile_name,
           							@body = @body,
           							@body_format ='HTML',            
           							@recipients =@recipients;
END
ELSE
BEGIN

		SELECT * FROM #Data
END
END 
ELSE 
BEGIN
IF @DryRun = 0
BEGIN


						SET @xml = Cast(( SELECT
						[Count] AS 'td',' ',
						[Type] AS 'td',' ',
						[$$$] AS 'td',' '

						FROM #Data
						ORDER  BY Type ASC
						FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))

						SET @body ='<html><body><H3>AlliedPremiumCalculation</H3>
						<table border = 1> 
						<tr>
						<th>&nbsp&nbsp&nbspCount&nbsp&nbsp&nbsp</th><th>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbspType&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</th><th>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp$$$&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</th>'

						SET @body = @body + @xml +'</table></body> </html>'

     						  EXEC msdb.dbo.sp_send_dbmail 
           							@Subject= 'AlliedPremiumCalculation',
           							@profile_name =@profile_name,
           							@body = 'No Data for today!',
           							@body_format ='HTML',            
           							@recipients = @recipients;
END

ELSE
BEGIN

		SELECT * FROM #Data
END
END 
