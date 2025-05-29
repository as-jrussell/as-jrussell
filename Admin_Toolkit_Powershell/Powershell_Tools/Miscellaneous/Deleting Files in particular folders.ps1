#For multiple; ensure that there is a document created for the services needed

$Path =   "C:\temp\InstallMe.txt"

Invoke-Command -ComputerName $Path -ScriptBlock { 
    Start-Process "e:\AdminAppFiles\AdaptiveLogExporter_setup.exe" -ArgumentList '/silent' -Wait
}
