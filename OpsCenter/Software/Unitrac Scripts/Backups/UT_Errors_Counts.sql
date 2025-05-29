USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[UT_Errors_Counts]    Script Date: 12/9/2019 2:20:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[UT_Errors_Counts]


as

SET NOCOUNT ON


select 'Process Log Item' [Location Table], INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (MAX)') MESSAGE_LOG,create_dt,  id AS id into #TMPPLI
from process_log_item
where status_cd = 'ERR'
and CREATE_DT >= DateAdd(HOUR, -6, getdate())
and INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (MAX)') is not null 
and INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (MAX)') not like '%GetEscrowExceptionReasons%'
and INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (MAX)')  not like '%There is an overlap with existing escrow. Enter as additional premium, if reported.%'
and INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (MAX)') NOT like '%InValidPayeeCode%'
and INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (MAX)') NOT like '%VerifyInsuranceEscrowOverlapRange%'
union
select 'MESSAGE' [Location Table],  LOG_MESSAGE, tpl.CREATE_DT, tpl.id AS ID 
 from trading_partner_log tpl
where CREATE_DT >= DateAdd(HOUR, -6, getdate())
and(LOG_TYPE_CD = 'Error' or LOG_SEVERITY_CD = 'Error')


select  [Location Table], MESSAGE_LOG, COUNT(*) [Count], MAX(ID)
from #TMPPLI
group BY  [Location Table],MESSAGE_LOG
HAVING COUNT(*) > 50










GO

