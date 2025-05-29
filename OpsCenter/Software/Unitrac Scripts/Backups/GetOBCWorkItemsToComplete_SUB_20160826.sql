USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[GetOBCWorkItemsToComplete]    Script Date: 8/26/2016 6:17:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetOBCWorkItemsToComplete]

AS
BEGIN	
	SET NOCOUNT ON
	
create table #Temp1
(
 WIId int,
 OBCIHId int,
 loanStatus varchar(100)
)

insert into #Temp1
select distinct wi.ID, ih.ID, l.STATUS_CD from WORK_ITEM wi
inner join WORKFLOW_DEFINITION wd on wd.ID = wi.WORKFLOW_DEFINITION_ID
	and wd.PURGE_DT is NULL
	and wd.NAME_TX = 'OutboundCall'
inner join INTERACTION_HISTORY ih on ih.ID = wi.RELATE_ID
	and ih.PURGE_DT is NULL
	and ih.LOAN_ID is not null
	and ih.PROPERTY_ID is null
inner join LOAN l on l.ID = ih.LOAN_ID
	and l.STATUS_CD in('U','O','P','I')
    and l.PURGE_DT is NULL
where
wi.STATUS_CD not in ( 'Complete','Error','Withdrawn')
and wi.PURGE_DT is null

insert into #Temp1
select distinct wi.ID, ih.ID, l.STATUS_CD from WORK_ITEM wi
inner join WORKFLOW_DEFINITION wd on wd.ID = wi.WORKFLOW_DEFINITION_ID
	and wd.PURGE_DT is NULL
	and wd.NAME_TX = 'OutboundCall'
inner join INTERACTION_HISTORY ih on ih.ID = wi.RELATE_ID
	and ih.PURGE_DT is NULL
	and ih.PROPERTY_ID is not null
	and ih.LOAN_ID is null
inner join COLLATERAL coll on coll.PROPERTY_ID = ih.PROPERTY_ID
	and coll.PURGE_DT is NULL
inner join LOAN l on l.ID = coll.LOAN_ID
	and l.STATUS_CD in('U','O','P','I')
    and l.PURGE_DT is NULL
where
wi.STATUS_CD not in ( 'Complete','Error','Withdrawn')
and wi.PURGE_DT is null

select WIId,OBCIHId,loanStatus from #Temp1


END

GO

