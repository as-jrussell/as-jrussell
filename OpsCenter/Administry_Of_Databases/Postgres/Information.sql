-- Replace 'your_role' and 'your_schema'
SELECT
    n.nspname AS schema_name,
    has_schema_privilege('lendinginsights', n.nspname, 'USAGE') AS has_usage
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




SELECT rolname, rolinherit
FROM pg_roles
WHERE rolname = 'lendinginsights';



-- Who owns the tables?
SELECT 
    schemaname,
    tablename,
    tableowner
FROM pg_tables
WHERE schemaname NOT LIKE 'pg_%' AND schemaname <> 'information_schema';
