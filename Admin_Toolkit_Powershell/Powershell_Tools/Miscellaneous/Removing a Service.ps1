(Get-WmiObject Win32_Service -filter "name='UnitracBusinessServiceProc10'").Delete()


$server_names = Get-Content  "E:\AdminAppFiles\deleteme.txt"

Foreach ($Service in $server_names){(Get-WmiObject Win32_Service -filter "name='$service'").Delete()}


#Deletes entire folder

#Remove-Item -Path "C:\Program Files (x86)\AlliedSolutions\LDHServices\LDHServiceVUT" -Recurse -Force


#Remove-Item -Path "C:\Program Files (x86)\AlliedSolutions\LDHServices\MSGSRVREXTVUT" -Recurse -Force




Invoke-Command -ComputerName unitrac-edi-0A -ScriptBlock {$server_names =  "TradeLink"
{
$UserName = "LDHService@as.local" 
$Password = "1ijt3kOwko2WT64mLhfh"
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
    }