$computers = gc "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\TreeSize\servers.txt"



foreach ($computer in $computers) {Invoke-Command -ComputerName $computer -ScriptBlock {cd "C:\Program Files (x86)\JAM Software\TreeSize Free\";
Start-Process -FilePath "E:\AdminAppFiles\BO.bat" -PassThru -Wait}}