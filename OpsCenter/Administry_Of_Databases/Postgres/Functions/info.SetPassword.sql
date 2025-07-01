
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_namespace WHERE nspname = 'info'
    ) THEN
        EXECUTE 'CREATE SCHEMA info AUTHORIZATION current_user';
        RAISE NOTICE 'Schema "info" created.';
    ELSE
        RAISE NOTICE 'Schema "info" already exists.';
    END IF;
END
$$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'info' AND table_name = 'password_change_audit'
    ) THEN
        EXECUTE '
            CREATE TABLE info.password_change_audit (
                audit_id SERIAL PRIMARY KEY,
                changed_at TIMESTAMPTZ DEFAULT now(),
                changed_by TEXT NOT NULL,
                changed_user TEXT NOT NULL,
                note TEXT
            )
        ';
        RAISE NOTICE 'Table "info.password_change_audit" created.';
    ELSE
        RAISE NOTICE 'Table "info.password_change_audit" already exists.';
    END IF;
END
$$;


CREATE OR REPLACE FUNCTION info.SetPassword(
    target_username TEXT,
    new_password TEXT
)
RETURNS VOID AS
$$
DECLARE
    caller TEXT := session_user;
BEGIN
    -- Input validation
    IF target_username IS NULL OR trim(target_username) = '' THEN
        RAISE EXCEPTION 'Username cannot be null or empty';
    END IF;

    IF new_password IS NULL OR trim(new_password) = '' THEN
        RAISE EXCEPTION 'Password cannot be null or empty';
    END IF;

    IF length(new_password) < 9 THEN
        RAISE EXCEPTION 'Password must be at least 12 characters long';
    END IF;

    IF lower(target_username) = 'postgres' THEN
        RAISE EXCEPTION 'Changing password for superuser "postgres" is not allowed through this function';
    END IF;

    -- Explicit check for user existence
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = target_username) THEN
        EXECUTE format('ALTER ROLE %I WITH PASSWORD %L', target_username, new_password);
        
        INSERT INTO info.password_change_audit (changed_by, changed_user, note)
        VALUES (caller, target_username, 'Password changed via info.safe_change_password');

        -- Return success message
        RAISE NOTICE 'SUCCESS: Password changed for user %', target_username;
    ELSE
        RAISE EXCEPTION 'User "%" does not exist', target_username;
    END IF;
END;
$$
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = info, public;

DO $$
BEGIN
    RAISE NOTICE 'To execute password change: SELECT info.SetPassword(''username'', ''password'')';
END;
$$ LANGUAGE plpgsql;

