USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[DashboardCacheRefresh]    Script Date: 12/14/2016 2:29:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[DashboardCacheRefresh] 
( @CacheDBName nvarchar(30), @CacheTableName nvarchar(30), @CacheName nvarchar(30) )

AS
BEGIN

   Declare @cacheDbTable as nvarchar(60)
   set @cacheDbTable = @cacheDBName + @cacheTableName

   Declare @sql as nvarchar(max)
   set @sql =
   'delete from ' + @cacheDbTable + ' where NAME_TX = ''' + @cacheName + ''''
   EXEC (@sql)

   if (@cacheName = 'WORKITEMS_COUNT')
   BEGIN
      set @sql =
      'insert into ' + @cacheDbTable + ' (NAME_TX, TYPE_CD, COUNT_NO, RECORD_DAY, RECORD_MONTH, RECORD_YEAR, RECORD_DATE, CACHE_CREATE_DT)
      SELECT ''' + @CacheName + ''' as NAME_TX, wd.WORKFLOW_TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
         DAY(wi.CREATE_DT) as RECORD_DAY, MONTH(wi.CREATE_DT) as RECORD_MONTH, YEAR(wi.CREATE_DT) as RECORD_YEAR,
         CONVERT(date, wi.CREATE_DT) as RECORD_DATE, GETDATE() as CACHE_CREATE_DT
      FROM WORK_ITEM wi
         join WORKFLOW_DEFINITION wd on wd.id = wi.WORKFLOW_DEFINITION_ID
         join LENDER l on l.ID = wi.LENDER_ID
      WHERE wi.PURGE_DT is NULL
         and wi.STATUS_CD not in (''Complete'',''Withdrawn'',''Error'')
         and l.AGENCY_ID = 1
         and l.TEST_IN = ''N''
         and (l.CANCEL_DT is null or l.CANCEL_DT > getdate())
      GROUP BY wd.WORKFLOW_TYPE_CD, YEAR(wi.CREATE_DT), MONTH(wi.CREATE_DT), DAY(wi.CREATE_DT), CONVERT(date, wi.CREATE_DT)'
      EXEC (@sql)
   END
   else if (@cacheName = 'CYCLE_DELAY')
   BEGIN
      set @sql =
      'SELECT pl.PROCESS_DEFINITION_ID, lcgct.LENDER_PRODUCT_ID, count(*) RUN_COUNT
      INTO #tmpPD
      FROM PROCESS_LOG pl
	      join PROCESS_DEFINITION pd on pd.ID = pl.PROCESS_DEFINITION_ID
	      join LENDER ldr on ldr.ID = pd.SETTINGS_XML_IM.value(''(/ProcessDefinitionSettings/LenderList/LenderID)[1]'', ''bigint'')
	      cross apply pd.SETTINGS_XML_IM.nodes(''/ProcessDefinitionSettings/LCGCTList/LCGCTId'') AS T1(LCGCTId)
	      join dbo.LENDER_COLLATERAL_GROUP_COVERAGE_TYPE lcgct on lcgct.ID = T1.LCGCTId.value(''text()[1]'', ''bigint'') 
      WHERE pd.PROCESS_TYPE_CD = ''CYCLEPRC''
	      and pd.ACTIVE_IN = ''Y''
	      and pd.EXECUTION_FREQ_CD != ''RUNONCE''
	      and ldr.TEST_IN = ''N''
	      and pl.STATUS_CD IN (''Complete'', ''InProcess'') 
      GROUP BY pl.PROCESS_DEFINITION_ID, lcgct.LENDER_PRODUCT_ID

      SELECT DISTINCT pd.ID, pd.NAME_TX, pd.EXECUTION_FREQ_CD,
		   cast(pd.LAST_RUN_DT as DATE) LAST_RUN_DT, cast(pd.LAST_SCHEDULED_DT AS DATE) LAST_SCHEDULED_DT, pd.ONHOLD_IN,
		   CASE pd.EXECUTION_FREQ_CD
			   WHEN ''WEEK'' THEN pd.LAST_SCHEDULED_DT + (7 * pd.FREQ_MULTIPLIER_NO)
			   WHEN ''DAY'' THEN pd.LAST_SCHEDULED_DT + (1 * pd.FREQ_MULTIPLIER_NO)
			   WHEN ''28DAYS'' THEN pd.LAST_SCHEDULED_DT + (28 * pd.FREQ_MULTIPLIER_NO)
			   WHEN ''14DAYS'' THEN pd.LAST_SCHEDULED_DT + (14 * pd.FREQ_MULTIPLIER_NO)
			   WHEN ''MONTHLY'' THEN pd.LAST_SCHEDULED_DT + (30 * pd.FREQ_MULTIPLIER_NO)
			   WHEN ''SEMIMONTH'' THEN pd.LAST_SCHEDULED_DT + (15 * pd.FREQ_MULTIPLIER_NO)
			   ELSE 0
			END AS CALCULATED_NEXT_RUN_DATE,
		   lp.BASIC_TYPE_CD,
		   pd.FREQ_MULTIPLIER_NO,
		   ldr.STATUS_CD LENDER_STATUS	
		INTO #tmpPD2
      FROM dbo.PROCESS_DEFINITION pd
	      join #tmpPD tmp on tmp.PROCESS_DEFINITION_ID = pd.ID
	      join dbo.LENDER_PRODUCT lp ON lp.ID = tmp.LENDER_PRODUCT_ID
	      join dbo.LENDER ldr on ldr.ID = lp.LENDER_ID
      WHERE DATEDIFF(day,cast(pd.LAST_RUN_DT as date),GetDate ()) >  
			CASE pd.EXECUTION_FREQ_CD
			   WHEN ''WEEK'' THEN ((7 * pd.FREQ_MULTIPLIER_NO)+ 2)
			   WHEN ''DAY'' THEN ((1 * pd.FREQ_MULTIPLIER_NO)+ 2)
			   WHEN ''28DAYS'' THEN ((28 * pd.FREQ_MULTIPLIER_NO)+ 2)
			   WHEN ''14DAYS'' THEN ((14 * pd.FREQ_MULTIPLIER_NO)+ 2)
			   WHEN ''MONTHLY'' THEN ((30 * pd.FREQ_MULTIPLIER_NO)+ 2)
			   WHEN ''SEMIMONTH'' THEN ((15 * pd.FREQ_MULTIPLIER_NO) + 2)
			   WHEN ''QUARTERLY'' THEN ((90 * pd.FREQ_MULTIPLIER_NO) + 2)
			   WHEN ''ANNUAL'' THEN ((365 * pd.FREQ_MULTIPLIER_NO)+ 2)
			   ELSE 0
			END
         and BASIC_TYPE_CD in (''FLTRK'', ''CPI'', ''ORDERUP'')
      ORDER BY pd.ID ASC

      insert into ' + @cacheDbTable + ' (NAME_TX, COUNT_NO, CACHE_CREATE_DT)
      SELECT ''' + @CacheName + ''' as NAME_TX, count(*) as COUNT_NO, GETDATE() as CACHE_CREATE_DT
      FROM #tmpPD2'
      EXEC (@sql)
   END
   else if (@cacheName = 'DAILY_PREMIUMS')
   BEGIN
      set @sql =
      'insert into ' + @cacheDbTable + ' (NAME_TX, RECORD_YEAR, RECORD_MONTH, RECORD_DAY, RECORD_DATE, CACHE_CREATE_DT, TYPE_CD, AMOUNT_NO)
      SELECT ''' + @CacheName + ''' as NAME_TX, YEAR(ft.TXN_DT) as RECORD_YEAR, MONTH(ft.TXN_DT) as RECORD_MONTH, DAY(ft.TXN_DT) as RECORD_DAY, ft.TXN_DT as RECORD_DATE,
	      GETDATE() as CACHE_CREATE_DT,
         ft.TXN_TYPE_CD as TYPE_CD,
	      ft.AMOUNT_NO as AMOUNT_NO
      FROM FINANCIAL_TXN ft
         join FORCE_PLACED_CERTIFICATE fpc on ft.FPC_ID = fpc.ID
         join LOAN l on fpc.LOAN_ID = l.ID
         join LENDER lend on l.LENDER_ID = lend.ID and lend.AGENCY_ID = 1
      WHERE ft.txn_dt > GETDATE() -60 and ft.txn_dt < GETDATE()
         and ft.PURGE_DT is null and ft.TXN_TYPE_CD in (''P'', ''CP'')
      GROUP BY ft.TXN_TYPE_CD, ft.TXN_DT, ft.AMOUNT_NO'
      EXEC (@sql)
   END
   else if (@cacheName = 'LOANCOUNT_2Y')
   BEGIN
      set @sql =
      'insert into ' + @cacheDbTable + ' (NAME_TX, COUNT_NO, RECORD_MONTH, RECORD_YEAR, CACHE_CREATE_DT)
      SELECT ''' + @CacheName + ''' as NAME_TX, COUNT(*) as COUNT_NO, 
         MONTH(l.CREATE_DT) as RECORD_MONTH, YEAR(l.CREATE_DT) as RECORD_YEAR, GETDATE() as CACHE_CREATE_DT
      FROM LOAN l
      WHERE YEAR(l.CREATE_DT) >= YEAR(dateadd(year,-1,GETDATE()))
      GROUP BY MONTH(l.CREATE_DT), YEAR(l.CREATE_DT)'
      EXEC (@sql)
   END
   else if (@cacheName = 'LOANCOUNT_CERTS')
   BEGIN
      set @sql =
      'SELECT lend.CODE_TX as LenderCode,lend.NAME_TX as LenderName,
	      DATEADD(dd,rc.DelayedBilling,fpc.ISSUE_DT) as AvailableToBeBillit,
	      rc.DelayedBilling,rc.ForcedPlcyOptUseCertAuth,fpc.AUTH_REQ_DT as AuthReqDt,
	      l.NUMBER_TX as LoanNumber, fpc.BILLING_STATUS_CD,
	      fpc.id as FPCId,fpc.NUMBER_TX,CERTSum.CPIASum as CPIASum, FTSum.FinTxnSum as FinTxnSum
      INTO #Temp1
      FROM FORCE_PLACED_CERTIFICATE fpc
      inner join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE fpcrcr on fpcrcr.FPC_ID = fpc.ID
	      and fpcrcr.PURGE_DT is null
      inner join REQUIRED_COVERAGE rc on rc.ID = fpcrcr.REQUIRED_COVERAGE_ID
	      and rc.PURGE_DT is null and rc.DelayedBilling > 0
      inner join LENDER_COLLATERAL_GROUP_COVERAGE_TYPE lcgct on lcgct.ID = rc.LCGCT_ID
	      and lcgct.PURGE_DT is null
      inner join COLLATERAL coll on coll.PROPERTY_ID = rc.PROPERTY_ID
	      and coll.PURGE_DT is null and coll.PRIMARY_LOAN_IN = ''Y''
      inner join LOAN l on l.ID = coll.LOAN_ID
	      and l.PURGE_DT is null
      inner join lender lend on lend.id = l.lender_id
	      and lend.PURGE_DT is null
      CROSS APPLY
      (
	      SELECT SUM(cpia.TOTAL_PREMIUM_NO) AS CPIASum FROM CPI_ACTIVITY cpia
	      WHERE cpia.CPI_QUOTE_ID = fpc.CPI_QUOTE_ID
		      and cpia.PURGE_DT is null
		      and cpia.TYPE_CD in (''I'',''C'')
      ) AS CERTSum
      OUTER APPLY
      (
         SELECT SUM(ft.AMOUNT_NO) AS FinTxnSum FROM FINANCIAL_TXN ft
	      WHERE ft.FPC_ID = fpc.ID
		      and ft.PURGE_DT is null
      ) AS FTSum
      WHERE fpc.BILLING_STATUS_CD = ''PEND''
	      and DATEADD(dd,rc.DelayedBilling,fpc.ISSUE_DT) > GETDATE()
      ORDER BY fpc.ID

      insert into ' + @cacheDbTable + ' (NAME_TX, ASSOC_CD, ASSOC_NAME_TX, COUNT_NO, CACHE_CREATE_DT)
      SELECT ''' + @CacheName + ''' as NAME_TX, 
         t1.LenderCode as ASSOC_CD, t1.LenderName as ASSOC_NAME_TX, COUNT(distinct t1.NUMBER_TX)as COUNT_NO, GETDATE() as CACHE_CREATE_DT
      FROM #Temp1 t1
      WHERE ((t1.CPIASum <> 0)
         or (isnull(t1.FinTxnSum,0) <> 0))
         and ((t1.ForcedPlcyOptUseCertAuth = ''0'')
         or ((t1.ForcedPlcyOptUseCertAuth = ''1'') and (t1.AuthReqDt is NOT null)))
      GROUP BY t1.LenderCode, t1.LenderName
      ORDER BY COUNT_NO desc'
      EXEC (@sql)
   END
   else if (@cacheName = 'TOP_LENDERS')
   BEGIN
      set @sql =
      'insert into ' + @cacheDbTable + ' (NAME_TX, ASSOC_NAME_TX, ASSOC_CD, STATUS_CD, SOURCE_CD, COUNT_NO, CACHE_CREATE_DT)
      SELECT ''' + @CacheName + ''' as NAME_TX, ldr.NAME_TX as ASSOC_NAME_TX, ldr.CODE_TX as ASSOC_CD, ldr.STATUS_CD AS LENDER_STATUS_CD,
         ln.DIVISION_CODE_TX as SOURCE_CD, COUNT(ln.ID) as LOAN_COUNTS, GETDATE() as CACHE_CREATE_DT
      FROM LOAN ln 
         join LENDER ldr ON ldr.ID = ln.LENDER_ID
      WHERE ln.RECORD_TYPE_CD = ''G''
         and ln.DIVISION_CODE_TX in (''3'',''8'',''4'',''10'')
         and ln.purge_dt is null
         and ldr.status_cd <> ''CANCEL''
      GROUP BY ldr.NAME_TX, ldr.CODE_TX, ldr.STATUS_CD, ln.DIVISION_CODE_TX'
      EXEC (@sql)
   END
   else if (@cacheName = 'TOTAL_COLLATERALS')
   BEGIN
     set @sql =
     'insert into ' + @cacheDbTable + ' (NAME_TX, COUNT_NO, CACHE_CREATE_DT)
     SELECT ''' + @CacheName + ''' as NAME_TX, COUNT(*) as COUNT_NO, GETDATE() as CACHE_CREATE_DT
     FROM COLLATERAL'
	 EXEC (@sql)
   END
   else if (@cacheName = 'TOTAL_COVERAGES')
   BEGIN
     set @sql =
     'insert into ' + @cacheDbTable + ' (NAME_TX, COUNT_NO, CACHE_CREATE_DT)
     SELECT ''' + @CacheName + ''' as NAME_TX, COUNT(*) as COUNT_NO, GETDATE() as CACHE_CREATE_DT
     FROM REQUIRED_COVERAGE'
	 EXEC (@sql)
   END
   else if (@cacheName = 'TOTAL_LOANS')
   BEGIN
      set @sql =
      'insert into ' + @cacheDbTable + ' (NAME_TX, COUNT_NO, CACHE_CREATE_DT)
      SELECT ''' + @CacheName + ''' as NAME_TX, COUNT(*) as COUNT_NO, GETDATE() as CACHE_CREATE_DT
      FROM LOAN'
	  EXEC (@sql)
   END
   else if (@cacheName = 'TOTAL_OWNERS')
   BEGIN
      set @sql =
      'insert into ' + @cacheDbTable + ' (NAME_TX, COUNT_NO, CACHE_CREATE_DT)
      SELECT ''' + @CacheName + ''' as NAME_TX, COUNT(*) as COUNT_NO, GETDATE() as CACHE_CREATE_DT
      FROM OWNER'
      EXEC (@sql)
   END
   else if (@cacheName = 'TOTAL_PROPERTIES')
   BEGIN
      set @sql =
      'insert into ' + @cacheDbTable + ' (NAME_TX, COUNT_NO, CACHE_CREATE_DT)
      SELECT ''' + @CacheName + ''' as NAME_TX, COUNT(*) as COUNT_NO, GETDATE() as CACHE_CREATE_DT
      FROM PROPERTY'
      EXEC (@sql)
   END
   else if (@cacheName = 'TOTAL_WORKITEMS')
   BEGIN
      set @sql =
      'insert into ' + @cacheDbTable + ' (NAME_TX, COUNT_NO, CACHE_CREATE_DT)
      SELECT ''' + @CacheName + ''' as NAME_TX, COUNT(*) as COUNT_NO, GETDATE() as CACHE_CREATE_DT
      FROM WORK_ITEM'
      EXEC (@sql)
   END
   else if (@cacheName = 'UTL_MATCHCOUNTS')
   BEGIN
      set @sql =
      'insert into ' + @cacheDbTable + ' (NAME_TX, ASSOC_CD, ASSOC_NAME_TX, COUNT_NO, TYPE_CD, SOURCE_CD, RESULT_CD, STATUS_CD, RECORD_MONTH, RECORD_YEAR, CACHE_CREATE_DT)
      SELECT ''' + @CacheName + ''' as NAME_TX, ldr.code_tx as ASSOC_CD, ldr.name_tx as ASSOC_NAME_TX, COUNT(*) as COUNT_NO, 
         ln.record_type_cd as TYPE_CD, ln.source_cd as SOURCE_CD, umr.match_result_cd as RESULT_CD, umr.apply_status_cd as STATUS_CD,
         CASE when MONTH(umr.CREATE_DT) is null then MONTH(ln.CREATE_DT)
		    else MONTH(umr.CREATE_DT)
	     END as RECORD_MONTH,
	     CASE when MONTH(umr.CREATE_DT) is null then YEAR(ln.CREATE_DT)
		    else YEAR(umr.CREATE_DT)
	     END as RECORD_YEAR, 
         GETDATE() as CACHE_CREATE_DT
      FROM LOAN ln
         join LENDER ldr on ldr.ID = ln.LENDER_ID and ldr.CANCEL_DT is null and ldr.STATUS_CD=''ACTIVE''
         left outer join UTL_MATCH_RESULT umr on umr.UTL_LOAN_ID = ln.ID
      WHERE
         ln.RECORD_TYPE_CD in (''E'',''I'',''U'')
         and ln.Create_dt > GETDATE()-(365/2)
      GROUP BY LDR.CODE_TX, LDR.NAME_TX, YEAR(umr.CREATE_DT), MONTH(umr.CREATE_DT), RECORD_TYPE_CD, SOURCE_CD, MATCH_RESULT_CD, APPLY_STATUS_CD,LN.CREATE_DT'
      EXEC (@sql)
   END
   else if (@cacheName = 'UTL_TOUCHCOUNTS')
   BEGIN
      set @sql =
      'insert into ' + @cacheDbTable + ' (NAME_TX, ASSOC_CD, ASSOC_NAME_TX, COUNT_NO, TYPE_CD, RESULT_CD, STATUS_CD, CACHE_CREATE_DT)
      SELECT ''' + @CacheName + ''' as NAME_TX, ldr.code_tx as ASSOC_CD, ldr.name_tx as ASSOC_NAME_TX, COUNT(*) as COUNT_NO, 
         ln.record_type_cd as TYPE_CD, umr.match_result_cd as RESULT_CD, umr.apply_status_cd as STATUS_CD, GETDATE() as CACHE_CREATE_DT
      FROM LOAN ln
         join LENDER ldr on ldr.ID = ln.LENDER_ID and ldr.CANCEL_DT is null and ldr.STATUS_CD=''ACTIVE''
         left outer join UTL_MATCH_RESULT umr on umr.UTL_LOAN_ID = ln.ID
      WHERE ln.RECORD_TYPE_CD in (''E'',''I'',''U'')
         and ln.CREATE_DT > (GETDATE() - (365/2))
      GROUP BY LDR.CODE_TX, LDR.NAME_TX, RECORD_TYPE_CD, MATCH_RESULT_CD, APPLY_STATUS_CD
      ORDER BY LDR.CODE_TX, COUNT(*) desc, RECORD_TYPE_CD, MATCH_RESULT_CD, APPLY_STATUS_CD'
	 EXEC (@sql)
   END
END


GO

