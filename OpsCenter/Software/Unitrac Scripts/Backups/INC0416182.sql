use unitrac





/*      UPDATE C.COLLATERAL_CODE_ID of 68 and 67 to 525      --This is Veh-OT code of 68 and Veh-A  code of 67 and changed to Vehicle code 525        


Continued clean up on Tier Tracking Lenders that changed to Predictive Decile.  Here are archived loan/property records and the respective collateral code IDs

We need to change the VEh- A and veh-Ot collateral code ids on the collateral record to 1.  C.Collateral_code_id of 90 Mtorcycyle -ot  to 7 Motorycyle , c.collateral_code_id 72 of BT-OT  to 8 Boat, and 259 Trvtrl-OT  to 61 TRVL TRl.   


Here would be the Collateral Table ID /Records.  We just need to update the collateral.collateral_code_id on these Collateral Records for this lender code 7016.  

   */



SELECT C.* into unitrachdstorage..INC0416182
FROM LOAN L 
INNER JOIN COLLATERAL C ON C.LOAN_ID = L.ID
INNER JOIN LENDER LE ON LE.ID = L.LENDER_ID
INNER JOIN PROPERTY P ON P.ID = C.PROPERTY_ID
INNER JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID
WHERE LE.CODE_TX = '7016'
AND L.PURGE_DT IS NULL
AND C.PURGE_DT IS NULL
AND P.PURGE_DT IS NULL
AND L.RECORD_TYPE_CD <> 'D'
AND P.RECORD_TYPE_CD <> 'D'
AND C.COLLATERAL_CODE_ID IN 
(68,67,90, 72, 259)
ORDER BY CC.CODE_TX


Here are the current counts

C.COLLATERAL_CODE_ID, 	CODE_TX	Count
68	                                                  VEH-OT	      6947
67	                                                     VEH-A	        984
90                                     	MCYCLE-OT	       137
72                                               	BT-OT            	87
259                                           	TRVTRL-OT 	71


/*Change Collateral Cod ID 67 and 68 to 1....change 90 to 7, change 72 to 8, change 259 to 61 */
update C 
set C.COLLATERAL_CODE_ID = 1, update_dt = GETDATE(), update_user_tx = 'INC0416182', C.LOCK_ID = CASE WHEN C.LOCK_ID >= 255 THEN 1 ELSE C.LOCK_ID + 1 END
--select C.COLLATERAL_CODE_ID,CC.COLLATERAL_CODE_ID,*
from COLLATERAL C
join unitrachdstorage..INC0416182 CC on CC.ID = C.ID
where C.id in (select id from unitrachdstorage..INC0416182)  AND CC.COLLATERAL_CODE_ID IN 
(68,67)




update C 
set C.COLLATERAL_CODE_ID = 8, update_dt = GETDATE(), update_user_tx = 'INC0416182', C.LOCK_ID = CASE WHEN C.LOCK_ID >= 255 THEN 1 ELSE C.LOCK_ID + 1 END
--select COLLATERAL_CODE_ID,*
from COLLATERAL C
where id in (select id from unitrachdstorage..INC0416182)
AND C.COLLATERAL_CODE_ID IN 
( 72)



update C 
set C.COLLATERAL_CODE_ID = 7, update_dt = GETDATE(), update_user_tx = 'INC0416182', C.LOCK_ID = CASE WHEN C.LOCK_ID >= 255 THEN 1 ELSE C.LOCK_ID + 1 END
from COLLATERAL C
where id in (select id from unitrachdstorage..INC0416182)
AND C.COLLATERAL_CODE_ID IN 
(90)




update C 
set C.COLLATERAL_CODE_ID = 61, update_dt = GETDATE(), update_user_tx = 'INC0416182', C.LOCK_ID = CASE WHEN C.LOCK_ID >= 255 THEN 1 ELSE C.LOCK_ID + 1 END
from COLLATERAL C
where id in (select id from unitrachdstorage..INC0416182)
AND C.COLLATERAL_CODE_ID IN 
( 259)
