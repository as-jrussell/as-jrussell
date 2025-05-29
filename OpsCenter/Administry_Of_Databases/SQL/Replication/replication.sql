SELECT *
FROM MStracer_tokens t with (nolock)
JOIN MStracer_history h with (nolock) ON t.tracer_id = h.parent_tracer_id
JOIN dbo.MSdistribution_agents a ON A.ID = h.agent_id
where 1= 1
AND h.agent_id = (SELECT id from MSdistribution_agents ma where publication = 'UTREP-01' AND subscriber_id > 0)
AND subscriber_commit is null
ORDER BY t.publisher_commit ASC

