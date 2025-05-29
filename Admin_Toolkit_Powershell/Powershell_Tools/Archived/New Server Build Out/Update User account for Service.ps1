
$server_names =  Get-Content  "E:\temp\QC.txt"
Foreach ($Service in $server_names){
$UserName = "UBSService@as.local" 
$Password = ""
$svc_Obj= Get-CimInstance Win32_Service -filter "name='$service'"
$StopStatus = $svc_Obj.StopService() 
If ($StopStatus.ReturnValue -eq "0") 
    {Write-host "The service '$Service' Stopped successfully"} 
$ChangeStatus = $svc_Obj.change($null,$null,$null,$null,$null,
                      $null, $UserName,$Password,$null,$null,$null)
If ($ChangeStatus.ReturnValue -eq "0")  
    {Write-host "User Name sucessfully for the service '$Service'"} 
$StartStatus = $svc_Obj.StartService() 
If ($ChangeStatus.ReturnValue -eq "0")  
    {Write-host "The service '$Service' Started successfully"} }


    

    
$server_names = Get-Content "E:\temp\QC.txt"
Foreach ($Service in $server_names){Set-Service -Name $Service -StartupType Disabled}



 Invoke-Command -ComputerName Unitrac-WH0S -ScriptBlock {get-wmiobject win32_service| where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"}} |Where {$_.State -inotlike "Stopped"} | Where {$_.StartMode -inotlike "Disabled"}



$server_names = Get-Content "\\unitrac-wh0S\e$\temp\QC.txt"
Foreach ($Service in $server_names) { 
Set-Service -ComputerName unitrac-wh0S -Name $Service -StartupType Automatic}
Foreach ($Service in $server_names) { 
Start-Service -Name $Service  }





$server_names = Get-Content "\\unitrac-wh0S\e$\temp\QC.txt"
Foreach ($Service in $server_names) { 
Set-Service -ComputerName unitrac-wh0S -Name $Service -StartupType Disabled}
Foreach ($Service in $server_names) { 
Get-Service -ComputerName unitrac-wh0S -Name $Service|Stop-Service -Force -NoWait}



$server_names = Get-Content "\\unitrac-wh0S\e$\temp\QC.txt"

Foreach ($Service in $server_names) { 
Get-Service -ComputerName unitrac-wh0S -Name $Service|Get-Service}



$server_names = Get-Content "C:\temp\servers.txt"
Foreach ($Service in $server_names) { 
Invoke-Command -ComputerName $Service -ScriptBlock {get-wmiobject win32_service| where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"} |Where {$_.State -inotlike "Stopped"}}}




$server_names = Get-Content "C:\temp\servers.txt"
Foreach ($Service in $server_names) { 
Invoke-Command -ComputerName $Service -ScriptBlock {get-wmiobject win32_service| where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"} |Where {$_.StartMode -inotlike "Disabled"}}}