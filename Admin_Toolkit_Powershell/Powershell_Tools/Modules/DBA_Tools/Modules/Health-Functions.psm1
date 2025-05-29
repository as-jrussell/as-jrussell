#
# Health_Functions.psm1
#
Export-ModuleMember -Function set-DBowner



#************************
# & "DatabaseHealthReport.ps1" "AllServers.txt" 
# Author:  Kyle Neier, Perpetual Technologies, Inc.
# SQL Server Health Check
#************************
#& "D:\PSScripts\Test\Hope\DatabaseHealthReport.ps1" "D:\PSScripts\Test\Hope\TESTAllServers2.txt"
<# 
20110813 v3 Release
20110815	KEN	added legend
20110815	KEN	modified colors to use CSS classes instead of "bgcolor"
20110823 	KEN	Try/Catch around WMI to produce sev 5 for disks instead of 0
20110823 	KEN	Use WMI to collect "real" OS when PhysicalNetbios is innaccurate
20110823	KEN	Order OS and Disks in list
20110823	KEN	Eliminated Divide by Zero error because you can evidently have a 0 size partition??
20111119	KEN	Added in Mirroring exceptions and features
#>
param 
(
  [string] $ServerFile = "\\insql2\PSSCRIPTS\allservers.txt",
  [string] $DBQueryPath = "\\insql2\PSSCRIPTS\HealthReport\DatabaseHealthReport_query_HKB.sql",
  [string] $SSISJobQueryPath = "\\insql2\PSSCRIPTS\HealthReport\SSISJobHealthReport_query.sql",
  [string] $SSRSJobQueryPath = "\\insql2\PSSCRIPTS\HealthReport\SSRSJobHealthReport_query.sql",
  [string] $DBAJobQueryPath = "\\insql2\PSSCRIPTS\HealthReport\DBAJobHealthReport_query_HKB.sql",
  [string] $MDWJobQueryPath = "\\insql2\PSSCRIPTS\HealthReport\MDWJobHealthReport_query.sql",
  [string] $SMTPServer = "mail.herffjones.hj-int",
  [string] $Subject = "Client MSSQL Daily Health Report",
  [string] $From = "Utility@herffjones.com",
  [string] $To = "hkbrotherton@herffjones.com",
  [string] $DiskQueryPath = "\\insql2\PSSCRIPTS\HealthReport\DiskHealthReport_query.sql"
  
)

function SendEmail_w_Attachment
{
param(
	[string]$MailServer,
	[string]$MailSubject,
	[string]$MailFrom,
	[string]$MailTo,
	[string]$MailBody,
	[string]$MailAttachment,
	[string]$MailAttachmentName
)
	$SMTPClient = new-object system.net.mail.smtpClient $MailServer
	$Message = new-Object system.net.mail.mailmessage $MailFrom, $MailTo, $MailSubject, $MailBody
	$Message.isBodyhtml = $true
	
	if($MailAttachment.Length -gt 0)
	{
		#Get attachment string into stream - don't need to write it to a file
		$AttachByte = [System.Text.Encoding]::ASCII.GetBytes($MailAttachment)
		[reflection.assembly]::LoadWithPartialName("System.IO") | Out-Null
		$AttachStream = New-Object System.IO.MemoryStream	
		$AttachStream.Write($AttachByte, 0, $AttachByte.Length)
		$AttachStream.Seek(0, [system.Io.SeekOrigin]::Begin) | Out-Null
		$AttachObject = New-Object system.Net.Mail.Attachment($AttachStream, "$MailAttachmentName.html", "text/html")
		
		$Message.attachments.add($AttachObject)
	}
	#$smtpclient.DeliveryMethod = "PickupDirectoryFromIis"
	#$SMTPClient.PickupDirectoryLocation = "C:\Inetpub\mailroot\Pickup\"
	#$SMTPClient.EnableSSL = $true
	$SMTPClient.Send($Message)
	$Message.dispose()
}

$DBHeader = "<tr bgcolor=`"#DEDEDE`"><td>Database</td><td>Recovery<br>Model</td><td>Last<br>Full Backup</td>"+`
		"<td>Last<br>Tran Backup</td><td>Data <br>File Size(GB)</td><td>Log File<br>Size (GB)</td>"+`
		"<td>Last Successful<br>CheckDB</td><td>VLF Count</td><td>AutoClose</td><td>AutoShrink</td><td>State</td></tr>"

$JobHeader = "<tr bgcolor=`"#DEDEDE`"><td>Job Name</td><td>Job Enabled?</td><td>Execution<br>Status</td>"+`
		"<td>Duration</td><td>Execution<br>Time</td></tr>"
		
$DiskHeader = "<tr bgcolor=`"#DEDEDE`"><td>MountName</td><td>Capacity(GB)</td><td>FreeSpzce(GB)</td>"+`
		"<td>% Free</td></tr>"

$htmlstring_Server = "<tr bgcolor=#DEDEDE><th colspan=3>SQL Instance</th><th colspan=4>Jobs</TH></tr>"
$htmlstring = "<tr bgcolor=#DEDEDE><th colspan=2>SQL Instance</th></tr>"

$servers = Get-Content $ServerFile
$DBHealthCommand = [string]::join([environment]::newline, (get-content $DBQueryPath ))
$SSISJobHealthCommand = [string]::join([environment]::newline, (get-content $SSISJobQueryPath ))
$SSRSJobHealthCommand = [string]::join([environment]::newline, (get-content $SSRSJobQueryPath ))
$DBAJobHealthCommand = [string]::join([environment]::newline, (get-content $DBAJobQueryPath ))
$MDWJobHealthCommand = [string]::join([environment]::newline, (get-content $MDWJobQueryPath ))
$DiskHealthCommand = [string]::join([environment]::newline, (get-content $DiskQueryPath ))
$OSDisk = @{}

foreach ($server in $Servers)
{
	$connString = "Data Source=$server;Initial Catalog=master;Integrated Security=SSPI;Application Name=Daily Health Report from $LocalOS"
	
	$serverseverity = 0
	$dbseverity = 0
	$SSISjobseverity = 0
	$SSRSjobseverity = 0
	$DBAjobseverity = 0
	$MDWjobseverity = 0
	$diskseverity = 0
	
	$dbda = new-object System.Data.SqlClient.SqlDataAdapter ($DBHealthCommand, $connString)
	$dbda.SelectCommand.CommandTimeout = 120
	$dbdt = new-object System.Data.DataTable
	try{
		$dbda.fill($dbdt) | out-null
		}
	catch
	{
		#Set-Variable -Name $Exception -Value $_. -Scope "Script"
		$dbseverity = 5
	}
	$DBcount = 0
##### this is where SSIS job data is populated.
	$SSISjobda = new-object System.Data.SqlClient.SqlDataAdapter ($SSISJobHealthCommand, $connString)
	$SSISjobda.SelectCommand.CommandTimeout = 120
	$SSISjobdt = new-object System.Data.DataTable
	try{
		$SSISjobda.fill($SSISjobdt) | out-null
		}
	catch
	{
		#Set-Variable -Name $Exception -Value $_. -Scope "Script"
		$SSISjobseverity = 5
	}
	$SSIScount = 0
##### this is where SSRS job data is populated.
	$SSRSjobda = new-object System.Data.SqlClient.SqlDataAdapter ($SSRSJobHealthCommand, $connString)
	$SSRSjobda.SelectCommand.CommandTimeout = 120
	$SSRSjobdt = new-object System.Data.DataTable
	try{
		$SSRSjobda.fill($SSRSjobdt) | out-null
		}
	catch
	{
		#Set-Variable -Name $Exception -Value $_. -Scope "Script"
		$SSRSjobseverity = 5
	}
	$SSRScount = 0	
##### this is where DBA job data is populated.  
	$DBAjobda = new-object System.Data.SqlClient.SqlDataAdapter ($DBAJobHealthCommand, $connString)
	$DBAjobda.SelectCommand.CommandTimeout = 120
	$DBAjobdt = new-object System.Data.DataTable
	try{
		$DBAjobda.fill($DBAjobdt) | out-null
		}
	catch
	{
		#Set-Variable -Name $Exception -Value $_. -Scope "Script"
		$DBAjobseverity = 5
	}
	$DBAcount = 0
##### this is where MDW job data is populated
	$MDWjobda = new-object System.Data.SqlClient.SqlDataAdapter ($MDWJobHealthCommand, $connString)
	$MDWjobda.SelectCommand.CommandTimeout = 120
	$MDWjobdt = new-object System.Data.DataTable
	try{
		$MDWjobda.fill($MDWjobdt) | out-null
		}
	catch
	{
		#Set-Variable -Name $Exception -Value $_. -Scope "Script"
		$MDWjobseverity = 5
	}
	$MDWcount = 0
##### 	
	$diskda = new-object System.Data.SqlClient.SqlDataAdapter ($DiskHealthCommand, $connString)
	$diskda.SelectCommand.CommandTimeout = 120
	$diskdt = new-object System.Data.DataTable
	try{
		$diskda.fill($diskdt) | Out-Null
		}
	catch
	{
		#Set-Variable -Name $Exception -Value $_. -Scope "Script"
		$diskseverity = 5
	}

#####	

	if ($dbseverity -ne 5)
	{
	#Write-Output $dbdt
	$DBString = $(foreach ($row in $dbdt){`
		"<tr>"+`
		$(if($row.IsReadOnly -eq $true){
			if($row.SnapOfDB -eq ""){"<td class=snap>"+$row.DBName+"<br><span class=undertype>Read-Only</span>"}
			else {"<td class=readonly>"+$row.DBName+"<br><span class=undertype>Snapshot of "+$row.SnapOfDB+"</span>"}
		}else{if($row.MirrorRole -ne ''){"<td>"+$row.DBName+"<br><span class=undertype_bold>"+$row.MirrorRole+" of "+$row.MirrorPartner+"</span>"}
		      else{if($row.DBName -like "*prodClone*"){"<td class=snap>"+$row.DBName+"<br><span class=undertype>prodClone</span>"}
			  	   elseif($row.DBName -like "*testClone*"){"<td class=snap>"+$row.DBName+"<br><span class=undertype>testClone</span>"}
		           else{"<td>"+$row.DBName}}
		}
			)+`
		"</td><td>"+$row.RecoveryModel+`
		"</td><td "+$(If(($row.DBName -ne "tempdb" -and $row.DBName -notlike "*prodClone*" -and $row.DBName -notlike "*testClone*" -and $row.MirrorRole -ne 'MIRROR') -and ($row.LastFullBackup -lt [DateTime]::Now.AddDays(-7)) -and ($row.dbCreateDate -lt [DateTime]::Now.AddDays(-1)) -and ($row.SnapOfDB -eq "")){"class=sev5";$dbseverity=5})+">"+$row.LastFullBackup+`
		"</td><td "+$(If(($row.DBNAme -ne "tempdb" -and $row.MirrorRole -ne 'MIRROR') -and ($row.DBNAme -ne "model") -and ($row.RecoveryModel -ne "SIMPLE") -and ( ($row.LastTranBackup -lt [datetime]::Now.AddDays(-2))) -and ($row.SnapOfDB -eq "") ){"class=sev5";$dbseverity=5})+">"+$row.LastTranBackup+`
		"</td><td>"+$("{0:N2}" -f $row.DataSize)+`
		"</td><td>"+$("{0:N2}" -f $row.LogSize)+`
		"</td><td "+$(If(($row.DBName -ne "tempdb" -and $row.DBName -notlike "*prodClone*" -and $row.DBName -notlike "*testClone*" -and $row.MirrorRole -ne 'MIRROR') -and ($row.LastSuccessfulCheckDB -lt [DateTime]::Now.AddDays(-7)) -and ($row.dbCreateDate -lt [DateTime]::Now.AddDays(-1)) -and ($row.IsReadOnly -ne $true) -and ($row.SnapOfDB -eq "")){"class=sev5";$dbseverity=5})+">"+$row.LastSuccessfulCheckDB+`
		"</td><td "+$(If($row.VLFCount -gt 200){if($row.VLFCount -lt 500){"class=sev1";if($dbseverity -lt 1){$dbseverity=1}}else{"class=sev2";if(($dbseverity -lt 2) -and ($row.VLFCount -gt 500)){$dbseverity=2} }})+">"+$row.VLFCount+`
		"</td><td "+$(If($row.IsAutoClose -eq 1){"class=sev2";if($dbseverity -lt 2){$dbseverity=2}})+">"+$row.IsAutoClose+`
		"</td><td "+$(If($row.IsAutoShrink -eq 1){"class=sev3";if($dbseverity -lt 3){$dbseverity=3}})+">"+$row.IsAutoShrink+`
		"</td><td "+$(If(("SYNCHRONIZED", "ONLINE") -notcontains $row.DBState){"class=sev5";if($dbseverity -lt 5){$dbseverity=5}})+">"+$row.DBState+`
		"</td></tr>";$DBcount = $DBcount +1})

#"</td><td "+$(If(($row.DBName -ne "tempdb" -and $row.DBName -notlike "*prodClone*" -and $row.DBName -notlike "*testClone*" -and $row.MirrorRole -ne 'MIRROR') -and ($row.LastSuccessfulCheckDB -lt [DateTime]::Now.AddDays(-7)) -and ($row.IsReadOnly -ne $true) -and ($row.SnapOfDB -eq "")){"class=sev5";$dbseverity=5})+">"+$row.LastSuccessfulCheckDB+`

	$DBString = $DBHeader + $DBString + "</table></td></tr>"
	}
	else
	{
		$DBString = "</table></td></tr>"
	}
#################	
	if($SSISjobseverity -ne 5)
	{
	$SSISjobString = $(foreach($row in $SSISjobdt)`
						{ 	if($row.JobName -ne $LastJobName){$ExecutionCount = 0;$LastJobName = $row.JobName;$lastStatus = $row.RunStatus;$SSIScount = $SSIScount +1}
							else{$ExecutionCount = $ExecutionCount+1};
							if($row.RunStatus -ne $lastStatus -or $ExecutionCount -eq 0)
								{	"<tr><td>$($row.JobName)</td><td>$($row.JobEnabled)</td>"+`
									"<td "+$(if($row.RunStatus -ne 1)
												{
													if($ExecutionCount -eq 0){"class=sev5";If($SSISjobseverity -lt 5){$SSISjobseverity = 5}}
													if($ExecutionCount -eq 1){"class=sev4";If($SSISjobseverity -lt 4){$SSISjobseverity = 4}}
													if($ExecutionCount -eq 2){"class=sev3";If($SSISjobseverity -lt 5){$SSISjobseverity = 3}}
													if($ExecutionCount -eq 3){"class=sev2";If($SSISjobseverity -lt 2){$SSISjobseverity = 2}}
													if($ExecutionCount -eq 4){"class=sev1";If($SSISjobseverity -lt 1){$SSISjobseverity = 1}}
													else{"class=sev0";}#If($jobseverity -lt 0){$jobseverity = 0}}
												}
											else{"class=sev0";}#;$jobseverity=0
											)+">$($row.RunStatus_Descr)</td>"+"<td>"+$($duration = $row.DurationSeconds;
									if($duration -lt 60){"$duration seconds"}
									elseif($duration -ge 60 -and $duration -lt 3600){$("{0:N2}" -f $($duration / 60))+" minutes"}
									else{$("{0:N2}" -f $($duration / 3600))+" hours"})+"</td>"+"<td>$($row.RunDateTime)</td></tr>"
								}
							$lastStatus = $row.RunStatus
						}
					)				
	
	$SSISjobString = $JobHeader + $SSISjobString + "</table></td></tr>"
	}
	else
	{
		$SSISJobString = "</table></td></tr>"
	}
#################	
	if($SSRSjobseverity -ne 5)
	{
	$SSRSjobString = $(foreach($row in $SSRSjobdt)`
						{ 	if($row.JobName -ne $LastJobName){$ExecutionCount = 0;$LastJobName = $row.JobName;$lastStatus = $row.RunStatus;$SSRScount = $SSRScount +1}
							else{$ExecutionCount = $ExecutionCount+1};
							if($row.RunStatus -ne $lastStatus -or $ExecutionCount -eq 0)
								{	"<tr><td>$($row.JobName)</td><td>$($row.JobEnabled)</td>"+`
									"<td "+$(if($row.RunStatus -ne 1)
												{
													if($ExecutionCount -eq 0){"class=sev5";If($SSRSjobseverity -lt 5){$SSRSjobseverity = 5}}
													if($ExecutionCount -eq 1){"class=sev4";If($SSRSjobseverity -lt 4){$SSRSjobseverity = 4}}
													if($ExecutionCount -eq 2){"class=sev3";If($SSRSjobseverity -lt 5){$SSRSjobseverity = 3}}
													if($ExecutionCount -eq 3){"class=sev2";If($SSRSjobseverity -lt 2){$SSRSjobseverity = 2}}
													if($ExecutionCount -eq 4){"class=sev1";If($SSRSjobseverity -lt 1){$SSRSjobseverity = 1}}
													else{"class=sev0";}#If($jobseverity -lt 0){$jobseverity = 0}}
												}
											else{"class=sev0";}#;$jobseverity=0
											)+">$($row.RunStatus_Descr)</td>"+"<td>"+$($duration = $row.DurationSeconds;
									if($duration -lt 60){"$duration seconds"}
									elseif($duration -ge 60 -and $duration -lt 3600){$("{0:N2}" -f $($duration / 60))+" minutes"}
									else{$("{0:N2}" -f $($duration / 3600))+" hours"})+"</td>"+"<td>$($row.RunDateTime)</td></tr>"
								}
							$lastStatus = $row.RunStatus
						}
					)				
	
	$SSRSjobString = $JobHeader + $SSRSjobString + "</table></td></tr>"
	}
	else
	{
		$SSRSJobString = "</table></td></tr>"
	}
#################	
	if($DBAjobseverity -ne 5)
	{
	$DBAjobString = $(foreach($row in $DBAjobdt)`
						{ 	if($row.JobName -ne $LastJobName){$ExecutionCount = 0;$LastJobName = $row.JobName;$lastStatus = $row.RunStatus;$DBAcount = $DBAcount +1}
							else{$ExecutionCount = $ExecutionCount+1};
							if($row.RunStatus -ne $lastStatus -or $ExecutionCount -eq 0)
								{	"<tr><td>$($row.JobName)</td><td>$($row.JobEnabled)</td>"+`
									"<td "+$(if($row.RunStatus -ne 1)
												{
													if($ExecutionCount -eq 0){"class=sev5";If($DBAjobseverity -lt 5){$DBAjobseverity = 5}}
													if($ExecutionCount -eq 1){"class=sev4";If($DBAjobseverity -lt 4){$DBAjobseverity = 4}}
													if($ExecutionCount -eq 2){"class=sev3";If($DBAjobseverity -lt 5){$DBAjobseverity = 3}}
													if($ExecutionCount -eq 3){"class=sev2";If($DBAjobseverity -lt 2){$DBAjobseverity = 2}}
													if($ExecutionCount -eq 4){"class=sev1";If($DBAjobseverity -lt 1){$DBAjobseverity = 1}}
													else{"class=sev0";}#If($jobseverity -lt 0){$jobseverity = 0}}
												}
											else{"class=sev0";}#;$jobseverity=0
											)+">$($row.RunStatus_Descr)</td>"+"<td>"+$($duration = $row.DurationSeconds;
									if($duration -lt 60){"$duration seconds"}
									elseif($duration -ge 60 -and $duration -lt 3600){$("{0:N2}" -f $($duration / 60))+" minutes"}
									else{$("{0:N2}" -f $($duration / 3600))+" hours"})+"</td>"+"<td>$($row.RunDateTime)</td></tr>"
								}
							$lastStatus = $row.RunStatus
						}
					)				
	
	$DBAjobString = $JobHeader + $DBAjobString + "</table></td></tr>"
	}
	else
	{
		$DBAJobString = "</table></td></tr>"
	}
#################
	if($MDWjobseverity -ne 5)
	{
	$MDWjobString = $(foreach($row in $MDWjobdt)`
						{ 	if($row.JobName -ne $LastJobName){$ExecutionCount = 0;$LastJobName = $row.JobName;$lastStatus = $row.RunStatus;$MDWcount = $MDWcount +1}
							else{$ExecutionCount = $ExecutionCount+1};
							if($row.RunStatus -ne $lastStatus -or $ExecutionCount -eq 0)
								{	"<tr><td>$($row.JobName)</td><td>$($row.JobEnabled)</td>"+`
									"<td "+$(if($row.RunStatus -ne 1)
												{
													if($ExecutionCount -eq 0){"class=sev5";If($MDWjobseverity -lt 5){$MDWjobseverity = 5}}
													if($ExecutionCount -eq 1){"class=sev4";If($MDWjobseverity -lt 4){$MDWjobseverity = 4}}
													if($ExecutionCount -eq 2){"class=sev3";If($MDWjobseverity -lt 5){$MDWjobseverity = 3}}
													if($ExecutionCount -eq 3){"class=sev2";If($MDWjobseverity -lt 2){$MDWjobseverity = 2}}
													if($ExecutionCount -eq 4){"class=sev1";If($MDWjobseverity -lt 1){$MDWjobseverity = 1}}
													else{"class=sev0";}#If($jobseverity -lt 0){$jobseverity = 0}}
												}
											else{"class=sev0";}#;$jobseverity=0
											)+">$($row.RunStatus_Descr)</td>"+"<td>"+$($duration = $row.DurationSeconds;
									if($duration -lt 60){"$duration seconds"}
									elseif($duration -ge 60 -and $duration -lt 3600){$("{0:N2}" -f $($duration / 60))+" minutes"}
									else{$("{0:N2}" -f $($duration / 3600))+" hours"})+"</td>"+"<td>$($row.RunDateTime)</td></tr>"
								}
							$lastStatus = $row.RunStatus
						}
					)				
	$MDWjobString = $JobHeader + $MDWjobString + "</table></td></tr>"
#	IF($MDWcount -eq 0){$MDWjobseverity = 6}
	}
	else
	{
		$MDWJobString = "</table></td></tr>"
	}
	
#################

	if($diskseverity -ne 5)
	{
	
		$Volumes = @()
		
		$diskString = $DiskHeader
		
		$OS = ""
		
		foreach($row in $diskdt)
		{ 
			if($OS -eq "")
			{
				$OS = $row.HostOS
				try
				{
					$RealOS = (gwmi -ComputerName $OS -Class Win32_ComputerSystem -ErrorAction Stop)
					$OS = $RealOS.Name
				
					Get-WmiObject -ComputerName $OS -Class Win32_Volume -Filter 'DriveType = 3' -ErrorAction Stop | %{$Volumes+= $_}
					if($OSDisk.ContainsKey($OS) -eq $false)
					{
						$OSList = @()
						$Volumes | %{$OSList += $_}
						$OSDisk.Add($OS, $OSList)
					}
				}
				catch
				{
					$OSDisk.Add($OS, $null)
					$diskseverity = 5
				}
			}
			
			$ThisVolume = $($Volumes | ?{$_.Name -eq $row.SubPath})
			if($ThisVolume -ne $null)
			{
				$PctFree = ($ThisVolume.FreeSpace/$ThisVolume.Capacity)*100
				$localdiskseverity = 0
				
				if($PctFree -le 5){$localdiskseverity=5}
				if($PctFree -gt 5 -and $PctFree -le 10 -and $localdiskseverity -lt 4){$localdiskseverity=4}
				if($PctFree -gt 10 -and $PctFree -le 15 -and $localdiskseverity -lt 3){$localdiskseverity=3}
				if($PctFree -gt 15 -and $PctFree -le 20 -and $localdiskseverity -lt 2){$localdiskseverity=2}
				#if($PctFree -gt 20 -and $PctFree -le 25 -and $localdiskseverity -lt 1){$localdiskseverity=1}
				
				Write-Output $server `t $ThisVolume.Name.Trim()
#				IF($ThisVolume.Name.Trim() -notlike '*Volume{*')
#				{
					$diskString = $diskstring + "<tr class=sev$localdiskseverity><td>"+$ThisVolume.Name.Trim()+"</td><td>"+$("{0:N2}" -f ($ThisVolume.Capacity/1073741824))+"</td><td>"+$("{0:N2}" -f ($ThisVolume.FreeSpace/1073741824))+"</td><td>"+$("{0:N2}" -f ($ThisVolume.FreeSpace/$ThisVolume.Capacity*100))+"</td></tr>"		
#				}
			
				if($localdiskseverity -gt $diskseverity){$diskseverity = $localdiskseverity}
			}	
		}
		
		$diskString = $diskString + "</table></td></tr>"
	}
	else
	{
		$diskString = "</table></td></tr>"
	}
	
	
	
	$maxseverity = 0
	($dbseverity, $DBAjobseverity, $SSISjobseverity, $SSRSjobseverity, $MDWjobseverity, $diskseverity) | %{if($_ -gt $maxseverity){$maxseverity = $_}}
	
	
		
	
#		IF( ($SSISjobstring -eq $JobHeader + "</table></td></tr>") -and ($MDWjobstring -eq $JobHeader + "</table></td></tr>") )
#		{
#			$htmlstring = $htmlstring + "<tr><th class=sev"+$maxseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"');`">"+$server+"</th><td style=`"display: ;`" id = `""+$server.replace("\", "_")+"`"><table width=150>"+`
#				"<tr><th class=sev"+$dbseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"_DB');`">"+"Databases -"+$DBcount+"</th><td style=`"display: none;`" id = `""+$server.replace("\", "_")+"_DB`"><table>"+$DBstring+`
#				"<tr><th class=sev"+$DBAjobseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"_DBAJOB');`">"+"DBA Jobs -"+$DBAcount+"</th><td style=`"display: none;`" id = `""+$server.replace("\", "_")+"_DBAJOB`"><table>"+$DBAjobstring+`
#				"<tr><th class=sev"+$diskseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"_DISK');`">"+"Disk"+"</th><td style=`"display: none;`" id = `""+$server.replace("\", "_")+"_DISK`"><table>"+$diskString+"</table>"
#		}
#		elseIF ($SSISjobstring -eq $JobHeader + "</table></td></tr>")
#		{
#			$htmlstring = $htmlstring + "<tr><th class=sev"+$maxseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"');`">"+$server+"</th><td style=`"display: ;`" id = `""+$server.replace("\", "_")+"`"><table width=150>"+`
#				"<tr width=100><th class=sev"+$dbseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"_DB');`">"+"Databases -"+$DBcount+"</th><td style=`"display: none;`" id = `""+$server.replace("\", "_")+"_DB`"><table>"+$DBstring+`
#				"<tr width=100><th class=sev"+$DBAjobseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"_DBAJOB');`">"+"DBA Jobs -"+$DBAcount+"</th><td style=`"display: none;`" id = `""+$server.replace("\", "_")+"_DBAJOB`"><table>"+$DBAjobstring+`
#				"<tr width=100><th class=sev"+$MDWjobseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"_MDWJOB');`">"+"MDW Jobs -"+$MDWcount+"</th><td style=`"display: none;`" id = `""+$server.replace("\", "_")+"_MDWJOB`"><table>"+$MDWjobstring+`
#				"<tr width=100><th class=sev"+$diskseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"_DISK');`">"+"Disk"+"</th><td style=`"display: none;`" id = `""+$server.replace("\", "_")+"_DISK`"><table>"+$diskString+"</table>"
#		}
#		elseIF ($MDWjobstring -eq $JobHeader + "</table></td></tr>")
#		{
#			$htmlstring = $htmlstring + "<tr><th class=sev"+$maxseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"');`">"+$server+"</th><td style=`"display: ;`" id = `""+$server.replace("\", "_")+"`"><table width=150>"+`
#				"<tr><th class=sev"+$dbseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"_DB');`">"+"Databases -"+$DBcount+"</th><td style=`"display: none;`" id = `""+$server.replace("\", "_")+"_DB`"><table>"+$DBstring+`
#				"<tr><th class=sev"+$DBAjobseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"_DBAJOB');`">"+"DBA Jobs -"+$DBAcount+"</th><td style=`"display: none;`" id = `""+$server.replace("\", "_")+"_DBAJOB`"><table>"+$DBAjobstring+`
#				"<tr><th class=sev"+$SSISjobseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"_SSISJOB');`">"+"SSIS Jobs -"+$SSIScount+"</th><td style=`"display: none;`" id = `""+$server.replace("\", "_")+"_SSISJOB`"><table>"+$SSISjobstring+`
#				"<tr><th class=sev"+$diskseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"_DISK');`">"+"Disk"+"</th><td style=`"display: none;`" id = `""+$server.replace("\", "_")+"_DISK`"><table>"+$diskString+"</table>"
#		}
#		ELSE
#		{
			$htmlstring = $htmlstring + "<tr><th class=sev"+$maxseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"');`">"+`
				"<a href=`"http://inms192/ReportServer/Pages/ReportViewer.aspx?%2FDBA%2FPerformanceDashboard%2FReports%2Fperformance_dashboard_main_CMS&ServerName="+$server.REPLACE(",","%2C")+"&rs%3ACommand=Render`" style=`"text-decoration:none;color:black;`">"+`
				$server+"</a></th><td style=`"display: ;`" id = `""+$server.replace("\", "_")+"`"><table width=150>"+`
				"<tr><th class=sev"+$dbseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"_DB');`">"+"Databases -"+$DBcount+"</th><td style=`"display: none;`" id = `""+$server.replace("\", "_")+"_DB`"><table>"+$DBstring+`
				"<tr><th class=sev"+$diskseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"_DISK');`">"+"Disk"+"</th><td style=`"display: none;`" id = `""+$server.replace("\", "_")+"_DISK`"><table>"+$diskString+`
				"<tr><th class=sev"+$DBAjobseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"_DBAJOB');`">"+"DBA Jobs -"+$DBAcount+"</th><td style=`"display: none;`" id = `""+$server.replace("\", "_")+"_DBAJOB`"><table>"+$DBAjobstring
			IF ($SSISjobstring -ne $JobHeader + "</table></td></tr>")
			{
				$htmlstring = $htmlstring + "<tr><th class=sev"+$SSISjobseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"_SSISJOB');`">"+"SSIS Jobs -"+$SSIScount+"</th><td style=`"display: none;`" id = `""+$server.replace("\", "_")+"_SSISJOB`"><table>"+$SSISjobstring
			}
			IF ($MDWjobstring -ne $JobHeader + "</table></td></tr>")
			{
				$htmlstring = $htmlstring + "<tr><th class=sev"+$MDWjobseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"_MDWJOB');`">"+"MDW Jobs -"+$MDWcount+"</th><td style=`"display: none;`" id = `""+$server.replace("\", "_")+"_MDWJOB`"><table>"+$MDWjobstring
			}
			IF ($SSRSjobstring -ne $JobHeader + "</table></td></tr>")
			{
				$htmlstring = $htmlstring + "<tr><th class=sev"+$SSRSjobseverity+"><span onClick=`"toggle('"+$server.replace("\", "_")+"_SSRSJOB');`">"+"SSRS Jobs -"+$SSRScount+"</th><td style=`"display: none;`" id = `""+$server.replace("\", "_")+"_SSRSJOB`"><table>"+$SSRSjobstring
			}
			$htmlstring = $htmlstring +"</table>"
#		}
	
	$htmlstring_Server = $htmlstring_Server + "<tr><th class=sev"+$maxseverity+">"+$server+"</th>"+`
	"<th class=sev"+$dbseverity+">DB</th>"+`
	"<th class=sev"+$diskseverity+">DISK</th>" +
	"<th class=sev"+$DBAjobseverity+">"+$(IF($DBAcount -eq 0){"<del>"})+"DBA</th>"+`
	"<th class=sev"+$SSISjobseverity+">"+$(IF($SSIScount -eq 0){"<del>"})+"SSIS</th>"+`
	"<th class=sev"+$MDWjobseverity+">"+$(IF($MDWcount -eq 0){"<del>"})+"MDW</th>"+
	"<th class=sev"+$SSRSjobseverity+">"+$(IF($SSRScount -eq 0){"<del>"})+"SSRS</th>"+
	"</tr>"

	

}

$head = "<HTML><HEAD>
<style>
	body{font-family:Calibri; background-color:white;}
	table{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
	th{font-size:1.3em; border-width: 1px;padding: 2px;border-style: solid;border-color: black;vertical-align:text-top;}
	td{border-width: 1px;padding: 2px;border-style: solid;border-color: black;vertical-align:text-top;}
	td.sev0{background-color: #009900}
	td.sev1{background-color: #FFFF00}
	td.sev2{background-color: #FFCC00}
	td.sev3{background-color: #FF9900}
	td.sev4{background-color: #FF6600}
	td.sev5{background-color: #FF0000}
	
	th.sev0{background-color: #009900}
	th.sev1{background-color: #FFFF00}
	th.sev2{background-color: #FFCC00}
	th.sev3{background-color: #FF9900}
	th.sev4{background-color: #FF6600}
	th.sev5{background-color: #FF0000}
	th.sev6{background-color: #000000}
	
	tr.sev0{background-color: #009900}
	tr.sev1{background-color: #FFFF00}
	tr.sev2{background-color: #FFCC00}
	tr.sev3{background-color: #FF9900}
	tr.sev4{background-color: #FF6600}
	tr.sev5{background-color: #FF0000}
	
	td.snap{background-color: #9B9B9B}
	td.readonly{background-color: #3399FF}
	span.undertype{font-size:70%;font-style:italic}
	span.undertype_bold{font-size:70%;font-style:italic;font-weight:bold}

</style>
<script type=`"text/javascript`">
   function toggle(ControlID) 
   {
		var control = document.getElementById(ControlID); 
		if( control.style.display =='none' )
		{
   			control.style.display = '';
 		}
		else
		{
   			control.style.display = 'none';
 		}
	}
</script>
<TITLE>SQL Server Health Check</TITLE></HEAD>
<body><table>
"

#OS Disk Usages
	$htmlstring = $htmlstring + "</table><br><table><tr bgcolor=#DEDEDE><th colspan=2>OS</th></tr>"
	$htmlstring_Server = $htmlstring_Server + "</table><br><table><tr bgcolor=#DEDEDE><th colspan=2>OS Stats</th></tr>"
	
	foreach($OSServer in ($OSDisk.Keys | sort))
	{
		$diskString = $diskheader
		
		$diskseverity = 0
		
		if($OSDisk[$OSServer].Count -eq $null)
		{
			$diskseverity = 5
		}
		else
		{
			foreach($ThisVolume in ($OSDisk[$OSServer]| sort @{Expression='Name'; Descending=$false }))
			{
#				IF($ThisVolume -notlike '*Volume{*')
#				{
					if($ThisVolume.Capacity -gt 0)
					{
						$PctFree = ($ThisVolume.FreeSpace/$ThisVolume.Capacity)*100
					}
					else
					{
						$PctFree=100
					}
						$localdiskseverity = 0
					IF($ThisVolume.Name.Trim() -notlike '*Volume{*')
					{					
						if($PctFree -le 5){$localdiskseverity=5}
						if($PctFree -gt 5 -and $PctFree -le 10 -and $localdiskseverity -lt 4){$localdiskseverity=4}
						if($PctFree -gt 10 -and $PctFree -le 15 -and $localdiskseverity -lt 3){$localdiskseverity=3}
						if($PctFree -gt 15 -and $PctFree -le 20 -and $localdiskseverity -lt 2){$localdiskseverity=2}
						#if($PctFree -gt 20 -and $PctFree -le 25 -and $localdiskseverity -lt 1){$localdiskseverity=1}
						
						if($localdiskseverity -gt $diskseverity){$diskseverity = $localdiskseverity}
	
						$diskString = $diskstring + "<tr class=sev$localdiskseverity><td>"+$ThisVolume.Name.Trim()+"</td><td>"+$("{0:N2}" -f ($ThisVolume.Capacity/1073741824))+"</td><td>"+$("{0:N2}" -f ($ThisVolume.FreeSpace/1073741824))+"</td><td>"+$("{0:N2}" -f ($PctFree))+"</td></tr>"		
					}
#				}
			}
		}
			
		$maxseverity = 0
		($diskseverity, 0) | %{if($_ -gt $maxseverity){$maxseverity = $_}}
		
		
		$htmlstring = $htmlstring + "<tr><th class=sev$maxseverity><span onClick=`"toggle('"+$OSServer.replace("\", "_")+"_OS');`">"+$OSServer+"</th><td style=`"display: ;`" id = `""+$OSServer.replace("\", "_")+"_OS`"><table>"
		$htmlstring = $htmlstring + "<tr><th class=sev$diskseverity><span onClick=`"toggle('"+$OSServer.replace("\", "_")+"_OS_DISK');`">"+"Disk"+"</th><td style=`"display: none;`" id = `""+$OSServer.replace("\", "_")+"_OS_DISK`"><table>"+$diskString+"</table></table>"
		
		$htmlstring_server = $htmlstring_server +  "<tr><th class=sev$maxseverity>"+$OSServer+"</th>"+`
			"<th class=sev$diskseverity>DISK</th></tr>"
	}


$now = Get-Date
$foot = "</table><br>Report ran at " + $now + " from the UTILITY instance.</i></body></html>"

<#
Severity 5 (Red)
	No Full Backup within 7 days
	No t-log backup since last full or within 24 hours
	DB State <> Online
	No Successful CheckDB within 7 days
	No Rows Returned
	No Jobs returned
	Job exists Most recent job execution within 24 hours not successful
	Free Disk Space < 5%

Severity 4 (Red-Orange)
	Job exists with non-successful run within 24 hours, but most recent successful
	Free Disk Space < 10% but greater than 5%
	
Severity 3 (Orange)
	AutoShrink Enabled
	Free Disk Space < 15% but greater than 10%

Severity 2 (Yellow-Orange)
	VLFCount > 500
	AutoClose Enabled
	Free Disk Space < 20% but greater than 15%

Severity 1 (Yellow)
	VLFCount between 200 and 500
	Free Disk Space < 25% but greater than 20%

Severity 0 (Green)
#>

$legend = "
<Br>
<br>
<table><tr><td><span onClick=`"toggle('LEGEND');`">Legend</span></td><td id=`"LEGEND`" style=`"display:none ;`">
<table>
<!--Severity 5 (Red)-->
	<tr><td class=sev5>No Full Backup within 7 days</td></tr>
	<tr><td class=sev5>No t-log backup since last full or within 24 hours</td></tr>
	<tr><td class=sev5>DB State <> Online</td></tr>
	<tr><td class=sev5>DB State <> Synchronized for Mirrored databases</td></tr>
	<tr><td class=sev5>No Successful CheckDB within 7 days</td></tr>
	<tr><td class=sev5>No Rows Returned</td></tr>
	<tr><td class=sev5>No Jobs returned</td></tr>
	<tr><td class=sev5>Most recent job execution within 24 hours not successful</td></tr>
	<tr><td class=sev5>Free Disk Space < 5%</td></tr>

<!--Severity 4 (Red-Orange)-->
	<tr><td class=sev4>Job exists with non-successful run within 24 hours, but most recent successful</td></tr>
	<tr><td class=sev4>Free Disk Space < 10% but greater than 5%</td></tr>
	
<!--Severity 3 (Orange)-->
	<tr><td class=sev3>AutoShrink Enabled
	<tr><td class=sev3>Free Disk Space < 15% but greater than 10%</td></tr>

<!--Severity 2 (Yellow-Orange)-->
	<tr><td class=sev2>VLFCount > 500</td></tr>
	<tr><td class=sev2>AutoClose Enabled</td></tr>
	<tr><td class=sev2>Free Disk Space < 20% but greater than 15%</td></tr>

<!--Severity 1 (Yellow)-->
	<tr><td class=sev1>VLFCount between 200 and 500</td></tr>
	<tr><td class=sev1>Free Disk Space < 25% but greater than 20%</td></tr>

<!--Severity 0 (Green)-->
	<tr><td class=sev0>No monitored condition exists</td></tr>
</table>
</td>
</tr>
</table>
"

$htmlbody = $head+$htmlstring_server+$foot
$attachment = $head+$htmlstring+$foot+$legend

SendEmail_w_Attachment -MailBody $htmlbody -MailAttachment $attachment -MailServer $SMTPServer -MailSubject $Subject -MailFrom $From -MailTo $To -MailAttachmentName "DatabaseHealthReport"

#Save to file..


$attachment >> "\\insql2\PSSCRIPTS\health.HTML"
$insertDate = Get-Date
$attachment = $attachment.Replace("'","''")  
$myQuery = "INSERT INTO dbaAdmin.SSRS.databaseHealthReport ([xmlInfo],[loadDate]) VALUES ('"+$attachment+"','"+ $insertDate +"')"
#Write-Output $myQuery
invoke-sqlcmd -ServerInstance "insql2\UTILITY" -Query $myQuery
##Call Proxy to upload report
#$ssrsTargetUrl = "http://inms192/ReportServer/ReportService2010.asmx?WSDL"
#$ssrsTargetProxy = New-WebServiceProxy -Uri $ssrsTargetUrl -UseDefaultCredential ;
#$byteArray = gc "\\insql2\PSSCRIPTS\health.HTML" -encoding byte
#$warnings = $ssrsTargetProxy.CreateCatalogItem("Report","HealthReport","/DBA/","TRUE",$byteArray,@(),[ref]$warnings)

exit 0


