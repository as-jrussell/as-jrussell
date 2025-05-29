use utl

select * from loan l
join (select le.id lender_id, le.code_tx, le.name_tx
       from LENDER le where le.enable_matching_in = 'Y' and le.purge_dt is null) le on le.lender_id = l.lender_id
	   where l.EVALUATION_DT < '1/1/1901'
	   and l.PURGE_DT is null
