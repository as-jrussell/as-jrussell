


DO $$
DECLARE
    s RECORD;
    fn RECORD;
BEGIN
    FOR s IN
        SELECT nspname, nspowner::regrole::TEXT AS owner_role
        FROM pg_namespace
       WHERE nspname NOT IN ('pg_catalog', 'information_schema', 'rdsadmin', 'pg_toast')


    LOOP
        RAISE NOTICE 'Processing schema: %', s.nspname;

        -- Revoke all first (optional but keeps things clean)
        EXECUTE format(
            'REVOKE ALL ON ALL TABLES IN SCHEMA %I FROM db_datawriter;',
            s.nspname
        );

        -- Grant SELECT, INSERT, UPDATE, DELETE on all existing tables
        EXECUTE format(
            'GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA %I TO db_datawriter;',
            s.nspname
        );

        -- Set default privileges for future tables
        EXECUTE format(
            'ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO db_datawriter;',
            s.owner_role, s.nspname
        );

        -- Set default privileges for future functions
        EXECUTE format(
            'ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT EXECUTE ON FUNCTIONS TO db_datawriter;',
            s.owner_role, s.nspname
        );

        -- Grant EXECUTE on existing functions/procedures
        FOR fn IN
            SELECT 
                n.nspname AS routine_schema,
                p.proname AS routine_name,
                pg_get_function_identity_arguments(p.oid) AS arglist
            FROM pg_proc p
            JOIN pg_namespace n ON p.pronamespace = n.oid
            WHERE n.nspname = s.nspname
        LOOP
            BEGIN
                EXECUTE format(
                    'GRANT EXECUTE ON FUNCTION %I.%I(%s) TO db_datawriter;',
                    fn.routine_schema, fn.routine_name, fn.arglist
                );
            EXCEPTION
                WHEN OTHERS THEN
                    RAISE NOTICE 'Skipped function %I.%I(%s) due to error.',
                        fn.routine_schema, fn.routine_name, fn.arglist;
            END;
        END LOOP;
    END LOOP;
END $$;










/*

ALTER ROLE svc_refundplus_docw_rw LOGIN;
ALTER ROLE svc_refundplus_docw_ro LOGIN;


-- Connect to the postgres DB first, then run:
REVOKE CONNECT ON DATABASE postgres FROM svc_refundplus_docw_ro;
REVOKE ALL ON SCHEMA public FROM svc_refundplus_docw_ro;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM svc_refundplus_docw_ro;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM svc_refundplus_docw_ro;




GRANT CREATE ON SCHEMA public TO db_datawriter;

GRANT CREATE ON SCHEMA public TO db_datawriter;

-- Existing table write access
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO db_datawriter;

-- Existing function execution
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO db_datawriter;

-- Default privileges for future tables (owned by role 'postgres', adjust if needed)
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
GRANT INSERT, UPDATE, DELETE ON TABLES TO svc_refundplus_docw_rw;

-- Default privileges for future functions
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
GRANT EXECUTE ON FUNCTIONS TO svc_refundplus_docw_rw;



ALTER ROLE svc_refundplus_docw_rw WITH PASSWORD '"dj#Yb%5gnD:R|6';
*/

