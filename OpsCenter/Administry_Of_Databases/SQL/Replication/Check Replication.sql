USE unitrac_distribution

DECLARE @time_Behind int
SELECT top 1 @time_Behind  = convert(numeric(6, 1), round(datediff(second, t.publisher_commit, isnull(h.subscriber_commit, getdate()))/60.0, 1))
FROM MStracer_tokens t with (nolock)
JOIN MStracer_history h with (nolock)
ON t.tracer_id = h.parent_tracer_id
where 1= 1
AND subscriber_commit is null
--and t.publisher_commit >= '2014-07-17 10:10:00'
--and Datediff(s,t.publisher_commit,h.subscriber_commit)  >= 10
--and isnull(subscriber_commit, '1/1/2999') >= DATEADD(MINUTE, -10, (select MAX(subscriber_commit) from MStracer_history) )
and agent_id = (SELECT id from MSdistribution_agents ma where publication = 'UTREP-01' AND subscriber_id > 0)
--and t.distributor_commit is not null
--ORDER BY t.publisher_commit asc
--AND convert(numeric(6, 1), round(datediff(second, t.publisher_commit, isnull(h.subscriber_commit, getdate()))/60.0, 1)) > 5
ORDER BY t.publisher_commit asc

SELECT @time_behind AS time_behind_in_minutes

--IF @time_Behind >= 60
--begin
--	RAISERROR ('Replication delivery latency of UTREP-01 publication exceeds 60 minutes', 16, 1, @time_Behind) with log
--end
