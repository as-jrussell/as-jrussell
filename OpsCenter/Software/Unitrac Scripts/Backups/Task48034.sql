/*will need to upload the file back to datastorage*/

select len(op.bic_name_tx) [Owner Policy BIC Length], len(d.[ALLIED BIC NAME]) [BIC name from spreadsheet], op.bic_name_tx , d.[Allied BIC Name], OP.* 
from unitrachdstorage..data3 D
join OWNER_POLICY op on op.id = d.op_id
where  len(d.[ALLIED BIC NAME]) > '30'

 --1907




 FLORIDA SPECIALTY (formerly SAFEWAY PROPERTY)


 select len(op.bic_name_tx) [Owner Policy BIC Length], len(d.[ALLIED BIC NAME]) [BIC name from spreadsheet],left(d.[ALLIED BIC NAME], 30) [BIC name from spreadsheet], 
  d.[Allied BIC Name], op.bic_name_tx , OP.* 
from unitrachdstorage..data3 D
join OWNER_POLICY op on op.id = d.op_id
where

 len(d.[ALLIED BIC NAME]) > '30'



 
update op set --op.bic_name_tx = d.[Allied BIC Name]
 OP.BIC_ID =d.[Allied BIC ID]
,update_dt =GETDATE(), LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END,  update_user_tx = 'Task48034'
--select d.[Allied BIC ID], OP.BIC_ID, OP.* 
from unitrachdstorage..data D
join OWNER_POLICY op on op.id = d.op_id
where
len(op.bic_name_tx)!= len(d.[ALLIED BIC NAME])
 and 
 len(d.[ALLIED BIC NAME]) <= '30'


sp_columns OWNER_POLICY 



select len(op.bic_name_tx), len(d.[ALLIED BIC NAME]), op.bic_name_tx , d.[Allied BIC Name], OP.* 
from unitrachdstorage..data D
join OWNER_POLICY op on op.id = d.op_id
where
len(op.bic_name_tx)<> len(d.[ALLIED BIC NAME]) and 
 len(d.[ALLIED BIC NAME]) > '30'
