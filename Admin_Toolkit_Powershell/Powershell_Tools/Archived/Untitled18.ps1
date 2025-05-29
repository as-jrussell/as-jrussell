Add-Type -AssemblyName System.Windows.Forms
 
Function MakeForm{
$Global:Option1 = Get-Service	 -ComputerName	UTQA2-APP2	"*LDHServiceUSD*"
$Global:Option2 = get-service "*XboxNetApiSvc*"
$Global:Option3 = get-service "*XblAuthManager*"
 
$Global:Option1Txt=$Global:Option1.Displayname
$Global:Option2Txt=$Global:Option2.Displayname
$Global:Option3Txt=$Global:Option3.Displayname
}
 
Function ServiceAdminForm {
    $Form.Close()
    $Form.Dispose()
    MakeForm
}
 
Function Option1 {
if ($Global:Option1.Status -eq "Running"){ Stop-Service $Global:Option1
}
else {Start-Service $Global:Option1}
}
 
Function Option2 {
if ($Global:Option2.Status -eq "Running"){ Stop-Service $Global:Option2
}
else {Start-Service $Global:Option2}
}
 
Function Option3 {
if ($Global:Option3.Status -eq "Running"){ Stop-Service $Global:Option3
}
else {Start-Service $Global:Option3}
}
 
Function Toggle {
if ($Global:Option1.Status -eq "Running") {$Global:Option1.stop();}Else{$Global:Option1.start();}
if ($Global:Option2.Status -eq "Running") {$Global:Option2.stop();}Else{$Global:Option2.start();}
if ($Global:Option3.Status -eq "Running") {$Global:Option3.stop();}Else{$Global:Option3.start();}
}
 
Function MakeForm {
Param
 
    $script:Form = New-Object system.Windows.Forms.Form
    $Form.Text = "Service Administration"
    $Font = New-Object System.Drawing.Font("Times New Roman",12,[System.Drawing.FontStyle]::Bold)
    $Form.Font = $Font
 
    #Label for Option1
    $Global:Option1lbl = New-Object system.windows.Forms.Label
    $Global:Option1lbl.Text = $Global:Option1.Status
    $Global:Option1lbl.AutoSize = $true
    $Global:Option1lbl.Width = 25
    $Global:Option1lbl.Height = 10
    $Global:Option1lbl.location = new-object system.drawing.point(5,90)
 
    #Label for Option2
    $Global:Option2lbl = New-Object system.windows.Forms.Label
    $Global:Option2lbl.Text = $Global:Option2.Status
    $Global:Option2lbl.AutoSize = $true
    $Global:Option2lbl.Width = 25
    $Global:Option2lbl.Height = 10
    $Global:Option2lbl.location = new-object system.drawing.point(5,150)
 
    #Label for Option3
    $Global:Option3lbl = New-Object system.windows.Forms.Label
    $Global:Option3lbl.Text = $Global:Option3.Status
    $Global:Option3lbl.AutoSize = $true
    $Global:Option3lbl.Width = 25
    $Global:Option3lbl.Height = 10
    $Global:Option3lbl.location = new-object system.drawing.point(5,210)
 
    #Refresh/Reload
    $Reloadbtn = New-Object System.Windows.Forms.Button
    $Reloadbtn.Location = New-Object System.Drawing.Size(5,10)
    $Reloadbtn.AutoSize = $true
    $Reloadbtn.Text = "Reload"
    $Reloadbtn.Add_Click({ServiceAdminForm})
     
    #Toggle
    $Togglebtn = New-Object System.Windows.Forms.Button
    $Togglebtn.Location = New-Object System.Drawing.Size(80,10)
    $Togglebtn.AutoSize = $true
    $Togglebtn.Text = "Toggle"
    $Togglebtn.Add_Click({Toggle})
 
    #Button Option1
    $Global:Option1btn = New-Object System.Windows.Forms.Button
    $Global:Option1btn.Location = New-Object System.Drawing.Size(5,60)
    $Global:Option1btn.AutoSize = $true
    $Global:Option1btn.Text = "$Global:Option1Txt"
    $Global:Option1btn.Add_Click({Option1})
 
    #Button Option2
    $Global:Option2btn = New-Object System.Windows.Forms.Button
    $Global:Option2btn.Location = New-Object System.Drawing.Size(5,120)
    $Global:Option2btn.AutoSize = $true
    $Global:Option2btn.Text = "$Global:Option2Txt"
    $Global:Option2btn.Add_Click({Option2})
 
    #Button Option3
    $Global:Option3btn = New-Object System.Windows.Forms.Button
    $Global:Option3btn.Location = New-Object System.Drawing.Size(5,180)
    $Global:Option3btn.AutoSize = $true
    $Global:Option3btn.Text = "$Global:Option3Txt"
    $Global:Option3btn.Add_Click({Option3})
 
    #Form Controls
    $Form.Controls.Add($Global:Option1lbl)
    $Form.Controls.Add($Global:Option2lbl)
    $Form.Controls.Add($Global:Option3lbl)
    $Form.Controls.Add($Reloadbtn)
    $Form.Controls.Add($Togglebtn)
    $Form.Controls.Add($Global:Option1btn)
    $Form.Controls.Add($Global:Option2btn)
    $Form.Controls.Add($Global:Option3btn)
    $Form.ShowDialog()
}
MakeForm