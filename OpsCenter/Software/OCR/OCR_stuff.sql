USE ACSYSTEM
GO


SELECT  p.Name, COUNT(*), MAX(CreationDate)
from viewbatchmanager v
join processes p on p.processid = v.processid
 where    CAST(CreationDate AS DATE) = CAST(GETDATE() AS DATE)
GROUP BY  p.Name


--Batches in Review
SELECT Name, *
from viewbatchmanager v
join processes p on p.processid = v.processid
where ExternalBatchID = 982103

--Batches in Error
SELECT *
from viewbatchmanager v
join processes p on p.processid = v.processid
where p.name = 'Quality Control'  


--Batches in Review
SELECT *
from viewbatchmanager v
join processes p on p.processid = v.processid
where p.name = 'KTM Server' 
