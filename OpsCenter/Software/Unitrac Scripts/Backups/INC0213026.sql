--Please run the following:
update C
set
 PURGE_DT = getdate()
,UPDATE_DT = getdate()
,UPDATE_USER_TX = 'INC0213026'
,LOCK_ID = C.LOCK_ID % 255 + 1
from COLLATERAL as C
where C.ID = 55100200
 
update C
set
 PURGE_DT = getdate()
,UPDATE_DT = getdate()
,UPDATE_USER_TX = 'INC0213026'
,LOCK_ID = C.LOCK_ID % 255 + 1
from COLLATERAL as C
where C.ID = 42149731
 
EXEC SaveSearchFullText 41604826




SELECT * 
--INTO UniTracHDStorage..INC0213026
FROM dbo.COLLATERAL
WHERE ID IN (55100200,42149731)