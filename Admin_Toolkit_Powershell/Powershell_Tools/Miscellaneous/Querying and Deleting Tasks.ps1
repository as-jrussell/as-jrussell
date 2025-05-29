#Querying Tasks
$service_names =  Get-Content "C:\Downloads\ServerProd.txt"
$file = "C:\Downloads\ScheduledTask.csv"
Foreach ($service in $service_names){
Invoke-Command -ComputerName $service -ScriptBlock{
Get-ScheduledTask -TaskName '*Services*' | Get-ScheduledTaskInfo | select TaskName, LastRunTime, NextRunTime} | Export-Csv $file}


#Deleting Tasks

$service_names =  "USD-RD001"
Foreach ($service in $service_names){
Invoke-Command -ComputerName $service -ScriptBlock { 
ipmo ScheduledTasks 
unRegister-ScheduledTask   -TaskName '*ASR*'}}



#Querying Tasks
$service_names =  Get-Content "C:\Downloads\ServerProd.txt"
Foreach ($service in $service_names){
Invoke-Command -ComputerName $service -ScriptBlock{
Get-ScheduledTask -TaskName '*Services*' | Get-ScheduledTaskInfo | select TaskName, LastRunTime, NextRunTime } | Export-Csv "C:\Downloads\ScheduledTask.csv"
