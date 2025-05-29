<#

_checkErrorLogs.ps1
Description:
Author: Jim Breffni.
This script displays the errorlog entries for all selected servers for the last n days.
The script can take a few minutes to run if the error logs are large and you are looking back over several days.

Requirements:
Module invokesqlquery needs to be installed.
1.  Invokesqlquery can be downloaded from http://powershell4sql.codeplex.com/

#>

cls
import-module D:\POWERSHELL\MODULES\invokesqlquery

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null;


#let's get our list of servers. For this, create a .txt files with all the server names you want to check.
$sqlservers = Get-Content "D:\Powershell\SQLServer.txt";

#we'll get the long date and toss that in a variable
$datefull = Get-Date
 
$today    = (get-date).toString()
$all      = @()
$lookback = ((get-date).adddays(-1)).ToString()  #  look back n days from current time

#  Load up the list of servers to check

#let's set up the email stuff
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient("10.11.1.147")
$msg.Body = “Here is a list of Errors in the Logs for $today (the last 24 hours)”


#here, we will begin with a foreach loop. We'll be checking all servers in the .txt referenced above.
foreach($sqlserver in $sqlservers)

{
    #here we need to set which server we are going to check in this loop
    $srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $sqlserver;
          
       TRY
        {
           $Query = invoke-sqlquery -query "EXEC master..xp_readerrorlog 0, 1, null, null,'$Lookback','$today' " -server $srv.name | select-object @{Name="Server"; Expression={$srv.name}}, LogDate, ProcessInfo, Text | `
                     where-object {$_.Text -match 'error|fail|warn|kill|dead|cannot|could|stop|terminate|bypass|roll|truncate|upgrade|victim|recover'} | `
                     where-object {$_.Text -notmatch 'setting database option recovery to|DBCC CHECKDB|CLIENT: 10.10.18.162'} |`
                     Where-Object {$_.Text -notlike 'Logging SQL Server messages in file'}
                    
        }
        catch {$Query="Unable to read SQL error log from server $srv"}
   
        IF ($query.Text)   
        {
            IF ($query.Text -notlike 'Logging SQL Server messages in file')  
             {
             $results=@($query.Logdate+','+ $Query.text )
                                #now we add the job info to our email body. use `n for a new line
                			    $msg.body   = $msg.body + "`n `n SQL LOG ERROR INFO: 
  SERVER = $srv 
  ERRORS IN SQL LOG = $results"
                }
    
}  
}


#once all that loops through and builds our $msg.body, we are read to send

#who is this coming from
$msg.From = “AlliedIgnite@alliedsolutions.net”
#and going to
$msg.To.Add(”leroy.brown@alliedsolutions.net")
#and a nice pretty title
$msg.Subject = “Errors in the Logs for $today”
#and BOOM! send that bastard!
$smtp.Send($msg)

