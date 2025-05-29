$deployLogDestination = "C:\Users\jrussell\Downloads\MongoConfigs"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Start-Transcript -Path $deployLogDestination


'Stage Mongo DB 1'
Select-String -Path '\\MongoDB-STG-01\E$\Mongodb\*\*.cfg' -Pattern "bindIp"

'Stage Mongo DB 2'
Select-String -Path '\\MongoDB-STG-02\E$\Mongodb\*\*.cfg' -Pattern "bindIp"

'QA Mongo DB 1'
Select-String -Path '\\MongoDB-QA-01\E$\Mongodb\*\*.cfg' -Pattern "bindIp"
Select-String -Path '\\MongoDB-QA-01\E$\Mongodb\*.cfg' -Pattern "bindIp"


'QA Mongo DB 2'
Select-String -Path '\\MongoDB-QA-02\E$\Mongodb\*\*.cfg' -Pattern "bindIp"
Select-String -Path '\\MongoDB-QA-02\E$\Mongodb\*.cfg' -Pattern "bindIp"


'PROD Mongo DB 1'
Select-String -Path '\\MongoDB-Prod-01\E$\Mongodb\*\*.cfg' -Pattern "bindIp"
Select-String -Path '\\MongoDB-PROD-01\E$\Mongodb\*.cfg' -Pattern "bindIp"


'PROD Mongo DB 2'
Select-String -Path '\\MongoDB-PROD-02\E$\Mongodb\*\*.cfg' -Pattern "bindIp"
Select-String -Path '\\MongoDB-PROD-02\E$\Mongodb\*.cfg' -Pattern "bindIp"

