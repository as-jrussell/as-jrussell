

	select count(*)
from vut..tblFTPQueue f
WHERE  (f.StatusCSV != 'Complete' OR f.StatusPGP != 'Complete')  and f.CreatedDate >= DateAdd(mi, -30, getdate())
--AND (AttemptCSV < 6 or AttemptPGP < 6) 
--order by CREATE_DT desc

	select count(*)
from vut..tblFTPQueue f
WHERE  (f.StatusCSV != 'Complete' OR f.StatusPGP != 'Complete')  and f.CreatedDate >= DateAdd(mi, -60, getdate())
--AND (AttemptCSV < 6 or AttemptPGP < 6) 
--order by CREATE_DT desc


	select count(*)
from vut..tblFTPQueue f
WHERE  (f.StatusCSV != 'Complete' OR f.StatusPGP != 'Complete')  --and f.CreatedDate >= DateAdd(mi, -90, getdate())
--AND (AttemptCSV < 6 or AttemptPGP < 6) 
--order by CREATE_DT desc
