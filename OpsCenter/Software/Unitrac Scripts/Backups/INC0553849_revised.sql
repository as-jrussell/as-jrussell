/*
Run in PowerShell:

$File = "C:\Users\hlewis\desktop\2257Sharonview.xlsx"
$Instance = "ut-prd-listener"
$Database = "UnitracHDStorage"
$fileName =  [System.IO.Path]::GetFileNameWithoutExtension($File)
foreach($sheet in Get-ExcelSheetInfo $File)
{
$data = Import-Excel -Path $File -WorksheetName $sheet.name | ConvertTo-DbaDataTable
$tablename = $fileName
Write-DbaDataTable -SqlInstance $Instance -Database $Database -InputObject $data -AutoCreateTable -Table $tablename
}


Use query below in database to check to see if it imported:

use UniTrac

SELECT *
FROM UniTracHDStorage..[2257Sharonview]
*******************************************************************

Run query:
UT-PRD-LISTENER
*/

use unitrac


select *
from LENDER
where CODE_TX = '2257'




--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.NUMBER_TX, concat(O.First_NAME_TX,' ',O.LAST_NAME_TX ) as  [Owner]    , OA.* 
FROM LOAN L
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX ='2257'
AND OA.ID in (SELECT ID FROM UniTracHDStorage..[2257Sharonview] S)

/*
SELECT L.NUMBER_TX, OA.* 
INTO UnitracHDStorage..INC0553849
FROM LOAN L
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX ='2257'
AND OA.ID in (SELECT ID FROM UniTracHDStorage..[2257Sharonview] S)



SELECT   *  
FROM OWNER_ADDRESS OA
JOIN UnitracHDStorage..INC0553849 L on OA.ID= L.ID




UPDATE OA
SET LINE_2_TX = NULL, UPDATE_USER_TX = 'INC0553849', UPDATE_DT = GETDATE()
--SELECT   count(*)  
FROM OWNER_ADDRESS OA
JOIN UnitracHDStorage..INC0553849 L on OA.ID= L.ID
--6733



--Verify Records
SELECT L.NUMBER_TX, concat(O.First_NAME_TX,' ',O.LAST_NAME_TX ) as  [Owner]    , OA.* 
FROM LOAN L
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX ='2257'
AND OA.ID in (SELECT ID FROM UniTracHDStorage..[2257Sharonview] S)




 UPDATE OA
SET OA.LINE_2_TX = U.LINE_2_TX, OA.UPDATE_USER_TX = 'INC0553849_BO', UPDATE_DT = GETDATE()
--SELECT   count(*)  
FROM OWNER_ADDRESS OA
JOIN UnitracHDStorage..INC0553849 U on OA.ID= U.ID



