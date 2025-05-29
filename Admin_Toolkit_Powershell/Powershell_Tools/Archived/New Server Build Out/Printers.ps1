$OldComputer = "Unitrac-PRT"
$NewComputer = "CMLLPF0X5EHP"

$OldComputerPrinters = Get-Printer -ComputerName $OldComputer

foreach($Printer in $OldComputerPrinters)
{
    $PrinterName   = $Printer.Name
    $PrinterDriver = $Printer.DriverName
    $PrinterPort   = $Printer.PortName

    Add-Printer -Name $PrinterName -DriverName $PrinterDriver -PortName $PrinterPort -ComputerName $NewComputer -ErrorAction SilentlyContinue
}