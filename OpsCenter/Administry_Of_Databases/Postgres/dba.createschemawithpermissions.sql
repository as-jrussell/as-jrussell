-- FUNCTION: dba.createschemawithpermissions(text, text, text[], boolean)
set role dba_team;

DO $$
DECLARE
    v_user TEXT;
    v_pass TEXT;
    v_conn TEXT;
BEGIN
    SELECT username,
           pgp_sym_decrypt(encrypted_password, 'UltraSecretKey2025')
    INTO v_user, v_pass
    FROM dba.dba_credentials
    WHERE dbname = 'DBA';

    v_conn := format('host=127.0.0.1 dbname=DBA user=%I password=%s', v_user, v_pass);
    PERFORM dblink_connect('dba_conn', v_conn);
END $$;

SELECT dblink_exec(
  'dba_conn',
  $$
    DROP FUNCTION IF EXISTS deploy.createschemawithpermissions(text, text, text[], boolean);
  $$
);


CREATE OR REPLACE FUNCTION dba.CreateSchemaWithPermissions(
    p_schema_name   TEXT,
    p_owner         TEXT,
    p_grant_roles   TEXT[] DEFAULT ARRAY[]::TEXT[],
    p_execute_flag  BOOLEAN DEFAULT FALSE
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    v_sql        TEXT;
    v_log_status TEXT;
    v_role       TEXT;  -- <--- THIS LINE FIXES THE ERROR
BEGIN
    -- Step 1: Build the CREATE SCHEMA statement
    v_sql := format('CREATE SCHEMA IF NOT EXISTS %I AUTHORIZATION %I;', p_schema_name, p_owner);

    -- Step 2: Either log it or run it
    IF p_execute_flag THEN
        EXECUTE v_sql;
        v_log_status := 'EXECUTED';
        RAISE NOTICE 'Schema "%" created.', p_schema_name;
    ELSE
        v_log_status := 'DRY-RUN';
        RAISE NOTICE '[DRY-RUN] Would create schema: %', p_schema_name;
    END IF;

    -- Step 3: Grant usage/create to each role
    FOREACH v_role IN ARRAY p_grant_roles LOOP
        v_sql := format('GRANT USAGE, CREATE ON SCHEMA %I TO %I;', p_schema_name, v_role);
        IF p_execute_flag THEN
            EXECUTE v_sql;
            RAISE NOTICE 'Granted usage/create on "%" to "%".', p_schema_name, v_role;
        ELSE
            RAISE NOTICE '[DRY-RUN] Would grant privileges on "%" to "%".', p_schema_name, v_role;
        END IF;
    END LOOP;

    -- Step 4: Log securely to DBA DB using dblink
    PERFORM dba.log_to_dba(
        p_action  := 'CREATE_SCHEMA',
        p_target  := p_schema_name,
        p_status  := v_log_status,
        p_message := 'Schema creation completed.',
        p_key     := 'UltraSecretKey2025'
    );

END;
$$;


ALTER FUNCTION dba.createschemawithpermissions(text, text, text[], boolean)
    OWNER TO dba_team;
