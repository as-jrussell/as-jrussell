


 # prompt user for the main parameter within the path. if they hit enter, use the default
Write-Output "What is the name of the where of the new version ?`n"
$version10 = Read-Host -Prompt  "(enter uses the default of 'Allied.Unitrac 10.1.2.2')"
if( [string]::IsNullOrEmpty($version10)){
   $version10 = "Version ReleaseCandidate"
   }




 # set the source path based on the input from the implementer
$nshare10 = "\\as.local\shared\InfoTech\Win10thinapps\$version10"
$nshare7 = "\\as.local\shared\InfoTech\Win7thinapps\$version10"


Copy-Item "\\Thinapp-Build.as.local\c$\Thinapp Builds\$version10" "$nshare10" -Recurse -Force

Copy-Item "\\windows7x64\c$\UniTrac ThinApp\$version10" "$nshare7" -Recurse -Force


   write-Output "`nThe Windows 7 VDI files will be copied here:   $nshare7"

   write-Output "`nThe Windows 10 VDI files will be copied here:  $nshare10"


