SELECT TOP 100 percent
 rc.escrow_in
,es_id=es.id
,es.POLICY_NUMBER_TX
,rc.RECORD_TYPE_CD
,rc.NOTICE_TYPE_CD
,rc.INSURANCE_STATUS_CD
,rc.INSURANCE_SUB_STATUS_CD
,rc.SUMMARY_STATUS_CD
,rc.SUMMARY_SUB_STATUS_CD
,rc.CPI_STATUS_CD
,rc.CPI_SUB_STATUS_CD
,rc.*
  FROM [UniTrac].[dbo].[REQUIRED_COVERAGE] rc with(nolock)
inner join escrow_required_coverage_relate ercr with(nolock) on ercr.required_coverage_id=rc.id
left join escrow es with(nolock) on es.id=ercr.escrow_id
  where
  (rc.SUMMARY_STATUS_CD = 'B'
  or rc.SUMMARY_SUB_STATUS_CD in ('B','BH','U','UH')
  or rc.INSURANCE_SUB_STATUS_CD = 'B'
  or es.POLICY_NUMBER_TX like '%bind%')