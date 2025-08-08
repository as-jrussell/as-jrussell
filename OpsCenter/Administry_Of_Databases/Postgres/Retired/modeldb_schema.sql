--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: dba; Type: SCHEMA; Schema: -; Owner: dba_team
--

CREATE SCHEMA dba;


ALTER SCHEMA dba OWNER TO dba_team;

--
-- Name: getprivileges(text); Type: FUNCTION; Schema: dba; Owner: dba_team
--

CREATE FUNCTION dba.getprivileges(p_role text DEFAULT ''::text) RETURNS TABLE(object_scope text, grantee text, privilege text, inherited_role text, source text)
    LANGUAGE plpgsql
    AS $_$
    DECLARE
        v_ver INT := current_setting('server_version_num')::INT;
    BEGIN
        RETURN QUERY
        -- CTE to get roles and their directly inherited roles
        WITH inherited_roles AS (
            SELECT
                r.rolname AS role_name,
                string_agg(m.rolname, ',' ORDER BY m.rolname) AS inherited_role
            FROM pg_roles r
            LEFT JOIN pg_auth_members am ON r.oid = am.member
            LEFT JOIN pg_roles m ON am.roleid = m.oid
            GROUP BY r.rolname
        ),
        -- CTE for schema CREATE privileges
        schema_create AS (
            SELECT
                n.nspname::TEXT AS object_scope,
                r.rolname::TEXT AS grantee,
                'CREATE'::TEXT AS privilege,
                ir.inherited_role,
                'actual_schema_privilege'::TEXT AS source
            FROM pg_namespace n
            JOIN pg_roles r ON has_schema_privilege(r.rolname, n.oid, 'CREATE')
            LEFT JOIN inherited_roles ir ON r.rolname = ir.role_name
            WHERE n.nspname NOT LIKE 'pg_%' AND n.nspname <> 'information_schema'
        ),
        -- CTE for schema USAGE privileges
        schema_usage AS (
            SELECT
                n.nspname::TEXT AS object_scope,
                r.rolname::TEXT AS grantee,
                'USAGE'::TEXT AS privilege,
                ir.inherited_role,
                'actual_schema_privilege'::TEXT AS source
            FROM pg_namespace n
            JOIN pg_roles r ON has_schema_privilege(r.rolname, n.oid, 'USAGE')
            LEFT JOIN inherited_roles ir ON r.rolname = ir.role_name
            WHERE n.nspname NOT LIKE 'pg_%' AND n.nspname <> 'information_schema'
        ),
        -- CTE for database-level privileges (CREATE, TEMP, CONNECT)
        db_privs AS (
            SELECT
                current_database()::TEXT AS object_scope,
                r.rolname::TEXT AS grantee,
                unnest(string_to_array(
                    TRIM(BOTH ',' FROM
                        CASE WHEN has_database_privilege(r.rolname, current_database(), 'CREATE') THEN 'CREATE,' ELSE '' END ||
                        CASE WHEN has_database_privilege(r.rolname, current_database(), 'TEMP') THEN 'TEMP,' ELSE '' END ||
                        CASE WHEN has_database_privilege(r.rolname, current_database(), 'CONNECT') THEN 'CONNECT' ELSE '' END
                    ), ','))::TEXT AS privilege,
                ir.inherited_role,
                'actual_database_privilege'::TEXT AS source
            FROM pg_roles r
            LEFT JOIN inherited_roles ir ON r.rolname = ir.role_name
        ),
        -- CTE to extract raw ACL entries from pg_default_acl for PG 14+
        raw_acls AS (
            SELECT
                pda.defaclnamespace::regnamespace::TEXT AS object_scope,
                (regexp_matches(acl_entry::TEXT, '^(.+?)=([a-zA-Z]*)/?(.+)?$'))[1]::TEXT AS grantee,
                (regexp_matches(acl_entry::TEXT, '^(.+?)=([a-zA-Z]*)/?(.+)?$'))[2]::TEXT AS privs_raw
            FROM pg_default_acl pda, unnest(pda.defaclacl) AS acl_entry
            WHERE current_setting('server_version_num')::INT >= 140000
        ),
        -- CTE to expand raw ACL characters into full privilege names
        expanded_acls AS (
            SELECT
                ra.object_scope,
                ra.grantee,
                CASE
                    WHEN ra.privs_raw IS NULL THEN NULL
                    ELSE array_to_string(ARRAY(
                        SELECT priv_subquery.privilege FROM (
                            SELECT CASE WHEN ra.privs_raw LIKE '%a%' THEN 'INSERT' END AS privilege
                            UNION ALL SELECT CASE WHEN ra.privs_raw LIKE '%r%' THEN 'SELECT' END
                            UNION ALL SELECT CASE WHEN ra.privs_raw LIKE '%w%' THEN 'UPDATE' END
                            UNION ALL SELECT CASE WHEN ra.privs_raw LIKE '%d%' THEN 'DELETE' END
                            UNION ALL SELECT CASE WHEN ra.privs_raw LIKE '%D%' THEN 'TRUNCATE' END
                            UNION ALL SELECT CASE WHEN ra.privs_raw LIKE '%x%' THEN 'REFERENCES' END
                            UNION ALL SELECT CASE WHEN ra.privs_raw LIKE '%t%' THEN 'TRIGGER' END
                            UNION ALL SELECT CASE WHEN ra.privs_raw LIKE '%X%' THEN 'EXECUTE' END
                        ) AS priv_subquery WHERE priv_subquery.privilege IS NOT NULL ORDER BY priv_subquery.privilege
                    ), ',')
                END AS privilege,
                ir.inherited_role,
                'default_acl'::TEXT AS source
            FROM raw_acls ra
            LEFT JOIN inherited_roles ir ON ra.grantee = ir.role_name
        )

        -- Combine all privilege types and filter by p_role if provided
        SELECT sc.object_scope, sc.grantee, sc.privilege, sc.inherited_role, sc.source FROM schema_create sc WHERE p_role = '' OR sc.grantee = p_role
        UNION ALL
        SELECT su.object_scope, su.grantee, su.privilege, su.inherited_role, su.source FROM schema_usage su WHERE p_role = '' OR su.grantee = p_role
        UNION ALL
        SELECT db.object_scope, db.grantee, db.privilege, db.inherited_role, db.source FROM db_privs db WHERE p_role = '' OR db.grantee = p_role
        UNION ALL
        SELECT ea.object_scope, ea.grantee, ea.privilege, ea.inherited_role, ea.source FROM expanded_acls ea WHERE p_role = '' OR ea.grantee = p_role
        ORDER BY grantee, object_scope, privilege;
    END;
    $_$;


ALTER FUNCTION dba.getprivileges(p_role text) OWNER TO dba_team;

--
-- Name: SCHEMA dba; Type: ACL; Schema: -; Owner: dba_team
--

GRANT USAGE ON SCHEMA dba TO db_datareader;
GRANT USAGE ON SCHEMA dba TO db_datawriter;
GRANT USAGE ON SCHEMA dba TO db_ddladmin_c;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO db_ddladmin_c;
GRANT USAGE ON SCHEMA public TO db_datareader;
GRANT USAGE ON SCHEMA public TO db_datawriter;
GRANT ALL ON SCHEMA public TO db_ddladmin;


--
-- Name: FUNCTION getprivileges(p_role text); Type: ACL; Schema: dba; Owner: dba_team
--

GRANT ALL ON FUNCTION dba.getprivileges(p_role text) TO db_datareader;
GRANT ALL ON FUNCTION dba.getprivileges(p_role text) TO db_datawriter;
GRANT ALL ON FUNCTION dba.getprivileges(p_role text) TO db_ddladmin;
GRANT ALL ON FUNCTION dba.getprivileges(p_role text) TO db_ddladmin_c;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: dba; Owner: dba_team
--

ALTER DEFAULT PRIVILEGES FOR ROLE dba_team IN SCHEMA dba GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO db_ddladmin;
ALTER DEFAULT PRIVILEGES FOR ROLE dba_team IN SCHEMA dba GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO db_datawriter;
ALTER DEFAULT PRIVILEGES FOR ROLE dba_team IN SCHEMA dba GRANT SELECT ON TABLES TO db_datareader;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: dba_team
--

ALTER DEFAULT PRIVILEGES FOR ROLE dba_team IN SCHEMA public GRANT ALL ON TABLES TO db_ddladmin;
ALTER DEFAULT PRIVILEGES FOR ROLE dba_team IN SCHEMA public GRANT ALL ON TABLES TO db_ddladmin_c;
ALTER DEFAULT PRIVILEGES FOR ROLE dba_team IN SCHEMA public GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO db_datawriter;
ALTER DEFAULT PRIVILEGES FOR ROLE dba_team IN SCHEMA public GRANT SELECT ON TABLES TO db_datareader;


--
-- PostgreSQL database dump complete
--

