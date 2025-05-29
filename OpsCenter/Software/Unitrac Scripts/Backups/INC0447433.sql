USE [UniTrac]
GO 


/* Capture your data for you are looking for:
identifiable information that will need to replaced is the lender and the dates that the user given. 
(if not do all but please verify with user)
*/
SELECT L.NUMBER_TX, ih.SPECIAL_HANDLING_XML.value('(/SH/Desc)[1]', 'varchar (50)') [SmartVideo],
IH.* FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
inner join dbo.REQUIRED_COVERAGE RC on RC.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID 
WHERE ih.TYPE_CD = 'NOTICE' and ih.SPECIAL_HANDLING_XML.value('(/SH/Desc)[1]', 'varchar (50)') = 'SmartVideo'
and LL.CODE_TX IN ('1940')  and ih.effective_dt between '2018-12-06' and '2019-01-09'
order by ih.effective_dt desc 

---Always make a backup of your work for best practice use ticket number
SELECT L.NUMBER_TX, ih.SPECIAL_HANDLING_XML.value('(/SH/Desc)[1]', 'varchar (50)') [SmartVideo],
IH.* 
INTO unitrachdstorage..INC0447433
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
inner join dbo.REQUIRED_COVERAGE RC on RC.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID 
WHERE ih.TYPE_CD = 'NOTICE' and ih.SPECIAL_HANDLING_XML.value('(/SH/Desc)[1]', 'varchar (50)') = 'SmartVideo'
and LL.CODE_TX IN ('1940')  and ih.effective_dt between '2018-12-06' and '2019-01-09'



/*
At this point the easiest thing to do is to replace INC0XXXXX with the ticket number 
that was used to back up the data throughout the remainder of the query.

Be aware of the ID and the Relate_id they will be used in the remainder queries
*/
select ID, relate_id, * from unitrachdstorage..INC0447433



---Purging the Interaction History 
update IH
set purge_dt = GETDATE(), UPDATE_dt =GETDATE(), update_user_tx = 'INC0447433',LOCK_ID = CASE WHEN ih.LOCK_ID >= 255 THEN 1 ELSE ih.LOCK_ID + 1 END
--select *
from dbo.INTERACTION_HISTORY IH
where id in (select id from unitrachdstorage..INC0447433)


--Purging the notices 
update n
set purge_dt = GETDATE(), UPDATE_dt =GETDATE(), update_user_tx = 'INC0447433',LOCK_ID = CASE WHEN n.LOCK_ID >= 255 THEN 1 ELSE n.LOCK_ID + 1 END
from NOTICE n 
where id in (select RELATE_ID from unitrachdstorage..INC0447433)
