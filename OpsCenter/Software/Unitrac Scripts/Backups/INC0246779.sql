
USE UniTrac			
declare @wi as varchar(MAX)
declare @ri as int
DECLARE @TID AS int
DECLARE @TranType AS varchar(max)



set @wi = 33578237 


SET @TranType ='UNITRAC'
--SET @TranType ='INFA'


SELECT
@ri = RELATE_ID 
FROM
dbo.WORK_ITEM WI
WHERE
WI.id = @wi
SELECT
@TID = T.ID
FROM
dbo.[TRANSACTION] T
JOIN
dbo.DOCUMENT D
ON T.document_id = D.id
WHERE
D.message_id = @ri and (RELATE_TYPE_CD = @TranType OR T.RELATE_TYPE_CD ='')


SELECT  Customers_XML.value('(/Customers/Customer/CustomerMatchResult/OwnerId)[1]', 'varchar (50)') [OwnerID]
INTO #tmp
  FROM LOAN_EXTRACT_TRANSACTION_DETAIL LETD (NOLOCK) WHERE LETD.TRANSACTION_ID = @TID 
  AND Customers_XML.value('(/Customers/Customer/CustomerMatchResult/Address/Line2)[1]', 'varchar (50)') IS NOT NULL	
  AND Customers_XML.value('(/Customers/Customer/CustomerMatchResult/Address/Line2)[1]', 'varchar (50)') <> ''
  


SELECT  O.LAST_NAME_TX ,
        O.FIRST_NAME_TX ,
        O.MIDDLE_INITIAL_TX ,
                        OA.LINE_1_TX ,
                OA.LINE_2_TX ,
                OA.CITY_TX ,
                OA.STATE_PROV_TX ,
                OA.COUNTRY_TX ,
                OA.POSTAL_CODE_TX ,
				OA.ID INTO #tmp2
			    FROM dbo.OWNER O
JOIN dbo.OWNER_ADDRESS OA ON OA.ID = O.ADDRESS_ID
WHERE O.ID IN (SELECT * FROM #tmp)
AND OA.LINE_2_TX NOT LIKE '[1-9]%'
AND OA.LINE_2_TX NOT LIKE 'PO%'
AND OA.LINE_2_TX NOT LIKE 'P O%'
ORDER BY OA.LINE_2_TX ASC 

SELECT * FROM #tmp2
ORDER BY ID ASC

UPDATE dbo.OWNER_ADDRESS
SET LINE_2_TX = '', UPDATE_DT = GETDATE(),
LOCK_ID = LOCK_ID+1
WHERE ID IN (SELECT ID FROM #tmp2)