use UniTrac

select *
from TRADING_PARTNER_LOG tpl
join TRADING_PARTNER tp on tp.id = tpl.trading_partner_id
where  tpl.create_dt >= '2019-01-01' 
and tp.EXTERNAL_ID_TX = '13102' AND tpl.LOG_TYPE_CD = 'ERRor'
ORDER BY tpl.CREATE_DT DESC 


Exception Transforming the Documents  Exception : One or more errors occurred.  


Inner Exception : Object reference not set to an instance of an object. 
Exception Stack Trace :    at Allied.UniTrac.LenderExtract.ExtractMatchingHelperChunked.ExecuteMatching(Lender loanExtract, TrackingChunkedPPD ppd) in E:\TeamCity\buildAgent4\work\cda46154e3ee397e\3 Upper Business Level\UniTracLib\LenderExtract\ExtractMatchingHelperChunked.cs:line 204     at Allied.UniTrac.LenderExtract.TrackingChunkedPPD.Apply(BusinessObjectCollection boColl) in E:\TeamCity\buildAgent4\work\cda46154e3ee397e\3 Upper Business Level\UniTracLib\LenderExtract\TrackingChunkedPPD.cs:line 207     at LDHLib.Message.FinalizeTransformation() in E:\TeamCity\buildAgent4\work\cda46154e3ee397e\3 Upper Business Level\LDH\LDHLib\Message\Message.cs:line 1267     at LDHLib.Message.Transform() in E:\TeamCity\buildAgent4\work\cda46154e3ee397e\3 Upper Business Level\LDH\LDHLib\Message\Message.cs:line 1223

SELECT * FROM dbo.TRADING_PARTNER
WHERE EXTERNAL_ID_TX = '13102'


select * from LENDER
where code_tx = '4665'

select 
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[2]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[3]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[4]', 'varchar (50)') ProcessID,*
from WORK_ITEM wi
where WORKFLOW_DEFINITION_ID =1 and RELATE_ID in (select distinct MESSAGE_ID
from TRADING_PARTNER_LOG tpl
join TRADING_PARTNER tp on tp.id = tpl.trading_partner_id
where LOG_MESSAGE like '%monthly%' and tpl.create_dt >= '2019-01-01'
and tp.EXTERNAL_ID_TX = '4665')


SELECT top 50 *-- MAX(UPDATE_DT)--, COUNT(*) 
from dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = 70173358
order by update_dt desc
--1226768

SELECT  COUNT(*) 
from dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = 70173358
--1226768

SELECT * FROM dbo.MESSAGE
WHERE  RELATE_ID_TX IN  (24274777,24703305)
and MESSAGE_DIRECTION_CD = 'O'


---Count of items per month 
SELECT process_log_id, relate_type_cd,  COUNT(*) , max(update_dt)
from dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (74448812)
group by process_log_id,relate_type_cd



SELECT process_log_id, relate_type_cd, status_cd, datename(MONTH, CREATE_DT),COUNT(*) 
from dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (81106801,83442656,
81210982,
81449412,
82219378,81043123,
81118987,
81282233,
82149939,
83257436) and STATUS_CD = 'COMP' and RELATE_TYPE_CD = 'Allied.UniTrac.Loan'
group by process_log_id, relate_type_cd, status_cd,datename(MONTH, CREATE_DT)
order by datename(MONTH, CREATE_DT)

select (366895+61+2717264+3034617+483236+2767053) [Jan]
select (294670+ 2730121) [Feb]
select 2711273 [March]


--January 2019
select 
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[2]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[3]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[4]', 'varchar (50)') ProcessID,
* 
from work_item wi
where relate_id in (18437953,
18970990)
and workflow_definition_id = 1
ORDER BY UPDATE_DT DESC ​

--9,369,126
--3,024,791 Feb
--2,711,273 March
