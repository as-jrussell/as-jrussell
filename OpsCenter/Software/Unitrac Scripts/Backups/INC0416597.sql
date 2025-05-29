use unitrac


select * from unitrachdstorage..INC0416597_Upload



update pc
set PC.BASE_AMOUNT_NO = I.Base_Amount_no, UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0416597',LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--SELECT PC.BASE_AMOUNT_NO , I.Base_Amount_no, i.*
from POLICY_COVERAGE PC
JOIN  unitrachdstorage..INC0416597_Upload I on I.[POLICY COVERAGE ID] = pc.id



SELECT  pc.*
into unitrachdstorage..INC0416597_POLICY_COVERAGE
from POLICY_COVERAGE PC
JOIN  unitrachdstorage..INC0416597_Upload I on I.[POLICY COVERAGE ID] = pc.id



update p
set P.REPLACEMENT_COST_VALUE_NO = I.REPLACEMENT_COST_VALUE_NO, UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0416597',LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select P.REPLACEMENT_COST_VALUE_NO , I.REPLACEMENT_COST_VALUE_NO,p.*
from property p
JOIN  unitrachdstorage..INC0416597_Upload I on I.[Property_ID] = p.id





