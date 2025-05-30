$Service = (
"Unitrac-WH001",
"Unitrac-WH002",
"Unitrac-WH003",
"Unitrac-WH004",
"Unitrac-WH005",
"Unitrac-WH006",
"Unitrac-WH007",
"Unitrac-WH008",
"Unitrac-WH009",
"Unitrac-WH010",
"Unitrac-WH011",
"Unitrac-WH012",
"Unitrac-WH013",
"Unitrac-WH014",
"Unitrac-WH015",
"Unitrac-WH016",
"Unitrac-WH017",
"Unitrac-WH018",
"utprod-asr1.colo.as.local",
"utprod-asr2.colo.as.local",
"utprod-asr3.colo.as.local",
"utprod-asr4.colo.as.local",
"utprod-asr5.colo.as.local",
"utprod-asr6.colo.as.local",
"utprod-asr7.colo.as.local",
"utprod-asr8.colo.as.local",
"utprod-asr9.colo.as.local",
"UTPROD-UTLAPP-1"
)



get-wmiobject win32_service -comp $Service | Select Name, State, SystemName, StartName | where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"} | Where {$_.StartMode -inotlike "Disabled"}| sort-object status  | Export-Csv -path "C:\temp\Unitrac-Production_Service.csv"
