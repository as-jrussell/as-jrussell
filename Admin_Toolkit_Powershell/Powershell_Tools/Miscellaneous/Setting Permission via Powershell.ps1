Invoke-Command -ComputerName "OCR-SQLTMP-01" -ScriptBlock {$NewAcl = Get-Acl -Path "F:\"
# Set properties
$identity = "NT SERVICE\MSSQLSERVER"
$fileSystemRights = "FullControl"
$type = "Allow"
# Create new rule
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
# Apply new rule
$NewAcl.SetAccessRule($fileSystemAccessRule)
Set-Acl -Path "F:\" -AclObject $NewAcl}


Invoke-Command -ComputerName "OCR-SQLTMP-01" -ScriptBlock {$NewAcl = Get-Acl -Path "G:\"
# Set properties
$identity = "NT SERVICE\MSSQLSERVER"
$fileSystemRights = "FullControl"
$type = "Allow"
# Create new rule
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
# Apply new rule
$NewAcl.SetAccessRule($fileSystemAccessRule)
Set-Acl -Path "F:\" -AclObject $NewAcl}



Invoke-Command -ComputerName "OCR-SQLTMP-02" -ScriptBlock {$NewAcl = Get-Acl -Path "F:\"
# Set properties
$identity = "NT SERVICE\MSSQLSERVER"
$fileSystemRights = "FullControl"
$type = "Allow"
# Create new rule
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
# Apply new rule
$NewAcl.SetAccessRule($fileSystemAccessRule)
Set-Acl -Path "F:\" -AclObject $NewAcl}


Invoke-Command -ComputerName "OCR-SQLTMP-02" -ScriptBlock {$NewAcl = Get-Acl -Path "G:\"
# Set properties
$identity = "NT SERVICE\MSSQLSERVER"
$fileSystemRights = "FullControl"
$type = "Allow"
# Create new rule
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
# Apply new rule
$NewAcl.SetAccessRule($fileSystemAccessRule)
Set-Acl -Path "F:\" -AclObject $NewAcl}

Invoke-Command -ComputerName "OCR-SQLTMP-03" -ScriptBlock {$NewAcl = Get-Acl -Path "F:\"
# Set properties
$identity = "NT SERVICE\MSSQLSERVER"
$fileSystemRights = "FullControl"
$type = "Allow"
# Create new rule
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
# Apply new rule
$NewAcl.SetAccessRule($fileSystemAccessRule)
Set-Acl -Path "F:\" -AclObject $NewAcl}


Invoke-Command -ComputerName "OCR-SQLTMP-03" -ScriptBlock {$NewAcl = Get-Acl -Path "G:\"
# Set properties
$identity = "NT SERVICE\MSSQLSERVER"
$fileSystemRights = "FullControl"
$type = "Allow"
# Create new rule
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
# Apply new rule
$NewAcl.SetAccessRule($fileSystemAccessRule)
Set-Acl -Path "F:\" -AclObject $NewAcl}









Invoke-Command -ComputerName "OCR-SQLTMP-03" -ScriptBlock {$NewAcl = Get-Acl -Path "F:\SQLDATA"
# Set properties
$identity = "NT SERVICE\MSSQLSERVER"
$fileSystemRights = "FullControl"
$type = "Allow"
# Create new rule
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
# Apply new rule
$NewAcl.SetAccessRule($fileSystemAccessRule)
Set-Acl -Path "F:\SQLDATA" -AclObject $NewAcl}


Invoke-Command -ComputerName "OCR-SQLTMP-03" -ScriptBlock {$NewAcl = Get-Acl -Path "G:\SQLLOGS\"
# Set properties
$identity = "NT SERVICE\MSSQLSERVER"
$fileSystemRights = "FullControl"
$type = "Allow"
# Create new rule
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
# Apply new rule
$NewAcl.SetAccessRule($fileSystemAccessRule)
Set-Acl -Path "G:\SQLLOGS\" -AclObject $NewAcl}


Invoke-Command -ComputerName "OCR-SQLTMP-01" -ScriptBlock {New-Item -ItemType directory -Path "F:\SQLDATA\"}
Invoke-Command -ComputerName "OCR-SQLTMP-01" -ScriptBlock {New-Item -ItemType directory -Path "G:\SQLLOGS\"}

Invoke-Command -ComputerName "OCR-SQLTMP-02" -ScriptBlock {New-Item -ItemType directory -Path "F:\SQLDATA\"}
Invoke-Command -ComputerName "OCR-SQLTMP-02" -ScriptBlock {New-Item -ItemType directory -Path "G:\SQLLOGS\"}


Invoke-Command -ComputerName "OCR-SQLTMP-03" -ScriptBlock {New-Item -ItemType directory -Path "F:\SQLDATA\"}
Invoke-Command -ComputerName "OCR-SQLTMP-03" -ScriptBlock {New-Item -ItemType directory -Path "G:\SQLLOGS\"}


