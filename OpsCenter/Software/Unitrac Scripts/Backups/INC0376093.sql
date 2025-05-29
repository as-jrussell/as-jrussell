USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.NUMBER_TX, L.*
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
inner join dbo.REQUIRED_COVERAGE RC on RC.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID 
WHERE LL.CODE_TX IN ('3838') 
AND L.NUMBER_TX IN ( '80477','727412') 


select * from #tmpIH

--drop table #tmpIH
select DISTINCT L.ID [Lender_id], P.ID [Prop_ID], LL.[Insurance Company] [InsuranceCo]
into #tmpIH
FROM INTERACTION_HISTORY IH
JOIN PROPERTY P ON IH.PROPERTY_ID = P.ID 
JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID
JOIN LOAN L ON L.ID = C.LOAN_ID
join UniTracHDStorage..Lender3838 LL on LL.[Acct # (LNMA)] = L.NUMBER_TX
where p.id not in (237533204,237533627)
--7808

INSERT into INTERACTION_HISTORY (TYPE_CD, LOAN_ID, PROPERTY_ID, REQUIRED_COVERAGE_ID, DOCUMENT_ID, EFFECTIVE_DT, EFFECTIVE_ORDER_NO, ISSUE_DT, NOTE_TX, SPECIAL_HANDLING_XML, alert_in, pending_in, in_house_onLY_in,RELATE_CLASS_TX, RELATE_ID, CREATE_DT, CREATE_USER_TX, UPDATE_DT, UPDATE_USER_TX, PURGE_DT, LOCK_ID, DELETE_ID, ARCHIVED_IN)
SELECT distinct 'MEMO', I.Lender_id, I.Prop_ID, null, null, GETDATE(), '0.00', GETDATE(), I.InsuranceCo, null, 'N', 'N', 'N', NULL, NULL, GETDATE(), 'INC0376093', GETDATE(), 'INC0376093', NULL, '1', NULL, 'N'
--select *
FROM INTERACTION_HISTORY IH
JOIN PROPERTY P ON IH.PROPERTY_ID = P.ID 
join #tmpIH I on I.Prop_ID = P.ID 
WHERE p.id in (select i.Prop_ID from #tmpIH)




--SELECT DISTINCT 'MEMO', L.ID, P.ID--, REQUIRED_COVERAGE_ID, DOCUMENT_ID, EFFECTIVE_DT, EFFECTIVE_ORDER_NO, ISSUE_DT, NOTE_TX, SPECIAL_HANDLING_TX, alert_in, pending_in, in_house_onLY_in, RELATE_CLASS_TX, RELATE_ID, CREATE_DT, CREATE_USER_TX, UPDATE_DT, UPDATE_USER_TX, PURGE_DT, LOCK_ID, DELETE_ID
select ih.*
FROM INTERACTION_HISTORY IH
JOIN PROPERTY P ON IH.PROPERTY_ID = P.ID 
JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID
JOIN LOAN L ON L.ID = C.LOAN_ID
join UniTracHDStorage..Lender3838 LL on LL.[Acct # (LNMA)] = L.NUMBER_TX
WHERE ih.ID IN (458713004)

--STATE FARM INSURANCE                                   


select  concat('Insurance: ''', [Insurance Company],' 
','Agent Name: ',[Agent Name], ' ','Agent Number: ', [AgentPhone],'
','Policy Number: ',[Policy Number]
)[Memo], [Acct # (LNMA)] AS NUMBER_TX
into #tmp
 from UniTracHDStorage..Lender3838


select * from UniTracHDStorage..Lender3838


select * from #tmp
update IH SET NOTE_TX = T.MEMO
--select *
FROM INTERACTION_HISTORY IH
JOIN PROPERTY P ON IH.PROPERTY_ID = P.ID 
join #tmpIH I on I.Prop_ID = P.ID 
join COLLATERAL C on C.PROPERTY_ID = P.ID
join LOAN L on L.ID = C.LOAN_ID
join #tmp T on T.NUMBER_TX = L.NUMBER_TX
WHERE p.id in (select i.Prop_ID from #tmpIH) and ih.UPDATE_USER_TX = 'INC0376093'
--7796

select P.id into #tmpP
 from loan l
join collateral c on l.id = c.loan_id
join property P on P.id = C.PROPERTY_ID
where L.NUMBER_TX IN (select NUMBER_TX from #tmp) and l.LENDER_ID = 2417

