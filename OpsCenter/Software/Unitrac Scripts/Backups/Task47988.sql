select * 
into unitrachdstorage..task47988_Backup
from OWNER_POLICY
where id in (select [op id] from unitrachdstorage..task47988)


update op set op.bic_name_tx= t.[updated bic_name_tx]
--select * 
from OWNER_POLICY op 
join unitrachdstorage..task47988 t on t.[op id] = op.id