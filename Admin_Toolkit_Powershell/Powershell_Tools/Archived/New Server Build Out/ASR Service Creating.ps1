#For multiple; ensure that there is a document created for the services needed


New-Service -Name "<newservice>" -BinaryPathName """E:\Services\<newservice>\UnitracBusinessService.exe"" -SVCNAME:<newservice> -SVCTYPE:QUEUEPROCESSOR -QUEUESVC://UniTrac/UBSReadyToExecuteService" -DisplayName "<newservice>" -StartupType Automatic -Description "<newservice>"
