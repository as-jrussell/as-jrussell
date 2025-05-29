
<# 

cd ..
cd "C:\PowerShell\Miscellaneous"



#>
.\cloneDB.ps1 -sourceDB 'EDITest' -targetPrimary 'UTSTAGE-SQL-01' -targetSecondary 'UTSTAGE-SQL-02'  -agName 'UTAG' -targetdatadrive 'F:\DB_5\' -targetLogDrive 'F:\SQLLogs\' -dryRun 0 
.\cloneDB.ps1 -sourceDB 'AGTest2' -targetPrimary 'UTSTAGE-SQL-01' -targetSecondary 'UTSTAGE-SQL-02'  -agName 'UTAG' -targetdatadrive 'F:\DB_5\' -targetLogDrive 'F:\SQLLogs\' -dryRun 0 
.\cloneDB.ps1 -sourceDB 'UnitracTestAG' -targetPrimary 'UTSTAGE-SQL-01' -targetSecondary 'UTSTAGE-SQL-02'  -agName 'UTAG' -targetdatadrive 'F:\DB_5\' -targetLogDrive 'F:\SQLLogs\' -dryRun 0 




.\cloneDB.ps1 -sourceDB 'ACSYSTEM' -targetPrimary 'OCR-SQLPRD-04' -targetSecondary 'OCR-SQLPRD-05'  -agName 'OCR-PRD2-AG' -targetdatadrive 'E:\SQLDATA\' -targetLogDrive 'F:\SQLLogs\' -dryRun 0 
