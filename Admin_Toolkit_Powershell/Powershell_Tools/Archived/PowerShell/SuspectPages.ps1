#Find Failed SQL Jobs with Powershell
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

#let's set up the email stuff
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient("10.11.1.147")
$msg.Body = “Here is a list of Suspect Pages for $today (the last 24 hours)”


#here, we will begin with a foreach loop. We'll be checking all servers in the .txt referenced above.
foreach($sqlserver in $sqlservers)
 
{
     #here we need to set which server we are going to check in this loop
   # $srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $sqlserver;
      
        {
           $Query = "SELECT db.NAME AS DatabaseName, sp.file_id, sp.page_id, sp.event_type,sp.error_count, sp.last_update_date
                    FROM msdb.dbo.suspect_pages sp INNER JOIN msdb.sys.databases db ON db.database_id=sp.database_id --AND sp.last_update_date>DATEDIFF(dd,GETDATE(),-7)"
       }
    
    {  IF ($Query -eq [DBNull]::Value) 
            {
                  
                                     
                   #now we add the job info to our email body. use `n for a new line
                	$msg.body   = $msg.body + "`n `n SUSPECT PAGES INFO: 
                    SERVER = $sqlserver 
                    SUSPECT PAGES = $Query"
            }
      }      
}

#once all that loops through and builds our $msg.body, we are read to send

#who is this coming from
$msg.From = “AlliedIgnite@alliedsolutions.net”
#and going to
$msg.To.Add(”leroy.brown@alliedsolutions.net")
#and a nice pretty title
$msg.Subject = “Suspect Pages for $today”
#and BOOM! send that bastard!
$smtp.Send($msg)
