


 # prompt user for the main parameter within the path. if they hit enter, use the default
Write-Output "Setup folder in TFS to use?`n"
$version = Read-Host -Prompt  "(enter uses the default of 'Version ReleaseCandidate')"
if( [string]::IsNullOrEmpty($version)){
   $version = "Version ReleaseCandidate"
   }


 # set the source path based on the input from the implementer
$tfsPath = "\\tfs-build-06\E$\UniTrac\Setups\$version"

$configRepository = "\\as.local\shared\InfoTech\UniTrac_Master_Configs"
Start-Sleep -s 3
 
Clear-Host


Write-Output "What is the name of the new service create today?`n"
$service_names = Read-Host -Prompt  "(enter new service name)"
#if( [string]::IsNullOrEmpty($version)
Foreach ($service in $service_names){

   $destPath = New-Item -ItemType "directory" -Path "E:\Services\$service"

   Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
   Copy-Item -Path "$tfsPath\LDH\UnitracBusinessService\*" -Destination $destPath -Recurse
   Copy-Item -Path "$configRepository\Prod\$service\*.exe.config" -Destination $destPath -Force
New-Service -Name "$Service" -BinaryPathName """E:\Services\$Service\UnitracBusinessService.exe"" -SVCNAME:$Service -SVCTYPE:QUEUEDISTRIBUTOR" -DisplayName "$Service" -StartupType Automatic -Description "$Service"}

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
    {Write-host "The service '$Service' Started successfully"

   
   }



   Write-Output "
   Check files on E drive and ensure the service was created`n"

