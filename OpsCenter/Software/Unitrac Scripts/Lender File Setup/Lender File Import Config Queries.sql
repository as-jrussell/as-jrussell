USE UniTrac

select *
from tbllender
where lenderid = '3525'

select LENDER_ORGANIZATION.id,LENDER_ORGANIZATION.CODE_TX, *
from vut.dbo.tbllenderextract
inner join LENDER_ORGANIZATION on tbllenderextract.branchkey = LENDER_ORGANIZATION.ID AND LENDER_ORGANIZATION.TYPE_CD = 'BRCH'
where tbllenderextract.lenderkey = 2254

select *
from vut.dbo.tbllenderextractconversion
where lenderextractkey in (2669,2670,2671,2672,2674,2675,2676,2678)

select *
from vut.dbo.tbllenderextract
where lenderextractkey = 2676

update vut.dbo.tbllenderextract
set branchkey = 12459
where lenderextractkey = 2676
