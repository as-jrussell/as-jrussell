$service_names = Get-Content "C:\downloads\logincrease.TXT"
Foreach ($service in $service_names){

Invoke-SQLcmd -QueryTimeout 0 -Server $service -Database master 'ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N''templog'', SIZE = 1GB )'  
   }

