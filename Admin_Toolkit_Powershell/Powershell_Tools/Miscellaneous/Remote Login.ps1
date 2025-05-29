#To start an interactive session with a single remote computer
Enter-PSSession websvc-int-01.colo.as.local



#Establish a Persistent Connection
New-PSSession -ComputerName Server01, Server02