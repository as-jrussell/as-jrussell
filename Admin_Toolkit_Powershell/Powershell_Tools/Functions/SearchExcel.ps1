Function Search-Excel {
    [cmdletbinding()]
    Param (
        [parameter(Mandatory)]
        [ValidateScript({
            Try {
                If (Test-Path -Path $_) {$True}
                Else {Throw "$($_) is not a valid path!"}
            }
            Catch {
                Throw $_
            }
        })]
        [string]$Source,
        [parameter(Mandatory)]
        [string]$SearchText
        #You can specify wildcard characters (*, ?)
    )
    $Excel = New-Object -ComObject Excel.Application
    Try {
        $Source = Convert-Path $Source
    }
    Catch {
        Write-Warning "Unable locate full path of $($Source)"
        BREAK
    }
    $Workbook = $Excel.Workbooks.Open($Source)
    ForEach ($Worksheet in @($Workbook.Sheets)) {
        # Find Method https://msdn.microsoft.com/en-us/vba/excel-vba/articles/range-find-method-excel
        $Found = $WorkSheet.Cells.Find($SearchText) #What
        If ($Found) {
            # Address Method https://msdn.microsoft.com/en-us/vba/excel-vba/articles/range-address-property-excel
            $BeginAddress = $Found.Address(0,0,1,1)
            #Initial Found Cell
            [pscustomobject]@{
                WorkSheet = $Worksheet.Name
                Column = $Found.Column
                Row =$Found.Row
                Text = $Found.Text
                Address = $BeginAddress
            }
            Do {
                $Found = $WorkSheet.Cells.FindNext($Found)
                $Address = $Found.Address(0,0,1,1)
                If ($Address -eq $BeginAddress) {
                    BREAK
                }
                [pscustomobject]@{
                    WorkSheet = $Worksheet.Name
                    Column = $Found.Column
                    Row =$Found.Row
                    Text = $Found.Text
                    Address = $Address
                }                 
            } Until ($False)
        }
        Else {
            Write-Warning "[$($WorkSheet.Name)] Nothing Found!"
        }
    }
    $workbook.close($false)
    [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$excel)
    [gc]::Collect()
    [gc]::WaitForPendingFinalizers()
    Remove-Variable excel -ErrorAction SilentlyContinue
}