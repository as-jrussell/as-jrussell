/*
SELECT * FROM dbo.DELIVERY_DETAIL
WHERE VALUE_TX LIKE ('\\vut-app%') OR VALUE_TX LIKE ('\\ftp-01%') OR VALUE_TX LIKE ('\\filelocker%') OR VALUE_TX LIKE ('%UNITRAC-EDI-01%') OR VALUE_TX LIKE ('%ALLIED-SERVICES%') 

*/

UPDATE DELIVERY_DETAIL
SET VALUE_TX = 'C:\filelocker\ftp\FTP Archives', UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\filelocker\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\ftp-01.colo.as.local\FTP Folders\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\ftp-01.colo.as.local%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\ftp-01.as.local\FTP Folders\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\ftp-01.as.local%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\ftp-01\FTP Folders\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\ftp-01\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\10.10.18.31\','\\vut-app.colo\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\10.10.18.31\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\Kazeck\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\Kazeck\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\Central\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
--SELECT * FROM dbo.DELIVERY_DETAIL
where value_tx like '%\\vut-app.colo\Central\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\Eastern\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\Eastern\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\Mountain\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\Mountain\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\Western\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\Western\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\Kazeck\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\Kazeck\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\Central\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\Central\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\Eastern\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\Eastern\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\Mountain\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\Mountain\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\Western\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\Western\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\Kesler\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\Kesler\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\Kazeck\Billing\','C:\LenderFiles\Kazeck\Billing\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\Kazeck\Billing\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\Kazeck\Billing\','C:\LenderFiles\Kazeck\Billing\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\Kazeck\Billing\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\10.10.18.218\LenderFiles\SoftcareOutput','C:\LenderFiles\SoftcareOutput'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\10.10.18.218\LenderFiles\SoftcareOutput%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\DJ Data','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\DJ Data%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\\Central\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\\Central\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\\Mountain\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\\Mountain\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\\Western\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\\Western\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\\Kazeck\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\\Kazeck\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\\Eastern\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\\Eastern\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\\DJ Data\\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\\DJ Data\\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\\DJ Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\\DJ Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\OhioSC\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\OhioSC\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\EOMFiles\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\EOMFiles\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\EOMFiles','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\EOMFiles%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\Escrow\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\Escrow\%'


UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\Eastern\Data','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\Eastern\Data%'


UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\DJ Data','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\DJ Data%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\\Central\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\\Central\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\\Mountain\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\\Mountain\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\\Western\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\\Western\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\\Kazeck\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\\Kazeck\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\\Eastern\Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\\Eastern\Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\\DJ Data\\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\\DJ Data\\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\\DJ Data\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\\DJ Data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\OhioSC\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\OhioSC\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\EOMFiles\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\EOMFiles\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\EOMFiles','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\EOMFiles%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\Escrow\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\Escrow\%'


UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\Eastern\Data','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\Eastern\Data%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\central\','C:\LenderFileExtracts\Central\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\central\%'


UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\AOBC','C:\LenderFiles\AOBC'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\AOBC%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\eastern\ArchiveOutput','C:\LenderFiles\Eastern\ArchiveOutput'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\eastern\ArchiveOutput%'


UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\kesler\specs','C:\LenderFileExtracts\kesler\specs'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\kesler\specs%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\Midwest\Data','C:\LenderFiles\Midwest\Data'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\Midwest\Data%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\Mountain\2771Test\','C:\LenderFiles\Mountain\2771Test\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\Mountain\2771Test\%'


UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\kazeck\billing','C:\LenderFiles\kazeck\billing'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\kazeck\billing%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\testpath','C:\LenderFiles\testpath'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\testpath%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\western\data\','C:\LenderFileExtracts\western\data\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\western\data\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\10.10.18.166\ftp\FTP Archives','C:\filelocker\ftp\FTP Archives'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\10.10.18.166\ftp\FTP Archives%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\10.10.20.11\FTP Folders','C:\filelocker\ftp'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\10.10.20.11\FTP Folders%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\filelocker.as.local\FTP\FTP Archives','C:\filelocker\ftp\FTP Archives'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\filelocker.as.local\FTP\FTP Archives%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\FileLocker\FTP\FTP Archives','C:\filelocker\ftp\FTP Archives'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\FileLocker\FTP\FTP Archives%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\ftp-01.as.local\','C:\filelocker\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\ftp-01.as.local\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\ftp-01.colo.as.local\','C:\filelocker\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\ftp-01.colo.as.local\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\ftp-01\','C:\filelocker\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\ftp-01\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\Kazeck\Billing\','C:\LenderFiles\Kazeck\Billing\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\Kazeck\Billing\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\Escrow\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\Escrow\%'


UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\Escrow\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\Escrow\%'



UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\eastern\specs','C:\LenderFileExtracts\eastern\specs'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\eastern\specs%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = 'C:\LenderFiles\GreatPlainsImport\ArchiveInput', UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
WHERE VALUE_TX LIKE '%\\ALLIED-SERVICES\GreatPlainsImport_2771$\ArchiveInput%' 

UPDATE DELIVERY_DETAIL
SET VALUE_TX = 'C:\LenderFiles\GreatPlainsImport', UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
WHERE VALUE_TX LIKE '%\\ALLIED-SERVICES\GreatPlainsImport_2771$%' 

UPDATE DELIVERY_DETAIL
SET VALUE_TX = 'C:\\LenderFiles\PenFed_Escrow', UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
WHERE VALUE_TX LIKE '%\\allied-ut-dev\Unitrac Source\PenFed_Escrow%' 

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\Eastern\ Data','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\Eastern\ Data%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\Kazeck\Input\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app.colo\Kazeck\Input\%'

UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\UNITRAC-EDI-01\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
WHERE VALUE_TX LIKE '%UNITRAC-EDI-01%'


UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app\','C:\LenderFiles\'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
where value_tx like '%\\vut-app\%'


UPDATE DELIVERY_DETAIL
SET VALUE_TX = Replace(value_tx,'\\vut-app.colo\Kazek\Billing\Output\ArchiveInput','C:\LenderFiles\Kazek\Billing\Output\ArchiveInput'), UPDATE_USER_TX = 'PrePrdRefresh',UPDATE_DT = GETDATE()
--SELECT * FROM  DELIVERY_DETAIL
where value_tx like '%\\vut-app.colo\kazek\billing%'