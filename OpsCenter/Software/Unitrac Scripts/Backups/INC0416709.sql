use unitrac


update I
set
CURRENT_IMPAIRED_IN = 'N',
UPDATE_DT= getdate(),
UPDATE_USER_TX= 'INC0416709',
LOCK_ID= (LOCK_ID % 255) + 1
--select *
from IMPAIRMENT I
where id in (4465476,4465477)


select *
INTO UnitracHDStorage..INC0416709
from IMPAIRMENT I
where id in (4465476,4465477)

