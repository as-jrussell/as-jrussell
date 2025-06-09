-- Show table-level privileges
SELECT 
    'TABLE' AS object_type,
    table_schema,
    table_name,
    privilege_type,
    grantee
FROM information_schema.role_table_grants
WHERE grantee = 'lendinginsights'

UNION ALL

-- Show usage on sequences
SELECT 
    'SEQUENCE' AS object_type,
    sequence_schema AS table_schema,
    sequence_name AS table_name,
    privilege_type,
    grantee
FROM information_schema.role_usage_grants
WHERE grantee = 'lendinginsights'

UNION ALL

-- Show function execution privileges
SELECT 
    'FUNCTION' AS object_type,
    routine_schema AS table_schema,
    routine_name AS table_name,
    privilege_type,
    grantee
FROM information_schema.role_routine_grants
WHERE grantee = 'lendinginsights'

ORDER BY object_type, table_schema, table_name;







-- Check what roles a user inherits from
SELECT 
    pg_roles.rolname AS role,
    m.member AS member_oid,
    pg_user.usename AS member_name
FROM pg_auth_members m
JOIN pg_roles ON m.roleid = pg_roles.oid
JOIN pg_user ON m.member = pg_user.usesysid
WHERE pg_user.usename = 'lendinginsights';

