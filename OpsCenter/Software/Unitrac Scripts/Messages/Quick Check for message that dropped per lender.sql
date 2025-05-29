use UniTrac

--drop table #tmpMessage
select *
from TRADING_PARTNER_LOG tpl
join TRADING_PARTNER tp on tp.id = tpl.TRADING_PARTNER_ID
where  tpl.create_dt >= '2020-01-02'
and tp.EXTERNAL_ID_TX = '2257' 

select * from TRADING_PARTNER_LOG
where MESSAGE_ID in (23715752 )
order by CREATE_DT ASC

select tpl.*
from TRADING_PARTNER_LOG tpl
join TRADING_PARTNER tp on tp.id = tpl.TRADING_PARTNER_ID
where tpl.create_dt >= '2019-08-11'
and tp.EXTERNAL_ID_TX = '4665' and PROCESS_CD = 'MS'
order by CREATE_DT desc

select * from WORK_ITEM
where 
RELATE_ID In (23556044,
23556046,
23567358,
23637961,
23637962,
23637963,
23715750,
23715751,
23715752)
and WORKFLOW_DEFINITION_ID = 1 and lender_id = 1878


select * from Lender
where CODE_TX = '2257'

select ll.name_tx, ll.code_tx, count(*) [Active Loans] , LL.ACTIVE_DT [Lender Start Date]
from loan l
join lender ll on ll.id = l.lender_id
where l.record_type_cd in ('A', 'G') and l.purge_dt is null 
and ll.PURGE_DT is null and ll.STATUS_CD = 'ACTIVE'
group by ll.name_tx, ll.code_tx, LL.[ACTIVE_DT]
having count(*) > '100000'
order by count(*) DESC 

UPDATE wi set PURGE_DT = GETDATE(), STATUS_CD = 'Withdrawn'
--select * 
from WORK_ITEM wi
where RELATE_ID in () and WORKFLOW_DEFINITION_ID = 1
and STATUS_CD = 'Error'

SELECT  p.name AS [loginname] ,
        p.type ,
        p.type_desc ,
        p.is_disabled,
        CONVERT(VARCHAR(10),p.create_date ,101) AS [created],
        CONVERT(VARCHAR(10),p.modify_date , 101) AS [update]
FROM    sys.server_principals p
        JOIN sys.syslogins s ON p.sid = s.sid
WHERE   p.type_desc IN ('SQL_LOGIN', 'WINDOWS_LOGIN', 'WINDOWS_GROUP')
        -- Logins that are not process logins
        AND p.name NOT LIKE '##%'
        -- Logins that are sysadmins
        AND s.sysadmin = 1