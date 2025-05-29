USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[DashboardCacheRefresh]    Script Date: 10/20/2017 4:51:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[DashboardCacheRefresh] 
( @CacheDBName nvarchar(30)=null, @CacheTableName nvarchar(30)=null, @CacheName nvarchar(30) )

AS
BEGIN
   Declare @cacheDate as nvarchar(20)
   set @cacheDate = GetUTCDate()
   
   delete from Unitrac_DW.dbo.DASH_CACHE where NAME_TX = @cacheName

   if (@cacheName = 'CYCLE_DELAY')
   BEGIN
      SELECT pl.PROCESS_DEFINITION_ID, lcgct.LENDER_PRODUCT_ID, count(*) RUN_COUNT
      INTO #tmpPD
      FROM PROCESS_LOG pl
	      join PROCESS_DEFINITION pd on pd.ID = pl.PROCESS_DEFINITION_ID
	      join LENDER ldr on ldr.ID = pd.SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]', 'bigint')
	      cross apply pd.SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LCGCTList/LCGCTId') AS T1(LCGCTId)
	      join dbo.LENDER_COLLATERAL_GROUP_COVERAGE_TYPE lcgct on lcgct.ID = T1.LCGCTId.value('text()[1]', 'bigint') 
      WHERE pd.PROCESS_TYPE_CD = 'CYCLEPRC'
	      and pd.ACTIVE_IN = 'Y'
	      and pd.EXECUTION_FREQ_CD != 'RUNONCE'
	      and ldr.TEST_IN = 'N'
	      and pl.STATUS_CD IN ('Complete', 'InProcess') 
      GROUP BY pl.PROCESS_DEFINITION_ID, lcgct.LENDER_PRODUCT_ID

      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, ASSOC_CD, ASSOC_NAME_TX, SOURCE_CD, STATUS_CD, TYPE_CD, RECORD_DAY, RECORD_MONTH, RECORD_DATE, CACHE_CREATE_DT)
      SELECT distinct @CacheName as NAME_TX, ldr.CODE_TX as ASSOC_CD, ldr.NAME_TX as ASSOC_NAME_TX,
	     '(PD:' + CAST(pd.ID as varchar) + ') ' + pd.NAME_TX as SOURCE_CD,
	     CASE WHEN pd.ONHOLD_IN = 'Y' THEN 'On Hold' ELSE 'Late' END as STATUS_CD,
		 pd.EXECUTION_FREQ_CD as TYPE_CD,
		 DATEDIFF(day,cast(pd.LAST_RUN_DT as date),cast(GetDate() as date)) -  
			(CASE pd.EXECUTION_FREQ_CD
			   WHEN 'WEEK' THEN (7 * pd.FREQ_MULTIPLIER_NO)
			   WHEN 'DAY' THEN (1 * pd.FREQ_MULTIPLIER_NO)
			   WHEN '28DAYS' THEN (28 * pd.FREQ_MULTIPLIER_NO)
			   WHEN '14DAYS' THEN (14 * pd.FREQ_MULTIPLIER_NO)
			   WHEN 'MONTHLY' THEN (30 * pd.FREQ_MULTIPLIER_NO)
			   WHEN 'SEMIMONTH' THEN (15 * pd.FREQ_MULTIPLIER_NO)
			   WHEN 'QUARTERLY' THEN (90 * pd.FREQ_MULTIPLIER_NO)
			   WHEN 'ANNUAL' THEN (365 * pd.FREQ_MULTIPLIER_NO)
			   ELSE 0
			END) as RECORD_DAY,
		 CASE pd.EXECUTION_FREQ_CD
	        WHEN 'WEEK' THEN DATEDIFF(day,cast(pd.LAST_RUN_DT as date),GetDate ()) / 7
			WHEN 'DAY' THEN DATEDIFF(day,cast(pd.LAST_RUN_DT as date),GetDate ()) / 1
			WHEN '28DAYS' THEN DATEDIFF(day,cast(pd.LAST_RUN_DT as date),GetDate ()) / 28
			WHEN '14DAYS' THEN DATEDIFF(day,cast(pd.LAST_RUN_DT as date),GetDate ()) / 14
			WHEN 'MONTHLY' THEN DATEDIFF(day,cast(pd.LAST_RUN_DT as date),GetDate ()) / 30
			WHEN 'SEMIMONTH' THEN DATEDIFF(day,cast(pd.LAST_RUN_DT as date),GetDate ()) / 15
			ELSE 0
        END AS RECORD_MONTH,
		 pd.LAST_RUN_DT as RECORD_DATE,
	     @cacheDate as CACHE_CREATE_DT
      FROM dbo.PROCESS_DEFINITION pd
	      join #tmpPD tmp on tmp.PROCESS_DEFINITION_ID = pd.ID
	      join dbo.LENDER_PRODUCT lp ON lp.ID = tmp.LENDER_PRODUCT_ID
	      join dbo.LENDER ldr on ldr.ID = lp.LENDER_ID
      WHERE DATEDIFF(day,cast(pd.LAST_RUN_DT as date),GetDate ()) >  
			CASE pd.EXECUTION_FREQ_CD
			   WHEN 'WEEK' THEN ((7 * pd.FREQ_MULTIPLIER_NO)+ 2)
			   WHEN 'DAY' THEN ((1 * pd.FREQ_MULTIPLIER_NO)+ 2)
			   WHEN '28DAYS' THEN ((28 * pd.FREQ_MULTIPLIER_NO)+ 2)
			   WHEN '14DAYS' THEN ((14 * pd.FREQ_MULTIPLIER_NO)+ 2)
			   WHEN 'MONTHLY' THEN ((30 * pd.FREQ_MULTIPLIER_NO)+ 2)
			   WHEN 'SEMIMONTH' THEN ((15 * pd.FREQ_MULTIPLIER_NO) + 2)
			   WHEN 'QUARTERLY' THEN ((90 * pd.FREQ_MULTIPLIER_NO) + 2)
			   WHEN 'ANNUAL' THEN ((365 * pd.FREQ_MULTIPLIER_NO)+ 2)
			   ELSE 0
			END
         and BASIC_TYPE_CD in ('FLTRK', 'CPI')
   END
   else if (@cacheName = 'DAILY_PREMIUMS')
   BEGIN
      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, RECORD_YEAR, RECORD_MONTH, RECORD_DAY, TYPE_CD, AMOUNT_NO, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX, YEAR(ft.TXN_DT) as RECORD_YEAR, MONTH(ft.TXN_DT) as RECORD_MONTH, DAY(ft.TXN_DT) as RECORD_DAY,
	     ft.TXN_TYPE_CD as TYPE_CD,
	     sum(ft.AMOUNT_NO) as AMOUNT_NO,
		 @cacheDate as CACHE_CREATE_DT
      FROM FINANCIAL_TXN ft
	     JOIN FORCE_PLACED_CERTIFICATE fpc on ft.FPC_ID = fpc.ID
	     AND fpc.PURGE_DT IS NULL
	     JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE REL ON REL.FPC_ID = FPC.ID
	     AND REL.PURGE_DT IS NULL
	     JOIN REQUIRED_COVERAGE RC ON RC.ID = REL.REQUIRED_COVERAGE_ID
	     AND RC.PURGE_DT IS NULL
	     JOIN PROPERTY PR ON PR.ID = RC.PROPERTY_ID
	     AND PR.PURGE_DT IS NULL
	     JOIN Collateral COLL
	     ON COLL.PROPERTY_ID = PR.ID AND COLL.PRIMARY_LOAN_IN = 'Y'
	     AND COLL.PURGE_DT IS NULL 
	     JOIN COLLATERAL_CODE CC ON CC.ID = COLL.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL  
	     JOIN REF_CODE_ATTRIBUTE RCA on RCA.DOMAIN_CD = 'SecondaryClassification'  
	     AND RCA.REF_CD = CC.SECONDARY_CLASS_CD
	     AND RCA.ATTRIBUTE_CD = 'PropertyType'   
	     WHERE 
		   (
			     PR.AGENCY_ID IN ( 1 , 9) OR 
			     ( PR.AGENCY_ID = 4 AND  
			     ( RCA.VALUE_TX = 'RE' OR (RCA.VALUE_TX = 'MH' AND ISNULL(PR.ADDRESS_ID, 0) > 0)))
		   ) 
         and ft.txn_dt >= GETDATE()-30 and ft.txn_dt < GETDATE()
         and ft.PURGE_DT is null and ft.TXN_TYPE_CD in ('P', 'CP')
      GROUP BY ft.TXN_TYPE_CD, YEAR(ft.TXN_DT), MONTH(ft.TXN_DT), DAY(ft.TXN_DT)
   END
   else if (@cacheName = 'LOANCOUNT_2Y')
   BEGIN
      Select ID
      into #tmpLender
      from LENDER ldr
      where ldr.TEST_IN = 'N' and ldr.STATUS_CD not in ('CANCEL', 'MERGED')

      declare @thisyear integer = year(getdate())
      declare @lastyear integer = @thisyear - 1
  
      SELECT count(*) as COUNT_NO, 
         case when YEAR(ln.CREATE_DT) < @lastyear then @lastyear else YEAR(ln.CREATE_DT) end as RECORD_YEAR,
	      case when (YEAR(ln.CREATE_DT) < @lastyear) then 1 else DATEPART(qq,ln.CREATE_DT) end as RECORD_MONTH
      into #tmpCounts
      FROM LOAN ln
	      JOIN #tmpLender ldr on ln.LENDER_ID = ldr.ID
      WHERE ln.RECORD_TYPE_CD = 'G'
      GROUP BY YEAR(ln.CREATE_DT), DATEPART(qq,ln.CREATE_DT)

      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, COUNT_NO, TYPE_CD, RECORD_YEAR, RECORD_MONTH, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX,
         (select sum(cnt2.COUNT_NO)
            from #tmpCounts cnt2 
            where (cnt2.RECORD_YEAR < cnt1.RECORD_YEAR or cnt2.RECORD_YEAR = cnt1.RECORD_YEAR and cnt2.RECORD_MONTH <= cnt1.RECORD_MONTH)) as COUNT_NO,
         'TOTAL' as TYPE_CD, cnt1.RECORD_YEAR, cnt1.RECORD_MONTH,
         GETUTCDATE() as CACHE_CREATE_DT
      FROM #tmpCounts cnt1
      GROUP BY RECORD_YEAR, RECORD_MONTH

     -- Get Total Active Loans

      select distinct(pcu.TABLE_ID) as LOAN_ID, MAX_DT = max(pcu.CREATE_DT), 
      case when (YEAR(pcu.CREATE_DT) < @lastyear) then @lastyear
           else YEAR(pcu.CREATE_DT) end as YR,
      case when (YEAR(pcu.CREATE_DT) < @lastyear) then 1
           else DATEPART(qq,pcu.CREATE_DT) end as QTR,
      pcu.COLUMN_NM as STATUS, pcu.TO_VALUE_TX as VALUE
      into #tmpPCU
      from PROPERTY_CHANGE_UPDATE pcu
         join LOAN ln on ln.ID = pcu.TABLE_ID and ln.RECORD_TYPE_CD = 'G'
      WHERE pcu.TABLE_NAME_TX = 'LOAN' and pcu.COLUMN_NM = 'STATUS_CD'
      GROUP BY pcu.TABLE_ID, pcu.COLUMN_NM, pcu.TO_VALUE_TX, YEAR(pcu.CREATE_DT), DATEPART(qq,pcu.CREATE_DT)

      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, COUNT_NO, RECORD_YEAR, RECORD_MONTH, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX, 'NET' as TYPE_CD,
         (select COUNT_NO 
	       from Unitrac_DW.dbo.DASH_CACHE cnt1 
	       where NAME_TX = 'LOANCOUNT_2Y' and TYPE_CD = 'TOTAL'
            and cnt1.RECORD_YEAR = pcu.YR and cnt1.RECORD_MONTH = pcu.QTR
         ) - COUNT(DISTINCT(ln.ID)) as COUNT_NO,
	      pcu.YR as RECORD_YEAR,
	      pcu.QTR as RECORD_MONTH, 
         GETUTCDATE() as CACHE_CREATE_DT
      FROM LOAN ln
         join #tmpPCU pcu on pcu.LOAN_ID = ln.ID
      WHERE ln.RECORD_TYPE_CD = 'G'
         and ((pcu.Status = 'STATUS_CD' and pcu.Value <> 'A')
         or (YEAR(ln.PURGE_DT) < pcu.YR) or (YEAR(ln.PURGE_DT) = pcu.YR and datepart(qq,ln.PURGE_DT) <= pcu.QTR))
      GROUP BY pcu.YR, pcu.QTR

-----Get new loans

      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, COUNT_NO, TYPE_CD, RECORD_YEAR, RECORD_MONTH, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX, COUNT(*) as COUNT_NO, 'NEW' as TYPE_CD,
	     YEAR(ln.CREATE_DT) as RECORD_YEAR, DATEPART(qq,ln.CREATE_DT) as RECORD_MONTH, GETUTCDATE() as CACHE_CREATE_DT
      FROM LOAN ln
	     join #tmpLender ldr on ln.LENDER_ID = ldr.ID
      WHERE YEAR(ln.CREATE_DT) >= YEAR(dateadd(year,-1,GETDATE()))
	     and ln.RECORD_TYPE_CD = 'G'
      GROUP BY YEAR(ln.CREATE_DT), DATEPART(qq,ln.CREATE_DT)

   END
   else if (@cacheName = 'CERTS_NOTBILLED')
   BEGIN
      SELECT lend.CODE_TX as LenderCode, lend.NAME_TX as LenderName,
      CAST (CONVERT(VARCHAR(10) , DATEADD(dd,rc.DelayedBilling + 1,fpc.ISSUE_DT) , 101) AS DATETIME) as AvailableToBeBillit,
      rc.DelayedBilling,
      rc.ForcedPlcyOptUseCertAuth,
      CONVERT(date, fpc.AUTH_REQ_DT) as AuthReqDt,
      fpc.id as FPCId,
      fpc.NUMBER_TX,
      CERTSum.CPIASum as CPIASum, 
      FTSum.FinTxnSum as FinTxnSum,
      rc.LCGCT_ID as RCLCGCTID
      into #Temp1
      from FORCE_PLACED_CERTIFICATE fpc
      inner join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE fpcrcr on fpcrcr.FPC_ID = fpc.ID
            and fpcrcr.PURGE_DT is null
      inner join REQUIRED_COVERAGE rc on rc.ID = fpcrcr.REQUIRED_COVERAGE_ID
            and rc.PURGE_DT is null
      inner join PROPERTY p on p.ID = rc.PROPERTY_ID
            and p.PURGE_DT is null
      inner join LENDER_COLLATERAL_GROUP_COVERAGE_TYPE lcgct on lcgct.ID = rc.LCGCT_ID
            and lcgct.PURGE_DT is null
      inner join lender lend on lend.id = p.LENDER_ID
            and lend.PURGE_DT is null
            and lend.TEST_IN != 'Y'
      CROSS APPLY 
      (
      SELECT SUM(cpia.TOTAL_PREMIUM_NO) AS CPIASum FROM CPI_ACTIVITY cpia
      WHERE cpia.CPI_QUOTE_ID = fpc.CPI_QUOTE_ID
      AND cpia.PURGE_DT is null
      and cpia.TYPE_CD in ('I', 'C', 'R', 'MT')
      ) AS CERTSum
      outer APPLY 
      (
      SELECT SUM(ft.AMOUNT_NO) AS FinTxnSum FROM FINANCIAL_TXN ft
      WHERE ft.FPC_ID = fpc.ID
      AND ft.PURGE_DT is null
      ) AS FTSum
      where
      fpc.BILLING_STATUS_CD = 'PEND'
      and CAST (CONVERT(VARCHAR(10) , DATEADD(dd,rc.DelayedBilling,fpc.ISSUE_DT) , 101) AS DATETIME) <=  CAST (CONVERT(VARCHAR(10) , GETDATE() , 101) AS DATETIME)
      order by fpc.ID

      SELECT pd.id as PDId,
      T1.LCGCTId.value('text()[1]', 'bigint') as LCGCT_ID,
      CONVERT(date, pd.LAST_RUN_DT) as PDLastRunDate
      into #TempProcDefs
      from PROCESS_DEFINITION pd
      CROSS APPLY pd.SETTINGS_XML_IM.nodes('/ProcessDefinitionSettings/LCGCTList/LCGCTId') AS T1(LCGCTId) 
            where pd.PROCESS_TYPE_CD = 'BILLING'
            and pd.PURGE_DT is null

      SELECT tbd.PDId as PDId, tbd.LCGCT_ID as LCGCTId,max(tbd.PDLastRunDate) PDLastRunDate
      into #Temp2
      from #TempProcDefs tbd
      group by tbd.PDId, tbd.LCGCT_ID

      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, ASSOC_CD, ASSOC_NAME_TX, SOURCE_CD, COUNT_NO, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX, 
         LenderCode as ASSOC_CD, LenderName as ASSOC_NAME_TX, t1.NUMBER_TX as SOURCE_CD,
		 count(distinct FPCId) as COUNT_NO, @cacheDate as CACHE_CREATE_DT
      FROM #Temp2 t2
         inner join #Temp1 t1 on t1.RCLCGCTID = t2.LCGCTId
      WHERE t1.AvailableToBeBillit <=  t2.PDLastRunDate
         and t1.CPIASum <> 0
         and ((t1.ForcedPlcyOptUseCertAuth = '0')
         or ((t1.ForcedPlcyOptUseCertAuth = '1') and (t1.AuthReqDt is NOT null)))
      GROUP BY LenderCode, LenderName, t1.NUMBER_TX
   END
   else if (@cacheName = 'LENDERS_LN_COUNT')
   BEGIN
      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, ASSOC_NAME_TX, ASSOC_CD, SOURCE_CD, COUNT_NO, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX, ldr.NAME_TX as ASSOC_NAME_TX, ldr.CODE_TX as ASSOC_CD,
         ln.DIVISION_CODE_TX as SOURCE_CD, COUNT(ln.ID) as COUNT_NO, @cacheDate as CACHE_CREATE_DT
      FROM LOAN ln 
         join LENDER ldr ON ldr.ID = ln.LENDER_ID
      WHERE ln.RECORD_TYPE_CD = 'G'
         --and ln.DIVISION_CODE_TX in ('3','8','4','10','99','7','9')
         and ln.purge_dt is null
		 and ldr.status_cd not in ('CANCEL', 'MERGED') and ldr.TEST_IN = 'N'
      GROUP BY ldr.NAME_TX, ldr.CODE_TX, ln.DIVISION_CODE_TX
   END
   else if (@cacheName = 'LENDERS_RC_COUNT')
   BEGIN
      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, ASSOC_NAME_TX, ASSOC_CD, SOURCE_CD, COUNT_NO, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX, ldr.NAME_TX as ASSOC_NAME_TX, ldr.CODE_TX as ASSOC_CD,
	     ln.DIVISION_CODE_TX as SOURCE_CD, COUNT(rc.ID) as COUNT_NO, @cacheDate as CACHE_CREATE_DT
      from REQUIRED_COVERAGE rc
         join COLLATERAL c on c.PROPERTY_ID = rc.PROPERTY_ID
	     join LOAN ln on c.LOAN_ID = ln.ID
	     join LENDER ldr on ldr.ID = ln.LENDER_ID
      WHERE ln.RECORD_TYPE_CD = 'G'
         --and ln.DIVISION_CODE_TX in ('3','8','4','10','99','7','9')
         and ln.purge_dt is null
		 and rc.purge_dt is null
		 and c.purge_dt is null
		 and rc.STATUS_CD <> 'I'
		 and c.STATUS_CD <> 'I'
         and ldr.status_cd not in ('CANCEL', 'MERGED') and ldr.TEST_IN = 'N'
      GROUP BY ldr.NAME_TX, ldr.CODE_TX, ln.DIVISION_CODE_TX
   END
   else if (@cacheName = 'TOTAL_COLLATERALS')
   BEGIN
     insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, COUNT_NO, CACHE_CREATE_DT)
     SELECT @CacheName as NAME_TX, COUNT(*) as COUNT_NO, @cacheDate as CACHE_CREATE_DT
     FROM COLLATERAL
   END
   else if (@cacheName = 'TOTAL_COVERAGES')
   BEGIN
     insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, COUNT_NO, CACHE_CREATE_DT)
     SELECT @CacheName as NAME_TX, COUNT(*) as COUNT_NO, @cacheDate as CACHE_CREATE_DT
     FROM REQUIRED_COVERAGE
   END
   else if (@cacheName = 'TOTAL_LOANS')
   BEGIN
      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, COUNT_NO, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX, COUNT(*) as COUNT_NO, @cacheDate as CACHE_CREATE_DT
      FROM LOAN
   END
   else if (@cacheName = 'TOTAL_OWNERS')
   BEGIN
      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, COUNT_NO, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX, COUNT(*) as COUNT_NO, @cacheDate as CACHE_CREATE_DT
      FROM OWNER
   END
   else if (@cacheName = 'TOTAL_PROPERTIES')
   BEGIN
      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, COUNT_NO, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX, COUNT(*) as COUNT_NO, @cacheDate as CACHE_CREATE_DT
      FROM PROPERTY
   END
   else if (@cacheName = 'TOTAL_WORKITEMS')
   BEGIN
      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, COUNT_NO, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX, COUNT(*) as COUNT_NO, @cacheDate as CACHE_CREATE_DT
      FROM WORK_ITEM
   END
   else if (@cacheName = 'UTL_MATCHCOUNTS')
   BEGIN
      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, ASSOC_CD, ASSOC_NAME_TX, COUNT_NO, RECORD_MONTH, SOURCE_CD, RESULT_CD, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX, ldr.code_tx as ASSOC_CD, ldr.name_tx as ASSOC_NAME_TX, COUNT(*) as COUNT_NO,
	     1 as RECORD_MONTH,
	     'EDI/IDR' as SOURCE_CD,
         umr.match_result_cd as RESULT_CD,
         @cacheDate as CACHE_CREATE_DT
      FROM LOAN ln
         join LENDER ldr on ldr.ID = ln.LENDER_ID and ldr.STATUS_CD='ACTIVE' and ldr.TEST_IN = 'N'
         left outer join UTL_MATCH_RESULT umr on ln.ID = umr.UTL_LOAN_ID
      WHERE
         ln.RECORD_TYPE_CD in ('E','I')
         and ln.CREATE_DT >= (GETDATE() - 30)
      GROUP BY LDR.CODE_TX, LDR.NAME_TX, MATCH_RESULT_CD
      UNION
      SELECT @CacheName as NAME_TX, ldr.code_tx as ASSOC_CD, ldr.name_tx as ASSOC_NAME_TX, COUNT(*) as COUNT_NO,
	     1 as RECORD_MONTH,
	     ln.SOURCE_CD as SOURCE_CD,
         umr.match_result_cd as RESULT_CD,
         @cacheDate as CACHE_CREATE_DT
      FROM LOAN ln
         join LENDER ldr on ldr.ID = ln.LENDER_ID and ldr.STATUS_CD='ACTIVE' and ldr.TEST_IN = 'N'
         left outer join UTL_MATCH_RESULT umr on ln.ID = umr.UTL_LOAN_ID
      WHERE
         ln.RECORD_TYPE_CD = 'U'
         and ln.CREATE_DT >= (GETDATE() - 30)
      GROUP BY LDR.CODE_TX, LDR.NAME_TX, SOURCE_CD, MATCH_RESULT_CD
      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, ASSOC_CD, ASSOC_NAME_TX, COUNT_NO, RECORD_MONTH, SOURCE_CD, RESULT_CD, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX, ldr.code_tx as ASSOC_CD, ldr.name_tx as ASSOC_NAME_TX, COUNT(*) as COUNT_NO,
	     2 as RECORD_MONTH,
	     'EDI/IDR' as SOURCE_CD,
         umr.match_result_cd as RESULT_CD,
         @cacheDate as CACHE_CREATE_DT
      FROM LOAN ln
         join LENDER ldr on ldr.ID = ln.LENDER_ID and ldr.STATUS_CD='ACTIVE' and ldr.TEST_IN = 'N'
         left outer join UTL_MATCH_RESULT umr on ln.ID = umr.UTL_LOAN_ID
      WHERE
         ln.RECORD_TYPE_CD in ('E','I')
         and ln.CREATE_DT >= (GETDATE() - 60)
		 and ln.CREATE_DT < (GETDATE() - 30)
      GROUP BY LDR.CODE_TX, LDR.NAME_TX, MATCH_RESULT_CD
      UNION
      SELECT @CacheName as NAME_TX, ldr.code_tx as ASSOC_CD, ldr.name_tx as ASSOC_NAME_TX, COUNT(*) as COUNT_NO,
	     2 as RECORD_MONTH,
	     ln.SOURCE_CD as SOURCE_CD,
         umr.match_result_cd as RESULT_CD,
         @cacheDate as CACHE_CREATE_DT
      FROM LOAN ln
         join LENDER ldr on ldr.ID = ln.LENDER_ID and ldr.STATUS_CD='ACTIVE' and ldr.TEST_IN = 'N'
         left outer join UTL_MATCH_RESULT umr on ln.ID = umr.UTL_LOAN_ID
      WHERE
         ln.RECORD_TYPE_CD = 'U'
         and ln.CREATE_DT >= (GETDATE() - 60)
		 and ln.CREATE_DT < (GETDATE() - 30)
      GROUP BY LDR.CODE_TX, LDR.NAME_TX, SOURCE_CD, MATCH_RESULT_CD
   END
   else if (@cacheName = 'UTL_TOUCHCOUNTS')
   BEGIN
      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, ASSOC_CD, ASSOC_NAME_TX, COUNT_NO, TYPE_CD, RESULT_CD, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX, ldr.code_tx as ASSOC_CD, ldr.name_tx as ASSOC_NAME_TX, COUNT(*) as COUNT_NO, 
         ln.record_type_cd as TYPE_CD, umr.match_result_cd as RESULT_CD, @cacheDate as CACHE_CREATE_DT
      FROM LOAN ln
         join LENDER ldr on ldr.ID = ln.LENDER_ID and ldr.STATUS_CD='ACTIVE'
         left outer join UTL_MATCH_RESULT umr on ln.ID = umr.UTL_LOAN_ID
      WHERE ln.RECORD_TYPE_CD in ('E','I','U')
         and ln.CREATE_DT >= (GETDATE() - 30)
      GROUP BY LDR.CODE_TX, LDR.NAME_TX, RECORD_TYPE_CD, MATCH_RESULT_CD
   END
   else if (@cacheName = 'WORKITEMS_COUNT')
   BEGIN
      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, COUNT_NO, RECORD_DAY, CACHE_CREATE_DT)
      select @CacheName as NAME_TX, wd.WORKFLOW_TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
          1 as RECORD_DAY,
          @cacheDate as CACHE_CREATE_DT
      from WORK_ITEM wi
         join WORKFLOW_DEFINITION wd on wd.id = wi.WORKFLOW_DEFINITION_ID
         --join LENDER l on l.ID = wi.CONTENT_XML.value('(Content/Lender/Id/node())[1]', 'bigint')
      WHERE wi.PURGE_DT is NULL
         and wi.STATUS_CD not in ('Complete','Withdrawn')
         and DATEDIFF(HOUR, wi.CREATE_DT, GETDATE()) <= 24
         --and l.AGENCY_ID = 1
         --and l.TEST_IN = 'N'
      GROUP BY wd.WORKFLOW_TYPE_CD
      
      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, COUNT_NO, RECORD_DAY, CACHE_CREATE_DT)
      select @CacheName as NAME_TX, wd.WORKFLOW_TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
         2 as RECORD_DAY,
         @cacheDate as CACHE_CREATE_DT
      from WORK_ITEM wi
         join WORKFLOW_DEFINITION wd on wd.id = wi.WORKFLOW_DEFINITION_ID
         --join LENDER l on l.ID = wi.CONTENT_XML.value('(Content/Lender/Id/node())[1]', 'bigint')
      WHERE wi.PURGE_DT is NULL
         and wi.STATUS_CD not in ('Complete','Withdrawn')
         and (DATEDIFF(HOUR, wi.CREATE_DT, GETDATE()) > 24 and
		      DATEDIFF(HOUR, wi.CREATE_DT, GETDATE()) <= 48)
         --and l.TEST_IN = 'N'
      GROUP BY wd.WORKFLOW_TYPE_CD

      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, COUNT_NO, RECORD_DAY, CACHE_CREATE_DT)
      select @CacheName as NAME_TX, wd.WORKFLOW_TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
         3 as RECORD_DAY,
         @cacheDate as CACHE_CREATE_DT
      from WORK_ITEM wi
         join WORKFLOW_DEFINITION wd on wd.id = wi.WORKFLOW_DEFINITION_ID
         --join LENDER l on l.ID = wi.CONTENT_XML.value('(Content/Lender/Id/node())[1]', 'bigint')
      WHERE wi.PURGE_DT is NULL
         and wi.STATUS_CD not in ('Complete','Withdrawn')
         and (DATEDIFF(HOUR, wi.CREATE_DT, GETDATE()) > 48 and
              DATEDIFF(HOUR, wi.CREATE_DT, GETDATE()) <= 72)
         --and l.TEST_IN = 'N'
      GROUP BY wd.WORKFLOW_TYPE_CD

      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, COUNT_NO, RECORD_DAY, CACHE_CREATE_DT) 
      select @CacheName as NAME_TX, wd.WORKFLOW_TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
         5 as RECORD_DAY,
         @cacheDate as CACHE_CREATE_DT
      from WORK_ITEM wi
         join WORKFLOW_DEFINITION wd on wd.id = wi.WORKFLOW_DEFINITION_ID
         --join LENDER l on l.ID = wi.CONTENT_XML.value('(Content/Lender/Id/node())[1]', 'bigint')
      WHERE wi.PURGE_DT is NULL
         and wi.STATUS_CD not in ('Complete','Withdrawn')
         and (DATEDIFF(HOUR, wi.CREATE_DT, GETDATE()) > 72 and
              DATEDIFF(HOUR, wi.CREATE_DT, GETDATE()) <= 120)
         --and l.TEST_IN = 'N'
      GROUP BY wd.WORKFLOW_TYPE_CD
      
      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, COUNT_NO, RECORD_DAY, CACHE_CREATE_DT)
      select @CacheName as NAME_TX, wd.WORKFLOW_TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
         14 as RECORD_DAY,
         @cacheDate as CACHE_CREATE_DT
      from WORK_ITEM wi
         join WORKFLOW_DEFINITION wd on wd.id = wi.WORKFLOW_DEFINITION_ID
         --join LENDER l on l.ID = wi.CONTENT_XML.value('(Content/Lender/Id/node())[1]', 'bigint')
      WHERE wi.PURGE_DT is NULL
         and wi.STATUS_CD not in ('Complete','Withdrawn')
         and (DATEDIFF(HOUR, wi.CREATE_DT, GETDATE()) > 120 and
              DATEDIFF(HOUR, wi.CREATE_DT, GETDATE()) <= 336)
         --and l.TEST_IN = 'N'
      GROUP BY wd.WORKFLOW_TYPE_CD
      
	  insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, COUNT_NO, RECORD_DAY, CACHE_CREATE_DT)
      select @CacheName as NAME_TX, wd.WORKFLOW_TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
         999 as RECORD_DAY,
         @cacheDate as CACHE_CREATE_DT
      from WORK_ITEM wi
         join WORKFLOW_DEFINITION wd on wd.id = wi.WORKFLOW_DEFINITION_ID
         --join LENDER l on l.ID = wi.CONTENT_XML.value('(Content/Lender/Id/node())[1]', 'bigint')
      WHERE wi.PURGE_DT is NULL
         and wi.STATUS_CD not in ('Complete','Withdrawn')
         and DATEDIFF(HOUR, wi.CREATE_DT, GETDATE()) > 336
         --and l.TEST_IN = 'N'
      GROUP BY wd.WORKFLOW_TYPE_CD
   END
   else if (@cacheName = 'WORKITEM_AGE')
   BEGIN
	    SELECT distinct wi.ID AS WORKITEM_ID, wd.WORKFLOW_TYPE_CD as TYPE_CD, wi.STATUS_CD AS STATUS_CD,
          wi.CREATE_DT AS CREATE_DT, wia.CREATE_DT as COMPLETE_DT, wia.TO_STATUS_CD as ACTION_CD
       INTO #TMP_WorkItem
       FROM WORK_ITEM wi
          join WORKFLOW_DEFINITION wd on wd.id = wi.WORKFLOW_DEFINITION_ID
          left outer join WORK_ITEM_ACTION wia on wi.id = wia.WORK_ITEM_ID and wia.TO_STATUS_CD in ('Complete', 'Withdrawn')
       WHERE wi.PURGE_DT is NULL
          and wi.CREATE_DT >= getdate() - 60
          and wd.WORKFLOW_TYPE_CD not in ('EOMReporting','InsuranceBackfeed','InboundCall')

      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, COUNT_NO, STATUS_CD, RECORD_DAY, RECORD_MONTH, CACHE_CREATE_DT)
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
         'Open' as STATUS_CD, 1 as RECORD_DAY, 1 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #TMP_WorkItem twi
      WHERE twi.STATUS_CD not in ('Complete','Withdrawn')
         and DATEDIFF(HOUR, twi.CREATE_DT, GETDATE()) <= 24
      GROUP BY twi.TYPE_CD
      union
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
         'Open' as STATUS_CD, 2 as RECORD_DAY, 1 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #TMP_WorkItem twi
      WHERE twi.STATUS_CD not in ('Complete','Withdrawn')
         and (DATEDIFF(HOUR, twi.CREATE_DT, GETDATE()) > 24 and
              DATEDIFF(HOUR, twi.CREATE_DT, GETDATE()) <= 48)
      GROUP BY twi.TYPE_CD
      union
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
          'Open' as STATUS_CD, 3 as RECORD_DAY, 1 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #TMP_WorkItem twi
      WHERE twi.STATUS_CD not in ('Complete','Withdrawn')
         and (DATEDIFF(HOUR, twi.CREATE_DT, GETDATE()) > 48 and
              DATEDIFF(HOUR, twi.CREATE_DT, GETDATE()) <= 72)
      GROUP BY twi.TYPE_CD
      union
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
         'Open' as STATUS_CD, 5 as RECORD_DAY, 1 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #TMP_WorkItem twi
      WHERE twi.STATUS_CD not in ('Complete','Withdrawn')
         and (DATEDIFF(HOUR, twi.CREATE_DT, GETDATE()) > 72 and
              DATEDIFF(HOUR, twi.CREATE_DT, GETDATE()) <= 120)
      GROUP BY twi.TYPE_CD
      union
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
          'Open' as STATUS_CD, 14 as RECORD_DAY, 1 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #TMP_WorkItem twi
      WHERE twi.STATUS_CD not in ('Complete','Withdrawn')
         and (DATEDIFF(HOUR, twi.CREATE_DT, GETDATE()) > 120 and
              DATEDIFF(HOUR, twi.CREATE_DT, GETDATE()) <= 336)
      GROUP BY twi.TYPE_CD
      union
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
          'Open' as STATUS_CD, 30 as RECORD_DAY, 1 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #TMP_WorkItem twi
      WHERE twi.STATUS_CD not in ('Complete','Withdrawn')
         and (DATEDIFF(HOUR, twi.CREATE_DT, GETDATE()) > 336 and
              DATEDIFF(HOUR, twi.CREATE_DT, GETDATE()) <= 720)
      GROUP BY twi.TYPE_CD
      union
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
          'Open' as STATUS_CD, 999 as RECORD_DAY, 1 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #TMP_WorkItem twi
      WHERE twi.STATUS_CD not in ('Complete','Withdrawn')
          and DATEDIFF(HOUR, twi.CREATE_DT, GETDATE()) > 720
      GROUP BY twi.TYPE_CD

      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, COUNT_NO, STATUS_CD, RECORD_DAY, RECORD_MONTH, CACHE_CREATE_DT)
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, count(*) as COUNT_NO,
         'Open' as STATUS_CD, 31 as RECORD_DAY, 2 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #tmp_Workitem twi
      where CAST(twi.CREATE_DT as DATE) = CAST((getdate() - 31) as DATE)
         and (CAST(twi.COMPLETE_DT as DATE) >= CAST((getdate() - 30) as DATE) or twi.COMPLETE_DT is null)
      group by twi.TYPE_CD
      union
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, count(*) as COUNT_NO,
         'Open' as STATUS_CD, 32 as RECORD_DAY, 2 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #tmp_Workitem twi
      where CAST(twi.CREATE_DT as DATE) = CAST((getdate() - 32) as DATE)
         and (CAST(twi.COMPLETE_DT as DATE) >= CAST((getdate() - 30) as DATE) or twi.COMPLETE_DT is null)
      group by twi.TYPE_CD
      union
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, count(*) as COUNT_NO,
         'Open' as STATUS_CD, 33 as RECORD_DAY, 2 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #tmp_Workitem twi
      where CAST(twi.CREATE_DT as DATE) = CAST((getdate() - 33) as DATE)
         and (CAST(twi.COMPLETE_DT as DATE) >= CAST((getdate() - 30) as DATE) or twi.COMPLETE_DT is null)
      group by twi.TYPE_CD
      union
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, count(*) as COUNT_NO,
         'Open' as STATUS_CD, 35 as RECORD_DAY, 2 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #tmp_Workitem twi
      where (CAST(twi.CREATE_DT as DATE) <= CAST((getdate() - 34) as DATE) and CAST(twi.CREATE_DT as DATE) >= CAST((getdate() - 35) as DATE))
         and (CAST(twi.COMPLETE_DT as DATE) >= CAST((getdate() - 30) as DATE) or twi.COMPLETE_DT is null)
      group by twi.TYPE_CD
      union
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, count(*) as COUNT_NO,
         'Open' as STATUS_CD, 44 as RECORD_DAY, 2 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #tmp_Workitem twi
      where (CAST(twi.CREATE_DT as DATE) <= CAST((getdate() - 36) as DATE) and CAST(twi.CREATE_DT as DATE) >= CAST((getdate() - 44) as DATE))
         and (CAST(twi.COMPLETE_DT as DATE) >= CAST((getdate() - 30) as DATE) or twi.COMPLETE_DT is null)
      group by twi.TYPE_CD
      union
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, count(*) as COUNT_NO,
         'Open' as STATUS_CD, 60 as RECORD_DAY, 2 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #tmp_Workitem twi
      where (CAST(twi.CREATE_DT as DATE) <= CAST((getdate() - 45) as DATE) and CAST(twi.CREATE_DT as DATE) >= CAST((getdate() - 60) as DATE))
         and (CAST(twi.COMPLETE_DT as DATE) >= CAST((getdate() - 30) as DATE) or twi.COMPLETE_DT is null)
      group by twi.TYPE_CD

      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, COUNT_NO, STATUS_CD, RECORD_DAY, RECORD_MONTH, CACHE_CREATE_DT)
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
         'Closed' as STATUS_CD, 1 as RECORD_DAY, 1 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #TMP_WorkItem twi
      where twi.ACTION_CD = 'Complete' and twi.CREATE_DT >= getdate() - 30
         and DATEDIFF(HOUR, twi.CREATE_DT, twi.COMPLETE_DT) <= 24
      GROUP BY twi.TYPE_CD
      union
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
         'Closed' as STATUS_CD, 2 as RECORD_DAY, 1 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #TMP_WorkItem twi
      where twi.ACTION_CD = 'Complete' and twi.CREATE_DT >= getdate() - 30
         and DATEDIFF(HOUR, twi.CREATE_DT, twi.COMPLETE_DT) > 24
         and DATEDIFF(HOUR, twi.CREATE_DT, twi.COMPLETE_DT) <= 48
      GROUP BY twi.TYPE_CD
      union
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
          'Closed' as STATUS_CD, 3 as RECORD_DAY, 1 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #TMP_WorkItem twi
      where twi.ACTION_CD = 'Complete' and twi.CREATE_DT >= getdate() - 30
         and DATEDIFF(HOUR, twi.CREATE_DT, twi.COMPLETE_DT) > 48
         and DATEDIFF(HOUR, twi.CREATE_DT, twi.COMPLETE_DT) <= 72
      GROUP BY twi.TYPE_CD
      union
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
         'Closed' as STATUS_CD, 5 as RECORD_DAY, 1 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #TMP_WorkItem twi
      where twi.ACTION_CD = 'Complete' and twi.CREATE_DT >= getdate() - 30
         and DATEDIFF(HOUR, twi.CREATE_DT, twi.COMPLETE_DT) > 72
         and DATEDIFF(HOUR, twi.CREATE_DT, twi.COMPLETE_DT) <= 120
      GROUP BY twi.TYPE_CD
      union
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
          'Closed' as STATUS_CD, 14 as RECORD_DAY, 1 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #TMP_WorkItem twi
      where twi.ACTION_CD = 'Complete' and twi.CREATE_DT >= getdate() - 30
         and DATEDIFF(HOUR, twi.CREATE_DT, twi.COMPLETE_DT) > 120
         and DATEDIFF(HOUR, twi.CREATE_DT, twi.COMPLETE_DT) <= 336
      GROUP BY twi.TYPE_CD
      union
      select @CacheName as NAME_TX, twi.TYPE_CD as TYPE_CD, Count(*) as COUNT_NO,
          'Closed' as STATUS_CD, 14 as RECORD_DAY, 1 as RECORD_MONTH, @cacheDate as CACHE_CREATE_DT
      from #TMP_WorkItem twi
      where twi.ACTION_CD = 'Complete' and twi.CREATE_DT >= getdate() - 30
         and DATEDIFF(HOUR, twi.CREATE_DT, twi.COMPLETE_DT) > 336
         and DATEDIFF(HOUR, twi.CREATE_DT, twi.COMPLETE_DT) <= 720
      GROUP BY twi.TYPE_CD
   END
   else if (@cacheName = 'CYCLE_PROCESS')
   BEGIN
      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, COUNT_NO, RECORD_DAY, RECORD_MONTH, RECORD_YEAR, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX, 'Run' as TYPE_CD, count(*) as COUNT_NO, 
         DAY(pl.CREATE_DT) as RECORD_DAY, MONTH(pl.CREATE_DT) as RECORD_MONTH, YEAR(pl.CREATE_DT) as RECORD_YEAR,
         @cacheDate as CACHE_CREATE_DT
      FROM PROCESS_DEFINITION pd
         join PROCESS_LOG pl on pl.PROCESS_DEFINITION_ID = pd.ID
      WHERE pd.PROCESS_TYPE_CD = 'CYCLEPRC'
         and pl.CREATE_DT > getdate()-14
         and pl.STATUS_CD = 'Complete'
      GROUP BY YEAR(pl.CREATE_DT), MONTH(pl.CREATE_DT), DAY(pl.CREATE_DT)
      union
      SELECT @CacheName as NAME_TX, 'Held' as TYPE_CD, count(*) as COUNT_NO, 
         DAY(pd.LAST_SCHEDULED_DT) as RECORD_DAY, MONTH(pd.LAST_SCHEDULED_DT) as RECORD_MONTH, YEAR(pd.LAST_SCHEDULED_DT) as RECORD_YEAR,
         @cacheDate as CACHE_CREATE_DT
      FROM PROCESS_DEFINITION pd
      WHERE pd.PROCESS_TYPE_CD = 'CYCLEPRC'
         and pd.ACTIVE_IN = 'Y'
         and pd.EXECUTION_FREQ_CD != 'RUNONCE'
         and pd.LAST_SCHEDULED_DT > getdate()-14
         and (DATEDIFF(DAY, pd.LAST_SCHEDULED_DT, pd.LAST_RUN_DT) > 1 or pd.LAST_RUN_DT < pd.LAST_SCHEDULED_DT)
         and pd.USE_LAST_SCHEDULED_DT_IN = 'Y'
      GROUP BY YEAR(pd.LAST_SCHEDULED_DT), MONTH(pd.LAST_SCHEDULED_DT), DAY(pd.LAST_SCHEDULED_DT)
      union
      SELECT @CacheName as NAME_TX, 'Escrow' as TYPE_CD, count(*) as COUNT_NO,
         DAY(pl.CREATE_DT) as RECORD_DAY, MONTH(pl.CREATE_DT) as RECORD_MONTH, YEAR(pl.CREATE_DT) as RECORD_YEAR,
         @cacheDate as CACHE_CREATE_DT
      FROM PROCESS_DEFINITION pd
         join PROCESS_LOG pl on pl.PROCESS_DEFINITION_ID = pd.ID
      WHERE pd.PROCESS_TYPE_CD = 'ESCROW'
         and pl.CREATE_DT > getdate()-14
         and pl.STATUS_CD = 'Complete'
      GROUP BY YEAR(pl.CREATE_DT), MONTH(pl.CREATE_DT), DAY(pl.CREATE_DT)
      union
      SELECT @CacheName as NAME_TX, 'Refund' as TYPE_CD, count(*) as COUNT_NO,
         DAY(pl.CREATE_DT) as RECORD_DAY, MONTH(pl.CREATE_DT) as RECORD_MONTH, YEAR(pl.CREATE_DT) as RECORD_YEAR,
         @cacheDate as CACHE_CREATE_DT
      FROM PROCESS_DEFINITION pd
         join PROCESS_LOG pl on pl.PROCESS_DEFINITION_ID = pd.ID
      WHERE pd.PROCESS_TYPE_CD = 'BILLING'
          and pd.SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/CancelRefund)[1]', 'char') = 'Y'
          and pl.CREATE_DT > getdate()-14
          and pl.STATUS_CD = 'Complete'
      GROUP BY YEAR(pl.CREATE_DT), MONTH(pl.CREATE_DT), DAY(pl.CREATE_DT)
   END
   else if (@cacheName = 'ESCROW_RPTD')
   BEGIN
      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, STATUS_CD, COUNT_NO, RECORD_DAY, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX, re.STATUS_CD as STATUS_CD, count(re.STATUS_CD) as COUNT_NO,
         DATEDIFF(DAY, ee.EVENT_DT, esc.DUE_DT) as RECORD_DAY,
         @cacheDate as CACHE_CREATE_DT
      FROM ESCROW esc
         join ESCROW_REQUIRED_COVERAGE_RELATE rel on rel.ESCROW_ID = esc.id
         join REQUIRED_COVERAGE rc on rc.ID = rel.REQUIRED_COVERAGE_ID
         join REQUIRED_ESCROW re on re.REQUIRED_COVERAGE_ID = rc.ID
		   join ESCROW_EVENT ee on ee.ESCROW_ID = esc.ID and ee.ACTION_TAKEN_CD in ('APPROVE','LenderAppr')
      WHERE ee.EVENT_DT >= getdate()-30 and ee.EVENT_DT < getdate()
         and esc.PURGE_DT is NULL
         and rel.PURGE_DT is NULL
         and rc.PURGE_DT is null
		   and ee.PURGE_DT is null
		   and re.STATUS_CD in ('CBP', 'CBR')
      GROUP BY re.STATUS_CD, DATEDIFF(DAY, ee.EVENT_DT, esc.DUE_DT)
      UNION
      SELECT @CacheName as NAME_TX, re.STATUS_CD as STATUS_CD, count(re.STATUS_CD) as COUNT_NO,
         DATEDIFF(DAY, ee.EVENT_DT, rc.GOOD_THRU_DT) as RECORD_DAY,
         @cacheDate as CACHE_CREATE_DT
      FROM ESCROW esc
         join ESCROW_REQUIRED_COVERAGE_RELATE rel on rel.ESCROW_ID = esc.id
         join REQUIRED_COVERAGE rc on rc.ID = rel.REQUIRED_COVERAGE_ID
         join REQUIRED_ESCROW re on re.REQUIRED_COVERAGE_ID = rc.ID
		   join ESCROW_EVENT ee on ee.ESCROW_ID = esc.ID --and ee.ACTION_TAKEN_CD in ('APPROVE','LenderAppr')
      WHERE ee.EVENT_DT >= getdate()-30 and ee.EVENT_DT < getdate()
         and esc.PURGE_DT is NULL
         and rel.PURGE_DT is NULL
         and rc.PURGE_DT is null
		   and rc.GOOD_THRU_DT is not null
		   and ee.PURGE_DT is null
		   and re.STATUS_CD in ('BM', 'PR', 'RRP')
      GROUP BY re.STATUS_CD, DATEDIFF(DAY, ee.EVENT_DT, rc.GOOD_THRU_DT)
   END
   else if (@cacheName = 'LFP_COUNTS')
   BEGIN
	   SELECT distinct wi.ID AS WORKITEM_ID, wi.RELATE_ID AS MESSAGE_ID, wi.CREATE_DT AS CREATE_DT, wi.STATUS_CD AS STATUS_CD
          INTO #TMP_LFP
	   FROM WORK_ITEM wi
          join WORKFLOW_DEFINITION wd on wd.id = wi.WORKFLOW_DEFINITION_ID
      WHERE wi.PURGE_DT is NULL
          and wd.NAME_TX = 'LenderExtract'
          and wi.STATUS_CD not in ('Complete','Withdrawn')
          and wi.CREATE_DT >= getdate() - 60

      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, STATUS_CD, COUNT_NO, RECORD_DAY, RECORD_MONTH, RECORD_YEAR, RECORD_DATE, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX, 'AGING' as TYPE_CD, twi.STATUS_CD, Count(*) as COUNT_NO,
         DAY(twi.CREATE_DT) as RECORD_DAY, MONTH(twi.CREATE_DT) as RECORD_MONTH, YEAR(twi.CREATE_DT) as RECORD_YEAR, CONVERT(DATE,(twi.CREATE_DT)),
         @cacheDate as CACHE_CREATE_DT
      FROM #TMP_LFP twi
      GROUP BY twi.STATUS_CD, YEAR(twi.CREATE_DT), MONTH(twi.CREATE_DT), DAY(twi.CREATE_DT), CONVERT(DATE,(twi.CREATE_DT))

	  insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, ASSOC_CD, ASSOC_NAME_TX, STATUS_CD, COUNT_NO, RECORD_DAY, CACHE_CREATE_DT)
      SELECT DISTINCT @CacheName as NAME_TX, 'LENDERS' as TYPE_CD, 
	     tp.EXTERNAL_ID_TX AS ASSOC_CD, tp.NAME_TX AS ASSOC_NAME_TX,
		 twi.STATUS_CD as STATUS_CD, Count(*) as COUNT_NO,
         MAX(DATEDIFF(DAY, twi.CREATE_DT, GETDATE())) as RECORD_DAY,
         @cacheDate as CACHE_CREATE_DT
      FROM DELIVERY_INFO di
         JOIN TRADING_PARTNER tp ON di.TRADING_PARTNER_ID = tp.ID
         JOIN MESSAGE m ON m.DELIVERY_INFO_ID = di.ID
         JOIN #TMP_LFP twi ON m.ID = twi.MESSAGE_ID
      GROUP BY tp.EXTERNAL_ID_TX, tp.NAME_TX, twi.STATUS_CD

      declare @status as varchar(50)
	   declare @type as varchar(50) = 'AGING'
	   declare @count as bigint

	   set @status = 'AuditComplete'
	   select @count = count(*) from Unitrac_DW.dbo.DASH_CACHE where NAME_TX = @CacheName and TYPE_CD = @type and STATUS_CD = @status
	   if @count = 0
	   insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, STATUS_CD, COUNT_NO, CACHE_CREATE_DT)
	   values (@CacheName, @type, @status, 0, @cacheDate)

	   set @status = 'DataMaintenance'
	   select @count = count(*) from Unitrac_DW.dbo.DASH_CACHE where NAME_TX = @CacheName and TYPE_CD = @type and STATUS_CD = @status
	   if @count = 0
	   insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, STATUS_CD, COUNT_NO, CACHE_CREATE_DT)
	   values (@CacheName, @type, @status, 0, @cacheDate)

	   set @status = 'Error'
	   select @count = count(*) from Unitrac_DW.dbo.DASH_CACHE where NAME_TX = @CacheName and TYPE_CD = @type and STATUS_CD = @status
	   if @count = 0
	   insert into Unitrac_DW.dbo.DASH_CACHEE (NAME_TX, TYPE_CD, STATUS_CD, COUNT_NO, CACHE_CREATE_DT)
	   values (@CacheName, @type, @status, 0, @cacheDate)

	   set @status = 'FileMaintenance'
	   select @count = count(*) from Unitrac_DW.dbo.DASH_CACHE where NAME_TX = @CacheName and TYPE_CD = @type and STATUS_CD = @status
	   if @count = 0
	   insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, STATUS_CD, COUNT_NO, CACHE_CREATE_DT)
	   values (@CacheName, @type, @status, 0, @cacheDate)

	   set @status = 'FileReview'
	   select @count = count(*) from Unitrac_DW.dbo.DASH_CACHE where NAME_TX = @CacheName and TYPE_CD = @type and STATUS_CD = @status
	   if @count = 0
	   insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, STATUS_CD, COUNT_NO, CACHE_CREATE_DT)
	   values (@CacheName, @type, @status, 0, @cacheDate)

	   set @status = 'ImportCompleted'
	   select @count = count(*) from Unitrac_DW.dbo.DASH_CACHE where NAME_TX = @CacheName and TYPE_CD = @type and STATUS_CD = @status
	   if @count = 0
	   insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, STATUS_CD, COUNT_NO, CACHE_CREATE_DT)
	   values (@CacheName, @type, @status, 0, @cacheDate)

	   set @status = 'Initial'
	   select @count = count(*) from Unitrac_DW.dbo.DASH_CACHE where NAME_TX = @CacheName and TYPE_CD = @type and STATUS_CD = @status
	   if @count = 0
	   insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, STATUS_CD, COUNT_NO, CACHE_CREATE_DT)
	   values (@CacheName, @type, @status, 0, @cacheDate)

	   set @status = 'Late'
	   select @count = count(*) from Unitrac_DW.dbo.DASH_CACHE where NAME_TX = @CacheName and TYPE_CD = @type and STATUS_CD = @status
	   if @count = 0
	   insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, STATUS_CD, COUNT_NO, CACHE_CREATE_DT)
	   values (@CacheName, @type, @status, 0, @cacheDate)

	   set @status = 'Merger'
	   select @count = count(*) from Unitrac_DW.dbo.DASH_CACHE where NAME_TX = @CacheName and TYPE_CD = @type and STATUS_CD = @status
	   if @count = 0
	   insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, STATUS_CD, COUNT_NO, CACHE_CREATE_DT)
	   values (@CacheName, @type, @status, 0, @cacheDate)

	   set @status = 'Received'
	   select @count = count(*) from Unitrac_DW.dbo.DASH_CACHE where NAME_TX = @CacheName and TYPE_CD = @type and STATUS_CD = @status
	   if @count = 0
	   insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, STATUS_CD, COUNT_NO, CACHE_CREATE_DT)
	   values (@CacheName, @type, @status, 0, @cacheDate)

	   set @status = 'Unknown'
	   select @count = count(*) from Unitrac_DW.dbo.DASH_CACHE where NAME_TX = @CacheName and TYPE_CD = @type and STATUS_CD = @status
	   if @count = 0
	   insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, STATUS_CD, COUNT_NO, CACHE_CREATE_DT)
	   values (@CacheName, @type, @status, 0, @cacheDate)

      SELECT wi.ID AS WORKITEM_ID, wi.RELATE_ID AS MESSAGE_ID, wi.CREATE_DT AS CREATE_DT, wia.CREATE_DT as WITHDRAWN_DT
          INTO #TMP_Withdrawn
	   FROM WORK_ITEM wi
	      join WORKFLOW_DEFINITION wd on wd.id = wi.WORKFLOW_DEFINITION_ID
		   join WORK_ITEM_ACTION wia on wi.id = wia.WORK_ITEM_ID and wia.ACTION_CD in ('Withdraw File')
	   WHERE wi.PURGE_DT is NULL
	      and wd.WORKFLOW_TYPE_CD = 'LenderExtract'
		   and wi.CREATE_DT >= getdate() - 30

      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, TYPE_CD, ASSOC_CD, ASSOC_NAME_TX, COUNT_NO, CACHE_CREATE_DT)
      SELECT @CacheName as NAME_TX, 'WITHDRAWN' as TYPE_CD, 
	      tp.EXTERNAL_ID_TX AS ASSOC_CD, tp.NAME_TX AS ASSOC_NAME_TX, Count(*) as COUNT_NO, 
         @cacheDate as CACHE_CREATE_DT
      FROM DELIVERY_INFO di
         JOIN TRADING_PARTNER tp ON di.TRADING_PARTNER_ID = tp.ID
         JOIN MESSAGE m ON m.DELIVERY_INFO_ID = di.ID
         JOIN #TMP_Withdrawn twi ON m.ID = twi.MESSAGE_ID
      GROUP BY tp.EXTERNAL_ID_TX, tp.NAME_TX, twi.WORKITEM_ID
   END
   else if (@cacheName = 'PREM_DUE')
   BEGIN
      select fpc.id as FPC_ID, sum(ft.AMOUNT_NO) as AMOUNT_NO
      into #tmpFPC
      from FORCE_PLACED_CERTIFICATE fpc
         join FINANCIAL_TXN ft on ft.FPC_ID = fpc.ID and ft.PURGE_DT is null
         join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.FPC_ID = fpc.ID AND FPCRCR.PURGE_DT IS NULL
         join REQUIRED_COVERAGE RC ON RC.ID = FPCRCR.REQUIRED_COVERAGE_ID AND RC.PURGE_DT IS NULL
         join PROPERTY p on p.ID = rc.PROPERTY_ID and p.PURGE_DT is null
		 join COLLATERAL c on c.PROPERTY_ID = p.id and c.PURGE_DT is null and c.PRIMARY_LOAN_IN = 'Y'
		 join LOAN l on l.id = c.LOAN_ID and l.PURGE_DT is null 
       join LENDER ldr on ldr.id = p.LENDER_ID and ldr.PURGE_DT is null and ldr.TEST_IN = 'N'        
         JOIN COLLATERAL_CODE CC ON CC.ID = c.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL  
	     JOIN REF_CODE_ATTRIBUTE RCA on RCA.DOMAIN_CD = 'SecondaryClassification'  
	     AND RCA.REF_CD = CC.SECONDARY_CLASS_CD
	     AND RCA.ATTRIBUTE_CD = 'PropertyType' 
	     WHERE 
		   (
			     p.AGENCY_ID IN ( 1 , 9) OR 
			     ( p.AGENCY_ID = 4 AND  
			     ( RCA.VALUE_TX = 'RE' OR (RCA.VALUE_TX = 'MH' AND ISNULL(p.ADDRESS_ID, 0) > 0)))
		   ) 		  
        and fpc.PURGE_DT is NULL
        group by fpc.ID
       having sum(ft.AMOUNT_NO) <> 0

      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, ASSOC_CD, ASSOC_NAME_TX, AMOUNT_NO, TYPE_CD, RECORD_DAY, CACHE_CREATE_DT)
      select 'PREM_DUE' as NAME_TX, ldr.CODE_TX as ASSOC_CD, ldr.NAME_TX as ASSOC_NAME_TX, sum(ft.AMOUNT_NO) as AMOUNT_NO,
	      'P' as TYPE_CD, max(pastDue.PAST_DUE_DAYS) as RECORD_DAY, @cacheDate as CACHE_CREATE_DT
      from #tmpFPC tfpc
         join FINANCIAL_TXN ft on ft.FPC_ID = tfpc.FPC_ID
         join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.FPC_ID = tfpc.FPC_ID AND FPCRCR.PURGE_DT IS NULL
         join REQUIRED_COVERAGE RC ON RC.ID = FPCRCR.REQUIRED_COVERAGE_ID AND RC.PURGE_DT IS NULL
         join PROPERTY p on p.ID = rc.PROPERTY_ID and p.PURGE_DT is null
         join lender ldr on ldr.id = p.LENDER_ID and ldr.PURGE_DT is null and ldr.TEST_IN = 'N'
         outer APPLY
          (SELECT PAST_DUE_DAYS
           FROM dbo.GetPastDueDaysDaysAndDate(tfpc.FPC_ID,RC.DelayedBilling,RC.ForcedPlcyOptReportNonPayDays)) as pastDue
      where tfpc.AMOUNT_NO > 0
      group by ldr.CODE_TX, ldr.NAME_TX
	  union
      select 'PREM_DUE' as NAME_TX, ldr.CODE_TX as ASSOC_CD, ldr.NAME_TX as ASSOC_NAME_TX, sum(ft.AMOUNT_NO) as AMOUNT_NO,
	      'R' as TYPE_CD, max(pastDue.PAST_DUE_DAYS) as RECORD_DAY, @cacheDate as CACHE_CREATE_DT
      from #tmpFPC tfpc
         join FINANCIAL_TXN ft on ft.FPC_ID = tfpc.FPC_ID
         join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.FPC_ID = tfpc.FPC_ID AND FPCRCR.PURGE_DT IS NULL
         join REQUIRED_COVERAGE RC ON RC.ID = FPCRCR.REQUIRED_COVERAGE_ID AND RC.PURGE_DT IS NULL
         join PROPERTY p on p.ID = rc.PROPERTY_ID and p.PURGE_DT is null
         join lender ldr on ldr.id = p.LENDER_ID and ldr.PURGE_DT is null and ldr.TEST_IN = 'N' 
       outer APPLY
          (SELECT PAST_DUE_DAYS
           FROM dbo.GetPastDueDaysDaysAndDate(tfpc.FPC_ID,RC.DelayedBilling,RC.ForcedPlcyOptReportNonPayDays)) as pastDue
      where tfpc.AMOUNT_NO < 0
      group by ldr.CODE_TX, ldr.NAME_TX

	  insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, ASSOC_CD, ASSOC_NAME_TX, AMOUNT_NO, TYPE_CD, SOURCE_CD, RECORD_DAY, CACHE_CREATE_DT)
	  select 'PREM_DUE' as NAME_TX, ldr.CODE_TX as ASSOC_CD, ldr.NAME_TX as ASSOC_NAME_TX, sum(ft.AMOUNT_NO) as AMOUNT_NO,
	   'FPC' as TYPE_CD, fpc.NUMBER_TX as SOURCE_CD, pastDue.PAST_DUE_DAYS as RECORD_DAY, GETUTCDATE() as CACHE_CREATE_DT
      from #tmpFPC tfpc
         join FORCE_PLACED_CERTIFICATE fpc on fpc.ID = tfpc.FPC_ID
		 join FINANCIAL_TXN ft on ft.FPC_ID = fpc.ID
		 join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.FPC_ID = tfpc.FPC_ID AND FPCRCR.PURGE_DT IS NULL
         join REQUIRED_COVERAGE RC ON RC.ID = FPCRCR.REQUIRED_COVERAGE_ID AND RC.PURGE_DT IS NULL
         join PROPERTY p on p.ID = rc.PROPERTY_ID and p.PURGE_DT is null
         join lender ldr on ldr.id = p.LENDER_ID
       outer APPLY
          (SELECT PAST_DUE_DAYS
           FROM dbo.GetPastDueDaysDaysAndDate(tfpc.FPC_ID,RC.DelayedBilling,RC.ForcedPlcyOptReportNonPayDays)) as pastDue
	  where tfpc.AMOUNT_NO <> 0 and pastDue.PAST_DUE_DAYS > 30
	  group by ldr.CODE_TX, ldr.NAME_TX, fpc.NUMBER_TX, pastDue.PAST_DUE_DAYS
   END
else if (@cacheName = 'PREM_DUE_30')
   BEGIN
     select fpc.id as FPC_ID, sum(ft.AMOUNT_NO) as AMOUNT_NO
      into #tmpFPC30
	  FROM FORCE_PLACED_CERTIFICATE fpc
         join FINANCIAL_TXN ft on ft.FPC_ID = fpc.ID --and ft.PURGE_DT is null
         join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.FPC_ID = fpc.ID AND FPCRCR.PURGE_DT IS NULL
         join REQUIRED_COVERAGE RC ON RC.ID = FPCRCR.REQUIRED_COVERAGE_ID AND RC.PURGE_DT IS NULL
         join PROPERTY p on p.ID = rc.PROPERTY_ID and p.PURGE_DT is null
         join COLLATERAL c on c.PROPERTY_ID = p.id and c.PURGE_DT is null and c.PRIMARY_LOAN_IN = 'Y'
         join LOAN l on l.id = c.LOAN_ID and l.PURGE_DT is null
         join LENDER ldr on ldr.id = p.LENDER_ID and ldr.PURGE_DT is null and ldr.TEST_IN = 'N'
         JOIN COLLATERAL_CODE CC ON CC.ID = c.COLLATERAL_CODE_ID AND CC.PURGE_DT IS NULL  
	      JOIN REF_CODE_ATTRIBUTE RCA on RCA.DOMAIN_CD = 'SecondaryClassification'  
	      AND RCA.REF_CD = CC.SECONDARY_CLASS_CD
	      AND RCA.ATTRIBUTE_CD = 'PropertyType' 
	      WHERE 
		   (
			     p.AGENCY_ID IN ( 1 , 9) OR 
			     ( p.AGENCY_ID = 4 AND  
			     ( RCA.VALUE_TX = 'RE' OR (RCA.VALUE_TX = 'MH' AND ISNULL(p.ADDRESS_ID, 0) > 0)))
		   ) 		  
         and fpc.PURGE_DT is NULL
         and convert(DATE, ft.CREATE_DT) <= convert(DATE, getdate()-30)
         and (ft.purge_dt is null or convert(DATE, ft.PURGE_DT) > convert(DATE, getdate()-30)) 
      group by fpc.ID
      having sum(ft.AMOUNT_NO) <> 0

      insert into Unitrac_DW.dbo.DASH_CACHE (NAME_TX, ASSOC_CD, ASSOC_NAME_TX, AMOUNT_NO, TYPE_CD, RECORD_DAY, CACHE_CREATE_DT)
      select 'PREM_DUE_30' as NAME_TX, ldr.CODE_TX as ASSOC_CD, ldr.NAME_TX as ASSOC_NAME_TX, sum(ft.AMOUNT_NO) as AMOUNT_NO,
	      'P' as TYPE_CD, max(pastDue.PAST_DUE_DAYS) as RECORD_DAY, GETUTCDATE() as CACHE_CREATE_DT
      from #tmpFPC30 tfpc
         join FORCE_PLACED_CERTIFICATE fpc on fpc.ID = tfpc.FPC_ID
         join FINANCIAL_TXN ft on ft.FPC_ID = fpc.ID
         join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.FPC_ID = fpc.ID AND FPCRCR.PURGE_DT IS NULL
         join REQUIRED_COVERAGE RC ON RC.ID = FPCRCR.REQUIRED_COVERAGE_ID AND RC.PURGE_DT IS NULL
         join PROPERTY p on p.ID = rc.PROPERTY_ID and p.PURGE_DT is null
         join lender ldr on ldr.id = p.LENDER_ID
         outer APPLY
          (SELECT PAST_DUE_DAYS
           FROM GetPastDueDaysByDate(fpc.ID,RC.DelayedBilling,RC.ForcedPlcyOptReportNonPayDays, Convert(DATE,GETDATE()-30))) as pastDue
      where tfpc.AMOUNT_NO > 0
         and convert(DATE, ft.CREATE_DT) <= convert(DATE, getdate()-30)
         and (ft.purge_dt is null or convert(DATE, ft.PURGE_DT) > convert(DATE, getdate()-30)) 
      group by ldr.CODE_TX, ldr.NAME_TX
	  union
      select 'PREM_DUE_30' as NAME_TX, ldr.CODE_TX as ASSOC_CD, ldr.NAME_TX as ASSOC_NAME_TX, sum(ft.AMOUNT_NO) as AMOUNT_NO,
	      'R' as TYPE_CD, max(pastDue.PAST_DUE_DAYS) as RECORD_DAY, GETUTCDATE() as CACHE_CREATE_DT
      from #tmpFPC30 tfpc
         join FORCE_PLACED_CERTIFICATE fpc on fpc.ID = tfpc.FPC_ID
         join FINANCIAL_TXN ft on ft.FPC_ID = fpc.ID
         join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.FPC_ID = fpc.ID AND FPCRCR.PURGE_DT IS NULL
         join REQUIRED_COVERAGE RC ON RC.ID = FPCRCR.REQUIRED_COVERAGE_ID AND RC.PURGE_DT IS NULL
         join PROPERTY p on p.ID = rc.PROPERTY_ID and p.PURGE_DT is null
         join lender ldr on ldr.id = p.LENDER_ID
         outer APPLY
          (SELECT PAST_DUE_DAYS
           FROM GetPastDueDaysByDate(fpc.ID,RC.DelayedBilling,RC.ForcedPlcyOptReportNonPayDays, Convert(DATE,GETDATE()-30))) as pastDue
      where tfpc.AMOUNT_NO < 0
         and convert(DATE, ft.CREATE_DT) <= convert(DATE, getdate()-30)
         and (ft.purge_dt is null or convert(DATE, ft.PURGE_DT) > convert(DATE, getdate()-30)) 
      group by ldr.CODE_TX, ldr.NAME_TX
   END
END



GO

