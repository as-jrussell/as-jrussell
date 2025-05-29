
--BACKOUT--
--UT-PRD-LISTENER--

Use Unitrac

declare @ticket nvarchar(25) 
declare @backout nvarchar(max) 

set @ticket = 'INC0568262' --INSERT TICKET NUMBER
set @backout = ''+@ticket+'_bo'

Exec('update pli
set
	PURGE_DT = bo.PURGE_DT,
	UPDATE_DT = GETDATE(),
	UPDATE_USER_TX = '''+@backout+''',
	pli.LOCK_ID = pli.LOCK_ID % 255 + 1
from UnitracHDStorage..'+@ticket+' bo
join process_log_item pli on pli.ID = bo.ID')

