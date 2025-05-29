



ipmo ScheduledTasks
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-file "E:\Unitrac Log Maintenance\Cleanup.ps1"'
$trigger =  New-ScheduledTaskTrigger -Daily -At 10:59pm
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Clean up Job" -Description "Job that cleans up logs that are in the main folder of Logs and are older than two days" -User "UniTracSyncService" -Password "19cHi0jLq8q3NTePZI5L"



New-Item -path "E:\" -ItemType "directory" -Name "Unitrac Log Maintenance"

Copy-Item -Path "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_ServerCreation\Cleanup.ps1" "E:\Unitrac Log Maintenance"