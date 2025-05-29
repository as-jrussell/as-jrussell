/* 
SELECT * FROM tblLenderExtractConversion

*/



UPDATE tblLenderExtractConversion
SET conversionprogram = Replace(conversionprogram,'\\vut-app.colo\','C:\LenderFileExtracts\')
where conversionprogram like '%\\vut-app.colo\%'

UPDATE tblLenderExtractConversion
SET conversionprogram = Replace(conversionprogram,'\\vut-app\','C:\LenderFileExtracts\')
where conversionprogram like '%\\vut-app\%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\vut-app\Eastern\Data\','\\utstage-app1\LenderFiles\')
where inputfilename like '%\\vut-app\Eastern\Data\%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\vut-app\Central\Data\','\\utstage-app1\LenderFiles\')
where inputfilename like '%\\vut-app\Central\Data\%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\vut-app\Mountain\Data\','\\utstage-app1\LenderFiles\')
where inputfilename like '%\\vut-app\Mountain\Data\%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\vut-app\Kazeck\Data\','\\utstage-app1\LenderFiles\')
where inputfilename like '%\\vut-app\Kazeck\Data\%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\vut-app\Western\Data\','\\utstage-app1\LenderFiles\')
where inputfilename like '%\\vut-app\Western\Data\%'


UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\vut-app.colo\Eastern\Data\','\\utstage-app1\LenderFiles\')
where inputfilename like '%\\vut-app.colo\Eastern\Data\%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\vut-app.colo\Central\Data\','\\utstage-app1\LenderFiles\')
where inputfilename like '%\\vut-app.colo\Central\Data\%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\vut-app.colo\Mountain\Data\','\\utstage-app1\LenderFiles\')
where inputfilename like '%\\vut-app.colo\Mountain\Data\%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\vut-app.colo\Kazeck\Data\','\\utstage-app1\LenderFiles\')
where inputfilename like '%\\vut-app.colo\Kazeck\Data\%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\vut-app.colo\Western\Data\','\\utstage-app1\LenderFiles\')
where inputfilename like '%\\vut-app.colo\Western\Data\%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\vut-app.colo\DJ Data\','\\utstage-app1\LenderFiles\DJ Data\')
where inputfilename like '%\\vut-app.colo\DJ Data\%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\vut-app\DJ Data\','\\utstage-app1\LenderFiles\DJ Data\')
where inputfilename like '%\\vut-app\DJ Data\%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\vut-app\Kesler\Data\','\\utstage-app1\LenderFiles\')
where inputfilename like '%\\vut-app\Kesler\Data\%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\vut-app\OhioSC\Data\','\\utstage-app1\LenderFiles\')
where inputfilename like '%\\vut-app\OhioSC\Data\%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\vut-app.colo\Kesler\Data\','\\utstage-app1\LenderFiles\')
where inputfilename like '%\\vut-app.colo\Kesler\Data\%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\vut-app.colo\OhioSC\Data\','\\utstage-app1\LenderFiles\')
where inputfilename like '%\\vut-app.colo\OhioSC\Data\%'


UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\10.10.18.31\mountain\Data\','\\utstage-app1\LenderFiles\')
where inputfilename like '%\\10.10.18.31\mountain\Data\%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\10.10.18.31\dj data\','\\utstage-app1\LenderFiles\DJ Data\')
where inputfilename like '%\\10.10.18.31\dj data%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\\10.10.18.31\Central\Data\','\\utstage-app1\LenderFiles\')
where inputfilename like '%\\10.10.18.31\Central\Data\%'

UPDATE tblLenderExtractConversion
SET inputfilename = Replace(inputfilename,'\vut-app\Eastern\Data\','\\utstage-app1\LenderFiles\')
where inputfilename like '%\vut-app\Eastern\Data\%'


