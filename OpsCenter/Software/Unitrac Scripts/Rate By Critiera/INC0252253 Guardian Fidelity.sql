-- Task INC0252253 PHW_ESREO
-- Backup Copy of lkuRateByCriteria
Select * into lkuRateByCriteria_10192016 from lkuRateByCriteria

Select * from tblCarrier
 where carrierkey = 34
--Select distinct rategroupid from lkuRateByCriteria where carrierkey = 34 

--Select * from lkuCarrierPropertyCode where carrierkey = 76 and coveragetypekey = 13
--Select * from lkuPropertyCode where carrierkey = 76 and propertycode in ( 'RRE', 'RO')

-- Insert into lkuRateGroupID
INSERT INTO [VUT].[dbo].[lkuRateGroupID]([CarrierKey], [RateGroupID], [Createddate], [Modifieddate])
VALUES(34, 'PHW_ESREO',getdate(), getdate())

-- Insert into lkuRateByCriteria

-- Mobile Home Occupied/Vacant
Insert into lkuRateByCriteria (State,Zip,Carrierkey,Miscellaneous,Coveragetypekey, RateGroupid, propertycode, propertytype,
PremiumRateFactor,PremiumAmount,createddate, contracttypekey, modifieddate, Tax2RateFactor, Tax2amount )
Select distinct z.State, Zip, pc.Carrierkey, Miscellaneous, pc.coveragetypekey, RateGroupid, propertycode, PropertyDescription,
'Per Hundred' ,0,getdate(), 4, getdate(), 'Percent', 0
--select *  -- 
from lkuCarrierPropertyCode PC
join lkuCarrierZipCode Z on Z.carrierkey = PC.carrierkey and Z.coveragetypekey = Pc.coveragetypekey
join lkuRateGroupID G on G.carrierkey = Z.Carrierkey
where z.carrierkey = 34 and z.coveragetypekey = 13 and RateGroupID = 'PHW_ESREO' 
and pc.propertycode in ('MO','MV') 
--20356

-- Insert into lkuRateByCriteria

-- Mobile Home Occupied/Vacant 1st Tier & 2nd Tier
Insert into lkuRateByCriteria (State,Zip,Carrierkey,Miscellaneous,Coveragetypekey, RateGroupid, propertycode, propertytype,
PremiumRateFactor,PremiumAmount,createddate, contracttypekey, modifieddate, Tax2RateFactor, Tax2amount )
Select distinct z.State, Zip, pc.Carrierkey, Miscellaneous, pc.coveragetypekey, RateGroupid, propertycode, PropertyDescription,
'Per Hundred' ,0,getdate(), 4, getdate(), 'Percent', 0
--select *  -- 
from lkuCarrierPropertyCode PC
join lkuCarrierZipCode Z on Z.carrierkey = PC.carrierkey and Z.coveragetypekey = Pc.coveragetypekey
join lkuRateGroupID G on G.carrierkey = Z.Carrierkey
where z.carrierkey = 34 and z.coveragetypekey = 13 and RateGroupID = 'PHW_ESREO' 
and pc.propertycode in ('KM','KN','KP','KQ') and state in ('AL','LA','MS','TX','FL','GA','NC','SC')
--35468


/* NO LONGER NEEDED
-- Update RO description 
Update lkuRateByCriteria set propertytype = 'Residential Occupied' 
--Select * from lkuRateByCriteria
where carrierkey = 76 and RateGroupID = 'WNC_Brightstar'  and propertycode = 'RO'
*/

---------- UPDATE RATES

-- Update Rates  not in ('AL','LA','MS','TX','FL','GA','NC','SC')
-- 
Update lkuRateByCriteria set premiumamount = 1.12/100
-- Select * from lkuRateByCriteria
where carrierkey = 34 and RateGroupID = 'PHW_ESREO' and propertycode in ('MO','MV')  and 
state not in ('AL','LA','MS','TX','FL','GA','NC','SC')
--2622


-- Update Rates ('AL', 'TX', 'LA', 'MS')
-- 
Update lkuRateByCriteria set premiumamount = 1.05/100
-- Select * from lkuRateByCriteria
where carrierkey = 34 and RateGroupID = 'PHW_ESREO' and propertycode in ('MO')  and 
state in ('AL', 'TX', 'LA', 'MS')
--4802
Update lkuRateByCriteria set premiumamount = 1.12/100
-- Select * from lkuRateByCriteria
where carrierkey = 34 and RateGroupID = 'PHW_ESREO' and propertycode in ('MV')  and 
state in ('AL', 'TX', 'LA', 'MS')
--4802
Update lkuRateByCriteria set premiumamount = 2.40/100
-- Select * from lkuRateByCriteria
where carrierkey = 34 and RateGroupID = 'PHW_ESREO' and propertycode in ('KM','KP')  and 
state in ('AL', 'TX', 'LA', 'MS')
--9604
Update lkuRateByCriteria set premiumamount = 1.70/100
-- Select * from lkuRateByCriteria
where carrierkey = 34 and RateGroupID = 'PHW_ESREO' and propertycode in ('KN','KQ')  and 
state in ('AL', 'TX', 'LA', 'MS')
--9604

-- FL
Update lkuRateByCriteria set premiumamount = 2.55/100
-- Select * from lkuRateByCriteria
where carrierkey = 34 and RateGroupID = 'PHW_ESREO' and propertycode in ('MO','MV')  and 
state in ('FL')
--2942

Update lkuRateByCriteria set premiumamount = 3.80/100
-- Select * from lkuRateByCriteria
where carrierkey = 34 and RateGroupID = 'PHW_ESREO' and propertycode in ('KM','KP')  and 
state in ('FL')
--2942
Update lkuRateByCriteria set premiumamount = 2.90/100
-- Select * from lkuRateByCriteria
where carrierkey = 34 and RateGroupID = 'PHW_ESREO' and propertycode in ('KN','KQ')  and 
state in ('FL')
--2942

-- Update Rates ('GA', 'NC', 'SC')

Update lkuRateByCriteria set premiumamount = 1.05/100
-- Select * from lkuRateByCriteria
where carrierkey = 34 and RateGroupID = 'PHW_ESREO' and propertycode in ('MO','MV')  and 
state in ('GA', 'NC', 'SC')
--5188
Update lkuRateByCriteria set premiumamount = 1.50/100
-- Select * from lkuRateByCriteria
where carrierkey = 34 and RateGroupID = 'PHW_ESREO' and propertycode in ('KM','KP')  and 
state in ('GA', 'NC', 'SC')
--5188
Update lkuRateByCriteria set premiumamount = 1.30/100
-- Select * from lkuRateByCriteria
where carrierkey = 34 and RateGroupID = 'PHW_ESREO' and propertycode in ('KN','KQ')  and 
state in ('GA', 'NC', 'SC')
--5188




-- The following select should not return any items - if it does let me know

Select * from lkuRateByCriteria where carrierkey = 34 and rategroupid = 'PHW_ESREO' and premiumamount = 0
--464
-- 2/11/2016 - We do not need the Wind rates for the All states Except for ('AL', 'FL', 'LA', 'MS', 'TX')
Select * from lkuRateByCriteria where carrierkey = 76 and rategroupid = 'PHW_ESREO' and premiumamount = 0 and state not in ('AL', 'FL', 'LA', 'MS', 'TX') and propertycode in ('WO')
--464
-- If the results are good then run the delete
Delete from lkuRateByCriteria where carrierkey = 76 and rategroupid = 'PHW_ESREO' and premiumamount = 0 and state not in ('AL', 'FL', 'LA', 'MS', 'TX') and propertycode in ('WO')
--464

/* *********************************************************************************
 IMPORTANT TO INSERT INTO UNITRAC TABLE RATE_GROUP_ID

-- The RateGroupID PHW_ESREO needs to be inserted in the UniTrac RateGroupID table
-- Carrier_VUT_Key = 34
-- Carrier_ID = 29

********************************************************************************* */

INSERT INTO RATE_GROUP_ID (CARRIER_ID,CODE_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,CARRIER_VUT_KEY)
VALUES (29,'PHW_ESREO',GETDATE(),GETDATE(),'INC0252253',1,34)

