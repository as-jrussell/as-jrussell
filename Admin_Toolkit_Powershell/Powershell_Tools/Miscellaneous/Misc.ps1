


#Memory Check


(systeminfo | select-object Name| Select-String 'Total Physical Memory:').ToString().Split(':')[1].Trim()




(Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb



Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | Foreach-Object {"{0:N2}" -f ([math]::round(($_.Sum / 1GB),2))}

Foreach-Object {
  Get-CimInstance -Class Win32_ComputerSystem -ComputerName $Environment |
  Select-Object PSComputerName, @{Name="Memory"; Expression={[math]::Round($_.TotalPhysicalMemory/1GB)}}}