
Invoke-SQLcmd -QueryTimeout 0 -Server 'Unitrac-DB01' -Database Unitrac 'SELECT lp.* FROM dbo.LENDER_PRODUCT lp JOIN dbo.LENDER L ON L.ID = lp.LENDER_ID WHERE L.CODE_TX = ''1045''' | Export-Csv -path "C:\Users\jrussell\Downloads\LenderProduct1045.csv"




Invoke-SQLcmd -QueryTimeout 0 -Server 'Unitrac-PROD1' -Database Unitrac 'Select * FROM jcs..INC0374906' | Export-Csv -path "C:\Users\jrussell\Downloads\INC0374906.csv"




Invoke-SQLcmd -QueryTimeout 0 -Server 'rfpl-sql-devtest.40f5fdcbfb84.database.windows.net' -Username 'RFPLdbJoseph.Russell' -Password 'NewPassword1234!!' 'Declare @cmd2 varchar(500) set @cmd2 =
''USE [?] SELECT db_name(), count(*) from sys.tables where name in (''Search_FullText'', ''Provider_Search_FullText'')''
exec sp_MSforeachdb  @cmd2  ' | Export-Csv -path "C:\Users\jrussell\Downloads\AIH_10441.csv"


New-Item -ItemType 'directory' -Path "C:\Users\jrussell\Downloads\AIH_10441\"


Invoke-SQLcmd -QueryTimeout 0 -Server 'PingFed-DB-01' -Database Pingfederate 'select * FROM [Pingfederate].[dbo].[channel_user]' | Export-Csv -path "C:\Users\jrussell\Downloads\AIH_10441\channel_user.csv"

Invoke-SQLcmd -QueryTimeout 0 -Server 'PingFed-DB-01' -Database Pingfederate 'select * FROM [Pingfederate].[dbo].[group_membership]' | Export-Csv -path "C:\Users\jrussell\Downloads\AIH_10441\group_membership.csv"

Invoke-SQLcmd -QueryTimeout 0 -Server 'PingFed-DB-01' -Database Pingfederate 'select * FROM [Pingfederate].[dbo].[channel_group]' | Export-Csv -path "C:\Users\jrussell\Downloads\AIH_10441\channel_group.csv"


sqlcmd -S ON-SQLCLSTPRD-2 -U solarwinds_sql -P S0l@rw1nds -i "C:\Users\jrussell\Downloads\idr.sql"  -o "C:\Users\jrussell\Downloads\idr.csv"
sqlcmd -S ON-SQLCLSTPRD-2 -U solarwinds_sql -P S0l@rw1nds -i "C:\Users\jrussell\Downloads\edi.sql"  -o "C:\Users\jrussell\Downloads\edi.csv"
sqlcmd -S ON-SQLCLSTPRD-2 -U solarwinds_sql -P S0l@rw1nds -i "C:\Users\jrussell\Downloads\ocr.sql"  -o "C:\Users\jrussell\Downloads\ocr.csv"



Invoke-SQLcmd -QueryTimeout 0 -Server 'ON-SQLCLSTPRD-2' -Database Unitrac -InputFile "C:\Users\jrussell\Downloads\INC0481354.sql" | Export-Csv -path "C:\Users\jrussell\Downloads\INC0481354.csv"


Invoke-SQLcmd -QueryTimeout 0 -Server 'UT-PRD-LISTENER' -Database Unitrac 'SELECT USER_NAME_TX, GIVEN_NAME_TX, FAMILY_NAME_TX
FROM users WHERE PURGE_DT IS NULL AND ACTIVE_IN = ''Y'''  | Export-Csv -path "C:\Users\jrussell\Downloads\INC0524609.csv"








Invoke-SQLcmd -QueryTimeout 0 -Server ivos-sqlqa-02.rd.as.local -Database ivos 'select  CONCAT(''The ROLE: '' ,rp.name, '' has the user : '',mp.name,'''') 
from sys.database_role_members dm
join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
where 
 rp.name like ''%IdentityNow_APP_ACCESS%''' 


 Invoke-SQLcmd -QueryTimeout 0 -Server ivos-sqlqa-02.rd.as.local -Database ivos 'SELECT CONCAT(''The ROLE: '' ,USER_NAME(grantee_principal_id), '' has access to the table: '', 
 OBJECT_NAME(major_id), '' with '' , permission_name, '' rights on '', DB_NAME(), '' database'')
 FROM sys.database_permissions
 where USER_NAME(grantee_principal_id) like ''%IdentityNow_APP_ACCESS%''' 