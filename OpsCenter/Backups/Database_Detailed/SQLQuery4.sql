USE [DBA]
GO


select * from sys.objects
where create_date >= '2022-11-11'





exec info.Getdatabase_detailed  @DryRun =0,  @Name='DBA', @type = 'ROWS'

exec info.Getdatabase_detailed  @DryRun =1,   @verbose =1

select * from DBA.info.Database_Detailed

  
--  drop table [DBA]. [info].[Database_Detailed]
-- drop proc info.Database_Detailed