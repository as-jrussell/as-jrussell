WITH schema_create_privs AS (
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

raw_acls AS (
    SELECT 
        defaclnamespace::regnamespace AS schema,
        defaclobjtype AS object_type,
        (regexp_matches(unnest(defaclacl)::text, '^(.+?)=([a-zA-Z]*)/?(.+)?$'))[1] AS grantee,
        (regexp_matches(unnest(defaclacl)::text, '^(.+?)=([a-zA-Z]*)/?(.+)?$'))[2] AS privilege_codes,
        (regexp_matches(unnest(defaclacl)::text, '^(.+?)=([a-zA-Z]*)/?(.+)?$'))[3] AS grantor_of_privileges
    FROM pg_default_acl
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
    'actual_schema_privilege' AS source
FROM schema_create_privs

UNION ALL

SELECT 
    schema,
    grantee,
    privilege,
    'actual_schema_privilege' AS source
FROM schema_usage_privs

UNION ALL

SELECT 
    schema::text,
    grantee,
    readable_privileges,
    'default_acl' AS source
FROM expanded_defaults
ORDER BY grantee, schema, privilege;
