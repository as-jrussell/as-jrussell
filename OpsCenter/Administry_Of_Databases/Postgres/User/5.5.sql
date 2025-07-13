----Within User DB


CREATE SCHEMA "dba"
    AUTHORIZATION dba_team;

GRANT USAGE ON SCHEMA DBA TO db_datareader

CREATE OR REPLACE FUNCTION dba.CreateSchemaWithPermissions(
    p_schema_name TEXT,
    p_owner TEXT,
    p_grant_roles TEXT[] DEFAULT NULL,
    p_execute_flag BOOLEAN DEFAULT FALSE
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
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

        INSERT INTO dba.object_log_history (
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

    INSERT INTO dba.object_log_history (
        action_type, target_entity, associated_entity, status, sql_command, message
    ) VALUES (
        'CREATE_SCHEMA',
        p_schema_name,
        p_owner,
        v_log_status,
        v_sql,
        'Schema creation completed.'
    );

    -- 🔐 Grant privileges
    IF p_grant_roles IS NOT NULL THEN
        FOREACH v_role IN ARRAY p_grant_roles LOOP
            v_sql := format('GRANT USAGE ON SCHEMA %I TO %I', p_schema_name, v_role);

            IF p_execute_flag THEN
                EXECUTE v_sql;
                v_log_status := 'EXECUTED';
            ELSE
                v_log_status := 'DRY_RUN';
            END IF;

            INSERT INTO dba.object_log_history (
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

    RETURN format('Schema "%s" processed with permissions.', p_schema_name);
END;
$$;

ALTER FUNCTION dba.CreateSchemaWithPermissions(TEXT, TEXT, TEXT[], BOOLEAN)
OWNER TO dba_team;














CREATE TABLE IF NOT EXISTS dba.object_log_history (
    log_id SERIAL PRIMARY KEY,
    log_timestamp TIMESTAMPTZ DEFAULT now(),
    action_type TEXT NOT NULL,                  -- e.g., CREATE_DATABASE, GRANT_DB_CONNECT
    target_entity TEXT NOT NULL,                -- The main object being acted on (e.g., db name, role)
    associated_entity TEXT,                     -- Optional: who/what is associated (e.g., role granted, owner)
    status TEXT NOT NULL,                       -- e.g., EXECUTED, DRY_RUN, ALREADY_EXISTS
    sql_command TEXT,                           -- The SQL that was (or would have been) run
    message TEXT                                 -- Human-friendly description of the action
);



ALTER TABLE dba.object_log_history OWNER TO dba_team;

GRANT SELECT ON dba.object_log_history TO db_datareader;
GRANT ALL ON dba.object_log_history TO dba_team;





