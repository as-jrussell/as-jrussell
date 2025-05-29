# Import the Active Directory module
Import-Module ActiveDirectory

# Define the common part of the group names
$groupNamePattern = "SQL_*"  # Use * as a wildcard to match any characters after the common part

# Specify the output file path
$outputFilePath = "C:\Users\jrussell\Downloads\File.txt"

# Initialize an array to store the output
$output = @()

# Get all groups that match the pattern
$matchingGroups = Get-ADGroup -Filter { Name -like $groupNamePattern }

# Iterate through matching groups
foreach ($group in $matchingGroups) {
    $groupOutput = "Checking group: $($group.Name)"
    $output += $groupOutput
    
    # Get the group members
    $groupMembers = Get-ADGroupMember -Identity $group | Where-Object { $_.objectClass -eq 'user' }

    # Iterate through group members and check if they are disabled
    foreach ($user in $groupMembers) {
        $userObj = Get-ADUser -Identity $user
        if ($userObj.Enabled -eq $false) {
            $userOutput = "User $($userObj.SamAccountName) is disabled in group $($group.Name)."
            $output += $userOutput
        }
    }
    
    $output += "Done checking group: $($group.Name)"
    $output += ""  # Add an empty line between groups
}

# Export the output to the specified file
$output | Out-File -FilePath $outputFilePath -Encoding UTF8

Write-Host "Output exported to: $outputFilePath"
