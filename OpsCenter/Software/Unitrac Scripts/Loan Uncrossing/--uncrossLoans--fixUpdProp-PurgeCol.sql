--Please run the following:
update C
set
 PROPERTY_ID =242411225 --New Property ID
 
 , PRIMARY_LOAN_IN = 'Y', LOAN_PERCENTAGE_NO = 100, COLLATERAL_NUMBER_NO = 1
,UPDATE_DT = getdate()
,UPDATE_USER_TX = 'INC02'
,LOCK_ID = C.LOCK_ID % 255 + 1
from COLLATERAL as C
where C.ID =1353581 -- Original Collateral ID

update C
set
 PURGE_DT = getdate()
,UPDATE_DT = getdate()
,UPDATE_USER_TX = 'INC02'
,LOCK_ID = C.LOCK_ID % 255 + 1
from COLLATERAL as C
where C.ID = 244450002--New Collateral ID


EXEC SaveSearchFullText 190363-- New Property ID

EXEC SaveSearchFullText 242411225-- Old Property ID
