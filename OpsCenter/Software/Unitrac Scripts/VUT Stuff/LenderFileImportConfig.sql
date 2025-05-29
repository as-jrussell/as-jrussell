use vut


select * 
into UnitracHDStorage..INC0393258_LenderExtract
from vut..tblLenderExtract



select * 
into UnitracHDStorage..INC0393258_LenderExtractCategory
from vut..tblLenderExtractCategory tle
--VUT Table

select * from vut..tblLender
where lenderID = ''



--VUT 
select * 
from vut..tblLenderExtractCategory tle
where LenderExtractKey in (2835,2836,2837,2841,2842)


select * 
from vut..tblLenderExtract
where lenderkey = 2470
and ExtracttypeCode =1
and minimumbalanceincrase = 101


select * from vut..tblbranch
where branchkey = 15604


select * from vut..tblLenderbranchContractType


delete tle
--select *
from vut..tblLenderExtract tle
where lenderkey = 2470 and lenderextractkey = 2836



