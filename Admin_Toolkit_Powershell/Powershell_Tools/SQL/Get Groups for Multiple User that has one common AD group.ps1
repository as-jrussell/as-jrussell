# Specify the name of the AD group whose members you want to check
$adGroupName = "SQL_OCR_ADMIN_TOOL"

# Get the members of the AD group
$groupMembers = Get-ADGroupMember -Identity $adGroupName

# Loop through each group member and retrieve their group membership
foreach ($member in $groupMembers) {
    # Ensure that the member is a user (not another group or object)
    if ($member.objectClass -eq "user") {
        $username = $member.samAccountName
        Write-Host "Group memberships for $username :"
        
        # Use Get-ADPrincipalGroupMembership cmdlet to get group memberships
        $groups = Get-ADPrincipalGroupMembership -Identity $username | Select-Object -ExpandProperty Name
        
        # Filter and display only group names that start with "SQL_"
        $filteredGroups = $groups | Where-Object { $_ -like "SQL_*" }
        
    # Display the username and filtered group names
    foreach ($group in $filteredGroups) {
        Write-Host "Username: $username - Group Name: $group"}
 
    }
}
