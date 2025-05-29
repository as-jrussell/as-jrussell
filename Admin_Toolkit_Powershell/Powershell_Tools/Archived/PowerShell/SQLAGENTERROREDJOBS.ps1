#Find Failed SQL Jobs with Powershell
#by Adam Mikolaj
#www.sqlsandwiches.com
#cls

import-module D:\POWERSHELL\MODULES\invokesqlquery

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null;


#  Load up the list of servers to check
#  Use this code if you can get your list of servers from a sql database
#$sqlservers = invoke-sqlquery -query @' 
#select distinct serverName from SQL_SERVERS WHERE Active = 'TRUE'
#  order by serverName 
#'@  -server IGNITE-SQL  -database SQL_TRACKING

#let's get our list of servers. For this, create a .txt files with all the server names you want to check.
$sqlservers = Get-Content "D:\Powershell\SQLServer.txt";

#we'll get the long date and toss that in a variable
$datefull = Get-Date
#and shorten it
$today = $datefull.ToShortDateString()

#let's set up the email stuff
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient("10.11.1.147")
$msg.Body = “Here is a list of failed SQL Jobs for $today (the last 24 hours)”


#here, we will begin with a foreach loop. We'll be checking all servers in the .txt referenced above.
foreach($sqlserver in $sqlservers)
{
    
    #here we need to set which server we are going to check in this loop
    $srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $sqlserver;
            
        #now let's loop through all the jobs
        foreach ($job in $srv.Jobserver.Jobs)
        {
            #now we are going to set up some variables. 
            #These values come from the information in $srv.Jobserver.Jobs
            $jobName = $job.Name;
        	$jobEnabled = $job.IsEnabled;
        	$jobLastRunOutcome = $job.LastRunOutcome;
            $jobLastRun = $job.LastRunDate;
    
 
            #we are only concerned about jos that are enabled and have run before. 
            #POSH is weird with nulls so you check by just calling the var
            #if we wanted to check isnull() we would use !$jobLastRun  
            if($jobEnabled = "true" -and $jobLastRun)
                {  
                   # we need to find out how many days ago that job ran
                   $datediff = New-TimeSpan $jobLastRun $today 
                   #now we need to take the value of days in $datediff
                   $days = $datediff.days
                   
                   
                       #gotta check to make sure the job ran in the last 24 hours     
                       if($days -le 1 )                    
                         {       
                            #and make sure the job failed
                            IF($jobLastRunOutcome -eq "Failed")
                            {
                                #now we add the job info to our email body. use `n for a new line
                			    $msg.body   = $msg.body + "`n `n FAILED JOB INFO: 
                                 SERVER = $sqlserver 
                                 JOB = $jobName 
                                 LASTRUN = $jobLastRunOutcome
                                 LASTRUNDATE = $jobLastRun"
                                 
                            }    
                          } 
                }
             

        }
}

#once all that loops through and builds our $msg.body, we are read to send

#who is this coming from
$msg.From = “AlliedIgnite@alliedsolutions.net”
#and going to
$msg.To.Add(”leroy.brown@alliedsolutions.net")
#and a nice pretty title
$msg.Subject = “FAILED SQL Jobs for $today”
#and BOOM! send that bastard!
$smtp.Send($msg)
