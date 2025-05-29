#Stops the Service
Get-Service -ComputerName UTQA2-APP1 -Name MSGSRVEXTUSD_QA2 |Stop-Service -Force

#Deletes the Service
Invoke-Command -ComputerName UTQA2-APP1 -ScriptBlock {(Get-WmiObject Win32_Service -filter "name='MSGSRVEXTUSD_QA2'").Delete()}

#Backup the Service
Invoke-Command -ComputerName UTQA2-APP1 -ScriptBlock {Compress-Archive -Path "\\utqa2-app1\c$\Program Files\Allied Solutions\MSGSRVREXTUSD_QA2" -DestinationPath  "F:\AppBackup\MSGSRVREXTUSD_QA2"}

#Deletes the Service from the Path
Invoke-Command -ComputerName UTQA2-APP1 -ScriptBlock {Remove-Item -Path "\\utqa2-app1\c$\Program Files\Allied Solutions\MSGSRVREXTUSD_QA2" -Recurse -Force}
