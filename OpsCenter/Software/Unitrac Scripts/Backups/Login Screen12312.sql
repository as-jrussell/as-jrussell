use vut


select * 
into UnitracHDStorage..INC0393258_LenderExtract
from vut..tblLenderExtract



select * 
into UnitracHDStorage..INC0393258_LenderExtractCategory
from vut..tblLenderExtractCategory tle


select * from vut..tblLender
where lenderID = '2501'

--2470


select * 
--into UnitracHDStorage..INC0393258_LenderExtractCategory
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




1	All	ALL	NULL	1999-06-01 17:17:59.327	2000-06-26 16:05:07.467
10	Commercial Mortgage	MOR	4	1999-10-22 17:05:50.810	2000-06-26 16:05:18.903
7	Equipment Lease	EQP	6	1999-06-02 09:48:54.560	2000-06-26 16:05:23.593
9	Equipment Loan	EQP	5	1999-06-24 10:20:14.670	2000-06-26 16:05:30.093
11	FICS PUD	PUD	NULL	2017-11-17 16:57:00.923	2017-11-17 16:57:00.923
4	Mortgage	MOR	3	1999-06-02 09:48:04.960	2000-06-26 16:05:34.187
8	Vehicle Lease	VEH	2	1999-07-20 12:50:16.113	2000-06-26 16:05:39.123
3	Vehicle Loan	VEH	1	1999-06-02 09:46:26.067	2000-06-26 16:05:57.577