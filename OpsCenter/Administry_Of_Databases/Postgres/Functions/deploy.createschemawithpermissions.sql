-- FUNCTION: deploy.createschemawithpermissions(text, text, text[], boolean)

-- DROP FUNCTION IF EXISTS deploy.createschemawithpermissions(text, text, text[], boolean);

CREATE OR REPLACE FUNCTION deploy.createschemawithpermissions(
	p_schema_name text,
	p_owner text,
	p_grant_roles text[] DEFAULT NULL::text[],
	p_execute_flag boolean DEFAULT false)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
/*
============================================================
📘 USAGE EXAMPLES: deploy.CreateSchemaWithPermissions()
============================================================

-- 🧪 Dry-run mode
SELECT deploy.CreateSchemaWithPermissions(
    p_schema_name := 'audit',
    p_owner := 'jrussell',
    p_grant_roles := ARRAY['db_datareader', 'db_datawriter', 'db_ddladmin'],
    p_execute_flag := FALSE
);

-- ⚙️ Execute schema creation with role grants and default privileges
SELECT deploy.CreateSchemaWithPermissions(
    p_schema_name := 'audit',
    p_owner := 'jrussell',
    p_grant_roles := ARRAY['db_datareader', 'db_datawriter', 'db_ddladmin'],
    p_execute_flag := TRUE
);

-- 🚫 Will skip creation if schema exists
SELECT deploy.CreateSchemaWithPermissions('public', 'postgres', ARRAY['readonly'], TRUE);
============================================================
*/

DECLARE
    v_exists BOOLEAN;
    v_sql TEXT;
    v_role TEXT;
    v_log_status TEXT;
BEGIN
    -- 🔍 Check if schema already exists
    SELECT EXISTS (
        SELECT 1 FROM information_schema.schemata WHERE schema_name = p_schema_name
    ) INTO v_exists;

    IF v_exists THEN
        v_log_status := 'ALREADY_EXISTS';
        RAISE NOTICE 'Schema "%" already exists.', p_schema_name;

        INSERT INTO info.object_log_history (
            action_type, target_entity, associated_entity, status, sql_command, message
        ) VALUES (
            'CREATE_SCHEMA',
            p_schema_name,
            p_owner,
            v_log_status,
            NULL,
            'Schema already existed. No action taken.'
        );

        RETURN format('Schema "%s" already exists.', p_schema_name);
    END IF;

    -- ✨ Create schema
    v_sql := format('CREATE SCHEMA %I AUTHORIZATION %I', p_schema_name, p_owner);
    RAISE NOTICE '[DRY-RUN] Would create schema: %', p_schema_name;

    IF p_execute_flag THEN
        EXECUTE v_sql;
        v_log_status := 'EXECUTED';
        RAISE NOTICE 'Schema "%" created.', p_schema_name;
    ELSE
        v_log_status := 'DRY_RUN';
    END IF;

    INSERT INTO info.object_log_history (
        action_type, target_entity, associated_entity, status, sql_command, message
    ) VALUES (
        'CREATE_SCHEMA',
        p_schema_name,
        p_owner,
        v_log_status,
        v_sql,
        'Schema creation completed.'
    );

    -- 🔐 Grant USAGE on schema
    IF p_grant_roles IS NOT NULL THEN
        FOREACH v_role IN ARRAY p_grant_roles LOOP
            v_sql := format('GRANT USAGE ON SCHEMA %I TO %I', p_schema_name, v_role);

            IF p_execute_flag THEN
                EXECUTE v_sql;
                v_log_status := 'EXECUTED';
            ELSE
                v_log_status := 'DRY_RUN';
            END IF;

            INSERT INTO info.object_log_history (
                action_type, target_entity, associated_entity, status, sql_command, message
            ) VALUES (
                'GRANT_SCHEMA_USAGE',
                v_role,
                p_schema_name,
                v_log_status,
                v_sql,
                format('Granted USAGE on schema "%s" to "%s".', p_schema_name, v_role)
            );
        END LOOP;
    END IF;

    -- 🔧 Set default privileges for future tables
    IF p_execute_flag THEN
        -- db_datareader: SELECT
        v_sql := format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT SELECT ON TABLES TO db_datareader', p_owner, p_schema_name);
        EXECUTE v_sql;
        INSERT INTO info.object_log_history VALUES (
            DEFAULT, now(), 'DEFAULT_PRIVS', p_schema_name, 'db_datareader', 'EXECUTED', v_sql,
            'Granted default SELECT privileges to db_datareader.');

        -- db_datawriter: INSERT/UPDATE/DELETE/SELECT
        v_sql := format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT DELETE, INSERT, SELECT, UPDATE ON TABLES TO db_datawriter', p_owner, p_schema_name);
        EXECUTE v_sql;
        INSERT INTO info.object_log_history VALUES (
            DEFAULT, now(), 'DEFAULT_PRIVS', p_schema_name, 'db_datawriter', 'EXECUTED', v_sql,
            'Granted default DML privileges to db_datawriter.');

        -- db_ddladmin: ALL
        v_sql := format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT ALL ON TABLES TO db_ddladmin', p_owner, p_schema_name);
        EXECUTE v_sql;
        INSERT INTO info.object_log_history VALUES (
            DEFAULT, now(), 'DEFAULT_PRIVS', p_schema_name, 'db_ddladmin', 'EXECUTED', v_sql,
            'Granted default ALL privileges to db_ddladmin.');
    END IF;

    RETURN format('Schema "%s" processed with usage and default table privileges.', p_schema_name);
END;
$BODY$;

ALTER FUNCTION deploy.createschemawithpermissions(text, text, text[], boolean)
    OWNER TO dba_team;
