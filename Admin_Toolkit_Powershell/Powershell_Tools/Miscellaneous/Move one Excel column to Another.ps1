$range1="A1:A300"
$range2="G1:G300"
$file1 = 'C:\temp\file\generated_codes.xlsx' 
$file2 = 'C:\temp\file\PolicyEndorsement.xlsx' 
$xl = new-object -c excel.application
$xl.displayAlerts = $false 
$wb1 = $xl.workbooks.open($file1, $null, $true) 
$wb2 = $xl.workbooks.open($file2)
$ws1 = $wb1.WorkSheets.item(1) 
$ws1.activate()  
$range = $ws1.Range($range1).Copy()

$ws2 = $wb2.Worksheets.item(1) 
$ws2.activate()
$x=$ws2.Range($range2).Select()

$ws2.Paste()  
$wb2.Save() 

$wb1.close($false) 
$wb2.close($true) 
$xl.quit()
spps -n excel