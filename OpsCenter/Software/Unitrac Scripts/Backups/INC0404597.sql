use unitrac


select * from work_item wi
join lender l on l.id = wi.lender_id 
where l.code_tx = '2375' and wi.workflow_definition_id = 13 
order by wi.create_dt desc


select * from workflow_definition


--52921398


select * from process_log
where id in (70473545, 70421908,
70421950)



select * from process_log_item
where process_log_id in ( 70473545)


select * from work_item_action
where work_item_id = 52921398



SELECT tp.id, dd.*
FROM TRADING_PARTNER TP
INNER JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN dbo.DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
WHERE tp.external_id_tx = '2375' and dd.delivery_code_tx = 'OutputFolder'


select * from trading_partner_log
where trading_partner_id =1463 and create_dt >= '2019-03-20'

LOW	Output File : \\vut-app\Escrow\InsFile\2375\Output\INS_2375-Langley Federal Credit Union-Mortgage-Earthquake-Hazard-Flood-Active Loans_20190320040333.dat created for Document ID : 30117819
LOW	Output File : (\\vut-app\Escrow\InsFile\2375\Output\INS_2375-Langley Federal Credit Union-Mortgage-Earthquake-Hazard-Flood-Active Loans_20190320040333.dat) archived to Directory : \\vut-app\Escrow\InsFile\2375\ArchiveOutput  as File: (\\vut-app\Escrow\InsFile\2375\ArchiveOutput\2019_03_20_09_47_24_622-INS_2375-Langley Federal Credit Union-Mortgage-Earthquake-Hazard-Flood-Active Loans_20190320040333.dat) created for Document Id : 30117819

--2019-03-20 09:38:33.147

Exception Transforming the Documents
Exception : Exception occurred for XSLT Pre Processing for Doc Id : 30117819
Exception Message : Object reference not set to an instance of an object.

Exception Stack Trace :    at Allied.UniTrac.LenderExtract.BackFeed.BackFeedPPD.Apply(Document document) in E:\Unitrac_QA_HotFix\3 Upper Business Level\UniTracLib\LenderExtract\BackFeed\BackFeedPPD.cs:line 312
   at LDHLib.Document.Transform(Boolean ignoreSettingTransformationStatus, Boolean processDJ, BusinessObjectCollection boColl) in E:\Unitrac_QA_HotFix\3 Upper Business Level\LDH\LDHLib\Message\Document.cs:line 468
   at LDHLib.Message.Transform() in E:\Unitrac_QA_HotFix\3 Upper Business Level\LDH\LDHLib\Message\Message.cs:line 1189


   
----------Taking them off hold for USD
UPDATE dbo.MESSAGE
SET PROCESSED_IN = 'N' , RECEIVED_STATUS_CD = 'RCVD' , LOCK_ID = LOCK_ID+1
--SELECT * FROM dbo.MESSAGE
WHERE ID IN  (17917464)




   select * from work_item
   where id in (52880517 ,52880581 )

