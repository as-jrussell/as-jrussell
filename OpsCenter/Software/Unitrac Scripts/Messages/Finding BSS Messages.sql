---Before running script, get as much information as you can from user if user haven't already ensure they give you a date 
---and approx time frame to look for and any information they typed in
---In CreateDate below place date the user remember placing the BSS message into the BSS portal
---Once ran look around the time frame that the stated, copy and Paste TempestID paths until you find the 
---correct path then scroll over until you find the ID

SELECT * FROM vut..tblImageQueue
WHERE STATUS_CD = 'PEND'
AND CreatedDate >= '2020-06-01'

WHERE TempestID LIKE '%UTImage%' AND CreatedDate >= '2016-06-20 16:00 ' AND IMAGE_SOURCE_CD = 'BSS' --AND ID IN (15815368)
--AND LastModifiedDate IS NOT NULL
ORDER BY CreatedDate DESC

SELECT * FROM vut..tblImageQueue
WHERE TempestID LIKE '%\\UNITRAC\VUT_IMAGES\2020\06\10\UT-ALLIED\CM50162130201\CM50162130201-E1KVP.TIF%'
AND CreatedDate >= '2020-06-01'

---Once you have found the ID place in the Relate ID 
SELECT * FROM dbo.WORK_ITEM
WHERE RELATE_TYPE_CD = 'Allied.UniTrac.KeyImage' AND RELATE_ID IN (15815368)
--15815368



---Add the Current_Queue ID below to find which Work Queue it is in. 
---IF the user is looking for it.
 SELECT * FROM dbo.WORK_QUEUE
 WHERE ID IN (11)

 ---Place in the date from above and the Current Queue from above 
 ---to get a count of how many other WI are in queue from that day
 SELECT COUNT(*) [BSS Unknown Lender Images] FROM dbo.WORK_ITEM
 WHERE CURRENT_QUEUE_ID = 'XX' AND CREATE_DT >= 'xxxx-xx-xx'


  SELECT * FROM dbo.WORK_ITEM
 WHERE RELATE_TYPE_CD = 'Allied.UniTrac.KeyImage' and CREATE_DT >= '2015-11-30'
 ORDER BY CREATE_DT ASC
 --15814747





---If the user is able to provide you with message IDs
---query below to see if they have been processed
---Inbound
 SELECT * FROM dbo.MESSAGE
 WHERE ID IN (4953293,4953294)

---Outbound
 SELECT * FROM dbo.MESSAGE
 WHERE RELATE_ID_TX IN (4953293,4953294)


 SELECT DATA.value('(/Transaction/@RelateId) [1]', 'varchar (50)')[ID for tblQueue],* FROM dbo.[TRANSACTION]
 WHERE DOCUMENT_ID IN (SELECT ID FROM dbo.DOCUMENT WHERE MESSAGE_ID IN (SELECT ID FROM dbo.MESSAGE  WHERE ID IN (4949364,4949365)))

 ---See where they are in the queue - this is for inbound only
SELECT  TP.EXTERNAL_ID_TX ,
        TP.NAME_TX ,
        TP.TYPE_CD ,
        M.ID ,
        M.CREATE_DT ,
        M.UPDATE_DT ,
        M.UPDATE_USER_TX
FROM    message M
        JOIN TRADING_PARTNER TP ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID
WHERE   M.PROCESSED_IN = 'N'
        AND M.RECEIVED_STATUS_CD = 'RCVD'
        AND M.MESSAGE_DIRECTION_CD = 'I'
        AND TP.TYPE_CD = 'BSS_TP'
ORDER BY TP.TYPE_CD DESC ,
        M.CREATE_DT ASC 
