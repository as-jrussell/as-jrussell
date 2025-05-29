$server_names =  "MSGSRVREXTUSD"
Foreach ($Service in $server_names){New-Service -Name "$Service" -BinaryPathName """C:\Program Files\Allied Solutions\$Service\LIMCListen.exe"" -SVCNAME:$Service" -DisplayName "$Service" -StartupType Automatic -Description "$Service"}
Foreach ($Service in $server_names)
{
$UserName = "UBSService@as.local" 
$Password = "DYwL45lRbG68sBMbGp0w"
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


