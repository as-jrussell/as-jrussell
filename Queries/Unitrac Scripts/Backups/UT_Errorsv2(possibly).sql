USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[UT_Errors]    Script Date: 10/16/2019 9:40:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[UT_Errors_Counts]


as

SET NOCOUNT ON


select 'Process Log Item' [Location Table], INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (MAX)') MESSAGE_LOG,create_dt,  id AS id into #TMPPLI
from process_log_item
where status_cd = 'ERR'
and CREATE_DT >= DateAdd(HOUR, -6, getdate())
and INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (MAX)') is not null 

union
select 'MESSAGE'[Location Table],  LOG_MESSAGE, tpl.CREATE_DT, tpl.id AS ID 
 from trading_partner_log tpl
where CREATE_DT >= DateAdd(HOUR, -6, getdate())
and(LOG_TYPE_CD = 'Error' or LOG_SEVERITY_CD = 'Error')


select 'Process Log Item' [Location Table], MESSAGE_LOG, COUNT(*) [Count]
from #TMPPLI
group BY MESSAGE_LOG
HAVING COUNT(*) > 50
union
select 'MESSAGE'[Location Table],  LOG_MESSAGE, COUNT(*)
 from trading_partner_log tpl
where CREATE_DT >= DateAdd(HOUR, -6, getdate())
and(LOG_TYPE_CD = 'Error' or LOG_SEVERITY_CD = 'Error')
group BY LOG_MESSAGE
HAVING COUNT(*) > 50