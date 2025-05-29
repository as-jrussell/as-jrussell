#################################
## done with windows services
## not sure why were checking status now since we know they are off... should we give a prompt to start them here?
Start-Transcript -Path "C:\logs\PowerShell Logs\UTAUTODeployment.txt"


 # roll through each server and get the status of all windows services included in the list
$serverList = (

"UTAUTO-APP1.colo.as.local"
)
Foreach ($server in $serverList) {
 #this remote session gets service status for each item in the list
$Session = New-PSSession -ComputerName $server
$serviceControlBlock = {
 
$serviceList = (
"DirectoryWatcher*",
"Fax*",
"LDH*",
"LetterGen*",
"LIMC*",
"Message*",
"MSGSRV*",
"Osprey*",
"QC*",
"Unitrac*",
"UTL*",
"Workflow*"
)

Get-Service  -DisplayName $serviceList | where {$_.StartType -ne "Disabled"} | sort-object status | format-table -Property DisplayName -groupby status 

 }  #end script block

Invoke-Command -ComputerName $server -ScriptBlock {hostname}
Invoke-Command -Session $Session -ScriptBlock $serviceControlBlock

} #end foreach server



Stop-Transcript

if(Test-Path "C:\logs\PowerShell Logs\QADeployment.txt"){
$destination = "C:\logs\PowerShell Logs\QADeployment"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Copy-Item -Path "C:\logs\PowerShell Logs\QADeployment.txt" -Destination $destination
}


Remove-Item -Path "C:\logs\PowerShell Logs\QADeployment.txt"