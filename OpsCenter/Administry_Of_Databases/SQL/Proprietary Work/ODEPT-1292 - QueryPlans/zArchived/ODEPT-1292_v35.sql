WITH XMLNAMESPACES (
    'http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS sp
)
SELECT
    q.query_text,
    COUNT(mi.value('(./@Database)[1]', 'NVARCHAR(MAX)')) AS MissingIndexCount
FROM
    sys.dm_exec_query_stats AS qs
    CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
    CROSS APPLY qp.query_plan.nodes('//sp:MissingIndexGroup/sp:MissingIndex') AS mi(mi)
    CROSS APPLY (SELECT qp.query_plan.value('(/sp:ShowPlanXML/sp:BatchSequence/sp:Batch/sp:Statements/sp:StmtSimple/@StatementText)[1]', 'NVARCHAR(MAX)')) AS q(query_text)
GROUP BY
    q.query_text
HAVING
    COUNT(mi.value('(./@Database)[1]', 'NVARCHAR(MAX)')) > 1;
