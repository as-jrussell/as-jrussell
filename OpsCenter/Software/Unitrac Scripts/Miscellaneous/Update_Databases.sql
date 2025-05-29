use unitrac


select * 
into unitrachdstorage..connection_descriptor_20190926
from connection_descriptor



update cd set server_tx = 'TIMMAY'
--select * 
from connection_descriptor cd
where id = 4


update cd set server_tx = 'WINTRAQSQL'
--select * 
from connection_descriptor cd
where id = 32


update cd set server_tx = 'Unitrac-PROD1'
--select * 
from connection_descriptor cd
where id = 38


---will update once Infrastructure get us an IP
update cd set server_tx = 'xx.xx.x.xxx:27027'
--select * 
from connection_descriptor cd
where id IN (44,45)





---backup scripts
update cd set server_tx = dc.SERVER_TX
--select * 
from connection_descriptor cd
join unitrachdstorage..connection_descriptor_20190926 dc cd.id = dc.id
where id = 4


update cd set server_tx = dc.SERVER_TX
--select * 
from connection_descriptor cd
join unitrachdstorage..connection_descriptor_20190926 dc cd.id = dc.id
where id = 32


update cd set server_tx = dc.SERVER_TX
--select * 
from connection_descriptor cd
join unitrachdstorage..connection_descriptor_20190926 dc cd.id = dc.id
where id = 38


update cd set server_tx = dc.SERVER_TX
--select * 
from connection_descriptor cd
join unitrachdstorage..connection_descriptor_20190926 dc cd.id = dc.id
where id IN (44,45)



