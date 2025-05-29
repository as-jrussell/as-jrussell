



 

# Replace 'GroupName' with the name of the AD group you want to query
$groupName = 'SQL_OCR_ADMIN_TOOL'

# Retrieve members of the AD group
$groupMembers = Get-ADGroupMember -Identity $groupName

# Display members' details
$groupMembers | Select-Object   @{Name='Username'; Expression={$groupName}}, SamAccountName, Name, ObjectClass

#Get-ADGroup -Filter "Name -like 'SQL_*'"| select  Name |  Export-CSV -Path C:\Users\jrussell\Downloads\groups.csv