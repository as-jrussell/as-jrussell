

;WITH location as (
SELECT @@SERVERNAME [Server],  *
  FROM [DBA].[info].[databaseConfig] DC
  where  confvalue like '\\dbbkprdawstgy01.as.local\alss3sqlsprd01'),

  storage as (SELECT @@SERVERNAME [Server],*
  FROM [DBA].[info].[databaseConfig] DC
  where confkey = 'Retention')

  --update S SET confvalue= '336'
  ----SELECT * 
  --from location L		
  --join storage S on S.Server = L.Server



   SELECT * 
  from location L		
  join storage S on S.Server = L.Server