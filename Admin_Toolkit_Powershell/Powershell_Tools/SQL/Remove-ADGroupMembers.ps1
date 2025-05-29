param(
    [string]$group,
    [string[]]$users,
    [switch]$WhatIf
)

# Check if the Active Directory module is available
if (-not (Get-Module -Name ActiveDirectory -ErrorAction SilentlyContinue)) {
    Write-Host "Active Directory module is not available. Please install and import the module."
    exit
}

# Check if the group parameter is provided
if (-not $group) {
    Write-Host "Please provide the AD group name using -group parameter."
    exit
}

# Check if the users parameter is provided
if (-not $users) {
    Write-Host "Please provide at least one user to remove using -users parameter."
    exit
}

# Display what the script will do if -WhatIf switch is used
if ($WhatIf) {
    Write-Host "The following actions will be performed:"
}

foreach ($user in $users) {
    # Display what the script will do if -WhatIf switch is used
    if ($WhatIf) {
        Write-Host "Remove user '$user' from group '$group'"
    }
    else {
        # Remove the user from the group
        Remove-ADGroupMember -Identity $group -Members $user
        Write-Host "Removed user '$user' from group '$group'"
    }
}
