use UniTrac


select count(*) 
--SELECT CONVERT(TIME,END_DT- START_DT)[hh:mm:ss:ms], *
from PROCESS_LOG
where PROCESS_DEFINITION_ID = 317276 
AND CREATE_DT > '2023-06-05 21:00:00.400'
AND CONVERT(TIME,END_DT- START_DT) >= '00:01:00.0000000'
AND MSG_TX is not null
--AND CAST(CREATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)


SELECT MAX(ID) 
from PROCESS_LOG
where PROCESS_DEFINITION_ID = 317276 

SELECT TOP 2000 * FROM PROCESS_LOG
--WHERE ID IN (270731713)
where PROCESS_DEFINITION_ID = 317276 
order BY id DESC 

select count(*) 
--SELECT CONVERT(TIME,END_DT- START_DT)[hh:mm:ss:ms], *
from PROCESS_LOG
where PROCESS_DEFINITION_ID = 317276 
AND CAST(CREATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)


select count(*) 
--SELECT CONVERT(TIME,END_DT- START_DT)[hh:mm:ss:ms], *
from PROCESS_LOG
where PROCESS_DEFINITION_ID = 317276 
AND CREATE_DT BETWEEN '2024-04-14 21:00:00.000'
AND  '2024-04-15 07:00:00.000'
--AND CAST(CREATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)



select count(*) 
--SELECT CONVERT(TIME,END_DT- START_DT)[hh:mm:ss:ms], *
from PROCESS_LOG
where PROCESS_DEFINITION_ID = 317276 
AND CREATE_DT BETWEEN '2024-04-14 21:00:00.000'
AND  '2024-04-15 07:00:00.000'
--AND CAST(CREATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)





select[To Go] = 5000 - (select count(*) 
from PROCESS_LOG
where PROCESS_DEFINITION_ID = 317276 
AND CREATE_DT > '2022-06-05 21:00:00.400')

use unitrac

select[To Go] = 7500 - (select count(*) 
from PROCESS_LOG
where PROCESS_DEFINITION_ID = 317276 
AND CREATE_DT > '2022-10-30 21:00:00.000')


IF NOT EXISTS (select DB_NAME() )
	BEGIN
	
			select top 1 CREATE_DT
			FROM PROPERTY_CHANGE pc
					WHERE pc.CREATE_DT < (GETDATE() - 450)
					and ENTITY_NAME_TX not in ('Allied.UniTrac.OwnerPolicyInteraction', 'Allied.UniTrac.DocumentInteraction')
					order by CREATE_DT asc
	END
ELSE 
	BEGIN 

			USE UNITRAC

			select top 1 CREATE_DT
			FROM PROPERTY_CHANGE pc
						WHERE pc.CREATE_DT < (GETDATE() - 450)
						and ENTITY_NAME_TX not in ('Allied.UniTrac.OwnerPolicyInteraction', 'Allied.UniTrac.DocumentInteraction')
						order by CREATE_DT asc
	END


SELECT CONVERT(TIME,END_DT- START_DT)[hh:mm:ss], *
	from PROCESS_LOG
	where PROCESS_DEFINITION_ID = 317276 
	AND CAST(CREATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)
	ORDER BY CREATE_DT DESC 

/*
https://www.timeanddate.com/date/durationresult.html?m1=12&d1=31&y1=2018&m2=12&d2=6&y2=2021&ti=on
			1027 days behind in Production
			1192 days behind in DEV
			1221 days behind in QA2
			1099 days behind in STG

			--March 22, 2022
			975 days behind in Production
			1085 days behind in DEV
			1209 days behind in QA2
			1005 days behind in STG

			--June 6, 2022
			930 days behind in Production
			1061 days behind in DEV
			1203 days behind in QA2
			979  days behind in STG


			--April 3, 2023
			901 days behind in Production


			*/


			select ENTITY_NAME_TX, COUNT(*) from Unitrac.dbo.PROPERTY_CHANGE
			where create_dt BETWEEN '2023-03-18 10:00' AND '2023-03-18 10:30'
			group by ENTITY_NAME_TX
			--order by CREATE_DT desc 


				select ENTITY_NAME_TX, COUNT(*) from Unitrac.dbo.PROPERTY_CHANGE
			where create_dt BETWEEN '2023-03-11 10:00' AND '2023-03-11 10:30'
			group by ENTITY_NAME_TX

			EXEC Unitrac.[dbo].[sp_AlliedPremiumCalculation]
			---Allied.UniTrac.RequiredCoverage	125729









					exec [dbo].[ArchivePropertyChange_Archive_Setting] @WhatIf =0