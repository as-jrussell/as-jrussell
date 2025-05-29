
select * from work_item
where id in (53299830 ,53300188 ,53318464)


select * from message
where id in (18295917) or RELATE_ID_TX in (18295917)


select * from users
where given_name_tx = 'Faith'


select * from work_item
where id in (53150674)


SELECT  RC.NOTICE_SEQ_NO, rc.*
--INTO UniTracHDStorage..INC0411940 
FROM   LOAN L
       INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
       INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
       INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
       INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE  LL.CODE_TX IN ( '1065' ) and RC.TYPE_CD = 'HAZARD'
       AND RC.NOTICE_SEQ_NO IN ('1', '2') ​​


	   drop table  #tmpRC
	   select distinct	   n.id into #tmpRC
	   
	    from NOTICE_REQUIRED_COVERAGE_RELATE nr
	   join notice n on nr.notice_id = n.id 
	   where nr.required_coverage_id in (select id from UniTracHDStorage..INC0411940 )
	   and sequence_no ='2'

	    select distinct	   nr.required_coverage_id into #tmpRCC
	   
	    from NOTICE_REQUIRED_COVERAGE_RELATE nr
	   join notice n on nr.notice_id = n.id 
	   where nr.required_coverage_id in (select id from UniTracHDStorage..INC0411940 )
	   and sequence_no ='2'



select distinct l.NUMBER_TX, rc.TYPE_CD, cc.CODE_TX, rc.LAST_EVENT_SEQ_ID, rc.LAST_EVENT_DT, rc.NOTICE_SEQ_NO, rc.ID as RC_ID, rc.PROPERTY_ID as PROP_ID
,eePend.Pending_EE_ID, eepend.EVENT_DT

into #tmpRCs
from loan l
join COLLATERAL c on c.LOAN_ID = l.id and c.PRIMARY_LOAN_IN = 'Y' and c.PURGE_DT is null
join REQUIRED_COVERAGE rc on rc.PROPERTY_ID = c.PROPERTY_ID and rc.TYPE_CD = 'hazard' and rc.PURGE_DT is NULL and rc.STATUS_CD='A'
join COLLATERAL_CODE cc on cc.id = c.COLLATERAL_CODE_ID and cc.PURGE_DT is null --and cc.PRIMARY_CLASS_CD='COM'
outer APPLY
(
	select top 1 ID as Pending_EE_ID, EVENT_DT
	from EVALUATION_EVENT where REQUIRED_COVERAGE_ID = rc.id and STATUS_CD='Pend'
	order by EVENT_DT desc
) EEpend
WHERE
 l.LENDER_ID = 2465
 --and rc.LAST_EVENT_SEQ_ID <> 0 or EEpend.Pending_EE_ID is not NULL
 AND RC.NOTICE_SEQ_NO IN ('1','2') 

 Declare @Task varchar(8) = 'INC0411940'
 update rc
 set      
	 rc.Good_THRU_DT = null, 
	 rc.NOTICE_DT = null, rc.LAST_EVENT_SEQ_ID = null, rc.LAST_EVENT_DT = null, rc.LAST_SEQ_CONTAINER_ID = null, rc.NOTICE_TYPE_CD = null, rc.NOTICE_SEQ_NO = null,
	 rc.CPI_QUOTE_ID = null,
	 rc.UPDATE_USER_TX=@Task, rc.UPDATE_DT = getdate(), rc.LOCK_ID = (LOCK_ID % 255) + 1
 --select *
 from REQUIRED_COVERAGE rc
 join #tmpRCs t on t.RC_ID = rc.ID
 where rc.PURGE_DT is null
    AND RC.NOTICE_SEQ_NO IN ('1') ​​ 
 -- Clear any pending events tied to these RCs that are part of a eval notice sequence
 -- 3924 events will be updated

  Declare @Task varchar(8) = 'INC0411940'
update ee
set ee.STATUS_CD = 'CLR', MSG_LOG_TX = 'Clear notice cycle INC0411940'
,ee.UPDATE_DT = getdate(), ee.UPDATE_USER_TX = @Task, ee.LOCK_ID = (ee.LOCK_ID % 255) + 1
from #tmpRCs t
join EVALUATION_EVENT ee on ee.REQUIRED_COVERAGE_ID = t.RC_ID
where ee.STATUS_CD = 'PEND' and ee.EVENT_SEQUENCE_ID is not null


	SELECT  
		n.TYPE_CD , 
		n.SEQUENCE_NO , 
		 n.EXPECTED_ISSUE_DT ,
		nr.REQUIRED_COVERAGE_ID ,
		GROUP_ID ,
		 ee.ID ,
		 ISNULL(ee.EVENT_SEQUENCE_ID ,0 )
	from NOTICE n join NOTICE_REQUIRED_COVERAGE_RELATE nr ON nr.NOTICE_ID = n.ID 	
	join EVALUATION_EVENT ee on ee.RELATE_ID = n.ID and ee.RELATE_TYPE_CD = 'Allied.UniTrac.Notice'
		and ee.REQUIRED_COVERAGE_ID = nr.REQUIRED_COVERAGE_ID and ee.TYPE_CD IN ('NTC','AGNO')		
	where n.ID IN (select id from #tmpRC)
	    	
	UPDATE IH SET PURGE_DT = GETDATE(), UPDATE_USER_TX = 'INC0411940' ,
	UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1
	--select *
	from interaction_history ih
     where RELATE_ID IN (select id from #tmpRC) and RELATE_CLASS_TX = 'Allied.UniTrac.Notice' and TYPE_CD = 'NOTICE'
     
    UPDATE nr SET PURGE_DT = GETDATE(), UPDATE_USER_TX = 'INC0411940' ,
    UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1 
	--select *
	from NOTICE_REQUIRED_COVERAGE_RELATE nr
	where NOTICE_ID IN-- (SELECT RELATE_ID FROM dbo.PROCESS_LOG_ITEM WHERE PROCESS_LOG_ID IN (@ProcessLogID) AND RELATE_TYPE_CD = 'Allied.UniTrac.Notice')
	(select id from #tmpRC)
     

		
	UPDATE ee set STATUS_CD = 'NOTU', PURGE_DT = GETDATE(), UPDATE_USER_TX = 'INC0411940',
	UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1
	--select *
	from EVALUATION_EVENT ee
	where REQUIRED_COVERAGE_ID in (select required_coverage_id from #tmpRCC) and STATUS_CD = 'PEND'
   AND EVENT_SEQUENCE_ID IS NOT NULL
	
	UPDATE DOCUMENT_CONTAINER SET PURGE_DT = GETDATE() , UPDATE_USER_TX = 'INC0411940',
	UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1
	WHERE RELATE_ID IN	(select id from #tmpRC)
 AND RELATE_CLASS_NAME_TX = 'ALLIED.UNITRAC.NOTICE'

 	UPDATE NOTICE SET PURGE_DT = GETDATE(), UPDATE_USER_TX = 'INC0411940' , 
	UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1 where ID IN 	(select id from #tmpRC)


	  UPDATE rc set NOTICE_DT = nr.update_dt , NOTICE_SEQ_NO = '1' , 
		  CPI_QUOTE_ID = NULL , LAST_EVENT_DT = NULL , LAST_EVENT_SEQ_ID = NULL , LAST_SEQ_CONTAINER_ID = NULL ,
		  GOOD_THRU_DT = NULL , UPDATE_DT = GETDATE() , rc.LOCK_ID = (rc.LOCK_ID % 255) + 1 , UPDATE_USER_TX = 'INC0411940'
		 --select NOTICE_SEQ_NO,nr.*
		  from REQUIRED_COVERAGE rc
		  join  NOTICE_REQUIRED_COVERAGE_RELATE nr on nr.REQUIRED_COVERAGE_id = rc.id
	      join notice n on nr.notice_id = n.id 
		  where rc.ID in (select required_coverage_id from #tmpRCC)  and NOTICE_SEQ_NO = '2'     
		   ---and  NOTICE_DT = @NoticeDt  
		   
		   
		     UPDATE IH SET PURGE_DT = GETDATE() , UPDATE_USER_TX = 'INC0411940' , 
		  UPDATE_DT = GETDATE() , LOCK_ID = (IH.LOCK_ID % 255) + 1		
		  --select *
		  FROM INTERACTION_HISTORY IH  
		  JOIN NOTICE NTC ON NTC.CPI_QUOTE_ID = IH.RELATE_ID 		  
		  WHERE IH.RELATE_CLASS_TX = 'Allied.Unitrac.CPIQuote'
		  AND IH.TYPE_CD = 'CPI'		 
		  AND NTC.ID IN  	(select id from #tmpRC)