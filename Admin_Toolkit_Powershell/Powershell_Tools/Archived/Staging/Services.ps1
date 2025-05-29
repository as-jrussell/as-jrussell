

$server1="UT-STGAPP-02"
$server2="UTSTAGE-APP3"
$server2="UTSTAGE-APP2"
$server3="UTSTAGE-APP4"
$server4="UTSTAGE-ASR1"
$server5="UTSTAGE-ASR2"
$server6="UTSTAGE-ASR3"
$server7="UT-STAGEWEB-1"

$Environment = $server1,$server2,$server3,$server4,$server5,$server6, $server7
  Get-CimInstance -Class Win32_ComputerSystem -ComputerName $Environment |
  Select-Object PSComputerName, @{Name="Memory"; Expression={[math]::Round($_.TotalPhysicalMemory/1GB)}}|Out-GridView

