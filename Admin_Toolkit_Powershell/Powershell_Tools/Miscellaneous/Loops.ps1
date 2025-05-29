# While loop
$i = 0;
While ($i -lt 10) {
    # Do Something
    Start-DbaAgentJob -SqlInstance ALLIED-UT-DEV2   -Job DBA-SendAlerts
    $i++;

    Start-Sleep 45
}