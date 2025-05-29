
ipmo ScheduledTasks 
$action = New-ScheduledTaskAction  -Execute 'Powershell.exe' -Argument '-file "C:\PowerShell\QA2\Stop.ps1"'
$trigger =  New-ScheduledTaskTrigger -Once -At 7pm
Register-ScheduledTask  -Action $action -Trigger $trigger -TaskName "Shut everything down in QA2" 





ipmo ScheduledTasks 
$action = New-ScheduledTaskAction  -Execute 'Powershell.exe' -Argument '-file "C:\PowerShell\QA2\Start.ps1"'
$trigger =  New-ScheduledTaskTrigger -Once -At 7am
Register-ScheduledTask  -Action $action -Trigger $trigger -TaskName "Bring everything back up in QA2" 

