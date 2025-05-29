USE ReportServer


SELECT  JobID ,
        StartDate ,
        ComputerName ,
        RequestName ,
        RequestPath ,        Timeout ,
        UserName
FROM dbo.RunningJobs RJ
INNER JOIN dbo.Users ON Users.UserID = RJ.UserId
ORDER BY StartDate



select GETDATE()