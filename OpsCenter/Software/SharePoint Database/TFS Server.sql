use Tfs_Allied2008


select bsh.[Status],mqr.QueueStatus,mqr.DateLastConnected,* 
FROM    tbl_BuildServiceHost bsh
JOIN    tbl_MessageQueueRegistration mqr
ON      mqr.QueueID = bsh.ServiceHostId
 
 /*

 update mqr set mqr.QueueStatus = '2', mqr.DateLastConnected = NULL
 --select *
 FROM    tbl_BuildServiceHost bsh
JOIN    tbl_MessageQueueRegistration mqr
ON      mqr.QueueID = bsh.ServiceHostId
where servicehostid = '5'





 update bsh set bsh.Status = '1'
  
 --select *
 FROM    tbl_BuildServiceHost bsh
JOIN    tbl_MessageQueueRegistration mqr
ON      mqr.QueueID = bsh.ServiceHostId
where servicehostid = '5'




SELECT * 
FROM tbl_MessageQueueRegistration M
where queueid = 5



SELECT * FROM tbl_BuildServiceHost



DECLARE @utcNow DATETIME = GETUTCDATE()

select bsh.[Status],mqr.QueueStatus,mqr.DateLastConnected,* 
FROM    tbl_BuildServiceHost bsh
JOIN    tbl_MessageQueueRegistration mqr
ON      mqr.QueueID = bsh.ServiceHostId
--WHERE   ServiceHostId = '5'



*/