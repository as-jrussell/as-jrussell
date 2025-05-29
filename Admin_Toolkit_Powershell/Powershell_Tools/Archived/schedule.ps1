# for windows 7 and less versions
ipmo PSScheduledJob
$T = New-JobTrigger -Weekly -DaysOfWeek 1,3,5 -At 12:01AM
Register-ScheduledJob -Name Test-HelpFiles1 -FilePath "C:\runas.ps1" -Trigger $T 

# for windows 8 and higher versions

ipmo ScheduledTasks
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -WindowStyle Hidden -command "& {get-eventlog -logname Application -After ((get-date).AddDays(-1)) | Export-Csv -Path c:\temp\applog.csv -Force -NoTypeInformation}"'
$trigger =  New-ScheduledTaskTrigger -Daily -At 9am
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "AppLog" -Description "Daily dump of Applog" 