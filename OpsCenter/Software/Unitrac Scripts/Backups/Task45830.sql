USE UniTrac

--Retains for Property

select P.* 
into #tmpP
FROM dbo.LOAN L
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
WHERE L.LENDER_ID = '835'



--DROP TABLE #tmpPP
SELECT P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') [Retain],
 P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [2]', 'varchar (max)') [Retain Field 2], 
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [3]', 'varchar (max)') [Retain Field 3],
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [4]', 'varchar (max)') [Retain Field 4], 
 P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [5]', 'varchar (max)') [Retain Field 5], 
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [6]', 'varchar (max)') [Retain Field 6], 
 P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [7]', 'varchar (max)') [Retain Field 7], 
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [8]', 'varchar (max)') [Retain Field 8], P.ID [Property_ID]
into #tmpPP
FROM
dbo.PROPERTY P
join #tmpP on #tmpP.id = P.id
WHERE 
 P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') = 'VIN' OR
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [2]', 'varchar (max)') = 'VIN'
OR  P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [3]', 'varchar (max)') = 'VIN'
OR  P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [4]', 'varchar (max)') = 'VIN'
OR  P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [5]', 'varchar (max)') = 'VIN'
OR  P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [6]', 'varchar (max)') = 'VIN'
OR  P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [7]', 'varchar (max)') = 'VIN'
OR  P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [8]', 'varchar (max)') = 'VIN'



SELECT 

count(*) ,L.RECORD_TYPE_CD
--into JCS..Task45830
FROM dbo.LOAN L
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
join #tmpPP  PPP on PPP.Property_ID = P.ID
where L.Purge_dt is null  
group by L.RECORD_TYPE_CD



use unitrac

select P.FIELD_PROTECTION_XML.value('(/FP/Field/@bv) [1]', 'varchar (max)') [VIN label] , P.VIN_TX, L.NUMBER_TX,
C.RETAIN_IN, L.RETAIN_IN, L.RETAIN_UTL_IN, P.Field_protection_xml, P.*
--into JCS..Task45830_ActiveOnly
FROM dbo.LOAN L
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
join #tmpPP  PPP on PPP.Property_ID = P.ID
where L.Purge_dt is null  and L.RECORD_TYPE_CD NOT IN ('D', 'A')
and P.FIELD_PROTECTION_XML.value('(/FP/Field/@bv) [1]', 'varchar (max)') is not null



--drop table JCS..Task45830_ActiveOnly



SELECT P.FIELD_PROTECTION_XML.value('(/FP/Field/@bv) [1]', 'varchar (max)') [Retain],
 P.FIELD_PROTECTION_XML.value('(/FP/Field/@bv) [2]', 'varchar (max)') [Retain Field 2], 
P.FIELD_PROTECTION_XML.value('(/FP/Field/@bv) [3]', 'varchar (max)') [Retain Field 3],
P.FIELD_PROTECTION_XML.value('(/FP/Field/@bv) [4]', 'varchar (max)') [Retain Field 4], 
 P.FIELD_PROTECTION_XML.value('(/FP/Field/@bv) [5]', 'varchar (max)') [Retain Field 5], 
P.FIELD_PROTECTION_XML.value('(/FP/Field/@bv) [6]', 'varchar (max)') [Retain Field 6], 
 P.FIELD_PROTECTION_XML.value('(/FP/Field/@bv) [7]', 'varchar (max)') [Retain Field 7], 
P.FIELD_PROTECTION_XML.value('(/FP/Field/@bv) [8]', 'varchar (max)') [Retain Field 8], P.ID [Property_ID]
, *
FROM
dbo.PROPERTY P
join #tmpP on #tmpP.id = P.id
WHERE 
 P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') = 'VIn'