
$usernames = @('user1', 'user2')

# Loop through each username and retrieve group membership
foreach ($username in $usernames) {
    # Use Get-ADPrincipalGroupMembership cmdlet to get group memberships
    $groups = Get-ADPrincipalGroupMembership -Identity $username | Select-Object -ExpandProperty Name
    
    # Filter and display only group names that start with "SQL_"
    $filteredGroups = $groups | Where-Object { $_ -like "SQL_*" }
    
    # Display the username and filtered group names
    foreach ($group in $filteredGroups) {
        Write-Host "Username: $username - Group Name: $group"
    }
}
