--Please run the following:
update C
set
 PURGE_DT = getdate()
,UPDATE_DT = getdate()
,UPDATE_USER_TX = 'INC0211744'
,LOCK_ID = C.LOCK_ID % 255 + 1
from COLLATERAL as C
where C.ID = 92344035
 
update C
set
 PRIMARY_LOAN_IN = 'Y'
,UPDATE_DT = getdate()
,UPDATE_USER_TX = 'INC0211744'
,LOCK_ID = C.LOCK_ID % 255 + 1
from COLLATERAL as C
where C.ID = 92343841
 
EXEC SaveSearchFullText 91243820