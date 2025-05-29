# This file contains the list of servers you want to copy files/folders to
$computers = gc "Unitrac-WH018"

$file1 = "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\TreeSize\Treesizefreesetup.exe"
$file2 = "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\TreeSize\BO.bat"
$file3 = "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\TreeSize\TS.bat"


# This is the file/folder(s) you want to copy to the servers in the $computer variable
$source = $file1, $file2, $file3
 
# The destination location you want the file/folder(s) to be copied to
$destination = "E$\AdminAppFiles\"

foreach ($computer in $computers) {Invoke-Command -ComputerName $computer -ScriptBlock {New-Item -ItemType "directory" -Path "E:\AdminAppFiles"}}
 
foreach ($computer in $computers) {
if ((Test-Path -Path \\$computer\$destination)) {
Copy-Item $source -Destination \\$computer\$destination -Recurse
} else {
"\\$computer\$destination is not reachable or does not exist"
}
}



foreach ($computer in $computers) {Invoke-Command -ComputerName $computer  -ScriptBlock {cd "E:\AdminAppFiles";
Start-Process -FilePath "E:\AdminAppFiles\TS.bat" -PassThru -Wait}}



