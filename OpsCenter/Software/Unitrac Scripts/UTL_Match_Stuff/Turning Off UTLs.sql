use Unitrac




SELECT --rd.id into #tmpLenderRemoval
rd.*    
FROM RELATED_DATA rd
    INNER JOIN LENDER l
        ON l.ID = rd.RELATE_ID
           AND rd.DEF_ID = '183' 
           where  l.code_tx in ('')
order by rd.START_DT ASC ;

update rd
set value_tx = 'false', lock_id = lock_id+1, UPDATE_DT = GETDATE(), UPDATE_USER_TX = ''
--select *
FROM RELATED_DATA rd
where id in (select id from #tmpLenderRemoval)

