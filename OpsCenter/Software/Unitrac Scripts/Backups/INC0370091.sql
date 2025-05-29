use UniTrac

--1) Capture all EDI Messages for a given date range
select MI.ID INTO #tmpMessageEDI
FROM MESSAGE MI (NOLOCK)
JOIN DELIVERY_INFO DI (NOLOCK) ON DI.ID = MI.DELIVERY_INFO_ID
JOIN TRADING_PARTNER TP (NOLOCK) ON TP.ID = DI.TRADING_PARTNER_ID  
where TP.TYPE_CD = 'EDI_TP' AND MI.CREATE_DT >= '2018-01-01 00:00:01'  AND MI.CREATE_DT <= '2018-07-04 23:59:59'     
            AND MI.MESSAGE_DIRECTION_CD = 'I'
            AND MI.PROCESSED_IN = 'Y'

--2) Capture all Documents for above Messages
SELECT ID into #tmpDocumentEDI
FROM DOCUMENT
WHERE MESSAGE_ID IN (select ID from #tmpMessageEDI)       

--3) Capture all EDI Txns for a given Lender (by TIN & Date Range)
SELECT id, DATA.value('(/Transaction/InsuranceDocument/LienHolder/@Id)[1]' , 'varchar(20)') [Lienhold_Id]
 into #tmpLienHolder
FROM [TRANSACTION]
WHERE DOCUMENT_ID IN (select ID from #tmpDocumentEDI) AND CREATE_DT >= '2018-01-01 00:00:01'  AND CREATE_DT <= '2018-07-04 23:59:59'  


select * 
into  #tmpTXNEDI
from #tmpLienHolder
where [Lienhold_Id] in ('590808589') 



--5) Transaction Details for above Txns
SELECT DATA.value('(/Transaction/InsuranceDocument/Insured/LastName)[1]' , 'varchar(20)') as LastName,
DATA.value('(/Transaction/InsuranceDocument/Insured/FirstName)[1]' , 'varchar(20)') as FirstName,
DATA.value('(/Transaction/InsuranceDocument/Property/Vehicle/Year)[1]' , 'varchar(20)') as Year,
DATA.value('(/Transaction/InsuranceDocument/Property/Vehicle/Make)[1]' , 'varchar(20)') as Make,
DATA.value('(/Transaction/InsuranceDocument/Property/Vehicle/Model)[1]' , 'varchar(20)') as Model,
DATA.value('(/Transaction/InsuranceDocument/Property/Vehicle/Style)[1]' , 'varchar(20)') as Style,
DATA.value('(/Transaction/InsuranceDocument/Property/Vehicle/VIN)[1]' , 'varchar(20)') as VIN,
DATA.value('(/Transaction/InsuranceDocument/InsuranceCompany/CompanyName)[1]' , 'varchar(40)') as InsCo,
DATA.value('(/Transaction/InsuranceDocument/Policy/@Number)[1]' , 'varchar(40)') as PolNo,
DATA.value('(/Transaction/InsuranceDocument/@InterchangeControlNumber)[1]' , 'varchar(40)') as InterchangeControlNo
FROM [TRANSACTION]
where ID in (select ID from #tmpTXNEDI)

