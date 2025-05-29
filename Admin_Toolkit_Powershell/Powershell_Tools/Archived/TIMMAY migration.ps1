
Get-Service -ComputerName limc-app-01 -name FTPQService |Stop-Service
Get-Service -ComputerName limc-app-01 -name OcrLookup |Stop-Service
Get-Service -ComputerName limc-app-01 -name LIMCOCRExport |Stop-Service
Get-Service -ComputerName limc-app-01 -name LIMCListen |Stop-Service
Get-Service -ComputerName limc-app-01 -name LIMCExportSoftFile |Stop-Service
Get-Service -ComputerName limc-app-01 -name LIMCExport |Stop-Service
Get-Service -ComputerName limc-app-01 -name LIMCEmail |Stop-Service

Copy-Item "\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\LIMC Listen\LIMCListen.exe.config" "\\limc-app-01\e`$\WindowsServices\LIMC Listen\LIMCListen.exe.config" -Force


Invoke-Command -ComputerName limc-app-01 -ScriptBlock {get-wmiobject win32_service|Select Name,StartName |where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*" }}





Get-Service -ComputerName limc-app-01 -name FTPQService |Start-Service
Get-Service -ComputerName limc-app-01 -name OcrLookup |Start-Service
Get-Service -ComputerName limc-app-01 -name LIMCOCRExport |Start-Service
Get-Service -ComputerName limc-app-01 -name LIMCListen |Start-Service
Get-Service -ComputerName limc-app-01 -name LIMCExportSoftFile |Start-Service
Get-Service -ComputerName limc-app-01 -name LIMCExport |Start-Service
Get-Service -ComputerName limc-app-01 -name LIMCEmail |Start-Service


Get-Service -ComputerName limc-app-01 -name FTPQService 
Get-Service -ComputerName limc-app-01 -name OcrLookup 
Get-Service -ComputerName limc-app-01 -name LIMCOCRExport 
Get-Service -ComputerName limc-app-01 -name LIMCListen 
Get-Service -ComputerName limc-app-01 -name LIMCExportSoftFile 
Get-Service -ComputerName limc-app-01 -name LIMCExport
Get-Service -ComputerName limc-app-01 -name LIMCEmail 