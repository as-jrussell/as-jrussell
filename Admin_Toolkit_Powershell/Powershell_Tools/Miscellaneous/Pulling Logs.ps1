
Write-Output "What is the server?`n"
$Server = Read-Host -Prompt  "(enter uses the default of 'UTPROD-API-01')"
if( [string]::IsNullOrEmpty($Server)){
   $Server = "UTPROD-API-01"
   }



Write-Output "What is the service name?`n"
$Service = Read-Host -Prompt  "(enter uses the default of 'WorkItemService')"
if( [string]::IsNullOrEmpty($Service)){
   $Service = "WorkItemService"
   }






<#
if($Service = 'UTLBusinessService'){
Copy-Item "\\$Server\e$\Logs\Error\UTL-UBS" "C:\temp2\$Service\Error" -Recurse
Copy-Item "\\$Server\e$\Logs\Info\UTL-UBS" "C:\temp2\$Service\Error" -Recurse
Copy-Item "\\$Server\e$\Logs\Warning\UTL-UBS" "C:\temp2\$Service\Error" -Recurse}
else {Start-Sleep 5}

Copy-Item "\\$Server\e$\Logs\API-Logs\$Service" "C:\temp2\$Service\API-Logs" -Recurse


Copy-Item "\\$Server\e$\Logs\APILogs\$Service" "C:\temp2\$Service\APILogs" -Recurse
Copy-Item "\\$Server\e$\Logs\API-Logs\$Service" "\\usd-rd001\e$\EscrowWebFiles\$Service\API-Logs" -Recurse


Copy-Item "\\$Server\e$\Logs\APILogs\$Service" "\\usd-rd001\e$\EscrowWebFiles\$Service\APILogs" -Recurse

#>


Copy-Item "\\$Server\e$\Logs\Error\$Service" "\\usd-rd001\e$\ServiceLogs\$Server\$Service\Error" -Recurse


Copy-Item "\\$Server\e$\Logs\Info\$Service" "\\usd-rd001\e$\ServiceLogs\$Server\$Service\Info" -Recurse



