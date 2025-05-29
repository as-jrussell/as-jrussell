
# Import the Active Directory module
Import-Module ActiveDirectory

# Define an array of group names
$groupNames = @('SQL_Analytics_Development_Team',
'SQL_Analytics_ReadOnly')


# Iterate through each group
foreach ($groupName in $groupNames) {
    Write-Host "Checking group: $groupName"
    
    # Get the group members
    $groupMembers = Get-ADGroupMember -Identity $groupName | Where-Object { $_.objectClass -eq 'user' }

    # Iterate through group members and check if they are disabled
    foreach ($user in $groupMembers) {
        $userObj = Get-ADUser -Identity $user
        if ($userObj.Enabled -eq $false) {
            Write-Host "User $($userObj.SamAccountName) is disabled in group $groupName."
        }
    }
    
    Write-Host "Done checking group: $groupName"
}