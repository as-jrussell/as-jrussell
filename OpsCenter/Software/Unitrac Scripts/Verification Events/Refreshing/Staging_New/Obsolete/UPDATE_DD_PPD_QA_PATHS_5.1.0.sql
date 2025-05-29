SELECT * FROM UniTrac..DELIVERY_DETAIL WHERE VALUE_TX LIKE '\%'
SELECT * FROM UniTrac..PREPROCESSING_DETAIL WHERE VALUE_TX LIKE '\%'

--DELIVERY DETAILS
BEGIN

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\Escrow\Input', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('InputFolder', 'ArchInFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\AOBC', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('InputFolder', 'ArchInFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\AOBC', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\Escrow\InsFile', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('InputFolder', 'ArchInFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\Escrow\InsFile', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\Escrow\Output', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('InputFolder', 'ArchInFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\Escrow\Output', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\Escrow\InsFile\INSBCKFD\ArchiveInput', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('InputFolder', 'ArchInFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\Escrow\InsFile\INSBCKFD\Output', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\Escrow\InsFile\INSBCKFD\Input', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('InputFolder', 'ArchInFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\Escrow\InsFile\INSBCKFD\ArchiveOutput', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\Escrow\InsFile\1097\Input', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('InputFolder', 'ArchInFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\Escrow\InsFile\1097\Output', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\Escrow\InsFile\1097\ArchiveOutput', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\Escrow\InsFile\1097\ArchiveInput', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('InputFolder', 'ArchInFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\OhioSC\Data\035000 United Arkansas\ArchiveOutput', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\OhioSC\Data\035000 United Arkansas', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\Vut-app\OhioSC\Data\023000 Heart of Louisiana', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\Vut-app\OhioSC\Data\023000 Heart of Louisiana\ArchiveInput', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\10.10.18.218\SoftcareOutput', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('InputFolder', 'ArchInFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\10.10.18.218\LenderFiles', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('InputFolder', 'ArchInFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\10.10.20.11\FTP Folders', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('InputFolder', 'ArchInFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\10.10.18.31\OhioSC', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('InputFolder', 'ArchInFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\10.10.18.31\OhioSC', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\ftp-01.colo.as.local\FTP Folders', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('InputFolder', 'ArchInFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\ftp-01\FTP Folders', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('InputFolder', 'ArchInFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\ftp-01.colo.as.local\FTP Folders', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\10.10.18.31\DJ Data\1689', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\ftp-01.as.local\FTP Folders', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('InputFolder', 'ArchInFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\ftp-01.as.local\FTP Folders', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\10.10.18.31\Eastern\Data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\10.10.18.31\Western\Data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\10.10.18.31\Central\Data\2992 Voyage', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFileName', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\10.10.18.31\Central\Data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\10.10.18.31\Mountain\Data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\10.10.20.11\FTP Folders', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\central\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\central\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\\central\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\\central\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\Kazeck\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\Kazeck\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\\Kazeck\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\\Escrow\InsFile', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\\Kazeck\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\testpath', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\10.10.18.31\Kazeck\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\Eastern\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\Eastern\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\Eastern\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('ArchInFolder', 'InputFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\\Eastern\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\\Eastern\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\Mountain\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\Mountain\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\\Mountain\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\\Mountain\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\Western\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\Western\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\\Western\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\ohiosc\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\\Western\data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\dj data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\dj data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\\dj data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\\dj data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\EOMFILES', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\EOMFILES', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('ArchInFolder', 'InputFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\Vut-app\eomfiles\Eastern\\ArchiveOutput', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\Vut-app\eomfiles\Eastern\', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\Kazeck\Billing', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\Kazeck\Billing', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('ArchInFolder', 'InputFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\Kazeck\Billing', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('ArchInFolder', 'InputFolder')

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\ftp-01.as.local\Aloha\Honolulu FCU', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('ArchInFolder', 'InputFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\ftp-01\FTP Folders\FirstHeritage_6201\ArchiveInput', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('ArchInFolder', 'InputFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\ftp-01\FTP Folders\FirstHeritage_6201\ArchiveInput\ArchiveInput', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('ArchInFolder', 'InputFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\OhioSC\EOMFILES\PASSMORE\ArchiveInput', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('ArchInFolder', 'InputFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\OhioSC\EOMFILES\PASSMORE\ArchiveOutput', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\ftp-01.as.local\InformaticaFileStaging$\', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('ArchInFolder', 'InputFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\ftp-01.as.local\InformaticaFileStaging$\', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\OhioSC\EOMFILES', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('ArchInFolder', 'InputFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\OhioSC\EOMFILES', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\ALLIED-SERVICES', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('ArchInFolder', 'InputFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\ALLIED-SERVICES', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\Vut-app\OhioSC\Data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\central', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\Kesler\Data', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

update DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\Midwest\Data\4824-NICFN', 'C:\LenderFiles') 
where DELIVERY_CODE_TX in ('OutputFolder', 'ArchOutFolder');

UPDATE DELIVERY_DETAIL set VALUE_TX = replace(VALUE_TX, 'C:\Program Files\Network Associates\PGPNT\Keys\Allied Solutions.asc', 'C:\LenderFiles\Keys\PNG\Allied Solutions.asc') 
where DELIVERY_CODE_TX = 'KeyfileLocation'

UPDATE DELIVERY_DETAIL SET VALUE_TX = 'C:\LenderFiles\SoftcareOutput'
WHERE VALUE_TX = '\\10.10.18.218\LenderFiles\SoftcareOutput' 

UPDATE DELIVERY_DETAIL SET VALUE_TX = 'C:\LenderFiles\SoftcareOutput'
WHERE VALUE_TX = '\\10.10.18.218\LenderFiles\SoftcareOutput\ArchiveInput'

UPDATE DELIVERY_DETAIL SET VALUE_TX = 'C:\DJ Data'
WHERE VALUE_TX = '\\10.10.18.31\DJ Data'

UPDATE DELIVERY_DETAIL SET VALUE_TX = 'C:\DJ Data\ArchiveOutput'
WHERE VALUE_TX = '\\10.10.18.31\DJ Data\ArchiveOutput'

UPDATE DELIVERY_DETAIL SET VALUE_TX = 'C:\filelocker\ftp\FTP Archives'
WHERE VALUE_TX LIKE '\\filelocker\ftp\FTP Archives\%'

UPDATE DELIVERY_DETAIL SET VALUE_TX = 'C:\Lenderfiles\eastern\ArchiveOutput'
WHERE VALUE_TX LIKE '\\vut-app\eastern\ArchiveOutput%'

UPDATE DELIVERY_DETAIL SET VALUE_TX = 'C:\Lenderfiles\FTP\ArchiveInput'
WHERE VALUE_TX LIKE '\\10.10.18.166\ftp\FTP Archives\%'

UPDATE DELIVERY_DETAIL SET VALUE_TX = 'C:\Lenderfiles\eastern\Data'
WHERE VALUE_TX LIKE '\\vut-app\eastern\Data%'

UPDATE DELIVERY_DETAIL SET VALUE_TX = 'C:\Lenderfiles\kesler\Specs'
WHERE VALUE_TX LIKE '\\vut-app\kesler\specs%'

UPDATE DELIVERY_DETAIL SET VALUE_TX = 'C:\Lenderfiles\kesler\Data'
WHERE VALUE_TX LIKE '\\vut-app\kesler\data%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = 'C:\LenderFiles\SoftcareOutput\ArchiveInput'
WHERE DELIVERY_CODE_TX = 'ArchInFolder'
AND VALUE_TX = 'C:\LenderFiles\SoftcareOutput'

UPDATE DELIVERY_DETAIL SET VALUE_TX = 'C:\Lenderfiles\Western'
WHERE VALUE_TX LIKE '\\Vut-app\Western\Data\4015%'


END
GO

SELECT * FROM UniTrac..PREPROCESSING_DETAIL
WHERE VALUE_TX LIKE '\\%'

--PREPROCESSING DETAILS
BEGIN

update PREPROCESSING_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\kesler\specs', 'C:\Conversions\DJFiles') 
where TYPE_CD ='DataJunction'

update PREPROCESSING_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\dj specs', 'C:\Conversions\DJFiles') 
where TYPE_CD ='DataJunction'

update PREPROCESSING_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\dj specs', 'C:\Conversions\DJFiles') 
where TYPE_CD ='DataJunction'

update PREPROCESSING_DETAIL set VALUE_TX = replace(VALUE_TX, '\\Vut-app.colo\Eastern\Specs', 'C:\Conversions\DJFiles') 
where TYPE_CD ='DataJunction'

update PREPROCESSING_DETAIL set VALUE_TX = replace(VALUE_TX, '\\Vut-app\Eastern\Specs', 'C:\Conversions\DJFiles') 
where TYPE_CD ='DataJunction'

update PREPROCESSING_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app.colo\eastern\specs', 'C:\Conversions\DJFiles') 
where TYPE_CD ='DataJunction'

update PREPROCESSING_DETAIL set VALUE_TX = replace(VALUE_TX, '\\vut-app\eastern\specs', 'C:\Conversions\DJFiles') 
where TYPE_CD ='DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app.colo\central\specs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\central\specs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app.colo\Western\specs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\Western\specs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app.colo\Western', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app.colo\Mountain\specs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\Mountain\specs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app.colo\ohiosc', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app.colo\dj functions', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\dj functions', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app.colo\Mountain\specs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'CRLF'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app.colo\kazeck\specs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\kazeck\specs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\kazeck\functions', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app.colo\kazeck\functions', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\vut-app.colo\western\specs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app.colo.as.local\eastern\specs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\10.10.18.31\Eastern\Specs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\eastern\specs\2771_PenFed_Mtg (Hogan) (Step #1).djs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'CRLF'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app.colo\eastern\data\2076 copoco\2076_Copoco_(Mtg_Step#4).djs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\central\data\2268 tyndall fcu\2268_Tyndall_FCU(#1 - Spectrum).djs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\central\data\2268 tyndall fcu\2268_Tyndall_FCU(#2 - Velocity).djs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\central\data\2268 tyndall fcu\2268_Tyndall_FCU(#3 - Join).djs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\mountain\data\1580 seattle metropolitan\1580 Seattle_Metro_CU_(Step #3).djs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\eastern\data\7105 harbor community bank\allied insurance report.xls', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\kesler\specs\7560_High_Country_Bank (Step #1).djs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\kesler\specs\7560_High_Country_Bank (Step #2).djs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\kesler\specs\7560_High_Country_Bank (Step #4).djs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\kesler\specs\7560_High_Country_Bank (Step #5).djs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\kesler\specs\7555_frontier_bank_(step_#1).djs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\kesler\specs\7555_frontier_bank (step #2).djs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\kesler\specs\7555_Frontier_Bank (Step #3).djs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\kesler\specs\7561_idaho_first_bank (step #1).djs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\kesler\specs\7561_idaho_first_bank (step #1).djs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\kesler\specs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

update PREPROCESSING_DETAIL SET value_tx = replace(VALUE_TX, '\\vut-app\ohiosc\specs', 'C:\Conversions\DJFiles') 
WHERE TYPE_CD = 'DataJunction'

END
GO