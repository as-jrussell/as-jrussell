# Import the Active Directory module
Import-Module ActiveDirectory

# Define the common part of the group names
$groupNamePattern = "SQL_*"  # Use * as a wildcard to match any characters after the common part

# Get all groups that match the pattern
$matchingGroups = Get-ADGroup -Filter { Name -like $groupNamePattern }

# Iterate through matching groups
foreach ($group in $matchingGroups) {
    Write-Host "Checking group: $($group.Name)"
    
    # Get the group members
    $groupMembers = Get-ADGroupMember -Identity $group | Where-Object { $_.objectClass -eq 'user' }

    # Iterate through group members and check if they are disabled
    foreach ($user in $groupMembers) {
        $userObj = Get-ADUser -Identity $user
        if ($userObj.Enabled -eq $false) {
            Write-Host "User $($userObj.SamAccountName) is disabled in group $($group.Name)."
        }
    }
    
    Write-Host "Done checking group: $($group.Name)"
}
