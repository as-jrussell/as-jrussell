CREATE OR REPLACE FUNCTION deploy.SetRevokeRolePermissions(
    target_user TEXT,
    target_schema TEXT DEFAULT 'your_schema',
    access_type TEXT DEFAULT 'select'  -- Options: select, write, ddladmin, owner
) RETURNS VOID AS $$
/*
==========================================================
🚫 deploy.SetRevokeRolePermissions() - Example Use Cases
==========================================================

-- 🧼 NUKE ALL: Revoke *all* privileges from role across schemas
SELECT deploy.SetRevokeRolePermissions(
    p_access_roles := ARRAY['db_datareader'],
    p_access_type := 'ALL',
    p_execute_flag := TRUE
);

-- 🔬 REVOKE SELECT ONLY: Removes only SELECT permissions from role
SELECT deploy.SetRevokeRolePermissions(
    p_access_roles := ARRAY['readonly_role'],
    p_access_type := 'SELECT',
    p_execute_flag := TRUE
);

-- ⚙️ REVOKE EXECUTE ONLY: Removes function/proc EXECUTE rights
SELECT deploy.SetRevokeRolePermissions(
    p_access_roles := ARRAY['executor_role'],
    p_access_type := 'EXECUTE',
    p_execute_flag := TRUE
);

-- 🧪 DRY-RUN: Simulate revocation without actually running it
SELECT deploy.SetRevokeRolePermissions(
    p_access_roles := ARRAY['audit_role'],
    p_access_type := 'SELECT',
    p_execute_flag := FALSE
);

-- 🎯 MULTI-ROLE TARGET: Revoke SELECT from multiple roles
SELECT deploy.SetRevokeRolePermissions(
    p_access_roles := ARRAY['app_reader', 'service_reader'],
    p_access_type := 'SELECT',
    p_execute_flag := TRUE
);
*/

DECLARE
    action_status TEXT := 'success';
    action_message TEXT := '';
BEGIN
    BEGIN
        IF access_type = 'select' THEN
            -- Revoke SELECT access
            EXECUTE format('REVOKE USAGE ON SCHEMA %I FROM %I', target_schema, target_user);
            EXECUTE format('REVOKE SELECT ON ALL TABLES IN SCHEMA %I FROM %I', target_schema, target_user);
            EXECUTE format('REVOKE EXECUTE ON ALL FUNCTIONS IN SCHEMA %I FROM %I', target_schema, target_user);
            EXECUTE format('REVOKE USAGE, SELECT ON ALL SEQUENCES IN SCHEMA %I FROM %I', target_schema, target_user);
            EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I REVOKE SELECT ON TABLES FROM %I', target_schema, target_user);
            EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I REVOKE EXECUTE ON FUNCTIONS FROM %I', target_schema, target_user);
            EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I REVOKE USAGE, SELECT ON SEQUENCES FROM %I', target_schema, target_user);

        ELSIF access_type = 'write' THEN
            -- Revoke write-level access
            EXECUTE format('REVOKE USAGE ON SCHEMA %I FROM %I', target_schema, target_user);
            EXECUTE format('REVOKE SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA %I FROM %I', target_schema, target_user);
            EXECUTE format('REVOKE EXECUTE ON ALL FUNCTIONS IN SCHEMA %I FROM %I', target_schema, target_user);
            EXECUTE format('REVOKE USAGE, UPDATE ON ALL SEQUENCES IN SCHEMA %I FROM %I', target_schema, target_user);
            EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLES FROM %I', target_schema, target_user);
            EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I REVOKE EXECUTE ON FUNCTIONS FROM %I', target_schema, target_user);
            EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I REVOKE USAGE, UPDATE ON SEQUENCES FROM %I', target_schema, target_user);

        ELSIF access_type = 'ddladmin' THEN
            -- Revoke ALL on all objects
            EXECUTE format('REVOKE USAGE ON SCHEMA %I FROM %I', target_schema, target_user);
            EXECUTE format('REVOKE ALL ON ALL TABLES IN SCHEMA %I FROM %I', target_schema, target_user);
            EXECUTE format('REVOKE ALL ON ALL FUNCTIONS IN SCHEMA %I FROM %I', target_schema, target_user);
            EXECUTE format('REVOKE ALL ON ALL SEQUENCES IN SCHEMA %I FROM %I', target_schema, target_user);
            EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I REVOKE ALL ON TABLES FROM %I', target_schema, target_user);
            EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I REVOKE ALL ON FUNCTIONS FROM %I', target_schema, target_user);
            EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I REVOKE ALL ON SEQUENCES FROM %I', target_schema, target_user);

        ELSIF access_type = 'owner' THEN
            -- Revoke ownership not possible unless you reassign, so log and skip
            RAISE NOTICE 'Cannot revoke ownership via REVOKE. Use ALTER OWNER TO reassign.';
            action_status := 'skipped';
            action_message := 'Ownership not revoked. Requires ALTER OWNER TO.';
        ELSE
            RAISE EXCEPTION 'Invalid access_type: %. Must be one of: select, write, ddladmin, owner.', access_type;
        END IF;

    EXCEPTION WHEN OTHERS THEN
        action_status := 'failed';
        action_message := SQLERRM;
    END;

    -- Log it
    INSERT INTO info.account_log_history (
        action_type,
        target_entity,
        associated_entity,
        status,
        sql_command,
        message
    ) VALUES (
        'REVOKE_ROLE',
        target_user,
        access_type,
        action_status,
        'deploy.RevokeRolePermissions',
        action_message
    );

    RAISE NOTICE 'Revoked % access from user % on schema %', access_type, target_user, target_schema;
END;
$$ LANGUAGE plpgsql;
