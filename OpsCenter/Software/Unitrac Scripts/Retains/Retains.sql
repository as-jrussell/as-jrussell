USE UniTrac


--Retains for Loans
SELECT L.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') [Retain], * 
FROM dbo.LOAN L
WHERE  L.LENDER_ID = '' 



--Retains for Collateral
SELECT L.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') [Retain], * 
FROM dbo.LOAN L
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
join lender le on le.id = l.lender_id
WHERE  LE.CODE_TX = '2771'  
--and  C.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') = 'CollateralCodeId'
and l.PURGE_DT is null and c.PURGE_DT is null and L.NUMBER_TX = '1512048528'

--Retains for Property
SELECT P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') [Retain], * 
FROM dbo.LOAN L
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
WHERE  L.LENDER_ID = '' 



--Retains for Property
SELECT RC.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') [Retain], * 
FROM dbo.LOAN L
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
JOIN dbo.REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
WHERE  L.LENDER_ID = '' 
