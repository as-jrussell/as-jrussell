USE PremAcc3

SELECT Report_Query_1,* FROM dbo.Report_List
WHERE Report_Query_1 like '%select RELATE_ID, VALUE_TX from RELATED_DATA
left outer join RELATED_DATA_DEF on RELATED_DATA_DEF.ID = RELATED_DATA.DEF_ID 
where 
1=1%'

select Run_After, Started [Start], Finished, E_Mail_Sent, Notify_Sent,*
from ScheduleParameters
WHERE Report_List_ID in (541)
ORDER BY Started DESC 

--ensure you are looking at ID for schedule paraments not report ID 
UPDATE  ScheduleParameters
SET     Run_AFter = '6/01/2016' ,
        Started = NULL ,
        Finished = NULL ,
        E_Mail_Sent = NULL ,
        Notify_Sent = NULL

WHERE   ID IN (541)

