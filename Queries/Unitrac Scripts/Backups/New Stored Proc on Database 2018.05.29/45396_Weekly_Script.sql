USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[45396_Weekly_Script]    Script Date: 5/29/2018 8:35:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[45396_Weekly_Script] 

AS 
SET NOCOUNT ON ; 

declare @tf table( TotalCount int, OPId bigint, TypeCd nvarchar(60), reqid bigint, propertyId bigint)

insert into @tf
SELECT count(*)
	,pc.OWNER_POLICY_ID
	, 'WIND'
	, rc.ID as ReqId
	, pop.PROPERTY_ID
FROM POLICY_COVERAGE pc
inner join PROPERTY_OWNER_POLICY_RELATE pop on pop.OWNER_POLICY_ID = pc.OWNER_POLICY_ID and pop.PURGE_DT is NULL
inner join REQUIRED_COVERAGE rc on rc.PROPERTY_ID = pop.PROPERTY_ID and rc.PURGE_DT is NULL and rc.TYPE_CD = 'WIND'
WHERE pc.TYPE_CD IN (
		'WIND'
		)
	AND pc.PURGE_DT IS NULL
GROUP BY pc.OWNER_POLICY_ID, rc.ID,  pop.PROPERTY_ID 

--select * from @tf

declare @tf2 table( TotalCount int, OPId bigint, TypeCd nvarchar(60), reqid bigint, propertyId bigint)

insert into @tf2
SELECT count(*)
	,pc.OWNER_POLICY_ID
	, 'FLOOD'
	, rc.ID as ReqId
	,pop.PROPERTY_ID
FROM POLICY_COVERAGE pc
inner join PROPERTY_OWNER_POLICY_RELATE pop on pop.OWNER_POLICY_ID = pc.OWNER_POLICY_ID and pop.PURGE_DT is NULL
inner join REQUIRED_COVERAGE rc on rc.PROPERTY_ID = pop.PROPERTY_ID and rc.PURGE_DT is NULL and rc.TYPE_CD = 'FLOOD'
WHERE pc.TYPE_CD IN (
		'FLOOD'
		)
	AND pc.PURGE_DT IS NULL
GROUP BY pc.OWNER_POLICY_ID, rc.ID , pop.PROPERTY_ID



declare @now nvarchar(50) = CONVERT(varchar(30), getdate(), 121)

--select l.RECORD_TYPE_CD,l.NUMBER_TX, le.CODE_TX,op.POLICY_NUMBER_TX, *
--select 'Update POLICY_COVERAGE SET PURGE_DT = '''+@now+''' , UPDATE_USER_TX = ''TFS45396'', LOCK_ID = LOCK_ID + 1  WHERE OWNER_POLICY_ID =' + cast(t1.OPId as varchar(15)) + ' and TYPE_CD = ''WIND'' and PURGE_DT is NULL'

declare @updateScript table( RecordType char(1), LoanNumber nvarchar(36), LoanId bigint, LenderCode nvarchar(20), TotalCount int, OPId bigint, TypeCd nvarchar(60), windreqid bigint, propertyId bigint, POLICY_NUMBER_TX nvarchar(60), windPcId bigint, floodReqId bigint )
insert into @updateScript
select l.RECORD_TYPE_CD,l.NUMBER_TX, l.ID, le.CODE_TX, t1.*, op.POLICY_NUMBER_TX, pc.ID as 'WindPCId', t2.reqid as floodreqId
 from @tf t1 inner join @tf2 t2 on t1.OPId = t2.OPId
inner join OWNER_POLICY op on op.ID = t1.OPId and op.PURGE_DT is null 
inner join PROPERTY_OWNER_POLICY_RELATE pop on pop.OWNER_POLICY_ID = t1.OPId and pop.PURGE_DT is NULL
inner join COLLATERAL c on c.PROPERTY_ID = pop.PROPERTY_ID and c.PURGE_DT is NULL
inner join LOAN l on l.ID = c.LOAN_ID and l.PURGE_DT is NULL
inner join LENDER le on le.id = l.LENDER_ID
inner join POLICY_COVERAGE pc on pc.OWNER_POLICY_ID = t1.OPId and pc.TYPE_CD = 'WIND' and pc.PURGE_DT is NULL
where 
l.RECORD_TYPE_CD = 'G' and
l.LENDER_ID = 2238
order by le.CODE_TX DESC

--select * from @updateScript

--0002027436
select distinct 'Update POLICY_COVERAGE SET PURGE_DT = '''+@now+''' , UPDATE_USER_TX = ''TFS45396'', LOCK_ID = LOCK_ID + 1  WHERE id = ' + cast(windPcId as varchar(15)) + '; Update INTERACTION_HISTORY SET SPECIAL_HANDLING_XML = dbo.fn_GetModifiedIHForWind_45396(SPECIAL_HANDLING_XML,'+ cast(windPcId as varchar(30))+', '+ cast(windreqid as varchar(30)) +') , UPDATE_USER_TX = ''TFS45396'', LOCK_ID = LOCK_ID + 1 WHERE PROPERTY_ID = '+ cast(propertyId as varchar(30)) + ' and cast(SPECIAL_HANDLING_XML as varchar(max)) like ''%'+POLICY_NUMBER_TX+'%'' and cast(SPECIAL_HANDLING_XML as varchar(max)) like ''%'+cast(windreqid as varchar(30))+'%'' and cast(SPECIAL_HANDLING_XML as varchar(max)) like ''%'+cast(floodReqId as varchar(30))+'%''' 
from @updateScript

