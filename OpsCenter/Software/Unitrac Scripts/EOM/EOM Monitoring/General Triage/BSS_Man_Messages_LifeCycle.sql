-------- Life Cycle of BSS Message
-------- After submitting Message through Helper Tool, check to find created message
SELECT 
     TP.EXTERNAL_ID_TX, 
     TP.NAME_TX, 
     TP.TYPE_CD, 
     M.* 
FROM message M 
JOIN TRADING_PARTNER TP 
     ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID 
WHERE M.PROCESSED_IN = 'N' 
AND M.RECEIVED_STATUS_CD = 'RCVD' 
AND M.MESSAGE_DIRECTION_CD = 'I' 
ORDER BY TP.TYPE_CD DESC

------ Casting Call, Find Particular Message(s), Pulling BSS_TP Rows
SELECT  *
FROM    UniTrac..MESSAGE
WHERE   ID IN ( 3885437, 3885449, 3885450, 3885457, 3885458, 3885460, 3885461,
                3885462, 3885463, 3885464, 3885465 )

------- Further Casting Call, Check Status                
SELECT  *
FROM    UniTrac..TRADING_PARTNER_LOG
WHERE   MESSAGE_ID IN ( 3885437, 3885449, 3885450, 3885457, 3885458, 3885460,
                        3885461, 3885462, 3885463, 3885464, 3885465 )  

------- Last Casting Call, Look at XML on Transaction, Match Up With Submitted XML
------- Pull Transaction Relate ID From Query (RELATE_ID on Document Container Table, Important!)
SELECT  *
FROM    dbo.[TRANSACTION] T ( NOLOCK )
        JOIN dbo.DOCUMENT D ( NOLOCK ) ON D.ID = T.DOCUMENT_ID
        JOIN dbo.MESSAGE M ( NOLOCK ) ON M.ID = D.MESSAGE_ID
WHERE   M.ID IN ( 3885465 )         
   
------- After Pay Dirt, Go To Document Look At NAME_TX Field for File Name (Confirm It Only)
SELECT * FROM UniTrac..DOCUMENT
WHERE MESSAGE_ID = 3885465 
   
------- Find Document Container Record Assigned to TIFF 
SELECT * FROM UniTrac..DOCUMENT_CONTAINER 
WHERE RELATE_ID = 90643202

------ DOCUMENT_CONTAINER..ID is "Document Name". 
------ Check Image Path on RELATIVE_PATH_TX To find Repository on UniTrac NAS.