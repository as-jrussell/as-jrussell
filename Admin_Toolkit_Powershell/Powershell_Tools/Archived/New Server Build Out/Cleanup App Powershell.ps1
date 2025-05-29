



ipmo ScheduledTasks
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-file "E:\AdminAppFiles\tempFileCleanup.ps1"'
$trigger =  New-ScheduledTaskTrigger -Daily -At 10:59pm
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Clean up Job" -Description "Removes temporary files from LDH_TEMP_FILES and Windows\Temp" -User "UniTracSyncService" -Password "19cHi0jLq8q3NTePZI5L"



New-Item -path "E:\" -ItemType "directory" -Name "Unitrac Log Maintenance"

Copy-Item -Path "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_ServerCreation\tempFileCleanup.ps1" "E:\Unitrac Log Maintenance"