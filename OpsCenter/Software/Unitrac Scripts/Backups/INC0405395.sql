USE UniTrac

select * from lender 
where code_tx = '6681'

--Retains for Property
SELECT  P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') [Retain],
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [2]', 'varchar (max)') [Retain2],
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [3]', 'varchar (max)') [Retain3],
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [4]', 'varchar (max)') [Retain4],
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [5]', 'varchar (max)') [Retain5],
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [6]', 'varchar (max)') [Retain6],
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [7]', 'varchar (max)') [Retain7],
P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [8]', 'varchar (max)') [Retain8],
P.FIELD_PROTECTION_XML.value('(/FP/Field/name/@bv) [1]', 'varchar (max)') [Retain9],
P.*
--into unitrachdstorage.. INC0405395
FROM dbo.LOAN L
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
WHERE  L.LENDER_ID = '1023'-- and P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') like '%address%'
and p.id  = 196268





select 
FIELD_PROTECTION_XML.value('(/FP/Field/name/@bv) [1]', 'varchar (max)') [Retain9],* from  unitrachdstorage.. INC0405395
where id  = 196268

update p
set FIELD_PROTECTION_XML = l.FIELD_PROTECTION_XML
--select *
from dbo.PROPERTY P
join unitrachdstorage.. INC0405395 l on p.id = l.id
where p.id in (196268) 
and P.FIELD_PROTECTION_XML.value('(/FP/Field/@name) [1]', 'varchar (max)') like '%address%'



	
		BEGIN			
			-- Change value of PolicyExcludesWind
			update P
			set --FIELD_PROTECTION_XML.modify('replace value of (/FP/Field/name[. = sql:variable("Address.Line1")]/text())[1] with sql:variable("@''")'),
			FIELD_PROTECTION_XML.modify('delete /FP/Field/[text() = "Address.Line1"]'),
			UPDATE_DT = getdate(), UPDATE_USER_TX = 'Task40213',
			LOCK_ID = (LOCK_ID % 255) + 1
			--select *
			from dbo.PROPERTY P
			where id in (196268) 	
		END	

		SET @xml.modify('delete /cat/Cats/AmericanShorthair[text() = "Tiger3"]')