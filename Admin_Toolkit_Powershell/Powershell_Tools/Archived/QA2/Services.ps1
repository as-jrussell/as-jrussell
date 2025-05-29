

$server1="UTQA2-APP2"
$server2="UTQA2-APP3"
$server3="UTQA2-APP4"
$server4="UTQA2-ASR1"
$server5="UTQA2-ASR2"
$server6="UTQA2-ASR3"

$Environment = $server1,$server2,$server3,$server4,$server5,$server6
Get-WmiObject win32_service -ComputerName $Environment |where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*" }|where {$_.Name -inotlike "MSGSRVREXTUSD_PROD"}|where {$_.Name -inotlike "UnitracBusinessServiceRPTdual"}|where {$_.Name -inotlike "SplunkForwarder"}|
select Name,State, StartName,SystemName  | Out-GridView




