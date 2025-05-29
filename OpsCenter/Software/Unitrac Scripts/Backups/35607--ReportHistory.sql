select
top 5
 rh.CREATE_DT
,rh.LENDER_ID
,RDX.Lender
,RDX.WorkItem
,RDX.ProcessLog
,PD_NAME=pd.name_tx
,RDX.ReportType
,RDX.ReportConfig
,RDX.Title
,rh.MSG_LOG_TX
,rh.REPORT_DATA_XML
,r.*
,rh.*
from REPORT_HISTORY rh (nolock)
left join report r (nolock) on r.id=rh.report_id
left join lender l (nolock) on l.id=rh.lender_id
outer apply(
	select
	 Lender=rh.report_data_xml.value('(/ReportData/Report/Lender)[1]/@value', 'nvarchar(max)')
	,ReportType=rh.report_data_xml.value('(/ReportData/Report/ReportType)[1]/@value', 'nvarchar(max)')
	,ReportConfig=rh.report_data_xml.value('(/ReportData/Report/ReportConfig)[1]/@value', 'nvarchar(max)')
	,Title=rh.report_data_xml.value('(/ReportData/Report/Title)[1]/@value', 'nvarchar(max)')
	,WorkItem=rh.report_data_xml.value('(/ReportData/Report/WorkItemId)[1]/@value', 'nvarchar(max)')
	,ProcessLog=rh.report_data_xml.value('(/ReportData/Report/ProcessLogID)[1]/@value', 'bigint')
) as RDX
left join process_log pl (nolock) on pl.id=RDX.ProcessLog
left join process_definition pd (nolock)
 on pd.id=pl.PROCESS_DEFINITION_ID
WHERE 1=1
  --and (rh.STATUS_CD='ERR')
and rdx.reporttype like 'escprm%'
order by rh.id desc