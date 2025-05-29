

#region Loadassembly
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

$credential = Get-Credential

#endregion Loadassembly

#region Defineform
$Form = New-Object System.Windows.Forms.Form
$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
$statusBar = New-Object System.Windows.Forms.StatusBar
$Form.width = 250
$Form.height = 325
$Form.Text = "Manage System Service"
$Form.backcolor = "#5D8AA8"
$Form.maximumsize = New-Object System.Drawing.Size(500, 350)
$Form.startposition = "centerscreen"
$Form.KeyPreview = $True
$Form.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$Form.Close()}})
#endregion Defineform

#region statusbar
$statusBar.Name = 'statusBar'
$statusBar.DataBindings.DefaultDataSourceUpdateMode = 0
$statusBar.TabIndex = 3
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 284
$System_Drawing_Size.Height = 22
$statusBar.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 0
$System_Drawing_Point.Y = 30
$statusBar.Location = $System_Drawing_Point
$statusBar.Text = 'Ready'
$form.Controls.Add($statusBar)
#endregion statusbar

function listservice {

$statusBar.Text=("Processing the request")

if ($computer.Text -eq "")
{

[Windows.Forms.MessageBox]::Show(" Please Enter Required Field")

}

if ($computer.Text -eq "QA2")
{

$server1="UNITRAC-WH001"
$server2="UNITRAC-WH002"
$server3="UNITRAC-WH003"
$server4="UNITRAC-WH004"
$server5="UNITRAC-WH005"
$server6="UNITRAC-WH006"

$CS = $server1,$server2,$server3,$server4,$server5,$server6
Get-WmiObject win32_service -ComputerName $CS.Text -Credential $credential |where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*" } |select Name,Status,State, StartName,SystemName| Out-GridView
}

else
{

Get-WmiObject win32_service -ComputerName $computer.Text -Credential $ |where {$_.StartName -like "*@as.local" -or  $_.StartName -like "ELDREDGE_A\*" }|select Name,Status,State, StartName,SystemName  | Out-GridView

}

$statusBar.Text=("Ready")

}

function stopservice {

$statusBar.Text=("Processing the request")

$service =$service.text

if(($computer.Text -eq "") -or ($service -eq ""))

{[Windows.Forms.MessageBox]::Show(" Please Enter Required Field")}

else
{

$returnvalue = (Get-WmiObject win32_service -ComputerName $computer.Text -filter "name='$service'" -Credential $credential).stopservice() | Select-Object -Property returnvalue

if($returnvalue.returnvalue -eq "0")

{[Windows.Forms.MessageBox]::Show(" Service stopped successfully! ")}

else{[Windows.Forms.MessageBox]::Show(" Service NOT stopped successfully! ")}

}
$statusBar.Text=("Ready")
}
function startservice {

$statusBar.Text=("Processing the request")

$service =$service.text

if(($computer.Text -eq "") -or ($service -eq ""))

{[Windows.Forms.MessageBox]::Show(" Please Enter Required Field")}

else {

$returnvalue = (Get-WmiObject win32_service -ComputerName $computer.Text -filter "name='$service'" -Credential $credential).startservice() | Select-Object -Property returnvalue

if($returnvalue.returnvalue -eq "0")

{[Windows.Forms.MessageBox]::Show(" service started successfully! ")}

else{[Windows.Forms.MessageBox]::Show(" service NOT started successfully!")}

}

$statusBar.Text=("Ready")

}

function servicestatus {

$statusBar.Text=("Processing the request")

$service =$service.text

if(($computer.Text -eq "") -or ($service -eq ""))

{[Windows.Forms.MessageBox]::Show(" Please Enter Required Field")}

else
{
$status = (Get-WmiObject win32_service -ComputerName $computer.Text -filter "name='$service'" -Credential $credential).state

if($status -eq "Running")

{[Windows.Forms.MessageBox]::Show(" $service Running!")}

else{[Windows.Forms.MessageBox]::Show(" $service NOT Running!")}

}

$statusBar.Text=("Ready")

}



#region computerlabel
$computerlabel = new-object System.Windows.Forms.Label
$computerlabel.Location = new-object System.Drawing.Size(10,12)
$computerlabel.size = new-object System.Drawing.Size(60,50)
$computerlabel.Font = new-object System.Drawing.Font("Microsoft Sans Serif",8,[System.Drawing.FontStyle]::Bold)
$computerlabel.Text = "Computer"
$Form.Controls.Add($computerlabel)
#endregion computerlabel

#region Servicelabel
$servicelabel = new-object System.Windows.Forms.Label
$servicelabel.Location = new-object System.Drawing.Size(10,60)
$servicelabel.size = new-object System.Drawing.Size(50,50)
$servicelabel.Font = new-object System.Drawing.Font("Microsoft Sans Serif",8,[System.Drawing.FontStyle]::Bold)
$servicelabel.Text = "Service `nName"
$Form.Controls.Add($servicelabel)
#endregion Servicelabel

#region computertext
$computer = new-object System.Windows.Forms.TextBox
$computer.Location = new-object System.Drawing.Size(70,10)
$computer.Size = new-object System.Drawing.Size(100,20)
$Form.Controls.Add($computer)

#endregion computertext

#region servicetext
$service = new-object System.Windows.Forms.TextBox
$service.Location = new-object System.Drawing.Size(70,60)
$service.Size = new-object System.Drawing.Size(100,20)
$Form.Controls.Add($service)
#endregion servicetext

#region listbutton
$ListButton = new-object System.Windows.Forms.Button
$ListButton.Location = new-object System.Drawing.Size(50,125)
$ListButton.Size = new-object System.Drawing.Size(130,30)
$ListButton.Text = "List service"
$ListButton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 192);
$Listbutton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$Listbutton.Cursor = [System.Windows.Forms.Cursors]::Hand
$ListButton.Add_Click({listservice})
#endregion listbutton

#region Stopbutton
$StopButton = new-object System.Windows.Forms.Button
$StopButton.Location = new-object System.Drawing.Size(50,163)
$StopButton.Size = new-object System.Drawing.Size(130,30)
$StopButton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 192);
$StopButton.Text = "Stop Service"
$StopButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$StopButton.Cursor = [System.Windows.Forms.Cursors]::Hand
$StopButton.Add_Click({stopservice})
#endregion stopbutton

#region Startbutton
$StartButton = new-object System.Windows.Forms.Button
$StartButton.Location = new-object System.Drawing.Size(50,200)
$StartButton.Size = new-object System.Drawing.Size(130,30)
$StartButton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 192);
$StartButton.Text = "Start Service"
$StartButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$StartButton.Cursor = [System.Windows.Forms.Cursors]::Hand
$StartButton.Add_Click({startservice})
#endregion startbutton

#region Statusbutton
$StatusButton = new-object System.Windows.Forms.Button
$StatusButton.Location = new-object System.Drawing.Size(50,237)
$StatusButton.Size = new-object System.Drawing.Size(130,30)
$StatusButton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 192);
$StatusButton.Text = "Service Status"
$StatusButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$StatusButton.Cursor = [System.Windows.Forms.Cursors]::Hand
$StatusButton.Add_Click({servicestatus})
#endregion StatusButton

#region Formadd
$Form.Controls.Add($StopButton)
$Form.Controls.Add($StartButton)
$Form.Controls.Add($StatusButton)
$Form.Controls.Add($ListButton)
#endregion Formadd

#region Activateform
$Form.Add_Shown({$Form.Activate()})
$Form.ShowDialog()
#endregion Activeform