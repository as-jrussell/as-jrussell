---------Notices-------

Select * from DOCUMENT_CONTAINER
where ID in (
		
		select
			DC.ID AS DC_ID
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
			inner join NOTICE N on N.id = pli.relate_id 
			inner join LOAN L on L.ID = n.LOAN_ID
			left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice'
		where
			pl.ID = 75775077	
			AND pli.PURGE_DT IS NULL
			AND N.PURGE_DT IS NULL 
			AND DC.PURGE_DT IS NULL		)
		--	and dc.PRINT_STATUS_CD in ('UNRES')) --'PRINTED', 'PEND' UNRES) )
			
	--1)	--------------------------------------------------------------------------------------------------------------	
			Update DOCUMENT_CONTAINER
			set PRINTED_DT = NULL,PRINT_STATUS_ASSIGNED_USER_TX =NULL, PRINT_STATUS_ASSIGNED_DT = NULL, PRINT_STATUS_CD = 'UNRES'
	where ID in (
		
		select DC.ID AS DC_ID
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
			inner join NOTICE N on N.id = pli.relate_id 
			inner join LOAN L on L.ID = n.LOAN_ID
			left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice'
		where
			pl.ID = 75775077	
			AND pli.PURGE_DT IS NULL
			AND N.PURGE_DT IS NULL 
			AND DC.PURGE_DT IS NULL		
			and dc.PRINT_STATUS_CD in ('EXCLUDE')) --'PRINTED', 'PEND' UNRES) )





		select *
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
			inner join NOTICE N on N.id = pli.relate_id 
			inner join LOAN L on L.ID = n.LOAN_ID
			left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice'
		where
			pl.ID = 75775077	
			AND pli.PURGE_DT IS NULL
			AND N.PURGE_DT IS NULL 
			AND DC.PURGE_DT IS NULL		
			and dc.PRINT_STATUS_CD in ('EXCLUDE') --'PRINTED', 'PEND' UNRES) )
			
----------------------------------------------------------------------------------------------------------------------------			
   Select * from PROCESS_LOG_ITEM
   where PROCESS_LOG_ID = 12379752
			
			Select * from PROCESS_LOG_ITEM
		where id in (
		
		select
			DC.ID AS DC_ID
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
			inner join NOTICE N on N.id = pli.relate_id 
			inner join LOAN L on L.ID = n.LOAN_ID
			left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice'
		where
			pl.ID = 75775077	
			AND pli.PURGE_DT IS NULL
			AND N.PURGE_DT IS NULL 
			AND DC.PURGE_DT IS NULL		
			and dc.PRINT_STATUS_CD in ('UNRES')) --'PRINTED', 'PEND' UNRES) )
			
	--2)	----Delete USER acttion info with the PLI.ID for notices---
			
		Update PROCESS_LOG_ITEM					
		SET INFO_XML.modify('delete /INFO_LOG/USER_ACTION')
     , LOCK_ID = LOCK_ID + 1
	where id in (
		select
			PLI.ID
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
			inner join NOTICE N on N.id = pli.relate_id 
			inner join LOAN L on L.ID = n.LOAN_ID
			left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice'
		where
			pl.ID = 75775077	
			AND pli.PURGE_DT IS NULL
			AND N.PURGE_DT IS NULL 
			AND DC.PURGE_DT IS NULL		
			and dc.PRINT_STATUS_CD in ('UNRES')) --'PRINTED', 'PEND' UNRES) )
			
select *
from WORK_ITEM
where ID = 7458764

select *
from PROCESS_LOG
where ID = 12175078

select *
from OUTPUT_BATCH
where EXTERNAL_ID like 'FPC_12175078_%'
			
	------------------------Find the certs Certs------------------------------------------------
			
	Select * from DOCUMENT_CONTAINER
where ID in (
		
		select
			DC.ID AS DC_ID
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.forceplacedcertificate'
			inner join FORCE_PLACED_CERTIFICATE fpc on fpc.id = pli.relate_id 
			left outer join document_container dc on dc.relate_id = fpc.id and dc.relate_class_name_tx = 'allied.unitrac.forceplacedcertificate'
		where
			pl.ID = 9514311	
			and pli.PURGE_DT is null		
		    and dc.PRINT_STATUS_CD = ('UNRES')) ---'PEND'--- 'UNRES' ----'PRINTED' --'UNRES')	
			
	1)  --------------------------Null out the DC and changed from PRrint to UNRES----------------------------------------------------------------------------------		
			
			Update DOCUMENT_CONTAINER
			set PRINTED_DT = NULL,PRINT_STATUS_ASSIGNED_USER_TX ='MBR', PRINT_STATUS_ASSIGNED_DT = NULL, PRINT_STATUS_CD = 'UNRES'
		where ID in (
		
		select
			DC.ID AS DC_ID
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.forceplacedcertificate'
			inner join FORCE_PLACED_CERTIFICATE fpc on fpc.id = pli.relate_id 
			left outer join document_container dc on dc.relate_id = fpc.id and dc.relate_class_name_tx = 'allied.unitrac.forceplacedcertificate'
		where
			pl.ID = 75775077
			and pli.PURGE_DT is null		
		    and dc.PRINT_STATUS_CD = ('PRINTED')) ---'PEND'--- 'UNRES' ----'PRINTED' --'UNRES')	
		    
		    
	--2)--------------	 Delete USER acttion info with the PLI.ID----------
		    
		    Update PROCESS_LOG_ITEM					
			SET INFO_XML.modify('delete /INFO_LOG/USER_ACTION')
		, LOCK_ID = LOCK_ID + 1
			where id in (
		select
			PLI.ID
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.forceplacedcertificate'
			inner join FORCE_PLACED_CERTIFICATE fpc on fpc.id = pli.relate_id 
			left outer join document_container dc on dc.relate_id = fpc.id and dc.relate_class_name_tx = 'allied.unitrac.forceplacedcertificate'
		where
			pl.ID = 9083334	
			and pli.PURGE_DT is null		
		    and dc.PRINT_STATUS_CD = ('UNRES')) ---'PEND'--- 'UNRES' ----'PRINTED' --'UNRES')	
		    
	select *
from WORK_ITEM
where ID = 7458764	    
		    
	--3)
		    Update 
			WORK_ITEM 
			SET STATUS_CD = 'Initial'
			where id = 7694829
			
			*/
			
	--4) If output batch is completed, update to PEND
	
	select *
	from OUTPUT_BATCH
	where EXTERNAL_ID = 'NTC_75775077_218086'
		
	update OUTPUT_BATCH
	set STATUS_CD = 'PEND'
	where ID = 218086
	
	
----CLEANUP PROCESS LOG ITEMS RELATED TO NOTICES WITH PURGED COLLATERALS (NOTICES IN UNRES NOT DISPLAYING IN UI)----


select COLLATERAL.PURGE_DT,*
from NOTICE, LOAN, COLLATERAL
WHERE NOTICE.LOAN_ID = LOAN.ID AND LOAN.ID = COLLATERAL.LOAN_ID
AND NOTICE.ID IN (7942653, 7942627, 7942615, 7942654, 7942622, 7942655, 7942657, 7942621, 7942662, 7942647,
7942650, 7942663, 7942633, 7942639, 7942626, 7942618, 7942616, 7942631, 7942640, 7942643, 7942659)
and COLLATERAL.PURGE_DT is not null

select PURGE_DT,*
from PROCESS_LOG_ITEM PLI
WHERE PLI.RELATE_ID IN (7942653, 7942627, 7942615, 7942654, 7942622, 7942655, 7942657, 7942621, 7942662, 7942647,
7942650, 7942663, 7942633, 7942639, 7942626, 7942618, 7942616, 7942631, 7942640, 7942643, 7942659)
AND PLI.RELATE_TYPE_CD = 'Allied.Unitrac.Notice'


UPDATE PROCESS_LOG_ITEM
SET PURGE_DT = GETDATE(), UPDATE_DT=GETDATE(), UPDATE_USER_TX = 'script', LOCK_ID = LOCK_ID+1
WHERE PROCESS_LOG_ITEM.RELATE_ID IN (7942653, 7942627, 7942615, 7942654, 7942622, 7942655, 7942657, 7942621, 7942662, 7942647,
7942650, 7942663, 7942633, 7942639, 7942626, 7942618, 7942616, 7942631, 7942640, 7942643, 7942659)
AND PROCESS_LOG_ITEM.RELATE_TYPE_CD = 'Allied.Unitrac.Notice'



