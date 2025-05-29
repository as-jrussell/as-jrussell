Rename-Item -Path E:\Services\UTL\UTLRematchDefaultWellsFargo -NewName  E:\Services\UTL\UTLRematchDefaultSantander



 $server_names = Get-Content  "UTLRematchDefaultSantander"
#$server_names = Get-Content  "C:\temp\UBS.txt"
Foreach ($Service in $server_names){New-Service -Name "$Service" -BinaryPathName """E:\Services\UTL\$Service\UTLBusinessService.exe"" -SVCNAME:$Service" -DisplayName "$Service" -StartupType Automatic -Description "$Service"}
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


Get-Service UTLRematchDefaultSantander | Stop-Service

Set-Service UTLRematchDefaultSantander -StartupType Disabled


  Copy-Item -Path "\\MSP-DFS-01\InformationTechnology\UniTrac_Master_Configs\Prod\UTLRematchDefaultSantander\*.exe.config" -Destination "E:\Services\UTL\UTLRematchDefaultSantander" -Force

