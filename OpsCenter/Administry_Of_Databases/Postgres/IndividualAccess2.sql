-- ==========================================
-- Script: schema_and_db_privileges.sql
-- Purpose: Show schema-level and database-level privileges for roles
-- Includes: CREATE on schemas, USAGE on schemas, default ACLs, and DB-level privileges
-- ==========================================

WITH my_user AS (
    SELECT ''::TEXT AS username  -- Set to a role like 'db_ddladmin_c' or leave blank for all
),

schema_create_privs AS (
    SELECT 
        n.nspname AS schema,
        r.rolname AS grantee,
        'CREATE' AS privilege
    FROM pg_namespace n
    JOIN pg_roles r ON has_schema_privilege(r.rolname, n.oid, 'CREATE')
    WHERE n.nspname NOT LIKE 'pg_%' AND n.nspname <> 'information_schema'
),

schema_usage_privs AS (
    SELECT 
        n.nspname AS schema,
        r.rolname AS grantee,
        'USAGE' AS privilege
    FROM pg_namespace n
    JOIN pg_roles r ON has_schema_privilege(r.rolname, n.oid, 'USAGE')
    WHERE n.nspname NOT LIKE 'pg_%' AND n.nspname <> 'information_schema'
),

db_level_privs AS (
    SELECT
        current_database() AS schema,
        r.rolname AS grantee,
        unnest(string_to_array(
            CASE
                WHEN has_database_privilege(r.rolname, current_database(), 'CREATE') THEN 'CREATE,' ELSE ''
            END ||
            CASE
                WHEN has_database_privilege(r.rolname, current_database(), 'TEMP') THEN 'TEMP,' ELSE ''
            END ||
            CASE
                WHEN has_database_privilege(r.rolname, current_database(), 'CONNECT') THEN 'CONNECT,' ELSE ''
            END, ',')) AS privilege
    FROM pg_roles r
),

raw_acls AS (
    SELECT 
        defaclnamespace::regnamespace AS schema,
        defaclobjtype AS object_type,
        (regexp_matches(unnest(defaclacl)::text, '^(.+?)=([a-zA-Z]*)/?(.+)?$'))[1] AS grantee,
        (regexp_matches(unnest(defaclacl)::text, '^(.+?)=([a-zA-Z]*)/?(.+)?$'))[2] AS privilege_codes,
        (regexp_matches(unnest(defaclacl)::text, '^(.+?)=([a-zA-Z]*)/?(.+)?$'))[3] AS grantor_of_privileges
    FROM pg_default_acl
),

interhited_roles AS (
    SELECT
        r.rolname AS role_name,
        ARRAY_AGG(m.rolname) AS inherited_role
    FROM pg_roles r
    LEFT JOIN pg_auth_members am ON r.oid = am.member
    LEFT JOIN pg_roles m ON am.roleid = m.oid
    GROUP BY r.rolname
),

expanded_defaults AS (
    SELECT *,
        CASE
            WHEN privilege_codes IS NULL THEN NULL
            ELSE array_to_string(
                ARRAY[
                    CASE WHEN privilege_codes LIKE '%a%' THEN 'INSERT' END,
                    CASE WHEN privilege_codes LIKE '%r%' THEN 'SELECT' END,
                    CASE WHEN privilege_codes LIKE '%w%' THEN 'UPDATE' END,
                    CASE WHEN privilege_codes LIKE '%d%' THEN 'DELETE' END,
                    CASE WHEN privilege_codes LIKE '%D%' THEN 'TRUNCATE' END,
                    CASE WHEN privilege_codes LIKE '%x%' THEN 'REFERENCES' END,
                    CASE WHEN privilege_codes LIKE '%t%' THEN 'TRIGGER' END,
                    CASE WHEN privilege_codes LIKE '%X%' THEN 'EXECUTE' END
                ], ', '
            )
        END AS readable_privileges
    FROM raw_acls
)

SELECT 
    schema,
    grantee,
    privilege,
    inherited_role,
    'actual_schema_privilege' AS source
FROM schema_create_privs
LEFT JOIN interhited_roles ON schema_create_privs.grantee = interhited_roles.role_name
WHERE schema::text <> 'public'
  AND (
    (SELECT username FROM my_user) = ''
    OR grantee = (SELECT username FROM my_user)
)

UNION ALL

SELECT 
    schema,
    grantee,
    privilege,
    inherited_role,
    'actual_schema_privilege' AS source
FROM schema_usage_privs
LEFT JOIN interhited_roles ON schema_usage_privs.grantee = interhited_roles.role_name
WHERE schema::text <> 'public'
  AND (
    (SELECT username FROM my_user) = ''
    OR grantee = (SELECT username FROM my_user)
)

UNION ALL

SELECT 
    schema,
    grantee,
    privilege,
    inherited_role,
    'actual_database_privilege' AS source
FROM db_level_privs
LEFT JOIN interhited_roles ON db_level_privs.grantee = interhited_roles.role_name
WHERE schema::text <> 'public'
  AND (
    (SELECT username FROM my_user) = ''
    OR grantee = (SELECT username FROM my_user)
)

UNION ALL

SELECT 
    schema::text,
    grantee,
    readable_privileges,
    inherited_role,
    'default_acl' AS source
FROM expanded_defaults
LEFT JOIN interhited_roles ON expanded_defaults.grantee = interhited_roles.role_name
WHERE schema::text <> 'public'
  AND (
    (SELECT username FROM my_user) = ''
    OR grantee = (SELECT username FROM my_user)
)

ORDER BY grantee, schema, privilege;
