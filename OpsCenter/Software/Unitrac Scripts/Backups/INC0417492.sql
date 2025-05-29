use unitrac

select * from unitrachdstorage..INC0417492_OP


select  BIC_ID , BIC_NAME_TX,*
--into unitrachdstorage..INC0417492_OP_Backup
 from owner_policy
where id in (select [op id] from unitrachdstorage..INC0417492_OP)




update op set op.BIC_ID = p.[Set BIC_ID] , op.BIC_NAME_TX=left(p.[set BIC_NAME_TX],7), update_dt = GETDATE(), update_user_tx ='INC0417492',  LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select op.BIC_ID , P.[Set BIC_ID] , op.BIC_NAME_TX,p.[set BIC_NAME_TX], *
from  owner_policy op
join unitrachdstorage..INC0417492_OP P on op.id= p.[op id]


select op.BIC_ID , P.[Set BIC_ID] , op.BIC_NAME_TX, LEN(op.BIC_NAME_TX),p.[set BIC_NAME_TX] , LEN(p.[set BIC_NAME_TX]), left(p.[set BIC_NAME_TX],7)
from  owner_policy op
join unitrachdstorage..INC0417492_OP P on op.id= p.[op id]

/*
Had to trim up the Owner Policy Name to suffice the 7 character field in the database. 
*/



select * 
--into  [UniTracHDStorage].[dbo].[INC0417492_OP_IH_Backup]
from interaction_history
where id in (select [IH ID]  from [UniTracHDStorage].[dbo].[INC0417492_OP IH])


DECLARE @IHID bigint
DECLARE @BICId nvarchar(max)
DECLARE @BICName nvarchar(max)
DECLARE @Task nvarchar(15) = 'INC0419104'

select  @IHID = [IH ID] from [UniTracHDStorage].[dbo].[INC0417492_OP IH]
select  @BICId =  [Set BICID]  from [UniTracHDStorage].[dbo].[INC0417492_OP IH]
select  @BICName =[SET InsuranceCompany, BicName, CompanyName]  from [UniTracHDStorage].[dbo].[INC0417492_OP IH]


update INTERACTION_HISTORY 
set special_handling_xml.modify('replace value of (/SH/OwnerPolicy/BicId/text())[1] with sql:variable("@BICId")')
--, special_handling_xml.replace('replace value of (/SH/OwnerPolicy/BicName/text())[1] with sql:variable("@BICName")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID = @IHID

select  [Set BICID]  from [UniTracHDStorage].[dbo].[INC0417492_OP IH]


select * from [UniTracHDStorage].[dbo].[INC0417492_OP IH]






select * from [UniTracHDStorage].[dbo].[INC0417492_EScrow]

select BIC_ID,REMITTANCE_ADDR_ID, * from escrow
where id in (select [escrow id] from [UniTracHDStorage].[dbo].[INC0417492_EScrow])


update op set op.BIC_ID = p.[Set BIC_ID] , op.REMITTANCE_ADDR_ID=p.[Set REMITTANCE_ADDR_ID], update_dt = GETDATE(), update_user_tx ='INC0417492',  LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select op.BIC_ID , OP.REMITTANCE_ADDR_ID ,p.[Set BIC_ID]  , P.[Set REMITTANCE_ADDR_ID], *
from  escrow op
join unitrachdstorage..[INC0417492_EScrow] P on op.id= p.[escrow id]



select * from [UniTracHDStorage].[dbo].[INC0417492_EScrow IH]