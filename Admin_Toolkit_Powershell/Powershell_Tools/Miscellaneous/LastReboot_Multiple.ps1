


$ErrorActionPreference = 'SilentlyContinue' 
$FormatEnumerationLimit =-1

$AG1 = 'OCR-SQLPRD-07'
$AG2 = 'OCR-SQLPRD-08'
$AG3 = 'OCR-SQLPRD-09'
#$Server = 'OCR-SQLTMP-01'

$serverList = $AG1, $AG2, $AG3 


Foreach ($Server in $serverList){
 Get-CimInstance -ComputerName $server -ClassName win32_operatingsystem | select csname, lastbootuptime}






