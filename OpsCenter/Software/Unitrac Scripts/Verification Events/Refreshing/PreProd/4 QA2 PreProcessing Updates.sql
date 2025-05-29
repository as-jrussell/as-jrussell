/* 
SELECT * FROM UniTrac..PREPROCESSING_DETAIL
WHERE VALUE_TX LIKE '\\%'
*/


UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app\Central\Specs\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app\Central\Specs\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app\Eastern\Specs\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app\Eastern\Specs\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app\Mountain\Specs\','C:\Conversions\DJFiles\')
--SELECT * FROM dbo.PREPROCESSING_DETAIL
where VALUE_TX like '%\\vut-app\Mountain\Specs\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app\Western\Specs\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app\Western\Specs\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app\Kesler\Specs\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app\Kesler\Specs\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app\Kazeck\Specs\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app\Kazeck\Specs\%'


UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app.colo\Central\Specs\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app.colo\Central\Specs\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app.colo\Eastern\Specs\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app.colo\Eastern\Specs\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app.colo\Mountain\Specs\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app.colo\Mountain\Specs\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app.colo\Western\Specs\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app.colo\Western\Specs\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app.colo\Kesler\Specs\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app.colo\Kesler\Specs\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app.colo\Kazeck\Specs\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app.colo\Kazeck\Specs\%'


UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app.colo.as.local\Eastern\Specs\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app.colo.as.local\Eastern\Specs\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app\OhioSC\Specs\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app\OhioSC\Specs\%'




UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app\dj specs\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app\dj specs\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app\dj functions\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app\dj functions\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app\kazeck\functions\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app\kazeck\functions\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app.colo\Western\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app.colo\Western\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app.colo\OhioSC\Specs\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app.colo\OhioSC\Specs\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app.colo\Central\Specs\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app.colo\Central\Specs\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app.colo\Eastern\Specs\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app.colo\Eastern\Specs\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app.colo\Central\Data\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app.colo\Central\Data\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app.colo\Eastern\Data\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app.colo\Eastern\Data\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app\Central\Data\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app\Central\Data\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app\Eastern\Data\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\\vut-app\Eastern\Data\%'

UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\vut-app.colo\Western\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\vut-app.colo\Western\%'


UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app\ohiosc\specs\014900_river_valley_cu (step #1).djs','C:\Conversions\DJFiles\')
--SELECT * FROM dbo.PREPROCESSING_DETAIL
where VALUE_TX like '%\\vut-app\ohiosc\%'



UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app\ohiosc\specs\014900_river_valley_cu (step #2).djs','C:\Conversions\DJFiles\')
--SELECT * FROM dbo.PREPROCESSING_DETAIL
where VALUE_TX like '%\\vut-app\ohiosc\%'



UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\\vut-app\ohiosc\specs\014900_river_valley_cu (step #1.5).djs','C:\Conversions\DJFiles\')
--SELECT * FROM dbo.PREPROCESSING_DETAIL
where VALUE_TX like '%\\vut-app\ohiosc\%'







UPDATE PREPROCESSING_DETAIL
SET VALUE_TX = Replace(VALUE_TX,'\vut-app\','C:\Conversions\DJFiles\')
where VALUE_TX like '%\vut-app%'







UPDATE PPDATTRIBUTE
SET VALUE_TX = 'ut-preprod-1'
--SELECT * FROM dbo.PPDATTRIBUTE
WHERE CODE_CD = 'DBServer'



