# Import the Active Directory module
Import-Module ActiveDirectory

# Define the parameters
$groupName = "SQL_DataStore_Development_Team"
$daysInactive = 90  # Number of days to consider as inactive

# Calculate the cutoff date for inactive users
$cutoffDate = (Get-Date).AddDays(-$daysInactive)

# Get the group members
$groupMembers = Get-ADGroupMember -Identity $groupName | Where-Object { $_.objectClass -eq 'user' }

# Iterate through group members and check their last logon date
foreach ($user in $groupMembers) {
    $lastLogon = Get-ADUser -Identity $user -Properties LastLogonDate | Select-Object -ExpandProperty LastLogonDate
    if ($lastLogon -lt $cutoffDate) {
        $inactiveDays = (Get-Date) - $lastLogon
        Write-Host "User $($user.SamAccountName) is inactive for $inactiveDays days."
    }
}
