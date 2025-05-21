-- Show all roles/users and their attributes (login, superuser, etc.)
SELECT rolname, rolsuper, rolcanlogin, rolcreaterole, rolcreatedb
FROM pg_roles
WHERE rolname IN ('report_user', 'app_user', 'postgres');

-- Show all schemas and their owners
SELECT schema_name, schema_owner
FROM information_schema.schemata
WHERE schema_name IN ('app_schema', 'analytics_schema', 'myveryfirstschema', 'public');

-- Show default privileges granted in the schemas (for tables)
-- This one is a bit tricky; pg_default_acl stores default privileges info
SELECT defaclrole::regrole AS role,
       defaclnamespace::regnamespace AS schema,
       defaclobjtype,
       defaclacl
FROM pg_default_acl
WHERE defaclnamespace IN (
  SELECT oid FROM pg_namespace WHERE nspname IN ('app_schema', 'analytics_schema')
);

-- Show table-level grants (example for app_schema and analytics_schema)
SELECT
  nsp.nspname AS schema,
  rel.relname AS table,
  pg_get_userbyid(rel.relowner) AS owner,
  array_agg(DISTINCT pg_get_userbyid(d.grantee)) AS grantees,
  array_agg(DISTINCT d.privilege_type) AS privileges
FROM pg_class rel
JOIN pg_namespace nsp ON rel.relnamespace = nsp.oid
JOIN information_schema.role_table_grants d ON d.table_name = rel.relname
WHERE nsp.nspname IN ('app_schema', 'analytics_schema')
GROUP BY nsp.nspname, rel.relname, rel.relowner
ORDER BY schema, table;
