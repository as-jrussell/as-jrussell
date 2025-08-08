set role dba_team; 

CREATE OR REPLACE FUNCTION deploy.DropSchemaWithCleanup(
    p_schema_name TEXT,
    p_execute_flag BOOLEAN DEFAULT FALSE,
    p_cascade BOOLEAN DEFAULT FALSE
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists BOOLEAN;
    v_sql TEXT;
    v_log_status TEXT;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM information_schema.schemata WHERE schema_name = p_schema_name
    ) INTO v_exists;

    IF NOT v_exists THEN
        v_log_status := 'NOT_FOUND';
        RAISE NOTICE 'Schema "%" does not exist.', p_schema_name;

        INSERT INTO dba.object_log_history (
            action_type, target_entity, associated_entity, status, sql_command, message
        ) VALUES (
            'DROP_SCHEMA',
            p_schema_name,
            NULL,
            v_log_status,
            NULL,
           'No schema dropped — not found.'       -- if your editor truly supports UTF-8
        );

        RETURN format('Schema "%s" does not exist.', p_schema_name);
    END IF;

    v_sql := format('DROP SCHEMA %I %s',
        p_schema_name,
        CASE WHEN p_cascade THEN 'CASCADE' ELSE 'RESTRICT' END
    );

    RAISE NOTICE '[DRY-RUN] Would drop schema: %', p_schema_name;

    IF p_execute_flag THEN
        EXECUTE v_sql;
        v_log_status := 'EXECUTED';
        RAISE NOTICE 'Schema "%" dropped.', p_schema_name;
    ELSE
        v_log_status := 'DRY_RUN';
    END IF;

    INSERT INTO dba.object_log_history (
        action_type, target_entity, associated_entity, status, sql_command, message
    ) VALUES (
        'DROP_SCHEMA',
        p_schema_name,
        NULL,
        v_log_status,
        v_sql,
        'Schema drop processed.'
    );

    RETURN format('Schema "%s" drop %s.', p_schema_name, v_log_status);
END;
$$;

ALTER FUNCTION deploy.DropSchemaWithCleanup(TEXT, BOOLEAN, BOOLEAN)
OWNER TO dba_team;
