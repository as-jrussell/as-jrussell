use UniTrac

select * 
into UniTracHDStorage..INC0437036_2new
from OWNER_POLICY
where id in (select [OP ID] from UniTracHDStorage..INC0437036_2n
)

select *from UniTracHDStorage..INC0437036_2n


update op set op.FLOOD_INSURANCE_TYPE_CD = po.[New Flood Doc Type Code],UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0437036', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END 
--select op.FLOOD_INSURANCE_TYPE_CD, po.[New Flood Doc Type Code], *
from OWNER_POLICY op
join UniTracHDStorage..INC0437036_2n PO on OP.ID =PO.[OP ID]


