Copy-Item -Path "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Powershell_Scripts\modules\ImportExcel"  "C:\Windows\system32\WindowsPowerShell\v1.0\Modules" -Recurse -Force

Copy-Item -Path "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Powershell_Scripts\modules\DBATools"  "C:\Windows\system32\WindowsPowerShell\v1.0\Modules" -Recurse -Force

Stop-Process -name "*Powershell*" [-passThru] [-Force]