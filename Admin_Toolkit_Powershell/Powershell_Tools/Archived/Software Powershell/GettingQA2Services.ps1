$Service = (
"UTQA2-APP1",
"UTQA2-APP2",
"UTQA2-APP3",
"UTQA2-APP4",
"UTQA2-ASR1",
"UTQA2-ASR2",
"UTQA2-ASR3"
)



get-wmiobject win32_service -comp $Service | Select Name, State, SystemName, StartName | where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"} | sort-object status  | Export-Csv -path "C:\temp\QA2WindowServices.csv"
