use unitrac

--drop table #tmp
select * 
--into unitrachdstorage..INC0465610
from loan
where LENDER_ID  = 1835
and BRANCH_CODE_TX  ='VSI'
and STATUS_CD = 'U' and RECORD_TYPE_CD not in ('D','A')
and PURGE_DT is null
--217532


--drop table #tmpCert
select L.* 
into #tmpCert
from loan l
join FORCE_PLACED_CERTIFICATE fpc on fpc.LOAN_ID =l.id
where l.id in (select id from unitrachdstorage..INC0465610)

select * from #tmpCert


--drop table #tmpNoCert
select L.* 
into #tmpNoCert
from loan l
where LENDER_ID  = 1835
and BRANCH_CODE_TX  ='VSI'
and l.STATUS_CD = 'U' and RECORD_TYPE_CD not in ('D','A')
and l.PURGE_DT is null and  l.id not in (select id from #tmpCert)
--217529





---Join multiple tables to do an update
	UPDATE LN 
	SET LN.RECORD_TYPE_CD = 'A',LN.UPDATE_USER_TX = 'INC0465610', LN.UPDATE_DT = GETDATE(),   LOCK_ID = LN.LOCK_ID % 255 + 1
	--SELECT LN.* 
	FROM dbo.LOAN LN
	INNER JOIN #tmpCert L ON LN.ID = L.ID
	

    
---Join multiple tables to do an update
	UPDATE LN 
	SET LN.RECORD_TYPE_CD = 'D',LN.UPDATE_USER_TX = 'INC0465610', LN.UPDATE_DT = GETDATE(),   LOCK_ID = LN.LOCK_ID % 255 + 1
	--SELECT LN.* 
	FROM dbo.LOAN LN
	INNER JOIN #tmpNoCert L ON LN.ID = L.ID


 INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0465610' , 'N' , 
 GETDATE() ,  1 , 
'Removed Unmatch Loans from system', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0465610)

   
	

