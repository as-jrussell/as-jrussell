
#Logged on users
$server1 = Get-Content "C:\Downloads\DBServers.txt"
Get-RemoteRdpSession -computername $server1 | Out-File -FilePath "C:\Downloads\UnitracUsers.txt"






#Distonnecting users that are not active 
$server1 = Get-Content "C:\Downloads\DBServers.txt"
#Get a list of all RDP disconnected session 
$RDPDiscSessions = Get-RemoteRdpSession -computername $server1 -state Disc 
#and then disconnect each of them one by one             
foreach ($row in $RDPDiscSessions){
    Write-Progress -Activity "Logging Off all RDP Disc Sessions" -Status "Logging OFF $($row.Item("USERNAME")) from $($row.Item("COMPUTERNAME"))" 
    logoff $($row.Item("ID")) /server:$( $row.Item("COMPUTERNAME")) | Out-File -FilePath "C:\Downloads\UnitracUsers.txt"
} 