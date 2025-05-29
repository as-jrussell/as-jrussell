update cpia 
SET cpia.TOTAL_PREMIUM_NO = '-442.32',
cpia.UPDATE_DT = GETDATE(),
cpia.UPDATE_USER_TX = 'TASK37559',
cpia.LOCK_ID = (cpia.LOCK_ID % 255) + 1
--select *
from CPI_ACTIVITY cpia
WHERE
cpia.ID = 28121455
GO

update cd 
SET cd.AMOUNT_NO = '-428.60',
cd.UPDATE_DT = GETDATE(),
cd.UPDATE_USER_TX = 'TASK37559',
cd.LOCK_ID = (cd.LOCK_ID % 255) + 1
--select *
from CERTIFICATE_DETAIL cd 
WHERE
cd.ID = 55228396
GO

update ft 
SET ft.AMOUNT_NO = '-442.32',
ft.UPDATE_DT = GETDATE(),
ft.UPDATE_USER_TX = 'TASK37559',
ft.LOCK_ID = (ft.LOCK_ID % 255) + 1
--select *
from FINANCIAL_TXN ft
WHERE
ft.ID = 16396267
GO

update ftd 
SET ftd.AMOUNT_NO = '-428.60',
ftd.UPDATE_DT = GETDATE(),
ftd.UPDATE_USER_TX = 'TASK37559',
ftd.LOCK_ID = (ftd.LOCK_ID % 255) + 1
--select *
from FINANCIAL_TXN_DETAIL ftd 
WHERE
ftd.ID = 18862854
GO
-----------------------------

update cpia 
SET cpia.TOTAL_PREMIUM_NO = '-121.76',
cpia.UPDATE_DT = GETDATE(),
cpia.UPDATE_USER_TX = 'TASK37559',
cpia.LOCK_ID = (cpia.LOCK_ID % 255) + 1
--select *
from CPI_ACTIVITY cpia
WHERE
cpia.ID = 28121468
GO

update cd 
SET cd.AMOUNT_NO = '-117.98',
cd.UPDATE_DT = GETDATE(),
cd.UPDATE_USER_TX = 'TASK37559',
cd.LOCK_ID = (cd.LOCK_ID % 255) + 1
--select *
from CERTIFICATE_DETAIL cd 
WHERE
cd.ID = 55228414
GO

update ft 
SET ft.AMOUNT_NO = '-121.76',
ft.UPDATE_DT = GETDATE(),
ft.UPDATE_USER_TX = 'TASK37559',
ft.LOCK_ID = (ft.LOCK_ID % 255) + 1
--select *
from FINANCIAL_TXN ft
WHERE
ft.ID = 16396266
GO

update ftd 
SET ftd.AMOUNT_NO = '-117.98',
ftd.UPDATE_DT = GETDATE(),
ftd.UPDATE_USER_TX = 'TASK37559',
ftd.LOCK_ID = (ftd.LOCK_ID % 255) + 1
--select *
from FINANCIAL_TXN_DETAIL ftd 
WHERE
ftd.ID = 18862851
GO

-----------------------------

update cpia 
SET cpia.TOTAL_PREMIUM_NO = '-191.28',
cpia.UPDATE_DT = GETDATE(),
cpia.UPDATE_USER_TX = 'TASK37559',
cpia.LOCK_ID = (cpia.LOCK_ID % 255) + 1
--select *
from CPI_ACTIVITY cpia
WHERE
cpia.ID = 28121467
GO

update cd 
SET cd.AMOUNT_NO = '-185.35',
cd.UPDATE_DT = GETDATE(),
cd.UPDATE_USER_TX = 'TASK37559',
cd.LOCK_ID = (cd.LOCK_ID % 255) + 1
--select *
from CERTIFICATE_DETAIL cd 
WHERE
cd.ID = 55228411
GO

update ft 
SET ft.AMOUNT_NO = '-191.28',
ft.UPDATE_DT = GETDATE(),
ft.UPDATE_USER_TX = 'TASK37559',
ft.LOCK_ID = (ft.LOCK_ID % 255) + 1
--select *
from FINANCIAL_TXN ft
WHERE
ft.ID = 16396269
GO

update ftd 
SET ftd.AMOUNT_NO = '-185.35',
ftd.UPDATE_DT = GETDATE(),
ftd.UPDATE_USER_TX = 'TASK37559',
ftd.LOCK_ID = (ftd.LOCK_ID % 255) + 1
--select *
from FINANCIAL_TXN_DETAIL ftd 
WHERE
ftd.ID = 18862860
GO