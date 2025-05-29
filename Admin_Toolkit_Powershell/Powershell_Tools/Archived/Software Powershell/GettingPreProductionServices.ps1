$Service = (
"UTPreProd-APP01"
)



get-wmiobject win32_service -comp $Service | Select Name, State, SystemName, StartName | where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*"} | sort-object status  | Export-Csv -path "C:\temp\PreProdWindowServices.csv"
