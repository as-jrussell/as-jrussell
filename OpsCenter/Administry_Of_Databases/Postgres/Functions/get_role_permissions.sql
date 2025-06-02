CREATE OR REPLACE FUNCTION dba.get_role_permissions(p_role TEXT, p_permission TEXT)
RETURNS TABLE (
    privilege TEXT,
    granted_on TEXT,
    object_name TEXT,
    table_catalog TEXT,
    table_schema TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_permission = 'SELECT' THEN
        RETURN QUERY EXECUTE format(
            $f$
            SELECT 
                'SELECT'::TEXT AS privilege,
                'TABLE'::TEXT AS granted_on,
                c.relname::TEXT AS object_name,
                current_database()::TEXT AS table_catalog,
                n.nspname::TEXT AS table_schema
            FROM pg_class c
            JOIN pg_namespace n ON n.oid = c.relnamespace
            WHERE c.relkind = 'r'
              AND has_schema_privilege(%L, n.nspname, 'USAGE')
              AND has_table_privilege(%L, n.nspname || '.' || c.relname, 'SELECT')
            $f$, p_role, p_role);

    ELSIF p_permission = 'USAGE' THEN
        RETURN QUERY EXECUTE format(
            $f$
            SELECT 
                'USAGE'::TEXT AS privilege,
                'SCHEMA'::TEXT AS granted_on,
                n.nspname::TEXT AS object_name,
                current_database()::TEXT AS table_catalog,
                n.nspname::TEXT AS table_schema
            FROM pg_namespace n
            WHERE has_schema_privilege(%L, n.nspname, 'USAGE')
            $f$, p_role);

    ELSIF p_permission = 'EXECUTE' THEN
        RETURN QUERY EXECUTE format(
            $f$
            SELECT 
                'EXECUTE'::TEXT AS privilege,
                'FUNCTION'::TEXT AS granted_on,
                (n.nspname || '.' || p.proname || '(' || pg_get_function_identity_arguments(p.oid) || ')')::TEXT AS object_name,
                current_database()::TEXT AS table_catalog,
                n.nspname::TEXT AS table_schema
            FROM pg_proc p
            JOIN pg_namespace n ON n.oid = p.pronamespace
            WHERE has_schema_privilege(%L, n.nspname, 'USAGE')
              AND has_function_privilege(%L, p.oid, 'EXECUTE')
              AND pg_get_function_identity_arguments(p.oid) NOT LIKE '%%VARIADIC%%'
            $f$, p_role, p_role);

    ELSIF p_permission = 'ALL' THEN
RETURN QUERY EXECUTE format($f$
 SELECT
    privilege AS privilege,
    'SCHEMA'::TEXT AS granted_on,
    sub.nspname::TEXT AS object_name,
    current_database()::TEXT AS table_catalog,
    sub.nspname::TEXT AS table_schema
FROM (
    SELECT
        n.nspname,
        unnest(array_remove(array[
            CASE WHEN has_schema_privilege(%L, n.nspname, 'CREATE') THEN 'CREATE' END,
            CASE WHEN has_schema_privilege(%L, n.nspname, 'CREATE TEMPORARY') THEN 'CREATE TEMPORARY' END,
            CASE WHEN has_schema_privilege(%L, n.nspname, 'ALL') THEN 'ALL' END
        ], NULL)) AS privilege
    FROM pg_namespace n
    WHERE has_schema_privilege(%L, n.nspname, 'CREATE')
) sub
WHERE privilege NOT IN ('USAGE')

$f$, p_role, p_role, p_role, p_role);




    ELSE
        RAISE EXCEPTION 'Unsupported permission type: %', p_permission;
    END IF;
END;
$$;
