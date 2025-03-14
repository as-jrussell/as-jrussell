$Service = (
"Unitrac-APP01",
"Unitrac-APP02",
"Unitrac-WH01",
"Unitrac-WH03",
"Unitrac-WH04",
"Unitrac-WH05",
"Unitrac-WH06",
"Unitrac-WH07",
"Unitrac-WH08",
"Unitrac-WH09",
"Unitrac-WH10",
"Unitrac-WH11",
"Unitrac-WH12",
"Unitrac-WH13",
"Unitrac-WH14",
"Unitrac-WH16",
"Unitrac-WH18",
"Unitrac-WH19",
"Unitrac-WH20",
"Unitrac-WH21",
"Unitrac-WH22",
"Unitrac-WH23",
"utprod-asr1.colo.as.local",
"utprod-asr2.colo.as.local",
"utprod-asr3.colo.as.local",
"utprod-asr4.colo.as.local",
"utprod-asr5.colo.as.local",
"utprod-asr6.colo.as.local",
"utprod-asr7.colo.as.local",
"utprod-asr8.colo.as.local",
"UTPROD-UTLAPP-1"
)



get-wmiobject win32_service -comp $Service | Select Name, State, SystemName, StartName | where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"} | sort-object status  | Export-Csv -path "C:\temp\production\Unitrac-Production_Service.csv"
