$ExcelPath = '\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_LINQPad\PolicyEndorsements\PolicyEndorsement.xlsx'
$excel = New-Object -ComObject Excel.Application -Verbose
$excel.Visible = $true
$workbook = $excel.Workbooks.Open($ExcelPath)
$workbook.ActiveSheet.Cells.Item(1,7) = 'CODE_TX'
$excel.DisplayAlerts = $false
$workbook.SaveAs($ExcelPath)
$workbook.Close($false) 
$excel.Quit()
