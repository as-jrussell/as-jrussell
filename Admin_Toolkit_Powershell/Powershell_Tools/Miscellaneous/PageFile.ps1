 $ComputerName = 'GP-DB-01'
 
 
 
  Get-CimInstance -Class Win32_ComputerSystem -ComputerName $ComputerName  |
  Select-Object PSComputerName, @{Name="Memory"; Expression={[math]::Round($_.TotalPhysicalMemory/1GB)}},
  @{Name="PageFile"; Expression={[math]::Round($_.TotalPhysicalMemory/1GB*1.5)}}


  Start-DbaAgentJob -SqlInstance UT-SQLDEV-01 -Job DBA-HarvestDaily

  Start-DbaAgentJob -SqlInstance UT-SQLSTG-01 -Job DBA-HarvestDaily

  nslookup 172.20.50.84