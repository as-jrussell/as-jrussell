Function Get-Uptime {
Param ( [string] $ComputerName = $env:COMPUTERNAME )
$os = Get-CimInstance win32_operatingsystem -ComputerName $ComputerName -ErrorAction SilentlyContinue
 if ($os.LastBootUpTime) {
   $uptime = (Get-Date) - $os.ConvertToDateTime($os.LastBootUpTime)
   Write-Output ("Last boot: " + $os.ConvertToDateTime($os.LastBootUpTime) )
   Write-Output ("Uptime   : " + $uptime.Days + " Days " + $uptime.Hours + " Hours " + $uptime.Minutes + " Minutes" )
  }
  else {
    Write-Warning "Unable to connect to $computername"
  }
}
 
$server_names = Get-Content  "C:\temp\OCR.txt"
Foreach ($Service in $server_names){Get-Uptime -ComputerName $Service}