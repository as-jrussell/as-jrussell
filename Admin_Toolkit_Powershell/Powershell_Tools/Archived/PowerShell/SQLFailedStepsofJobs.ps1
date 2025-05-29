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
$msg.Body = “Here is a list of Failed SQL Job steps for $today (the last 48 hours)”
$msgBodyLen= $msg.Body| measure-object -character | select -expandproperty characters

#here, we will begin with a foreach loop. We'll be checking all servers in the .txt referenced above.
foreach($sqlserver in $sqlservers)
 
{
     #here we need to set which server we are going to check in this loop
    $srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $sqlserver;
      
        {
           $Query = InvokeSQLQuery -computer $sqlserver  -commandtext "SELECT  sj.name as 'JOB_NAME' ,sjt.step_name as 'STEP_NAME',JJ.run_status,JJ.message,JJ.exec_date
                    FROM    (SELECT ssh.instance_id ,sjh.job_id,sjh.step_id,sjh.sql_message_id,sjh.sql_severity,sjh.message
			                        ,(CASE sjh.run_status
				                        WHEN 0 THEN 'Failed'
				                        WHEN 1 THEN 'Succeeded'
				                        WHEN 2 THEN 'Retry'
				                        WHEN 3 THEN 'Canceled'
				                        WHEN 4 THEN 'In progress'
				                    END) as run_status
			                        ,((SUBSTRING(CAST(sjh.run_date AS VARCHAR(8)), 5, 2) + '/' + SUBSTRING(CAST(sjh.run_date AS VARCHAR(8)), 7, 2) + '/' 
			                    + SUBSTRING(CAST(sjh.run_date AS VARCHAR(8)), 1, 4) + ' ' + SUBSTRING((REPLICATE('0',6-LEN(CAST(sjh.run_time AS varchar))) 
			                    + CAST(sjh.run_time AS VARCHAR)), 1, 2) + ':' + SUBSTRING((REPLICATE('0',6-LEN(CAST(sjh.run_time AS VARCHAR))) 
			                    + CAST(sjh.run_time AS VARCHAR)), 3, 2) + ':' + SUBSTRING((REPLICATE('0',6-LEN(CAST(sjh.run_time as varchar)))
			                    + CAST(sjh.run_time AS VARCHAR)), 5, 2))) AS 'exec_date'
			                    ,sjh.run_duration
			                    ,sjh.retries_attempted
			                    ,sjh.server
			                FROM       msdb.dbo.sysjobhistory sjh
	                        JOIN  (SELECT sjh.job_id ,sjh.step_id ,MAX(sjh.instance_id) as instance_id
					                FROM       msdb.dbo.sysjobhistory sjh
					                GROUP BY   sjh.job_id,sjh.step_id) AS ssh ON sjh.instance_id = ssh.instance_id
					                WHERE sjh.run_status <> 1) AS JJ
	                        JOIN  msdb.dbo.sysjobs sj ON (jj.job_id = sj.job_id)
	                        JOIN  msdb.dbo.sysjobsteps sjt ON (jj.job_id = sjt.job_id AND jj.step_id = sjt.step_id)
                    WHERE exec_date>GETDATE()-5 "
                    
       }
    
    {  IF ($Query -eq [DBNull]::Value) 
            {
                  
                                     
                   #now we add the job info to our email body. use `n for a new line
                	$msg.body   = $msg.body + "`n `n Failed Job Steps INFO: 
                    SERVER = $sqlserver 
                    FAILED JOB STEPS = $Query"
            }
      }      

$Finalmsgbody=$msg.Body| measure-object -character | select -expandproperty characters
}

#once all that loops through and builds our $msg.body, we are read to send
{   IF ($Finalmsgbody>$msgBodyLen)
        {

        #who is this coming from
        $msg.From = “AlliedIgnite@alliedsolutions.net”
        #and going to
        $msg.To.Add(”leroy.brown@alliedsolutions.net")
        #and a nice pretty title
        $msg.Subject = “Job Steps that failed $today”
        #and BOOM! send that bastard!
        $smtp.Send($msg)
        }
}