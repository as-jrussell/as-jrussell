Write-Output "What is the RC folder name?`n"
$folder1 = Read-Host -Prompt  "(enter uses the default of 'RC_UTWEB_1.1.0')"
if( [string]::IsNullOrEmpty($folder1)){
   $folder1 = "RC_UTWEB_1.1.0"
   }



 # prompt user for the main parameter within the path. if they hit enter, use the default
Write-Output "What is the folder version?`n"
$folder2 = Read-Host -Prompt  "(enter uses the default of '$folder2')"
if( [string]::IsNullOrEmpty($folder2)){
   $folder2 = "$folder2"
   }


 # set the source path based on the input from the implementer
$tfsPath = "\\tfs-build-06\e$\UniTrac Web Binaries\$folder1\$folder2"

if (test-path -Path $tfsPath){
   Clear-Host
   write-Output "`nThe source path will be    $tfsPath"
   Write-Output "`n(hit Ctrl+C within 6 seconds to cancel) `n`n"
   Start-Sleep -s 7
   }
else {
   Write-Host "$tfsPath `nThat path is not accessible"  
   Return      #would like to loop back here
   }


Rename-Item "$tfsPath\EscrowUI.UTWEB.$folder2.nupkg" "$tfsPath\EscrowUI.UTWEB.$folder2.nupkg.zip"
Expand-Archive "$tfsPath\EscrowUI.UTWEB.$folder2.nupkg.zip" "$tfsPath\EscrowUI\"


Rename-Item "$tfsPath\HeaderUI.UTWEB.$folder2.nupkg" "$tfsPath\HeaderUI.UTWEB.$folder2.nupkg.zip"
Expand-Archive "$tfsPath\HeaderUI.UTWEB.$folder2.nupkg.zip" "$tfsPath\HeaderUI\"


Rename-Item "$tfsPath\NavigationUI.UTWEB.$folder2.nupkg" "$tfsPath\NavigationUI.UTWEB.$folder2.nupkg.zip"
Expand-Archive "$tfsPath\NavigationUI.UTWEB.$folder2.nupkg.zip" "$tfsPath\NavigationUI\"

Rename-Item "$tfsPath\UnitracWeb.UTWEB.$folder2.nupkg" "$tfsPath\UnitracWeb.UTWEB.$folder2.nupkg.zip"
Expand-Archive "$tfsPath\UnitracWeb.UTWEB.$folder2.nupkg.zip" "$tfsPath\UnitracWeb\"

Rename-Item "$tfsPath\Workflow.UTWEB.$folder2.nupkg" "$tfsPath\Workflow.UTWEB.$folder2.nupkg.zip"
Expand-Archive "$tfsPath\Workflow.UTWEB.$folder2.nupkg.zip" "$tfsPath\Workflow\"


$configRepository = "\\as.local\shared\InfoTech\UniTrac_Master_Configs"


#EscrowUI
$webAppName = "EscrowUI"
$sourcePath = "$tfsPath\$webAppName\*"
$destPath =  "\\\utqa2-app1\C$\inetpub\UnitracWeb\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse 
Copy-Item -Path "$configRepository\Test\QA2\$webAppName\appsettings.QA2.json" -Destination $destPath -Force


#HeaderUI
$webAppName = "HeaderUI"
$sourcePath = "$tfsPath\$webAppName\*"
$destPath =  "\\\utqa2-app1\C$\inetpub\UnitracWeb\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse 
Copy-Item -Path "$configRepository\Test\QA2\$webAppName\appsettings.QA2.json" -Destination $destPath -Force



#NavigationUI
$webAppName = "NavigationUI"
$sourcePath = "$tfsPath\$webAppName\*"
$destPath =  "\\\utqa2-app1\C$\inetpub\UnitracWeb\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse 
Copy-Item -Path "$configRepository\Test\QA2\$webAppName\appsettings.QA2.json" -Destination $destPath -Force


#Workflow
$webAppName = "Workflow"
$sourcePath = "$tfsPath\$webAppName\*"
$destPath =  "\\\utqa2-app1\C$\inetpub\UnitracWeb\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse 
Copy-Item -Path "$configRepository\Test\QA2\$webAppName\appsettings.QA2.json" -Destination $destPath -Force


#UnitracWeb
$webAppName = "UnitracWeb"
$sourcePath = "$tfsPath\$webAppName\*"
$destPath =  "\\\utqa2-app1\C$\inetpub\UnitracWeb\$webAppName\"
Get-ChildItem -Path $destPath -Recurse | Remove-Item -Force -Recurse  
Copy-Item -Path $sourcePath -Destination $destPath -Recurse 
Copy-Item -Path "$configRepository\Test\QA2\$webAppName\appsettings.QA2.json" -Destination $destPath -Force
Copy-Item -Path "$configRepository\Test\QA2\$webAppName\web.config" -Destination $destPath -Force