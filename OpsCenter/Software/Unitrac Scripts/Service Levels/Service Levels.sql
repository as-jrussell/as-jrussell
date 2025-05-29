use unitrac



---service level for lenders
select * from RELATED_DATA_DEF
where id = 194

--definition of Service Level
select * from ref_code 
where domain_cd = 'ServiceLevel'


/*

Colors as of 11/7/2018 (Subject to Change)

SECURE - Orange
PROTECT - Green
SHIELD  - Blue

*/

---Lenders that are active and their service level
select L.NAME_TX, L.CODE_TX, RD.* from RELATED_DATA rd
join lender l on l.id = rd.RELATE_ID
where def_id = 194 


/*

--Manual Inserting ServiceLevels Colors
SELECT rdd.ID RelatedDataId,
       l.ID LenderId
INTO #temp20Lenders
FROM RELATED_DATA_DEF rdd
    INNER JOIN LENDER l
        ON 1 = 1
WHERE rdd.NAME_TX = 'ServiceLevel'
      AND l.CODE_TX IN ( '5030')
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
       '',
       GETDATE(),
       NULL,
       NULL,
       GETDATE(),
       GETDATE(),
       '',
       1
FROM #temp20Lenders;
GO
--DROP TABLE #temp20Lenders;
GO

*/


update rd set VALUE_TX = 'SHIELD'
--select L.NAME_TX, L.CODE_TX, RD.* 
from RELATED_DATA rd
join lender l on l.id = rd.RELATE_ID
where def_id = 194 
and l.CODE_TX IN ( '3068')
--SHIELD

