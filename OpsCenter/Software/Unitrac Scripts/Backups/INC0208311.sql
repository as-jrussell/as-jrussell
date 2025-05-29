/* (inserted by DPA)
Procedure: UniTrac.dbo.GetWorkQueueCounts
*/
SELECT wi.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, *
FROM    WORK_QUEUE_WORK_ITEM_RELATE wqwi  
        INNER JOIN WORK_ITEM wi   ON wqwi.WORK_ITEM_ID = wi.ID
        JOIN WORK_QUEUE wq  ON wq.ID = wqwi.WORK_QUEUE_ID
        LEFT JOIN REF_CODE rc   ON wqwi.SLA_LEVEL_NO = rc.CODE_CD
                                                 AND rc.DOMAIN_CD = 'SLALevel'
        LEFT OUTER JOIN ( SELECT    wia.work_item_id ,
                                    MAX(wia.create_dt) AS max_reassign_dt
                          FROM      WORK_ITEM_ACTION wia  
                          WHERE     wia.ACTION_CD = '%'
                                    AND wia.PURGE_DT IS NULL
                          GROUP BY  wia.WORK_ITEM_ID
                        ) wiaRA ON wiaRA.Work_item_id = wi.id
       -- INNER JOIN #USER_LEVELS ur ON ur.USER_ROLE_CD = wi.USER_ROLE_CD
WHERE -- WI.RELATE_TYPE_CD = 'Allied.UniTrac.UTLMatchResult'
--        AND wi.STATUS_CD NOT IN ( 'Complete', 'Withdrawn', 'Error' )
--        AND wi.PURGE_DT IS NULL
--        AND wqwi.PURGE_DT IS NULL
--        AND wq.purge_dt IS NULL
--        AND wqwi.CROSS_QUEUE_COUNT_IND = 'Y'
--		        AND wq.ACTIVE_IN = 'Y' and
wi.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '1007'
ORDER BY CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') ASC
        --AND wi.content_xml.value('Content[1]/Lender[1]/Id[1]', 'bigint') = ISNULL(@lenderId,
        --                                                      wi.content_xml.value('Content[1]/Lender[1]/Id[1]',
        --                                                      'bigint'))



		SELECT * FROM dbo.PROCESS_DEFINITION
		WHERE ID IN (3137)