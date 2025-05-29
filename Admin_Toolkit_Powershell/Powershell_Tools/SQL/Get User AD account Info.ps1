# Replace 'Username' with the actual username you want to retrieve information for
$username =''






# Retrieve user information from AD
$userInfo = Get-ADUser -Identity $username -Properties *

# Display user information
$userInfo | Select-Object SamAccountName, Name, DisplayName, Title, EmailAddress, Enabled, DistinguishedName, UserPrincipalName, LastLogonDate,Manager






