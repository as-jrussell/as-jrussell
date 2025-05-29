use unitrac_distribution
go

--sp_replmonitorsubscriptionpendingcmds_RRR 'Unitrac-DB01', 'Unitrac', 'UTRep-01', 'UTPROD-SUB-01', 'Unitrac_Reports', 0d
go

 --2019-01-08 12:33:20.150

--Historical Breakdown (in seconds)
SELECT top 1000
publication_id 'PubID', h.agent_id 'AgentID', h.parent_tracer_id,
                   t.publisher_commit 'PubCommit',
       t.distributor_commit 'DistCommit',
      h.subscriber_commit 'SubCommit',
       Datediff(s,t.publisher_commit,t.distributor_commit) as 'Dist(sec)',
       Datediff(s,t.distributor_commit,h.subscriber_commit) as 'Sub(sec)',
       Datediff(s,t.publisher_commit,h.subscriber_commit) as 'Total(sec)'
                                ,current_dt = getdate()
                                ,time_behind_in_minutes = convert(numeric(6, 1), round(datediff(second, t.publisher_commit, isnull(h.subscriber_commit, getdate()))/60.0, 1))
                                ,time_behind_in_hours = convert(numeric(6, 1), round(datediff(second, t.publisher_commit, isnull(h.subscriber_commit, getdate()))/3600.0, 1))
FROM MStracer_tokens t with (nolock)
JOIN MStracer_history h with (nolock)
ON t.tracer_id = h.parent_tracer_id
where 1= 1
and agent_id = (SELECT id from MSdistribution_agents ma where publication = 'UTREP-01' AND subscriber_id > 0)
ORDER BY t.publisher_commit desc
 

Go

/*

The UTL Loan purge should not be able to remove any Property or Owner or Owner relates records that are associated with another loan record because it would fail with a FK constraint violation (like it did for the handful of cross linked Property records we did have). 
However, if you want to check and see if any records associated with  an existing loan were possibly deleted by the purge process, you can look in the UniTrac_Maintenance database.
There are 2 tables there that keep a record of the Primary Key Ids of the tables we delete from: delLoanHistory, and delObjTempTableHistory.
delObjTempTableHistory has 2 field you’d want to look at – ObjectType and PrimaryKeyID
OBjectType is typically the table name (Property, Owner, etc.) the only exception is PROPERTY_ADDRESS (the actual table it points to is OWNER_ADDRESS). 
So if you wanted to see if a specific Property record was deleted, you’d run a query like this:

Select * from UniTrac_Maintenance.dbo.delObjTempTableHistory 
Where ObjectType = ‘PROPERTY’ 
And PrimaryKeyID = ???????

Or, an Owner_Loan_Relate record:

Select * from UniTrac_Maintenance.dbo.delObjTempTableHistory 
Where ObjectType = ‘OWNER_LOAN_RELATE’ 
And PrimaryKeyID = ???????

*/
