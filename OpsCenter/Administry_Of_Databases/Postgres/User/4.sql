-- ================================================================
-- Create: info.account_log_history with auto-incrementing log_id
-- ================================================================

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'info' AND table_name = 'account_log_history'
    ) THEN
        EXECUTE '
CREATE SEQUENCE IF NOT EXISTS info.account_log_history_log_id_seq
    START WITH 1
    INCREMENT BY 1;
	

-- Step 2: Create the table with DEFAULT log_id from sequence
CREATE TABLE IF NOT EXISTS info.account_log_history (
    log_id INTEGER NOT NULL DEFAULT nextval(''info.account_log_history_log_id_seq''),
    log_timestamp TIMESTAMPTZ DEFAULT now(),
    action_type TEXT COLLATE pg_catalog."default" NOT NULL,
    target_entity TEXT COLLATE pg_catalog."default" NOT NULL,
    associated_entity TEXT COLLATE pg_catalog."default",
    status TEXT COLLATE pg_catalog."default" NOT NULL,
    sql_command TEXT COLLATE pg_catalog."default",
    message TEXT COLLATE pg_catalog."default",
    CONSTRAINT account_log_history_pkey PRIMARY KEY (log_id)
)
TABLESPACE pg_default;


-- Step 3: Attach sequence ownership to table column
ALTER SEQUENCE info.account_log_history_log_id_seq
OWNED BY info.account_log_history.log_id;


		ALTER TABLE IF EXISTS info.account_log_history
    OWNER to dba_team;
	
GRANT SELECT ON TABLE info.account_log_history TO db_datareader;
GRANT ALL ON TABLE info.account_log_history TO db_ddladmin;
GRANT ALL ON TABLE info.account_log_history TO dba_team;


	
        ';
        RAISE NOTICE 'Table "info.account_log_history" created.';
    ELSE
        RAISE NOTICE 'Table "info.account_log_history" already exists.';
    END IF;
END
$$;


DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'info' AND table_name = 'object_log_history'
    ) THEN
        EXECUTE '
           CREATE TABLE IF NOT EXISTS info.object_log_history (
    log_id SERIAL PRIMARY KEY,
    log_timestamp TIMESTAMPTZ DEFAULT now(),
    action_type TEXT NOT NULL,                  -- e.g., CREATE_DATABASE, GRANT_DB_CONNECT
    target_entity TEXT NOT NULL,                -- The main object being acted on (e.g., db name, role)
    associated_entity TEXT,                     -- Optional: who/what is associated (e.g., role granted, owner)
    status TEXT NOT NULL,                       -- e.g., EXECUTED, DRY_RUN, ALREADY_EXISTS
    sql_command TEXT,                           -- The SQL that was (or would have been) run
    message TEXT                                 -- Human-friendly description of the action
);


		ALTER TABLE IF EXISTS info.object_log_history
    OWNER to dba_team;

GRANT ALL ON TABLE info.object_log_history FROM db_datareader;

GRANT SELECT ON TABLE info.object_log_history TO db_datareader;

GRANT ALL ON TABLE info.object_log_history TO dba_team;
	
        ';
        RAISE NOTICE 'Table "info.object_log_history" created.';
    ELSE
        RAISE NOTICE 'Table "info.object_log_history" already exists.';
    END IF;
END
$$;


