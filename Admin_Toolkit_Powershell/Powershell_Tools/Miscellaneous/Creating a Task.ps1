
$service_names =  Get-Content "C:\temp\ASR.TXT"
Foreach ($service in $service_names){
Invoke-Command -ComputerName $service -ScriptBlock { 
ipmo ScheduledTasks 
$action = New-ScheduledTaskAction  -Execute 'Powershell.exe' -Argument '-file "E:\Unitrac Log Maintenance\Stop_UBS_Service.ps1"'
$trigger =  New-ScheduledTaskTrigger -Weekly -WeeksInterval 4 -DaysOfWeek Saturday -At 7pm
Register-ScheduledTask  -Action $action -Trigger $trigger -TaskName "Stop_Services" -Description "Services that need to be stopped so cycle and reports won't run during windows patching" -User "UniTracSyncService" -Password "19cHi0jLq8q3NTePZI5L"}}





$service_names =  Get-Content "C:\temp\ASR.TXT"
Foreach ($service in $service_names){
Invoke-Command -ComputerName $service -ScriptBlock {
ipmo ScheduledTasks 
$action = New-ScheduledTaskAction  -Execute 'Powershell.exe' -Argument '-file "E:\Unitrac Log Maintenance\Start_UBS_Service.ps1"'
$trigger =  New-ScheduledTaskTrigger -Weekly -WeeksInterval 4 -DaysOfWeek Sunday -At 7am
Register-ScheduledTask  -Action $action -Trigger $trigger -TaskName "Start_Services" -Description "Services that need to be start so cycle and reports won't run during windows patching" -User "UniTracSyncService" -Password "19cHi0jLq8q3NTePZI5L"}}

