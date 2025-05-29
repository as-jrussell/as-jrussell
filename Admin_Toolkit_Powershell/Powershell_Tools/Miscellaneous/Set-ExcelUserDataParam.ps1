

Param(
   $path = "C:\temp\file\PolicyEndorsement.xlsx",
   $worksheet1 = “Codes”,
   $range1 = “A1:B1”, 
   $worksheet2 = "NatGen",
   $range2 = “G1”
   ) #end param
$Excel = New-Object -ComObject excel.application
$Excel.visible = $false
$Workbook = $excel.Workbooks.open($path)
$Worksheet = $Workbook.WorkSheets.item($worksheet1)
$worksheet.activate() 
$range = $WorkSheet.Range($range1).EntireColumn
$range.Copy() | out-null
$Worksheet = $Workbook.Worksheets.item($worksheet2)
$Range = $Worksheet.Range($range2)
$Worksheet.Paste($range) 
$workbook.Save() 
$Excel.Quit()
Remove-Variable -Name excel
[gc]::collect()
[gc]::WaitForPendingFinalizers()