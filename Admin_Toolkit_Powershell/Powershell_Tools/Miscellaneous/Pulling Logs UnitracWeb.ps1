
Write-Output "What is the server?`n"
$answer = Read-Host -Prompt  "(enter either UTPROD-WEB-1, UT-QAWEB-1, UT-STAGEWEB-1)"
if( [string]::IsNullOrEmpty($answer)){
   $answer = "UTPROD-WEB-1"
   }


if ($answer -eq "UTPROD-WEB-1") {$path = Remove-Item "\\usd-rd001\e$\EscrowWebFiles\PROD\" -Recurse -Force}
elseif ($answer -eq "UT-STAGEWEB-1") {$path = Remove-Item "\\usd-rd001\e$\EscrowWebFiles\Stage\" -Recurse -Force}
elseif  ($answer -eq "UT-QAWEB-1") {$path = Remove-Item "\\usd-rd001\e$\EscrowWebFiles\QA2\WorkflowUI" -Recurse -Force}
else {$path ="Error"}




if ($answer -eq "UTPROD-WEB-1")  {Copy-Item "\\UTPROD-WEB-1\e$\inetpub\UnitracWeb\EscrowUI\logs" "\\usd-rd001\e$\EscrowWebFiles\PROD\EscrowUI\" -Recurse
Copy-Item "\\UTPROD-WEB-1\e$\inetpub\UnitracWeb\UniTracWeb\logs" "\\usd-rd001\e$\EscrowWebFiles\PROD\UniTracWeb\" -Recurse
Copy-Item "\\UTPROD-WEB-1\e$\inetpub\UnitracWeb\WorkflowUI\logs" "\\usd-rd001\e$\EscrowWebFiles\PROD\WorkflowUI" -Recurse}

elseif ($answer -eq "UT-STAGEWEB-1") {Copy-Item "\\UT-STAGEWEB-1\e$\inetpub\UnitracWeb\EscrowUI\logs" "\\usd-rd001\e$\EscrowWebFiles\Stage\EscrowUI\" -Recurse
Copy-Item "\\UT-STAGEWEB-1\e$\inetpub\UnitracWeb\UniTracWeb\logs" "\\usd-rd001\e$\EscrowWebFiles\Stage\UniTracWeb\" -Recurse
Copy-Item "\\UT-STAGEWEB-1\e$\inetpub\UnitracWeb\WorkflowUI\logs" "\\usd-rd001\e$\EscrowWebFiles\Stage\WorkflowUI" -Recurse}

elseif  ($answer -eq "UT-QAWEB-1") {Copy-Item "\\UT-QAWEB-1\e$\inetpub\UnitracWeb\EscrowUI\logs" "\\usd-rd001\e$\EscrowWebFiles\QA2\EscrowUI\" -Recurse
Copy-Item "\\UT-QAWEB-1\e$\inetpub\UnitracWeb\UniTracWeb\logs" "\\usd-rd001\e$\EscrowWebFiles\QA2\UniTracWeb\" -Recurse
Copy-Item "\\UT-QAWEB-1\e$\inetpub\UnitracWeb\WorkflowUI\logs" "\\usd-rd001\e$\EscrowWebFiles\QA2\WorkflowUI" -Recurse}

else {'No files were copied'}

Clear-Host

if ($answer -eq "UTPROD-WEB-1") {$path = "\\usd-rd001\e$\EscrowWebFiles\PROD\"}
elseif ($answer -eq "UT-STAGEWEB-1") {$path ="\\usd-rd001\e$\EscrowWebFiles\Stage\"}
elseif  ($answer -eq "UT-QAWEB-1") {$path ="\\usd-rd001\e$\EscrowWebFiles\QA2\WorkflowUI"}
else {$path ="Error"}





Write-Output  "Files are located here:"  $path





