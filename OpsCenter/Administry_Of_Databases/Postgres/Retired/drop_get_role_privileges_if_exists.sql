DO $$
DECLARE
    v_schema text;
    v_sql text;
BEGIN
    IF current_database() = 'DBA' THEN
        v_schema := 'info';
    ELSIF current_database() IN ('postgres', 'rdsadmin') THEN
        RAISE NOTICE 'Skipping function drop in system DB: %', current_database();
        RETURN;
    ELSE
        v_schema := 'dba';
    END IF;

    v_sql := 'DROP FUNCTION IF EXISTS ' || quote_ident(v_schema) || '.get_role_privileges(TEXT);';
    EXECUTE v_sql;
END $$;
