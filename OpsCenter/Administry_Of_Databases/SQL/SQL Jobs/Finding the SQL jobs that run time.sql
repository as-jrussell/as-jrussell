SELECT j.name                                                                                             AS 'JobName',
       msdb.dbo.Agent_datetime(run_date, run_time)                                                        AS 'RunDateTime',
       run_duration,
       ( ( run_duration / 10000 * 3600 + ( run_duration / 100 )%100 * 60 + run_duration%100 + 31 ) / 60 ) AS 'RunDurationMinutes'
FROM   msdb.dbo.sysjobs j
       INNER JOIN msdb.dbo.sysjobhistory h
               ON j.job_id = h.job_id
WHERE  j.enabled = 1 --Only Enabled Jobs 
       AND run_date = Cast(Cast(Datepart(year, Getdate()) AS VARCHAR)
                           + RIGHT('0' + Cast (Datepart(month, Getdate()) AS VARCHAR), 2)
                           + RIGHT('0' + Cast (Datepart(day, Getdate()) AS VARCHAR), 2) AS NUMERIC(10, 0))
ORDER  BY JobName,
          RunDateTime DESC
/*

cast(

 cast(datepart(year,getdate()) as varchar) + -- get the year

 right('0' + cast (datepart(month,getdate()) as varchar),2) + --get the month and zero pad

 right('0' + cast (datepart(day,getdate()) as varchar),2) --get the day and zero pad

as numeric(10,0)) -- convert back to a numeric(10,0)

*/
