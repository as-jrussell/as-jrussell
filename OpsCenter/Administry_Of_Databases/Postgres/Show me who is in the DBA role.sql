-- Show dba_team role itself
SELECT
    rolname AS member_name,
    rolname AS role_name,
    rolsuper,rolinherit,
    rolcreaterole,
    rolcreatedb,
    rolreplication,
    rolbypassrls
FROM
    pg_roles
WHERE
    rolname = 'dba_team'

UNION ALL

-- Show members of dba_team role
SELECT
    member.rolname AS member_name,
    role.rolname AS role_name,
    member.rolsuper, member.rolinherit,
    member.rolcreaterole,
    member.rolcreatedb,
    member.rolreplication,
    member.rolbypassrls
FROM
    pg_auth_members m
    JOIN pg_roles role ON m.roleid = role.oid
    JOIN pg_roles member ON m.member = member.oid
WHERE
    role.rolname = 'dba_team'

ORDER BY
    member_name;

