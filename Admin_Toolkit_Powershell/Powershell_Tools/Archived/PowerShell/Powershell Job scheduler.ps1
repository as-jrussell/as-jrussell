$RunAsAdmin = New-ScheduledJobOption -RunElevated
$SQLJobTrigger=New-JOBTrigger -Daily -At 5:15am
 Register-ScheduledJob –Name “SQL Agent Check” -FilePath D:\Powershell\SQLAgentCheck.ps1 –Trigger $SQLJobTrigger -ScheduledJobOption $RunAsAdmin

