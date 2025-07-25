/*-- Replace 'your_role' and 'your_schema'
SELECT
    n.nspname AS schema_name,
    has_schema_privilege('dba_team', n.nspname, 'USAGE') AS has_usage
FROM pg_namespace n
WHERE n.nspname NOT LIKE 'pg_%' AND n.nspname <> 'information_schema';



-- Replace 'your_role' and optionally filter by schema
SELECT
    schemaname,
    tablename,
    has_table_privilege('lendinginsights', format('%I.%I', schemaname, tablename), 'SELECT') AS has_select
FROM pg_tables
WHERE schemaname NOT LIKE 'pg_%' AND schemaname <> 'information_schema';



-- Replace 'your_role'
WITH RECURSIVE role_inheritance AS (
    SELECT oid, rolname, ARRAY[rolname] AS path
    FROM pg_roles
    WHERE rolname = 'lendinginsights'
    
    UNION
    
    SELECT m.roleid, r.rolname, ri.path || r.rolname
    FROM pg_auth_members m
    JOIN pg_roles r ON m.roleid = r.oid
    JOIN role_inheritance ri ON m.member = ri.oid
)
SELECT * FROM role_inheritance;




SELECT rolname, rolinherit,*
FROM pg_roles
WHERE rolname = 'lendinginsights';



-- Who owns the tables?
SELECT 
    schemaname,
    tablename,
    tableowner
FROM pg_tables

WHERE schemaname NOT LIKE 'pg_%' AND schemaname <> 'information_schema';



SELECT * FROM INFO.account_log_history


SELECT * FROM INFO.object_log_history



SELECT * FROM INFO.password_change_audit

SELECT
    n.nspname AS schema_name,
    p.proname AS function_name,
    pg_get_function_arguments(p.oid) AS arguments, 
	  format('DROP FUNCTION %I.%I%s;', n.nspname, p.proname, 
         '(' || pg_get_function_identity_arguments(p.oid) || ')') AS drop_sql
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'deploy';  -- or whatever schema you want




*/


SELECT
    r.rolname AS role_name,
    ARRAY_AGG(m.rolname) AS inherited_roles, r.rolcanlogin
FROM
    pg_roles r
LEFT JOIN
    pg_auth_members am ON r.oid = am.member
LEFT JOIN
    pg_roles m ON am.roleid = m.oid
	WHERE r.rolname  like 'db%'
GROUP BY
    r.rolname, r.rolcanlogin
	UNION 
SELECT
    r.rolname AS role_name,
    ARRAY_AGG(m.rolname) AS inherited_roles, r.rolcanlogin
FROM
    pg_roles r
LEFT JOIN
    pg_auth_members am ON r.oid = am.member
LEFT JOIN
    pg_roles m ON am.roleid = m.oid
	WHERE m.rolname like 'db%'
GROUP BY
    r.rolname,r.rolcanlogin
ORDER BY rolcanlogin ASC,  inherited_roles asc










