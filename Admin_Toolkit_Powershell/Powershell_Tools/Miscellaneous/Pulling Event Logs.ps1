
Write-Output "What is the server?`n"
$Server = Read-Host -Prompt  "(enter uses the default of 'UTPROD-API-01')"
if( [string]::IsNullOrEmpty($Server)){
   $Server = "UTPROD-API-01"
   }



Write-Output "What are the Windows Logs you are looking for ?`n"
$Logs = Read-Host -Prompt  "(Application, Security, System, Setup)"
if( [string]::IsNullOrEmpty($Logs)){
   $Logs = "Application"
   }


   
Write-Output "What are the EntryType ?`n"
$EntryType = Read-Host -Prompt  "(Error,FailureAudit,Information,SuccessAudit,Warning)"
if( [string]::IsNullOrEmpty($EntryType)){
   $EntryType = "Application"
   }



Write-Output "What is the starting date ?`n"
$Date2 = Read-Host -Prompt  "(7/18/2020 or 7/18/2020 12:00:00 AM)"
if( [string]::IsNullOrEmpty($Date2)){
   $Date2 = Get-Date -Format "dddd MM/dd/yyyy HH:mm"
   }

Write-Output "What is the ending date ?`n"
$Date1 = Read-Host -Prompt  "(7/18/2020 or 7/18/2020 12:00:00 AM)"
if( [string]::IsNullOrEmpty($Date1)){
   $Date1 = Get-Date -Format "dddd MM/dd/yyyy HH:mm"
   }

  

 Get-EventLog -ComputerName	$Server -LogName $Logs -EntryType $EntryType  -Before "$Date1" -After "$Date2" |  Out-GridView -Title "Event Logs"