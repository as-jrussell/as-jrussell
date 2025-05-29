

[Cmdletbinding()]
Param(
    [string]$Computername = "UTPROD-ASR7"
)
cls
$PysicalMemory = Get-CimInstance -class "win32_physicalmemory" -namespace "root\CIMV2" -ComputerName $Computername



Write-Host "Total Memory:" -ForegroundColor Green
Write-Host "$((($PysicalMemory).Capacity | Measure-Object -Sum).Sum/1GB)GB"



If($UsedSlots -eq $TotalSlots)
{
    Write-Host "All memory slots are filled up, none is empty!" -ForegroundColor Yellow
}
