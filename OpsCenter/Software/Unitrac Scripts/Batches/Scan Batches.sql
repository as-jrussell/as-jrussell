


select *
from vut.dbo.scanbatch
where batchtype = 3 and intftpkey <> -1 and batchdate >= '2019-04-02' and received = 1
and lenderkey in (2094) 
and pagecount > 10




select *
from vut.dbo.scanbatch
where batchtype = 3 and intftpkey <> -1 and batchdate >= '2019-04-02' and received = 1
and lenderkey in (651) 



--reset scan batchs 
update s set received= 0, receiveddate = null
--select *
from vut.dbo.scanbatch s
where batchtype = 3 and intftpkey <> -1 and batchdate >= '2019-04-02' and received = 1
and lenderkey in (2094) 
and pagecount > 10


select *
from vut.dbo.scanbatch s
where batchtype = 3 and intftpkey <> -1 and batchdate >= '2019-04-02'-- and received = 1
and lenderkey in (2094) 
and pagecount > 10







