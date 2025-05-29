--Delete from tblftpqueue
DELETE
from vut.dbo.tblftpqueue
where batchid = 'LIUNITRACAPP01201603170725192249323'
--1

--Delete from tblimagequeue
DELETE
from vut.dbo.tblimagequeue
where batchid = 'LIUNITRACAPP01201603170725192249323'
--2

--Reset batch in ScanBatch table
update vut.dbo.scanbatch
set BatchType = 1, UploadDate = null, UploadWorkstation = null
where batchid = 'LIUNITRACAPP01201603170725192249323'
--1