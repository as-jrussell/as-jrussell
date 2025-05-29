select * from related_data_def
where id in (137)

select L.CODE_TX, L.NAME_TX, RD.* 
from related_data rd 
join lender l on l.id = rd.relate_id
where L.CODE_TX = ''
and def_id = 137


select  di.* from PPDATTRIBUTE p
join preprocessing_detail pd on pd.id = p.preprocessing_detail_id
join delivery_info_group dig on pd.delivery_info_group_id = dig.id
join delivery_info di on dig.delivery_info_id = di.id
join trading_partner tp on tp.id = di.trading_partner_id
join lender l on l.code_tx = tp.external_id_tx
where p.code_cd ='SkipNewCollCrossColl'
and L.CODE_TX = ''
and p.purge_dt is null
and di.active_in = 'Y'


