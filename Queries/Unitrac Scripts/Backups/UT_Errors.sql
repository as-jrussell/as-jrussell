USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[UT_Errors]    Script Date: 10/16/2019 9:40:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



alter  PROCEDURE [dbo].[UT_Errors]


as

SET NOCOUNT ON

select 'Process Log Item' [Location Table], INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (MAX)') MESSAGE_LOG,create_dt,  id AS id 
from process_log_item
where status_cd = 'ERR'
and CREATE_DT >= DateAdd(HOUR, -6, getdate())
and INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (MAX)') is not null 
and INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (MAX)') not like '%GetEscrowExceptionReasons%'
and INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (MAX)')  not like '%There is an overlap with existing escrow. Enter as additional premium, if reported.%'
and INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (MAX)') NOT like '%InValidPayeeCode%'

union
select 'MESSAGE'[Location Table],  LOG_MESSAGE, tpl.CREATE_DT, tpl.id AS ID
 from trading_partner_log tpl
where CREATE_DT >= DateAdd(HOUR, -6, getdate())
and(LOG_TYPE_CD = 'Error' or LOG_SEVERITY_CD = 'Error')