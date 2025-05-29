$ADUser = "jrussell"
Get-ADPrincipalGroupMembership -identity $ADUser | Select Name





Get-ADGroupMember -Identity "UniTrac Allied Development Team"|select name




# While loop
$i = 0;
While ($i -lt 10) {
    # Do Something
    Start-DbaAgentJob -SqlInstance UTQA-SQL-14   -Job DBA-SendAlerts
    $i++;

    Start-Sleep 45
}

