use unitrac_distribution

/******************************************************************************/
DECLARE @AlertThresholdinMin INT = 10 -- If more than X min, delay, get alerts
/******************************************************************************/
SET @AlertThresholdinMin = @AlertThresholdinMin * 1000 * 60
SELECT cast(ma2.publisher_db as varchar(32)) as dbname,
   cast(mh1.delivery_latency / ( 1000 * 60 ) as int) AS delivery_latency_Minutes,
   mh1.time
--INTO ##tmpLogReaderLatencyStatus
FROM mslogreader_history mh1 
   JOIN (
      SELECT mh1.agent_id, MAX(mh1.time) as maxtime
      FROM mslogreader_history mh1
         JOIN MSlogreader_agents ma on ma.id = mh1.agent_id
      GROUP BY mh1.agent_id) AS mh2 ON mh1.agent_id = mh2.agent_id and mh1.time = mh2.maxtime
   JOIN MSlogreader_agents ma2 on ma2.id = mh2.agent_id  
WHERE mh1.delivery_latency > @AlertThresholdinMin
   and mh1.comments not like '%No replicated transactions are available.%'
   