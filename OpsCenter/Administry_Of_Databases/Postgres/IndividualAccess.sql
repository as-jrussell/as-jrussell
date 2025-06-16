DO $$
DECLARE
    target_role TEXT := 'db_datawriter';
    r RECORD;
BEGIN

-- 1️⃣ Privilege report with decoded default ACLs
FOR r IN
    EXECUTE format(
        '
        WITH table_grants AS (
            SELECT 
                ''TABLE''::TEXT AS object_type,
                table_schema::TEXT AS schema,
                table_name::TEXT AS object_name,
                NULL::TEXT AS arguments,
                privilege_type::TEXT AS privilege,
                grantee::TEXT AS grantee
            FROM information_schema.role_table_grants
            WHERE grantee = %L
        ),
        function_grants AS (
            SELECT 
                ''FUNCTION''::TEXT AS object_type,
                n.nspname::TEXT AS schema,
                p.proname::TEXT AS object_name,
                pg_get_function_identity_arguments(p.oid)::TEXT AS arguments,
                ''EXECUTE''::TEXT AS privilege,
                r.rolname::TEXT AS grantee
            FROM pg_proc p
            JOIN pg_namespace n ON p.pronamespace = n.oid
            JOIN pg_roles r ON has_function_privilege(r.rolname, p.oid, ''EXECUTE'')
            WHERE n.nspname NOT IN (''pg_catalog'', ''information_schema'')
              AND r.rolname = %L
        ),
        default_privs_parsed AS (
            SELECT 
                CASE defaclobjtype
                    WHEN ''r'' THEN ''DEFAULT_TABLE''
                    WHEN ''f'' THEN ''DEFAULT_FUNCTION''
                    ELSE defaclobjtype::TEXT
                END AS object_type,
                defaclnamespace::regnamespace::TEXT AS schema,
                NULL::TEXT AS object_name,
                NULL::TEXT AS arguments,
                regexp_replace(priv_string, ''^([^=]*)=(.*)$'', ''\2'')::TEXT AS raw_priv,
                regexp_replace(priv_string, ''^([^=]*)=(.*)$'', ''\1'')::TEXT AS grantee
            FROM (
                SELECT defaclobjtype, defaclnamespace, unnest(defaclacl)::TEXT AS priv_string
                FROM pg_default_acl
                WHERE defaclacl::TEXT ILIKE ''%%'' || %L || ''%%''
            ) AS expanded
        ),
        decoded_privs AS (
            SELECT 
                object_type,
                schema,
                object_name,
                arguments,
                grantee,
                raw_priv,
                TRIM(TRAILING '', '' FROM (
                    CASE WHEN raw_priv LIKE ''%%a%%'' THEN ''INSERT, '' ELSE '''' END ||
                    CASE WHEN raw_priv LIKE ''%%r%%'' THEN ''SELECT, '' ELSE '''' END ||
                    CASE WHEN raw_priv LIKE ''%%w%%'' THEN ''UPDATE, '' ELSE '''' END ||
                    CASE WHEN raw_priv LIKE ''%%d%%'' THEN ''DELETE, '' ELSE '''' END ||
                    CASE WHEN raw_priv LIKE ''%%D%%'' THEN ''TRUNCATE, '' ELSE '''' END ||
                    CASE WHEN raw_priv LIKE ''%%x%%'' THEN ''REFERENCES, '' ELSE '''' END ||
                    CASE WHEN raw_priv LIKE ''%%t%%'' THEN ''TRIGGER, '' ELSE '''' END ||
                    CASE WHEN raw_priv LIKE ''%%X%%'' THEN ''EXECUTE, '' ELSE '''' END ||
                    CASE WHEN raw_priv LIKE ''%%U%%'' THEN ''USAGE, '' ELSE '''' END ||
                    CASE WHEN raw_priv LIKE ''%%C%%'' THEN ''CREATE, '' ELSE '''' END ||
                    CASE WHEN raw_priv LIKE ''%%T%%'' THEN ''TEMP, '' ELSE '''' END ||
                    CASE WHEN raw_priv LIKE ''%%c%%'' THEN ''CONNECT, '' ELSE '''' END
                )) AS privilege
            FROM default_privs_parsed
        )
        SELECT object_type, schema, object_name, arguments, privilege, grantee
        FROM decoded_privs
        UNION ALL
        SELECT object_type, schema, object_name, arguments, privilege, grantee FROM table_grants
        UNION ALL
        SELECT object_type, schema, object_name, arguments, privilege, grantee FROM function_grants
        ORDER BY object_type, schema, object_name NULLS LAST, arguments NULLS LAST;
        ',
        target_role, target_role, target_role
    )
LOOP
    RAISE NOTICE 'Access - % | % | % | % | % | %',
        r.object_type, r.schema, r.object_name, r.arguments, r.privilege, r.grantee;
END LOOP;

-- 2️⃣ Real permission check
RAISE NOTICE '--- BEGIN ACTUAL TABLE PRIV CHECK ---';

FOR r IN
    SELECT 
        schemaname, 
        tablename,
        has_table_privilege(target_role, format('%I.%I', schemaname, tablename), 'SELECT') AS can_select,
        has_table_privilege(target_role, format('%I.%I', schemaname, tablename), 'INSERT') AS can_insert,
        has_table_privilege(target_role, format('%I.%I', schemaname, tablename), 'UPDATE') AS can_update,
        has_table_privilege(target_role, format('%I.%I', schemaname, tablename), 'DELETE') AS can_delete
    FROM pg_tables
    WHERE schemaname NOT IN ('pg_catalog', 'information_schema', 'myveryfirstschema')
LOOP
    RAISE NOTICE 'Schema: %, Table: %, SELECT: %, INSERT: %, UPDATE: %, DELETE: %',
        r.schemaname, r.tablename, r.can_select, r.can_insert, r.can_update, r.can_delete;
END LOOP;

RAISE NOTICE '--- END ACTUAL TABLE PRIV CHECK ---';

END $$;
