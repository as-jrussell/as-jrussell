use Unitrac

/* This SQL Update script will update the 'Uses UTL 2.0 Processing' switch for the first
   5 lenders (Lender Codes:  Mid-Minn # 1630, Credit Acceptance # 5310, Space Coast # 2252, Pen Fed # 2771, Texas Dow # 8500.)
   The script will generate a temp table of Lender IDs from a list of Lender Codes and insert
   an entry into the Related Data table switching the Lender to be a UTL 2.0 Lender.  */
SELECT rdd.ID RelatedDataId,
       l.ID LenderId
INTO #temp20Lenders
FROM RELATED_DATA_DEF rdd
    INNER JOIN LENDER l
        ON 1 = 1
WHERE rdd.NAME_TX = 'UTL2.0'
      AND l.CODE_TX IN ( '')
      AND l.TEST_IN = 'N'
      AND l.PURGE_DT IS NULL;
GO


INSERT INTO RELATED_DATA
(
    DEF_ID,
    RELATE_ID,
    VALUE_TX,
    START_DT,
    END_DT,
    COMMENT_TX,
    CREATE_DT,
    UPDATE_DT,
    UPDATE_USER_TX,
    LOCK_ID
)
SELECT RelatedDataId,
       LenderId,
       'true',
       GETDATE(),
       NULL,
       NULL,
       GETDATE(),
       GETDATE(),
       'UTL20Update',
       1
FROM #temp20Lenders;
GO
--DROP TABLE #temp20Lenders;
GO



SELECT l.NAME_TX,
       l.CODE_TX,l.id, l.purge_dt,
       rd.VALUE_TX,
       rd.START_DT,rd.*
    
FROM RELATED_DATA rd
    INNER JOIN LENDER l
        ON l.ID = rd.RELATE_ID
           AND rd.DEF_ID = '183' 
           where  l.code_tx in ('')
order by rd.START_DT ASC ;

/*
update rd
set value_tx = 'true', lock_id = lock_id+1
--select *
FROM RELATED_DATA rd
where id in ()

*/


--select * from #temp20Lenders



select COUNT(L.NAME_TX),  L.NAME_TX, L.Code_TX
FROM RELATED_DATA rd
    INNER JOIN LENDER l
        ON l.ID = rd.RELATE_ID
           AND rd.DEF_ID = '183'
where L.PURGE_DT is NULL and L.TEST_IN = 'N'
and rd.END_DT is  null
group by  L.NAME_TX, L.Code_TX
having COUNT(L.NAME_TX) >= '2'





/*

update rd
set value_tx = 'false'
--select *
FROM RELATED_DATA rd
    INNER JOIN LENDER l
        ON l.ID = rd.RELATE_ID
           AND rd.DEF_ID = '183'
		 
where L.PURGE_DT is NULL and L.TEST_IN = 'N'
and rd.END_DT is  null and L.CODE_TX = '3767'

*/

