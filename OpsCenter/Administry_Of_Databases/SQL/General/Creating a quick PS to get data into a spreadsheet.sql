

select CONCAT('Invoke-SQLcmd -QueryTimeout 0 -Server ''', @@SERVERNAME ,''' -Database ', DB_NAME(),' ''select * FROM ', schema_name(schema_id),'.', name ,'''| Export-Csv -path "C:\Users\jrussell\Downloads\Genesys\',name,'.CSV"')
from sys.tables 
where schema_name(schema_id) not in ('dbo')


select schema_name(schema_id), *
from sys.tables 
where schema_name(schema_id) not in ('dbo')

