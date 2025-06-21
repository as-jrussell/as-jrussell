


DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT DISTINCT 
            defaclrole::regrole::text AS owner_role,
            defaclnamespace::regnamespace::text AS schema_name
        FROM pg_default_acl
        WHERE defaclrole::regrole::text IS NOT NULL
          AND EXISTS (
              SELECT 1 FROM unnest(defaclacl) acl
              WHERE acl::text LIKE '%db_datawriter%'
          )
    LOOP
        RAISE NOTICE 'Revoking default privileges for role % in schema %', r.owner_role, r.schema_name;

        EXECUTE format(
            'ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I REVOKE ALL ON TABLES FROM db_datawriter;',
            r.owner_role, r.schema_name
        );

        EXECUTE format(
            'ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I REVOKE ALL ON FUNCTIONS FROM db_datawriter;',
            r.owner_role, r.schema_name
        );
    END LOOP;
END;
$$;


REASSIGN OWNED BY db_datawriter TO dba_team;


REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA myveryfirstschema FROM db_datawriter;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA myveryfirstschema FROM db_datawriter;
REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA myveryfirstschema FROM db_datawriter;

SELECT grantee, privilege_type, table_schema, table_name
FROM information_schema.role_table_grants
WHERE grantee = 'db_datawriter';

REVOKE ddl_admin FROM some_user;



SELECT 
    'REVOKE ddl_admin FROM ' || r.rolname || ';'
FROM 
    pg_auth_members m
JOIN 
    pg_roles r ON m.member = r.oid
JOIN 
    pg_roles p ON m.roleid = p.oid
WHERE 
    p.rolname = 'ddl_admin';




-- Revoke default privileges for future tables owned by 'postgres' in 'analytics_schema'



SELECT * FROM pg_tables WHERE tableowner = 'db_datawriter';
SELECT * FROM pg_class WHERE relowner = (SELECT oid FROM pg_roles WHERE rolname = 'db_datawriter');




"REVOKE ddl_admin FROM ""Chris.Dunham;"
SET ROLE dba_team;
REVOKE db_ddladmin FROM "Chris.Dunham";
REVOKE db_ddladmin FROM "Luke.Bodwell";
REVOKE db_ddladmin FROM "Zachary.Comer";
REVOKE db_ddladmin FROM "Jiayun.You";
REVOKE db_ddladmin FROM "DurgaMalleswari.Tanguturi";
REVOKE db_ddladmin FROM "Scott.Anderson";
REVOKE db_ddladmin FROM "Joseph.Hance";
REVOKE db_ddladmin FROM "Vijay.Srireddy";


SELECT 
    'REVOKE ddl_admin FROM ' || r.rolname || ';'
FROM 
    pg_auth_members m
JOIN 
    pg_roles r ON m.member = r.oid
JOIN 
    pg_roles p ON m.roleid = p.oid
WHERE 
    r.rolname like '%.%';
