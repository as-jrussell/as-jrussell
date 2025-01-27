use unitrac 

--drop table #tmpWI
SELECT 
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[2]', 'varchar (50)') ProcessID2,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[3]', 'varchar (50)') ProcessID3,
L.NAME_TX [Lender], L.CODE_TX [Lender Code],
WI.* 
into #tmpWI
FROM dbo.WORK_ITEM WI
LEFT JOIN dbo.LENDER L ON L.ID = WI.LENDER_ID
WHERE wi.id = 58508086


--select * from #tmpWI

select 
 INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (max)'),
* from process_log_item
where (process_log_id in (select processId from #tmpWI)
or  process_log_id in (select processId2 from #tmpWI)
or  process_log_id in (select processId3 from #tmpWI))
and  status_cd= 'ERR' and relate_type_cd = 'Allied.UniTrac.Loan'


select 
 INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (max)'),
* from process_log_item
where (process_log_id in (select processId from #tmpWI)
or  process_log_id in (select processId2 from #tmpWI)
or  process_log_id in (select processId3 from #tmpWI))
and  status_cd= 'ERR' and relate_type_cd = 'Allied.UniTrac.Loan'


SELECT *
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID 
WHERE LL.CODE_TX = '3124' AND L.ID IN (153860485,264337216,153859502,153859782,153858116,153859848)

select * from property
where id in (126594345)

select * from collateral
where property_id = 126594345


SELECT L.* 
INTO  UniTracHDStorage..INC0293671_L
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX = '3124' AND L.ID IN (153860485,264337216,153859502,153859782,153858116,153859848)




SELECT C.* 
INTO  UniTracHDStorage..INC0293671_C
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX = '3124' AND L.ID IN (153860485,264337216,153859502,153859782,153858116,153859848)



SELECT P.* 
INTO  UniTracHDStorage..INC0293671_P
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX = '3124' AND L.ID IN (153860485,264337216,153859502,153859782,153858116,153859848)



SELECT OL.*
INTO  UniTracHDStorage..INC0293671_OL
 FROM LOAN L
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX = '3124' AND L.ID IN (153860485,264337216,153859502,153859782,153858116,153859848)




update ol set primary_in = 'Y', update_dt = GETDATE(), update_user_tx = 'INC0293671',  LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select ol.*
 FROM LOAN L
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
where ol.id = 270192141



update C set PRIMARY_LOAN_IN = 'Y', update_dt = GETDATE(), update_user_tx = 'INC0293671',  LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select * 
from collateral C
where property_id = 126594345
and loan_id = ''


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0293671' , 'N' , 
 GETDATE() ,  1 , 
'Make This Loan Primary to the Collateral', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0293671_L)




INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Collateral' , L.ID , 'INC0293671' , 'N' , 
 GETDATE() ,  1 , 
'Make This Loan Primary to the Collateral', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Collateral' , L.ID , 'PEND' , 'N'
FROM collateral L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0293671_C)





INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Owner' , L.ID , 'INC0293671' , 'N' , 
 GETDATE() ,  1 , 
'Make This Loan Primary to the Owner', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Owner' , L.ID , 'PEND' , 'N'
FROM OWNER_LOAN_RELATE L 
WHERE L.ID IN (SELECT OWNER_ID FROM UniTracHDStorage..INC0293671_OL)



-----BACKUP

update ol set primary_in = LO.primary_in, update_dt = GETDATE(), update_user_tx = 'INC0293671',  LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select ol.*
 FROM LOAN L
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
inner join UniTracHDStorage..INC0293671_OL LO on LO.ID = OL.ID



update C set PRIMARY_LOAN_IN = D.PRIMARY_LOAN_IN, update_dt = GETDATE(), update_user_tx = 'INC0293671',  LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select * 
from collateral C
JOIN  UniTracHDStorage..INC0293671_C D ON D.ID = C.ID 
where property_id = 126594345
and loan_id = ''
