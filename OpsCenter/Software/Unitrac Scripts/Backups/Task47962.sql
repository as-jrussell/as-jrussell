select p.* into UnitracHDStorage..Task47962_2
--select COUNT(*)
 from property p
join collateral C on c.property_id = p.id
join loan l on l.id = c.loan_id
join lender le on le.id = l.lender_id
join required_coverage rc on rc.property_id = p.id and rc.type_cd = 'flood'
where p.address_id is not null
and p.participating_community_in = 'n'
and l.record_type_cd = 'g'
and p.record_type_cd = 'g'
and l.purge_dt is null
and p.purge_dt is null
and c.purge_dt is null
and l.status_cd != 'u'
and le.test_in = 'n'
and le.status_cd = 'active'
and c.status_cd != 'u'
and c.EXTRACT_UNMATCH_COUNT_NO = 0
and l.extract_unmatch_count_no = 0


declare @rowcount int = 10000
while @rowcount >= 10000
BEGIN
 BEGIN TRY

 UPDATE TOP (10000) P
SET p.participating_community_in = 'Y', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'Task47962', LOCK_ID = LOCK_ID+1
--SELECT   count(*)  
from property p
join  UnitracHDStorage..Task47962 T on P.ID = T.ID 
--368481

 select @rowcount = @@rowcount
 END TRY
 BEGIN CATCH
  select Error_number(),
      error_message(),
      error_severity(),
    error_state(),
    error_line()
   THROW
   BREAK
 END CATCH
END
		