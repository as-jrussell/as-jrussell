EXEC HDTStorage.archive.CreateStorageSchema @WhatIf = 1, @Debug = 0
EXEC HDTStorage.archive.CreateStorageSchema @WhatIf = 1, @Debug = 1 ---prints code that the job is going to execute and additionally prints discovery query; add notes 
EXEC HDTStorage.archive.CreateStorageSchema @WhatIf = 0, @Debug = 0
EXEC HDTStorage.archive.CreateStorageSchema @WhatIf = 0, @Debug = 1 --executes job and prints discovery query

select DB.NAME, S.Name from sys.databases DB
LEFT join HDTStorage.sys.schemas S on S.name = DB.name
where (database_id >=5 AND  DB.name not in ('Perfstats','HDTStorage', 'DBA'))

