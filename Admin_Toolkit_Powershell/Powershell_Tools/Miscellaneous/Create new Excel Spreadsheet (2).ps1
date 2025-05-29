# create new Excel file
$excel = New-Object -ComObject Excel.Application 
$excel.Visible = $true
$workbook = $excel.Workbooks.Add()
$workbook.ActiveSheet.Cells.Item(1,7) = 'CODE_TX'
$ExcelPath = "C:\temp2\jc.xlsx"
$workbook.SaveAs($ExcelPath)
$workbook.Close($false)
$excel.Quit()

# show new file in Explorer
explorer "/select,$ExcelPath"