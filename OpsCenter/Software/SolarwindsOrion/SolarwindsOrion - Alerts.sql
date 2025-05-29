
USE SolarwindsOrion
 
Select DISTINCT  Nodes.Caption,environment, businessfunction, Nodes.DNS
From Nodes

left Join AlertHistoryView on Nodes.NodeID = AlertHistoryView.RelatedNodeID

Where  BusinessApplication = 'Unitrac'
and name is null 
and caption  not in ('UT-EDITEST-01','UniTrac-wh0J', 'unitrac-WH0B.colo.as.local', 
'UniTrac-WH008', 'ALLIED-UT-DEV2', 'UNITRAC-APP01', 'UniTrac-WH0R.colo.as.local', 'USD-RD0B.colo.as.local')