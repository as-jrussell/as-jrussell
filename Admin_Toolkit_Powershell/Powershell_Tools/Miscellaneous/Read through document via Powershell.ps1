$deployLogDestination = "C:\Users\jrussell\Downloads\RPAFilesProd"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Start-Transcript -Path $deployLogDestination



Select-String -Path '\\MSP-DFS-01\InformationTechnology\UniTrac_Master_Configs\Prod\*\*.exe.config' -Pattern "RPAService.WriteUrl"



Select-String -Path '\\MSP-DFS-01\InformationTechnology\UniTrac_Master_Configs\Prod\API\*\*.exe.config' -Pattern "RPAService.WriteUrl"


Stop-Transcript