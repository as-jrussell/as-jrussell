USE [Unitrac]




UPDATE dbo.PROCESS_DEFINITION
SET SETTINGS_XML_IM = '<ProcessDefinitionSettings>
  <LastProcessedDate>9/9/2012 5:08:52 AM</LastProcessedDate>
  <TargetServerList>
    <TargetServer />
  </TargetServerList>
  <TargetServiceList>
    <TargetService>LetterGen</TargetService>
  </TargetServiceList>
  <PredecessorProcessList>
    <PredecessorProcess />
  </PredecessorProcessList>
  <AnticipatedNextScheduledDate>2/3/2016 9:55:02 AM</AnticipatedNextScheduledDate>
</ProcessDefinitionSettings>',
LOCK_ID = LOCK_ID+1
--SELECT * FROM dbo.PROCESS_DEFINITION
WHERE ID = '6'