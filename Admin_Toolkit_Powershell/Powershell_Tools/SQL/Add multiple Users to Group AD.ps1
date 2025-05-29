# Replace 'GroupName' with the name of the AD group you want to add members to
$groupName = 'SQL_INFO_ReadOnly' 
        #Snowflake Data Warehouse - User
        #SQL_RFPL_SSAS

# Replace 'Member1' and 'Member2' with the usernames of the users you want to add
$membersToAdd =  'eschroeder'

# Add members to the AD group
$membersToAdd | ForEach-Object {
    Add-ADGroupMember -Identity $groupName -Members $_
}



# Retrieve members of the AD group
$groupMembers = Get-ADGroupMember -Identity $groupName


# Get the group membership for the specified username and filter for group names like 'SQL_*SSAS'
Get-ADPrincipalGroupMembership -Identity $membersToAdd | 
    Where-Object { $_.Name -like 'SQL_*' } |
    Select-Object SamAccountName,  @{Name='Username'; Expression={$membersToAdd}}