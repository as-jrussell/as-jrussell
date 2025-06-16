WITH raw_acls AS (
    SELECT 
        defaclrole::regrole AS grantor,
        defaclnamespace::regnamespace AS schema,
        defaclobjtype AS object_type,
        (regexp_matches(unnest(defaclacl)::text, '^(.+?)=([a-zA-Z]*)/?(.+)?$'))[1] AS grantee,
        (regexp_matches(unnest(defaclacl)::text, '^(.+?)=([a-zA-Z]*)/?(.+)?$'))[2] AS privilege_codes,
        (regexp_matches(unnest(defaclacl)::text, '^(.+?)=([a-zA-Z]*)/?(.+)?$'))[3] AS grantor_of_privileges
    FROM pg_default_acl
),
expanded AS (
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
    grantor,
    schema,
    object_type,
    grantee,
    readable_privileges
FROM expanded
ORDER BY schema, object_type, grantee;
