#################################
## done with windows services
## not sure why were checking status now since we know they are off... should we give a prompt to start them here?

 # record the deployment session
$deployLogDestination = "C:\logs\Deployments\ProductionDeployment"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Start-Transcript -Path $deployLogDestination

 # roll through each server and get the status of all windows services included in the list
$serverList = (
'Unitrac-WH013',
'UTPROD-UTLAPP-1.colo.as.local',
'Unitrac-WH016','Unitrac-WH014','Unitrac-WH015'
)
Foreach ($server in $serverList) {
 #this remote session gets service status for each item in the list
$Session = New-PSSession -ComputerName $server
$serviceControlBlock = {
 
$serviceList = (
"UTL*"
)

Get-Service  -DisplayName $serviceList | where {$_.StartType -ne "Disabled"} | sort-object status | format-table -Property DisplayName -groupby status 

 }  #end script block

Invoke-Command -ComputerName $server -ScriptBlock {hostname}
Invoke-Command -Session $Session -ScriptBlock $serviceControlBlock

} #end foreach server



Stop-Transcript
