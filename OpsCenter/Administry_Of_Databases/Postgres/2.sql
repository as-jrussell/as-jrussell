--1
CREATE SCHEMA IF NOT EXISTS dba;

-- 2
CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA dba;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA dba;

-- 3
CREATE TABLE IF NOT EXISTS dba.dba_credentials (
    dbname TEXT PRIMARY KEY,
    username TEXT NOT NULL,
    encrypted_password BYTEA NOT NULL
);

-- 4
INSERT INTO dba.dba_credentials (dbname, username, encrypted_password)
VALUES (
    'DBA',
    'ghost_logger',
    pgp_sym_encrypt('SomeRandomButLongPassword!', 'UltraSecretKey2025')

-- 5
REVOKE ALL ON TABLE dba.dba_credentials FROM PUBLIC;


-- 6
GRANT ALL ON dba.dba_credentials TO dba_team;
GRANT EXECUTE ON FUNCTION dba.log_to_dba(text, text, text, text, text) TO ghost_logger;
GRANT EXECUTE ON FUNCTION dba.createschemawithpermissions(text, text, text[], boolean) TO ghost_logger;
GRANT EXECUTE ON FUNCTION pgp_sym_decrypt(bytea, text) TO ghost_logger;


-- 7
CREATE OR REPLACE FUNCTION log_to_dba(
    p_action TEXT,
    p_target TEXT,
    p_status TEXT,
    p_message TEXT,
    p_key TEXT
)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
    v_username TEXT;
    v_password TEXT;
    v_conn_str TEXT;
BEGIN
    -- Step 1: Decrypt credentials
    SELECT
        username,
        pgp_sym_decrypt(encrypted_password, p_key)
    INTO
        v_username, v_password
    FROM secure.dba_credentials
    WHERE dbname = 'DBA';

    -- Step 2: Build the connection string
    v_conn_str := format(
        'host=127.0.0.1 dbname=DBA user=%I password=%s',
        v_username,
        v_password
    );

    -- Step 3: Connect to DBA
    PERFORM dblink_connect('dba_conn', v_conn_str);

  
    PERFORM dblink_exec(
        'dba_conn',
        format(
            'INSERT INTO info.object_log_history
             (action_type, target_entity, status, sql_command, message)
             VALUES (%L, %L, %L, %L, %L)',
            p_action, p_target, p_status, 'log_to_dba', p_message
        )
    );

    -- Step 5: Disconnect
    PERFORM dblink_disconnect('dba_conn');
END;
$$;




