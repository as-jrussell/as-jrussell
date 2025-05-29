 #Find Repository Path for a module
 (Get-Module -ListAvailable *FailoverCluster*).path


 #Find Repository
 Get-PSRepository 

 Get-ClusterResource "CP-QA-LISTENER" | Get-ClusterParameter
