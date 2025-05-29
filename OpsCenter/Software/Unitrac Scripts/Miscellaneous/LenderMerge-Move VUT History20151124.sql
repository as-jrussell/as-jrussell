--- 1689 - Spire CU - acquired 6145 - Greater MN
---- 6145 to 1689
/*
select RegionID , lndr.LenderKey ,  * from Timmay.VUT.dbo.tblLender lndr
join Timmay.VUT.dbo.tblCenter cntr on cntr.CenterKey = lndr.CenterKey
 where lenderid in ('6454' , '2005' )

 --2928- 10860 - WES
 --4220- 357 - MID


EST-764	1	2005	Verve a Credit Union
MID-44	30	6454	Community CU (WI)

 


 select COUNT(*) from [VUT-DB01].MID.dbo.tblCustomer where LenderKey = 448

  select * from [VUT-DB01].MID.dbo.tblCustomer where LenderKey = 448

 ----24701
*/
 
 select RegionID , lndr.LenderKey ,  * from Timmay.VUT.dbo.tblLender lndr
join Timmay.VUT.dbo.tblCenter cntr on cntr.CenterKey = lndr.CenterKey
 where lenderid in ('2928' , '4220', '6454' , '2005')


 SELECT * FROM VUT..tblLender
 WHERE LEnderID IN ('6454', '2005')


 select * into #tmp6454_Cust from [VUT-DB01].MID.dbo.tblCustomer where LenderKey = 448
---- 24701

--select MAX(ContractHistoryintid) from [VUT-DB01].MID.dbo.tblContractHistory07
----- 9374703

---- DROP TABLE #tmpHist_01
select * INTO #tmpHist_01 FROM [VUT-DB01].MID.dbo.tblContractHistory04 where 1 = 2

Alter Table #tmpHist_01
Add idx int identity(1, 1)
 

Insert into #tmpHist_01
( CustomerKey, ContractKey, CollateralKey, CoverageKey, FieldFriendlyName,OriginalValue,NewValue,UserID,PolicyEffectiveDate,
PolicyEndDate,Action,Memo,CalculatePremIssCxl ,EndorseORPaidPrem ,HistoryType, PolicyBasis,StatusDate,BorrInsCompanyName ,PolicyNumber,
Officer,PreVUT ,MailDate,ScanDate ,TempestID,OBCallKey,CreatedDate, SortCreatedDate,InhouseOnly, TempestIDBak 
  ) 
Select CH.CustomerKey, ContractKey, CollateralKey, CoverageKey, FieldFriendlyName,OriginalValue,NewValue,UserID,PolicyEffectiveDate,
PolicyEndDate,Action,Memo,CalculatePremIssCxl ,EndorseORPaidPrem ,HistoryType, PolicyBasis,StatusDate,BorrInsCompanyName ,PolicyNumber,
Officer,PreVUT ,MailDate,ScanDate ,TempestID,OBCallKey,CH.CreatedDate, SortCreatedDate,InhouseOnly, TempestIDBak 
--- select count(*)
from [VUT-DB01].MID.dbo.tblContractHistory08 CH (nolock) join #tmp6454_Cust c on 
c.CustomerKey = CH.CustomerKey
---- 109898


Insert into tblContractHistory04
( CustomerKey, ContractKey, CollateralKey, CoverageKey, FieldFriendlyName,OriginalValue,NewValue,UserID,PolicyEffectiveDate,
PolicyEndDate,Action,Memo,CalculatePremIssCxl ,EndorseORPaidPrem ,HistoryType, PolicyBasis,StatusDate,BorrInsCompanyName ,PolicyNumber,
Officer,PreVUT ,MailDate,ScanDate ,TempestID,OBCallKey,CreatedDate, SortCreatedDate,InhouseOnly, TempestIDBak ---,ContractHistoryintid 
) 
Select CH.CustomerKey, ContractKey, CollateralKey, CoverageKey, FieldFriendlyName,OriginalValue,NewValue,UserID,PolicyEffectiveDate,
PolicyEndDate,Action,Memo,CalculatePremIssCxl ,EndorseORPaidPrem ,HistoryType, PolicyBasis,StatusDate,BorrInsCompanyName ,PolicyNumber,
Officer,PreVUT ,MailDate,ScanDate ,TempestID,OBCallKey,CH.CreatedDate, SortCreatedDate,InhouseOnly, TempestIDBak --,
--9346297 + idx as ContractHistoryintid
---- select count(*)
from #tmpHist_01 CH
---- 143423



----- for VUT History
---- drop table #tmpHist
select top 1 * into #tmpHist from [VUT-DB01].MIDHistory.dbo.tblContractHistory04 where 1 = 2

Alter Table #tmpHist
Add idx int identity(1, 1)



Insert into #tmpHist
( CustomerKey, ContractKey, CollateralKey, CoverageKey, FieldFriendlyName,OriginalValue,NewValue,UserID,PolicyEffectiveDate,
PolicyEndDate,Action,Memo,CalculatePremIssCxl ,EndorseORPaidPrem ,HistoryType, PolicyBasis,StatusDate,BorrInsCompanyName ,PolicyNumber,
Officer,PreVUT ,MailDate,ScanDate ,TempestID,OBCallKey,CreatedDate, SortCreatedDate,InhouseOnly, TempestIDBak  ) 
Select CH.CustomerKey, ContractKey, CollateralKey, CoverageKey, FieldFriendlyName,OriginalValue,NewValue,UserID,PolicyEffectiveDate,
PolicyEndDate,Action,Memo,CalculatePremIssCxl ,EndorseORPaidPrem ,HistoryType, PolicyBasis,StatusDate,BorrInsCompanyName ,PolicyNumber,
Officer,PreVUT ,MailDate,ScanDate ,TempestID,OBCallKey,CH.CreatedDate, SortCreatedDate,InhouseOnly, TempestIDBak
---- select count(*)
from [VUT-DB01].MIDHistory.dbo.tblContractHistory08 CH (nolock) join #tmp6454_Cust c on 
c.CustomerKey = CH.CustomerKey
--- 361766

--select MAX(ContractHistoryintid) from [VUT-DB01].MSTHistory.dbo.tblContractHistory04
---- 11466737

--select MAX(ContractHistoryintid) from [VUT-DB01].ESTHistory.dbo.tblContractHistory04
--- 7536689


----- VUTHistory also
Insert into ESTHistory.dbo.tblContractHistory04
( CustomerKey, ContractKey, CollateralKey, CoverageKey, FieldFriendlyName,OriginalValue,NewValue,UserID,PolicyEffectiveDate,
PolicyEndDate,Action,Memo,CalculatePremIssCxl ,EndorseORPaidPrem ,HistoryType, PolicyBasis,StatusDate,BorrInsCompanyName ,PolicyNumber,
Officer,PreVUT ,MailDate,ScanDate ,TempestID,OBCallKey,CreatedDate, SortCreatedDate,InhouseOnly, TempestIDBak ,ContractHistoryintid ) 
Select CH.CustomerKey, ContractKey, CollateralKey, CoverageKey, FieldFriendlyName,OriginalValue,NewValue,UserID,PolicyEffectiveDate,
PolicyEndDate,Action,Memo,CalculatePremIssCxl ,EndorseORPaidPrem ,HistoryType, PolicyBasis,StatusDate,BorrInsCompanyName ,PolicyNumber,
Officer,PreVUT ,MailDate,ScanDate ,TempestID,OBCallKey,CH.CreatedDate, SortCreatedDate,InhouseOnly, TempestIDBak ,
3814043 + idx as ContractHistoryintid
---- select count(*)
from #tmpHist CH
---- 361766
