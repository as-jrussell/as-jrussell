-- Ensure the dba schema exists (run this first if you haven't already)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_namespace WHERE nspname = 'dba'
    ) THEN
        EXECUTE 'CREATE SCHEMA dba AUTHORIZATION current_user';
        RAISE NOTICE 'Schema "dba" created.';
    ELSE
        RAISE NOTICE 'Schema "dba" already exists.';
    END IF;
END
$$;

-- Ensure the account_log_history table exists in the dba schema (run this first if you haven't already)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'dba'
          AND table_name = 'account_log_history'
    ) THEN
        CREATE TABLE dba.account_log_history (
            log_id SERIAL PRIMARY KEY,
            log_timestamp TIMESTAMPTZ DEFAULT NOW(),
            action_type TEXT NOT NULL,
            target_entity TEXT NOT NULL,
            associated_entity TEXT,
            status TEXT NOT NULL,
            sql_command TEXT,
            message TEXT
        );
        COMMENT ON TABLE dba.account_log_history IS 'Logs for role and user creation/modification attempts via dba.SetAccountCreation function.';
        RAISE NOTICE 'Table "dba.account_log_history" created.';
    ELSE
        RAISE NOTICE 'Table "dba.account_log_history" already exists.';
    END IF;
END
$$;


-- STEP 2: Create function
CREATE OR REPLACE FUNCTION dba.SetDropUsers(
    usernames TEXT[],
    execute_flag BOOLEAN DEFAULT FALSE
)
RETURNS VOID AS $$
DECLARE
    user_name TEXT;
    is_login BOOLEAN;
    action_type TEXT;
    v_sql_command TEXT;
    v_log_status TEXT;
    v_message TEXT;
BEGIN
    RAISE NOTICE 'Execution mode is %', CASE WHEN execute_flag THEN 'ON (changes will be applied)' ELSE 'OFF (dry-run only)' END;

    FOREACH user_name IN ARRAY usernames LOOP
        v_sql_command := ''; -- Reset for each loop iteration
        v_message := '';     -- Reset for each loop iteration

        -- Check if role exists
        IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = user_name) THEN

            -- Determine if it's a login role or not
            SELECT rolcanlogin INTO is_login
            FROM pg_roles WHERE rolname = user_name;

            action_type := CASE WHEN is_login THEN 'DROP_USER' ELSE 'DROP_ROLE' END;
            v_sql_command := format('DROP ROLE %I', user_name);

            -- Check for dependencies
            -- This check might not be fully comprehensive for all ownerships/grants
            -- A "DROP ROLE ... CASCADE;" might be needed for full removal, but is more dangerous.
            IF EXISTS (
                SELECT 1
                FROM pg_shdepend d
                JOIN pg_roles r ON r.oid = d.refobjid
                WHERE r.rolname = user_name
            ) THEN
                v_log_status := 'ERROR';
                v_message := format('Cannot drop %s "%s": dependencies exist (owns objects or has grants). Manual intervention or CASCADE needed.', action_type, user_name);
                RAISE NOTICE '%', v_message;

                INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                VALUES (action_type, user_name, NULL, v_log_status, v_sql_command, v_message);

            ELSE
                IF execute_flag THEN
                    EXECUTE v_sql_command;
                    v_log_status := 'EXECUTED';
                    v_message := format('Dropped %s: "%s".', action_type, user_name);
                    RAISE NOTICE '%', v_message;

                    INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                    VALUES (action_type, user_name, NULL, v_log_status, v_sql_command, v_message);
                ELSE
                    v_log_status := 'DRY_RUN';
                    v_message := format('[DRY RUN] Would drop %s: "%s".', action_type, user_name);
                    RAISE NOTICE '%', v_message;

                    INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
                    VALUES (action_type, user_name, NULL, v_log_status, v_sql_command, v_message);
                END IF;
            END IF;

        ELSE
            v_log_status := 'ALREADY_EXISTS'; -- Using ALREADY_EXISTS to mean "not found" in this context
            v_message := format('Role/User "%s" does not exist. No action taken.', user_name);
            RAISE NOTICE '%', v_message;

            INSERT INTO dba.account_log_history (action_type, target_entity, associated_entity, status, sql_command, message)
            VALUES ('DROP_ATTEMPT', user_name, NULL, v_log_status, NULL, v_message);
        END IF;
    END LOOP;
END
$$ LANGUAGE plpgsql;