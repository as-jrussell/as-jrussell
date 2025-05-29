
Declare @body as varchar(6000)
declare @statuscomp as varchar(400)
declare @statuspend as varchar(400)
declare @statusbie1 as varchar(400)
declare @statusbie2 as varchar(400)
declare @statusbie3 as varchar(400)
declare @statusbie4 as varchar(400)
declare @statuscheck as varchar(400)
declare @overall as varchar(400)
declare @time as datetime
declare @date as date
declare @overallday as varchar(400)



set @time = dateadd(hour,-24,getdate())
set @date =  CAST(GETDATE()AS date)

select Count(*)
from [ocr-prd1-listen].ocr.dbo.importimages
where batchdate > @time and status = 'COMP'

select Count(*) 'PEND'
from [ocr-prd1-listen].ocr.dbo.importimages
where batchdate > @time and status = 'PEND'

select Count(*)'BIE1'
from [ocr-prd1-listen].ocr.dbo.importimages
where batchdate > @time and status = 'BIE1'

select Count(*)'BIE2'
from [ocr-prd1-listen].ocr.dbo.importimages
where batchdate > @time and status = 'BIE2'

select Count(*)'BIE3'
from [ocr-prd1-listen].ocr.dbo.importimages
where batchdate > @time and status = 'BIE3'

select Count(*)'BIE4'
from [ocr-prd1-listen].ocr.dbo.importimages
where batchdate > @time and status = 'BIE4'

select Count(*) 'err'
from [ocr-prd1-listen].ocr.dbo.importimages
where batchdate > @time and status = 'ERR'

select Count(*)
from [ocr-prd1-listen].ocr.dbo.importimages
where batchdate > @time

select Count(*)
from [ocr-prd1-listen].ocr.dbo.importimages
where batchdate > @date


