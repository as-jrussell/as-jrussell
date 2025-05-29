USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[3MonthEventSuccessRate]    Script Date: 12/24/2015 10:30:36 AM ******/
DROP PROCEDURE [dbo].[3MonthEventSuccessRate]
GO

/****** Object:  StoredProcedure [dbo].[3MonthEventSuccessRate]    Script Date: 12/24/2015 10:30:36 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[3MonthEventSuccessRate]
   @lenderCodes nvarchar(max)
AS
BEGIN

CREATE TABLE #LENDER_CODES (
	LENDER_CODE NVARCHAR(100)
)

INSERT INTO #LENDER_CODES
	SELECT
		sf.STRVALUE
	FROM
		dbo.SplitFunction(@lenderCodes, ',') sf

-------------------------------------------------------------------------------------------------------------------------
-- 9 3 Month Event Success Rate by type
-------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
------ new way to calculate / Event success rate
------		STEP 1: get all the COMP events for specified range (normalize the event type)
------		STEP 2: get the group ids for those events
------		STEP 3: get evaluation event groups by es order numberr and by status for ease of use 
------		STEP 4: aggregate the results

---- STEP 1: Get the completed evaluation events using update_dt for the lender and date range in question
	SELECT
			ldr.code_tx AS 'LENDER_CD',
			ldr.name_tx AS 'LENDER_NAME',
			l.BRANCH_CODE_TX AS 'BRANCH',
		   CAST( CONVERT(VARCHAR, datepart(year, ee.update_dt)) + '-' + CONVERT(VARCHAR,DATEPART(MONTH, ee.update_dt)) + '-01' as date) as 'YEAR_MONTH',
		   es.order_no as 'es_order_no',
		   es.event_type_cd,
		   es.NOTICE_SEQ_NO,
   		rces.MEANING_TX,
	   	rces.MEANING_TX + ' ' + case when es.EVENT_TYPE_CD = 'NTC' THEN CONVERT(nvarchar(10),es.NOTICE_SEQ_NO) ELSE '' END as 'EVENT_TYPE',
   		ee.GROUP_ID as 'ee_group_id',
   		ee.id as 'ee_id'
	   into 
		   #ee_to_consider
	   FROM	
		   loan l (nolock)
		   join lender ldr (nolock) on ldr.id = l.lender_id 
		   JOIN #LENDER_CODES ldrCode ON ldr.CODE_TX = ldrCode.LENDER_CODE
           join LENDER_ORGANIZATION lo (nolock) on lo.LENDER_ID = ldr.id and lo.CODE_TX = l.DIVISION_CODE_TX
		   join COLLATERAL c (nolock) on c.loan_id = l.id and c.PURGE_DT is null
		   join REQUIRED_COVERAGE rc (nolock) on rc.PROPERTY_ID = c.PROPERTY_ID and rc.PURGE_DT is null and rc.RECORD_TYPE_CD = 'G' AND rc.STATUS_CD = 'A'
		   join EVALUATION_EVENT ee (nolock) on ee.required_coverage_id = rc.id and ee.relate_id is not null and ee.status_cd = 'COMP' and ee.purge_dt is null 
                                     and ee.UPDATE_DT >= dateadd(month, -3, CAST( CONVERT(VARCHAR, datepart(year, getdate())) + '-' + CONVERT(VARCHAR,DATEPART(MONTH, getdate())) + '-01' as date))
		   JOIN EVENT_SEQUENCE es (nolock) ON es.id = ee.event_sequence_id AND es.PURGE_DT IS NULL and es.EVENT_TYPE_CD not in ('DFLT') 
		   join event_seq_container esc (nolock) on esc.id = es.event_seq_container_id and esc.purge_dt is null and esc.notice_cycle_in ='Y'
		   join ref_code rces (nolock) on rces.DOMAIN_CD = 'EventSequenceEventType' and rces.PURGE_DT is null and rces.CODE_CD = es.EVENT_TYPE_CD
	   WHERE
		   l.record_type_cd in ('G')
		   and l.PURGE_DT is null
		   and l.STATUS_CD in ('A','B')

   ---- STEP 2: Get the evaluation events GROUP IDs for those completed events

      select 
	      distinct
	      LENDER_NAME,
	      BRANCH,
	      ee_group_id
      into
	      #ee_groups_to_consider
      from
	      #ee_to_consider
			
      ---- STEP 3: Get evaluation event groups by es order numberr and by status for ease of use
      select
	      eegtc.ee_group_id,
	      es.ORDER_NO,
	      ee.STATUS_CD
      into
	      #ee_group_status
      from
	      #ee_groups_to_consider eegtc
	      join EVALUATION_EVENT ee on ee.group_id = eegtc.ee_group_id and ee.PURGE_DT is null
	      join EVENT_SEQUENCE es on ee.event_sequence_id = es.id 
      group by
	      eegtc.ee_group_id,
	      es.ORDER_NO,
	      ee.STATUS_CD

      ------ STEP 4: aggregate the results
      select
         etc.LENDER_CD AS 'LENDER_CD',
         etc.LENDER_NAME AS 'LENDER_NAME',
	      etc.BRANCH AS 'BRANCH',
         etc.YEAR_MONTH 'YEAR_MONTH',
	      etc.EVENT_TYPE as 'EVENT_TYPE',
	      case when isnull(next_etc.STATUS_CD, '') in ('', 'COMP') THEN ''
		       when ISNULL(next_etc.STATUS_CD, '') IN ('CLR') THEN 'Success'
		       else 'Pending'
	      end as 'SEQUENCE_TYPE',
	      count(etc.ee_id) as 'EVENT_COUNT'
      from
	      #ee_to_consider etc
	      left outer join #ee_group_status next_etc on next_etc.ee_group_id = etc.ee_group_id and next_etc.order_no = etc.es_order_no+1
      --	join #ee_group_id_status_pivot egsp on egsp.ee_group_id = etc.ee_group_id
      group by
         etc.LENDER_CD,
         etc.LENDER_NAME,
	      etc.BRANCH,
	      etc.YEAR_MONTH,
	      etc.EVENT_TYPE,
	      case when isnull(next_etc.STATUS_CD, '') in ('', 'COMP') THEN ''
		       when ISNULL(next_etc.STATUS_CD, '') IN ('CLR') THEN 'Success'
		       else 'Pending'
	      end 
      order by 
	      4, 
	      6	


	DROP TABLE #LENDER_CODES
end

GO

