USE UniTrac

SELECT M.PROCESSED_IN, MESSAGE_ID, TPL.UPDATE_USER_TX, TP.EXTERNAL_ID_TX, TPl.* , Tp.*
FROM TRADING_PARTNER_LOG TPL (NOLOCK) 
join TRADING_PARTNER TP on TP.ID = TPL.TRADING_PARTNER_ID
JOIN dbo.MESSAGE M ON M.ID = TPL.MESSAGE_ID
WHERE  
CAST(TPL.CREATE_DT AS date) = CAST(GETDATE()  AS date) 
AND TPL.PROCESS_CD = 'MS'
AND M.PROCESSED_IN <> 'Y' AND TP.EXTERNAL_ID_TX NOT IN ('BSSWeb')
AND TPL.UPDATE_USER_TX not in ('MsgSrvrDEF', 'MsgSrvrEDIIDR')
ORDER BY TPL.CREATE_DT, m.id ASC 



select tpl.*
FROM TRADING_PARTNER_LOG TPL 
WHERE  
 message_id = '36591847'
ORDER BY TPL.CREATE_DT ASC 


update m set purge_dt = GETDATE(), processed_in = 'Y'
from message m 
where id in (23114087,
23116549,
23116551)



select COUNT(*),TPL.UPDATE_USER_TX
FROM TRADING_PARTNER_LOG TPL (NOLOCK) 
join TRADING_PARTNER TP on TP.ID = TPL.TRADING_PARTNER_ID
JOIN dbo.MESSAGE M ON M.ID = TPL.MESSAGE_ID
WHERE  
CAST(TPL.CREATE_DT AS date) = CAST(GETDATE()  AS date) 
AND TPL.PROCESS_CD = 'MS'
AND M.PROCESSED_IN <> 'Y' AND TP.EXTERNAL_ID_TX NOT IN ('BSSWeb')
AND TPL.UPDATE_USER_TX not in ('MsgSrvrDEF', 'MsgSrvrEDIIDR')
group by TPL.UPDATE_USER_TX
ORDER BY TPL.CREATE_DT, m.id ASC 


SELECT   COUNT(*) [MSG Errors] 
--top 5 *
FROM MESSAGE M
                           WHERE    M.RECEIVED_STATUS_CD = 'RCVD'
            and processEd_in = 'Y'      AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
			and message_direction_cd='I' and UPDATE_USER_TX like 'MsgSrvr%'

SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,* 
							  from PROCESS_DEFINITION
where process_type_cd= 'GOODTHRUDT'
and ONHOLD_IN = 'N' 
        AND ACTIVE_IN = 'Y'
		and STATUS_CD <> 'Expired' and execution_freq_cd = 'RUNONCE'

SELECT M.PROCESSED_IN, MESSAGE_ID, TPL.UPDATE_USER_TX, TP.EXTERNAL_ID_TX, TPl.* , Tp.*
FROM TRADING_PARTNER_LOG TPL (NOLOCK) 
join TRADING_PARTNER TP on TP.ID = TPL.TRADING_PARTNER_ID
JOIN dbo.MESSAGE M ON M.ID = TPL.MESSAGE_ID
WHERE EXTERNAL_ID_TX = 'XXXX' AND M.PROCESSED_IN = 'Y'
ORDER BY TPL.CREATE_DT ASC 

SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_ID IN (seLECT ID FROM dbo.MESSAGE WHERE ID = '36591847') AND WORKFLOW_DEFINITION_ID = '1'



SELECT TOP 10 PD.NAME_TX, PROCESS_TYPE_CD, PL.* FROM dbo.PROCESS_LOG PL
JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE PD.ID IN (13555, 7920, 199525, 426510)
ORDER BY PL.UPDATE_DT DESC


SELECT * FROM dbo.TRADING_PARTNER_LOG 
WHERE --TRADING_PARTNER_ID IN (3410) and create_dt >= '2019-04-11'
MESSAGE_ID  = 23116661 and create_dt >= '2020-08-18'
ORDER BY MESSAGE_ID, create_dt ASC 




select dig.NAME_TX ,*
FROM dbo.TRADING_PARTNER_LOG tpl 
JOIN TRADING_PARTNER TP ON tp.id = tpl.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
INNER JOIN dbo.DELIVERY_INFO_GROUP DIG ON DI.ID = DIG.DELIVERY_INFO_ID
INNER JOIN dbo.DELIVERY_DETAIL DD ON DIG.ID = DD.DELIVERY_INFO_GROUP_ID
where tp.id = 3526 and tpl.create_dt >= '2020-08-18 12:00'
and log_message not in ('Message Processed Successfully', 'Started Processing Message','Message Preliminary Transformation Complete')
 order by tpl.create_dt desc




 select u.* from users u
 join user_security_group_relate usg on usg.user_id = u.id
 join security_group sg on sg.id = usg.sec_grp_id 
 where description_tx like '%ons%'

  


 SELECT * FROM dbo.TRADING_PARTNER_LOG 
WHERE --TRADING_PARTNER_ID IN (3410) and create_dt >= '2019-04-11'
MESSAGE_ID  = 23116661 and create_dt >= '2020-08-18'
ORDER BY MESSAGE_ID, create_dt ASC 
