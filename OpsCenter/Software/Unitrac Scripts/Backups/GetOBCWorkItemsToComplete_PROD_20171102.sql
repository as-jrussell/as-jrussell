USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[GetOBCWorkItemsToComplete]    Script Date: 11/2/2017 5:14:23 PM ******/
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
 OBCCloseType varchar(20),
 WIId int,
 OBCIHId int,
 returnStatus varchar(100),
 LenderID BIGINT,
 LenderCode NVARCHAR(10)
)

insert into #Temp1
select distinct 'LOANSTAT', wi.ID, ih.ID, l.STATUS_CD, l1.ID, l1.CODE_TX from WORK_ITEM wi
inner join WORKFLOW_DEFINITION wd on wd.ID = wi.WORKFLOW_DEFINITION_ID
	and wd.PURGE_DT is NULL
	and wd.NAME_TX = 'VerificationEvent'
inner join INTERACTION_HISTORY ih on ih.ID = wi.RELATE_ID
	and ih.PURGE_DT is NULL
	and ih.LOAN_ID is not null
	and ih.PROPERTY_ID is null
inner join LOAN l on l.ID = ih.LOAN_ID
	and l.STATUS_CD in('U','O','P','I')
      and l.PURGE_DT is NULL
LEFT JOIN LENDER l1 on l1.ID = l.LENDER_ID
where
wi.STATUS_CD not in ( 'Complete','Error','Withdrawn')
and wi.PURGE_DT is null

insert into #Temp1
select distinct 'LOANSTAT', wi.ID, ih.ID, l.STATUS_CD, l1.ID, l1.CODE_TX from WORK_ITEM wi
inner join WORKFLOW_DEFINITION wd on wd.ID = wi.WORKFLOW_DEFINITION_ID
	and wd.PURGE_DT is NULL
	and wd.NAME_TX = 'VerificationEvent'
inner join INTERACTION_HISTORY ih on ih.ID = wi.RELATE_ID
	and ih.PURGE_DT is NULL
	and ih.PROPERTY_ID is not null
	and ih.LOAN_ID is null
inner join COLLATERAL coll on coll.PROPERTY_ID = ih.PROPERTY_ID
	and coll.PURGE_DT is NULL
inner join LOAN l on l.ID = coll.LOAN_ID
	and l.STATUS_CD in('U','O','P','I')
      and l.PURGE_DT is NULL
LEFT JOIN LENDER l1 ON l1.ID = l.LENDER_ID
where
wi.STATUS_CD not in ( 'Complete','Error','Withdrawn')
and wi.PURGE_DT is null
AND ih.PROPERTY_ID NOT IN (select coll.PROPERTY_ID
							from WORK_ITEM wi
							inner join WORKFLOW_DEFINITION wd on wd.ID = wi.WORKFLOW_DEFINITION_ID
								and wd.PURGE_DT is NULL
								and wd.NAME_TX = 'VerificationEvent'
							inner join INTERACTION_HISTORY ih on ih.ID = wi.RELATE_ID
								and ih.PURGE_DT is NULL
								and ih.PROPERTY_ID is not null
								and ih.LOAN_ID is null
							inner join COLLATERAL coll on coll.PROPERTY_ID = ih.PROPERTY_ID
								and coll.PURGE_DT is NULL
							inner join LOAN l on l.ID = coll.LOAN_ID
								and l.STATUS_CD NOT in('U','O','P','I')
								and l.PURGE_DT is NULL
							where	
							wi.STATUS_CD not in ( 'Complete','Error','Withdrawn')
							and wi.PURGE_DT is null)
                     
-- Close Escrow OBC if Premium Bill is Received
-- Base Criteria:
--    OBC Work Item Interaction History Reasons:
--       * Escrow Due Days (EDD)
--    Escrow Status::
--       * Current Bill Reported (CBR)
--       * Current Bill Paid (CBP)
--       * Received Needs to be Reported/Paid (RRP)
insert into #Temp1
select distinct 'ESCROWPREMBILL', wi.ID, ih.ID, re.STATUS_CD, l.ID, l.CODE_TX
from     WORK_ITEM wi
         inner join WORKFLOW_DEFINITION wd on wd.ID = wi.WORKFLOW_DEFINITION_ID
	         and wd.PURGE_DT is NULL
	         and wd.NAME_TX = 'VerificationEvent'
         inner join INTERACTION_HISTORY ih on ih.ID = wi.RELATE_ID
            and ih.PURGE_DT is NULL
	         and ih.PROPERTY_ID is not null            
            and ih.SPECIAL_HANDLING_XML.value('(/SH/ReasonCode)[1]', 'varchar(max)') = 'EDD'
         inner join REQUIRED_COVERAGE rc on rc.PROPERTY_ID = ih.PROPERTY_ID
            and rc.PURGE_DT is NULL
			AND rc.ID = ih.SPECIAL_HANDLING_XML.value('(/SH/RC)[1]', 'bigint')
         inner join REQUIRED_ESCROW re on re.REQUIRED_COVERAGE_ID = rc.ID 
            and re.PURGE_DT is NULL
            and re.STATUS_CD in ('CBR','CBP','RRP')
			left JOIN LENDER l on l.ID = wi.LENDER_ID
where
wi.STATUS_CD not in ( 'Complete','Error','Withdrawn')
and wi.PURGE_DT is null

-- TFS# 38445
-- Base Criteria:
--    OBC User Level Inclusion:
--       * Comes from Active items the REF_CODE Domain OBCUserLevelInclusion
--    OBC Create Reason Exclusion:
--       * Comes from Active items the REF_CODE Domain OBCCreateReasonExclusion
insert into #Temp1 (OBCCloseType, WIId, OBCIHId, LenderID, LenderCode)
select   distinct 'OBCINSSTAT', wi.ID, ih.ID, l.ID, l.CODE_TX
from     WORK_ITEM wi
         inner join
            (SELECT CODE_CD FROM REF_CODE WHERE DOMAIN_CD = 'OBCUserLevelInclusion' AND ACTIVE_IN = 'Y') uli 
            on wi.USER_ROLE_CD = uli.CODE_CD
         inner join WORKFLOW_DEFINITION wd on wd.ID = wi.WORKFLOW_DEFINITION_ID
            and wd.PURGE_DT is NULL
            and wd.NAME_TX = 'VerificationEvent'
         inner join INTERACTION_HISTORY ih on ih.ID = wi.RELATE_ID
            and ih.PURGE_DT is NULL
            and ih.SPECIAL_HANDLING_XML.value('(/SH/ReasonCode)[1]', 'varchar(max)') not in 
               (SELECT CODE_CD FROM REF_CODE WHERE DOMAIN_CD = 'OBCCreateReasonExclusion' AND ACTIVE_IN = 'Y')
         inner join USERS u on ih.CREATE_USER_TX = u.USER_NAME_TX 
            and ((u.SYSTEM_IN = 'N' and u.PURGE_DT IS NULL) or (u.PURGE_DT IS NOT NULL))
		 INNER JOIN PROPERTY_CHANGE_UPDATE pcu ON pcu.TABLE_ID = ih.SPECIAL_HANDLING_XML.value('(/SH/RC)[1]', 'bigint')
				AND pcu.TABLE_NAME_TX = 'REQUIRED_COVERAGE'
				AND pcu.COLUMN_NM IN ('INSURANCE_STATUS_CD', 'INSURANCE_SUB_STATUS_CD')
				AND pcu.CREATE_DT > wi.CREATE_DT
			left join LENDER l ON l.ID = wi.LENDER_ID
where
wi.STATUS_CD not in ( 'Complete','Error','Withdrawn')
and wi.PURGE_DT is null

-- TFS# 41077
-- Close if Verified Inactive Insurance document is Received
insert into #Temp1
select distinct 'VFDINACTVINS', wi.ID, ih.ID, 'VII', l.ID, l.CODE_TX
from     WORK_ITEM wi
         inner join WORKFLOW_DEFINITION wd on wd.ID = wi.WORKFLOW_DEFINITION_ID
	         and wd.PURGE_DT is NULL
	         and wd.NAME_TX = 'VerificationEvent'
         inner join INTERACTION_HISTORY ih on ih.ID = wi.RELATE_ID
             and ih.PURGE_DT is NULL
	         and ih.PROPERTY_ID is not null
         inner join INTERACTION_HISTORY docIH on docIH.PROPERTY_ID = ih.PROPERTY_ID
		     and docIH.TYPE_CD = 'DOCUMENT'
		     and docIH.SPECIAL_HANDLING_XML.value('(/SH/Type/text())[1]', 'varchar(20)') = 'VII'
			 and docIH.PURGE_DT is NULL
			 LEFT JOIN LENDER l ON l.ID = wi.LENDER_ID
where
wi.STATUS_CD not in ( 'Complete','Error','Withdrawn')
and wi.PURGE_DT is null

select t.OBCCloseType,t.WIId,t.OBCIHId,t.returnStatus, t.LenderID, t.LenderCode
from #Temp1 t



END

GO

