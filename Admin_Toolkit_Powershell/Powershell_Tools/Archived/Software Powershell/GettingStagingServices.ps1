$Service = (
"ut-stgapp-02",
"UTSTAGE-APP2",
"UTSTAGE-APP3",
"UTSTAGE-APP4",
"UTSTAGE-ASR1",
"UTSTAGE-ASR2",
"UTSTAGE-ASR3"
)



get-wmiobject win32_service -comp $Service | Select Name, State, SystemName, StartName | where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"} | sort-object status  | Export-Csv -path "C:\temp\StageWindowSer.csv"
