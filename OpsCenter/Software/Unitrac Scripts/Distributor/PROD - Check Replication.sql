USE unitrac_distribution




DECLARE @time_Behind int
SELECT top 1 @time_Behind  = convert(numeric(6, 1), round(datediff(second, t.publisher_commit, isnull(h.subscriber_commit, getdate()))/60.0, 1))
FROM [UTPROD-DIST-01].unitrac_distribution.[dbo]. MStracer_tokens t with (nolock)
JOIN [UTPROD-DIST-01].unitrac_distribution.[dbo].MStracer_history h with (nolock)
ON t.tracer_id = h.parent_tracer_id
where 1= 1
AND subscriber_commit is null
and agent_id = (SELECT id from MSdistribution_agents ma where publication = 'UTREP-01' AND subscriber_id > 0)
ORDER BY t.publisher_commit asc
	
SELECT @time_behind AS time_behind_in_minutes

