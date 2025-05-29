# Define the username
$username = ''

# Get the group membership for the specified username and filter for group names like 'SQL_*SSAS'
Get-ADPrincipalGroupMembership -Identity $username | 
    Where-Object { $_.Name -like 'SQL_*' } |
    Select-Object SamAccountName, Name, @{Name='Username'; Expression={$username}}