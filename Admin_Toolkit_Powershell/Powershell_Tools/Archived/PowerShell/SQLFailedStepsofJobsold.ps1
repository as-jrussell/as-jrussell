#Altered this (Find Failed SQL Jobs with Powershell) to check for suspect pages.
#by Adam Mikolaj
#www.sqlsandwiches.com
#cls

import-module D:\POWERSHELL\MODULES\invokesqlquery

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null;


#let's get our list of servers. For this, create a .txt files with all the server names you want to check.
$sqlservers = Get-Content "D:\Powershell\SQLServer.txt";

#we'll get the long date and toss that in a variable
$datefull = Get-Date
#and shorten it
$today = $datefull.ToShortDateString()
$Looksback = (Get-Date).AddDays((-3))
$Lookback=$Looksback.ToShortDateString()


#let's set up the email stuff
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient("10.11.1.147")
$msg.Body = “Here is a list of FAILED JOB STEPS for $today (the last 24 hours)”


#here, we will begin with a foreach loop. We'll be checking all servers in the .txt referenced above.
foreach($sqlserver in $sqlservers)
 
{
    
    #here we need to set which server we are going to check in this loop
   # $srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $sqlserver;
          
       TRY
        {
           $Query = invoke-sqlquery -query "EXEC master..xp_readerrorlog 0, 1, null, null,'$Lookback','$today' " -server $sqlserver.servername | select-object @{Name="Server"; Expression={$sqlserver.servername}}, LogDate, ProcessInfo, Text | `
                     where-object {$_.Text -match 'error|fail|warn|kill|dead|cannot|could|stop|terminate|bypass|roll|truncate|upgrade|victim|recover'} | `
                     where-object {$_.Text -notmatch 'setting database option recovery to'}
        }
        catch {"Unable to read SQL error log from server $sqlserver"}
   
    {  IF ($Query -eq [DBNull]::Value) 
                   {
                                #now we add the job info to our email body. use `n for a new line
                			    $msg.body   = $msg.body + "`n `n SQL LOG ERROR INFO: 
                                 SERVER = $sqlserver 
                                 Errors in the SQL Log = $query"
                }
        }
       
}

#once all that loops through and builds our $msg.body, we are read to send

#who is this coming from
$msg.From = “AlliedIgnite@alliedsolutions.net”
#and going to
$msg.To.Add(”leroy.brown@alliedsolutions.net")
#and a nice pretty title
$msg.Subject = “FAILED JOB STEPS for $today”
#and BOOM! send that bastard!
$smtp.Send($msg)
