USE UniTrac


------Pull notices or certs back from HOV and put back in the queue to be reworked-----

---------Use the work item ID to get the batch ID/External_ID ------------


 
 SELECT WI.ID [WorkItemId], OC.OUTPUT_TYPE_CD, OC.TYPE_CD, OB.* FROM dbo.OUTPUT_BATCH OB
JOIN dbo.OUTPUT_CONFIGURATION OC ON OC.ID = OB.OUTPUT_CONFIGURATION_ID
join WORK_ITEM WI ON WI.RELATE_ID = OB.PROCESS_LOG_ID AND WI.RELATE_TYPE_CD = 'Osprey.ProcessMgr.ProcessLog'
  WHERE WI.ID IN (40172032 )

  
