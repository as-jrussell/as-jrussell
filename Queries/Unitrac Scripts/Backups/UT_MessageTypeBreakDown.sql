USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[UT_MessageTypeBreakDown]    Script Date: 10/16/2019 9:40:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[UT_MessageTypeBreakDown]


as

SET NOCOUNT ON
select tp.type_cd, max(tpl.create_dt) [Last run],count(*) [Count] 

from trading_partner_log tpl
join trading_partner tp on tp.id = tpl.trading_partner_id
where CAST(tpl.create_dt AS DATE) >= CAST(GETDATE() AS DATE)
group by  tp.type_cd  
							