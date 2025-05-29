
# Get all groups with names matching the pattern "SQL_*_SASS"
$groups = Get-ADGroup -Filter {Name -like 'SQL_*SSAS'}

# Display group names
foreach ($group in $groups) {
    Write-Host $group.Name
}





# Per User

Get-ADUser -Filter {Name -like '*Ekins*'} |Select Name, SamAccountName