USE UniTrac

SELECT LO.TYPE_CD, LO.CODE_TX , Lo.NAME_TX,*
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID --AND RD.DEF_ID = '105'
WHERE L.CODE_TX IN ('2912')

select * from TRADING_PARTNER_LOG tpl
join TRADING_PARTNER tp on tp.id = tpl.TRADING_PARTNER_ID
WHERE  TP.EXTERNAL_ID_TX = '7404'
and LOG_MESSAGE like '%DailyLoan%'
and tpl.CREATE_DT >= '2020-08-18'


SELECT dd.value_tx,DELIVERY_CODE_TX, dig.NAME_TX*
FROM TRADING_PARTNER TP
INNER JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN dbo.DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
WHERE  TP.id = '3131' and dd.value_tx like '%INSBACKFEED%'


Input File : DailyLoan.txt archived to Directory : \\nas\utstage_files\QATEST\7404 OneMain\ArchiveInput as File : \\nas\utstage_files\QATEST\7404 OneMain\ArchiveInput\2020_08_18_10_58_05-DailyLoan.txt

SELECT dd.value_tx,DELIVERY_CODE_TX,dig.NAME_TX, dig.*
FROM TRADING_PARTNER TP
INNER JOIN DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
INNER JOIN RELATED_DATA RD on RD.RELATE_ID = DI.ID and RD.DEF_ID = 96
INNER JOIN PREPROCESSING_DETAIL PD on PD.DELIVERY_INFO_GROUP_ID = DIG.ID
INNER JOIN PPDATTRIBUTE PPD on PPD.PREPROCESSING_DETAIL_ID = PD.ID
WHERE  TP.ID = 3526
and Delivery_CODE_TX = 'InputFolder'




--Input File: DailyLoan.txt renamed to :OneMain.txt for Delivery Info Group ID : 17124

E:\LenderFiles\InformaticaFileStaging$\Output

select * from ppdattribute ppd
join preprocessing_detail pd on ppd.preprocessing_detail_id = pd.id
where delivery_info_group_id in (16567) and ppd.purge_dt is null
and pd.purge_dt is null

SELECT value_tx, DELIVERY_CODE_TX,DD.*
FROM TRADING_PARTNER TP
INNER JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN dbo.DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
WHERE 

tp.type_cd = 'OCR_TP'

--
--


SELECT value_tx, DELIVERY_CODE_TX,*
FROM TRADING_PARTNER TP
INNER JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN dbo.DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
where EXTERNAL_ID_TX = ''-- AND DIG.DELIVERY_INFO_ID  = '4091'
and DELIVERY_CODE_TX IN ('OutputFolder','OutputFileName', 'ArchOutFolder')


SELECT *
FROM TRADING_PARTNER TP
INNER JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN dbo.DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
WHERE DELIVERY_CODE_TX IN ('InputFolder','InputFileName', 'ArchInFolder')
and tp.id = 



SELECT *
FROM TRADING_PARTNER TP
INNER JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN dbo.DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
WHERE DELIVERY_CODE_TX IN ('OutputFolder','OutputFileName', 'ArchOutFolder')
and EXTERNAL_ID_TX = '' and DIG.NAME_TX like '%%'
and DIG.PURGE_DT is null and DI.PURGE_DT is null and TP.PURGE_DT is null 




SELECT *
FROM TRADING_PARTNER TP
INNER JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN dbo.DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
WHERE DELIVERY_CODE_TX IN ('InputFolder','InputFileName', 'ArchInFolder')
and EXTERNAL_ID_TX = '' and DIG.NAME_TX like '%%'
and DIG.PURGE_DT is null and DI.PURGE_DT is null and TP.PURGE_DT is null 





SELECT *
FROM dbo.TRADING_PARTNER_LOG
WHERE TRADING_PARTNER_ID = 49 AND CREATE_DT >= '2016-09-15'

SELECT *
FROM dbo.MESSAGE
WHERE Id IN (6129471,6129474)

SELECT *
FROM dbo.DOCUMENT
WHERE MESSAGE_ID IN (6129471,6129474)

SELECT *
FROM [dbo].[TRANSACTION]
WHERE DOCUMENT_ID IN (14946004,14946017,14946018,14946019,14946020,14946021,14946007,14946070,14946071,14946074,14946075,14946076)

SELECT *
FROM dbo.PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD IN ('DWINBOUND','MSGSRV')

SELECT *
FROM dbo.WORK_ITEM
WHERE RELATE_ID IN (6129471,6129474)



SELECT *
FROM dbo.DELIVERY_INFO
WHERE TRADING_PARTNER_ID = 49

SELECT *
FROM dbo.DELIVERY_INFO_GROUP
WHERE DELIVERY_INFO_ID IN (56,3555)

SELECT *
FROM dbo.DELIVERY_DETAIL
WHERE DELIVERY_INFO_GROUP_ID = 5566

BSS_TP
EDI_TP
IDR_TP
LFP_TP

SELECT *
FROM dbo.REF_CODE
WHERE DOMAIN_CD LIKE '%TRADING%'

SELECT *
FROM VUT.DBO.SCANBATCH
WHERE batchdate >= '2016-09-26' AND batchid IN ('AS76270122915','AS76270123127','AS76270123630','AS76270124410','AS76270124523','AS76270124600')

SELECT *
FROM TRADING_PARTNER TP
INNER JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN dbo.DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
WHERE TP.TYPE_CD = 'IDR_TP'

SELECT *
FROM TRADING_PARTNER TP
INNER JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN dbo.DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
WHERE EXTERNAL_ID_TX = '0270' AND DIG.NAME_TX = 'Allied.*.zip'

select lec.*
from vut.dbo.tbllender l
inner join vut.dbo.tbllenderextract le on l.lenderkey = le.lenderkey
inner join vut.dbo.tbllenderextractconversion lec on le.lenderextractkey = lec.lenderextractkey
where lenderid = '0270'

SELECT *
FROM dbo.TRADING_PARTNER_LOG
WHERE TRADING_PARTNER_ID = 49 AND CREATE_DT >= '2016-09-15'

SELECT *
FROM dbo.MESSAGE
WHERE Id IN (6129471,6129474)

SELECT *
FROM dbo.DOCUMENT
WHERE MESSAGE_ID IN (6129471,6129474)

SELECT *
FROM [dbo].[TRANSACTION]
WHERE DOCUMENT_ID IN (14946004,14946017,14946018,14946019,14946020,14946021,14946007,14946070,14946071,14946074,14946075,14946076)

SELECT *
FROM dbo.PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD IN ('DWINBOUND','MSGSRV')

SELECT *
FROM dbo.WORK_ITEM
WHERE RELATE_ID IN (6129471,6129474)



SELECT *
FROM dbo.DELIVERY_INFO
WHERE TRADING_PARTNER_ID = 49

SELECT *
FROM dbo.DELIVERY_INFO_GROUP
WHERE DELIVERY_INFO_ID IN (56,3555)

SELECT *
FROM dbo.DELIVERY_DETAIL
WHERE DELIVERY_INFO_GROUP_ID = 5566

BSS_TP
EDI_TP
IDR_TP
LFP_TP

SELECT *
FROM dbo.REF_CODE
WHERE DOMAIN_CD LIKE '%TRADING%'

SELECT RECEIVED,RECEIVEDDATE,*
FROM VUT.DBO.SCANBATCH
WHERE batchdate >= '2016-09-26' AND batchid IN ('AS76270122915','AS76270123127','AS76270123630','AS76270124410','AS76270124523','AS76270124600')
AND INTFTPKEY = 4

SELECT *
FROM VUT.DBO.TBLFTPQUEUE
WHERE BATCHID = 'AS76270124523'

SELECT *
FROM dbo.TRADING_PARTNER_LOG
WHERE log_message like '%AS76270124523%'  AND CREATE_DT >= '2016-09-15'

SELECT *
FROM dbo.TRADING_PARTNER_LOG
WHERE MESSAGE_ID = 6175558



SELECT *
FROM VUT.DBO.TBLSCANOPTIONS


SELECT *
FROM TRADING_PARTNER TP
INNER JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN dbo.DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
WHERE TP.TYPE_CD = 'IDR_TP' AND EXTERNAL_ID_TX = 'FBI'

SELECT *
FROM TRADING_PARTNER TP
INNER JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN dbo.DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
WHERE TP.TYPE_CD = 'EDI_TP' AND value_tx like '%ALLSTATE%'


SELECT *
FROM dbo.TRADING_PARTNER_LOG
WHERE TRADING_PARTNER_ID = 1993 AND CREATE_DT >= '2016-09-26'


select * from trading_partner
where name_tx like '%OneMain%'


SELECT dig.NAME_TX, *
FROM dbo.TRADING_PARTNER_LOG tpl 
JOIN TRADING_PARTNER TP ON tp.id = tpl.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN dbo.DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
 WHERE tpl.TRADING_PARTNER_ID = 3526 AND dig.NAME_TX = 'conversion test.*.txt'
 and message_id = 23116661
ORDER BY tpl.CREATE_DT DESC 


SELECT distinct dig.NAME_TX ,message_id, convert(date,tpl.create_dt)
FROM dbo.TRADING_PARTNER_LOG tpl 
JOIN TRADING_PARTNER TP ON tp.id = tpl.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN dbo.DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
 WHERE tpl.TRADING_PARTNER_ID = 3526 AND dig.NAME_TX like '%DailyLoan%'
 and tpl.create_dt >= '2020-08-13'
 order by tpl.create_dt asc

 select * from message
 where  id in (23116862,
23116865,
23116906,
23116921)

  select * from message
 where recipient_trading_partner_id = 3526
 and message_direction_cd = 'O' and processed_in = 'Y'


 select CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') ProcessID, *
 from work_item
 where relate_id  in (23116543,
23116661,
23116862,
23116865,
23116906,
23116921)
 and workflow_definition_id =1 
 
SELECT  COUNT(*), PROCESS_LOG_ID
from dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID in (select * from #tmpPD)
group by PROCESS_LOG_ID
--2,169,276



select * from trading_partner_log
where message_id = 23116928

InformaticaPPD::ResolveWorkItem() - Informatica Error


Informatica Error/s : , Event Id : 543415



select dig.NAME_TX ,*
FROM dbo.TRADING_PARTNER_LOG tpl 
JOIN TRADING_PARTNER TP ON tp.id = tpl.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN dbo.DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
where message_id  in (SELECT distinct message_id
FROM dbo.TRADING_PARTNER_LOG tpl 
JOIN TRADING_PARTNER TP ON tp.id = tpl.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN dbo.DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
 WHERE tpl.TRADING_PARTNER_ID = 3526 AND dig.NAME_TX = 'DailyLoan.txt'
 and tpl.create_dt >= '2020-08-18') and dig.NAME_TX= 'DailyLoan.txt'
 order by tpl.create_dt desc