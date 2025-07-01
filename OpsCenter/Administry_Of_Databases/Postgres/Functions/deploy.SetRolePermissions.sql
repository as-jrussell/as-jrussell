CREATE OR REPLACE FUNCTION deploy.SetRolePermissions(
    target_user TEXT,
    target_schema TEXT DEFAULT 'your_schema',
    access_type TEXT DEFAULT 'select'  -- Options: select, write, ddladmin, owner
) RETURNS VOID AS $$
/*
==========================================================
🎯 deploy.SetRolePermissions() - Example Use Cases
==========================================================

-- 🔍 BASIC: Grant SELECT on all tables in all schemas to a role
SELECT deploy.SetRolePermissions(
    p_apply_schema_privs_to_roles := ARRAY['db_datareader'],
    p_table_privileges := ARRAY['SELECT'],
    p_apply_to_existing_tables := TRUE,
    p_execute_flag := TRUE
);

-- 🧠 FUNCTIONS ONLY: Grant EXECUTE on all functions to a role
SELECT deploy.SetRolePermissions(
    p_apply_schema_privs_to_roles := ARRAY['db_function_exec'],
    p_function_privileges := ARRAY['EXECUTE'],
    p_execute_flag := TRUE
);

-- 🧪 DRY-RUN: Simulate a permission grant without applying
SELECT deploy.SetRolePermissions(
    p_apply_schema_privs_to_roles := ARRAY['test_role'],
    p_table_privileges := ARRAY['SELECT', 'INSERT'],
    p_apply_to_existing_tables := TRUE,
    p_set_default_for_future_tables := TRUE,
    p_execute_flag := FALSE
);

-- 🚿 CLEAN & GRANT: Revoke all table permissions first, then apply SELECT + INSERT
SELECT deploy.SetRolePermissions(
    p_apply_schema_privs_to_roles := ARRAY['db_datawriter'],
    p_table_privileges := ARRAY['SELECT', 'INSERT'],
    p_apply_to_existing_tables := TRUE,
    p_revoke_all_first := TRUE,
    p_execute_flag := TRUE
);

-- 🧬 DEFAULT PRIVILEGES: Set future defaults for tables and functions
SELECT deploy.SetRolePermissions(
    p_apply_schema_privs_to_roles := ARRAY['db_future_ready'],
    p_table_privileges := ARRAY['SELECT'],
    p_function_privileges := ARRAY['EXECUTE'],
    p_set_default_for_future_tables := TRUE,
    p_set_default_for_future_functions := TRUE,
    p_execute_flag := TRUE
);

-- 🧨 FULL SEND: Apply SELECT + INSERT to all existing tables and future tables/functions
SELECT deploy.SetRolePermissions(
    p_apply_schema_privs_to_roles := ARRAY['db_fullpower'],
    p_table_privileges := ARRAY['SELECT', 'INSERT'],
    p_function_privileges := ARRAY['EXECUTE'],
    p_apply_to_existing_tables := TRUE,
    p_set_default_for_future_tables := TRUE,
    p_set_default_for_future_functions := TRUE,
    p_execute_flag := TRUE
);

-- 💥 MULTI-ROLE: Apply SELECT to multiple roles at once
SELECT deploy.SetRolePermissions(
    p_apply_schema_privs_to_roles := ARRAY['db_a', 'db_b', 'db_c'],
    p_table_privileges := ARRAY['SELECT'],
    p_apply_to_existing_tables := TRUE,
    p_execute_flag := TRUE
);
*/

DECLARE
    r RECORD;
    action_status TEXT := 'success';
    action_message TEXT := '';
BEGIN
    -- Create user if not exists (no password logic)
    PERFORM 1 FROM pg_roles WHERE rolname = target_user;
    IF NOT FOUND THEN
        EXECUTE format('CREATE ROLE %I WITH LOGIN', target_user);
    END IF;

    -- Conditionally create role and assign privileges
    IF access_type = 'select' THEN
        PERFORM 1 FROM pg_roles WHERE rolname = 'db_datareader';
        IF NOT FOUND THEN
            EXECUTE 'CREATE ROLE db_datareader';
        END IF;
        EXECUTE format('GRANT db_datareader TO %I', target_user);
        EXECUTE format('GRANT USAGE ON SCHEMA %I TO %I', target_schema, target_user);
        EXECUTE format('GRANT SELECT ON ALL TABLES IN SCHEMA %I TO %I', target_schema, target_user);
        EXECUTE format('GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA %I TO %I', target_schema, target_user);
        EXECUTE format('GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA %I TO %I', target_schema, target_user);
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT SELECT ON TABLES TO %I', target_schema, target_user);
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT EXECUTE ON FUNCTIONS TO %I', target_schema, target_user);
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT USAGE, SELECT ON SEQUENCES TO %I', target_schema, target_user);

    ELSIF access_type = 'write' THEN
        PERFORM 1 FROM pg_roles WHERE rolname = 'db_datawriter';
        IF NOT FOUND THEN
            EXECUTE 'CREATE ROLE db_datawriter';
        END IF;
        EXECUTE format('GRANT db_datawriter TO %I', target_user);
        EXECUTE format('GRANT USAGE ON SCHEMA %I TO %I', target_schema, target_user);
        EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA %I TO %I', target_schema, target_user);
        EXECUTE format('GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA %I TO %I', target_schema, target_user);
        EXECUTE format('GRANT USAGE, UPDATE ON ALL SEQUENCES IN SCHEMA %I TO %I', target_schema, target_user);
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO %I', target_schema, target_user);
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT EXECUTE ON FUNCTIONS TO %I', target_schema, target_user);
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT USAGE, UPDATE ON SEQUENCES TO %I', target_schema, target_user);

    ELSIF access_type = 'ddladmin' THEN
        PERFORM 1 FROM pg_roles WHERE rolname = 'db_ddladmin';
        IF NOT FOUND THEN
            EXECUTE 'CREATE ROLE db_ddladmin';
        END IF;
        EXECUTE format('GRANT db_ddladmin TO %I', target_user);
        EXECUTE format('GRANT USAGE ON SCHEMA %I TO %I', target_schema, target_user);
        EXECUTE format('GRANT ALL ON ALL TABLES IN SCHEMA %I TO %I', target_schema, target_user);
        EXECUTE format('GRANT ALL ON ALL FUNCTIONS IN SCHEMA %I TO %I', target_schema, target_user);
        EXECUTE format('GRANT ALL ON ALL SEQUENCES IN SCHEMA %I TO %I', target_schema, target_user);
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT ALL ON TABLES TO %I', target_schema, target_user);
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT ALL ON FUNCTIONS TO %I', target_schema, target_user);
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT ALL ON SEQUENCES TO %I', target_schema, target_user);

    ELSIF access_type = 'owner' THEN
        BEGIN
            FOR r IN SELECT tablename FROM pg_tables WHERE schemaname = target_schema LOOP
                EXECUTE format('ALTER TABLE %I.%I OWNER TO %I', target_schema, r.tablename, target_user);
            END LOOP;

            FOR r IN SELECT sequence_name FROM information_schema.sequences WHERE sequence_schema = target_schema LOOP
                EXECUTE format('ALTER SEQUENCE %I.%I OWNER TO %I', target_schema, r.sequence_name, target_user);
            END LOOP;

            FOR r IN SELECT routine_name FROM information_schema.routines WHERE routine_schema = target_schema LOOP
                BEGIN
                    EXECUTE format('ALTER FUNCTION %I.%I() OWNER TO %I', target_schema, r.routine_name, target_user);
                EXCEPTION WHEN OTHERS THEN
                    RAISE NOTICE 'Could not change owner for function %', r.routine_name;
                END;
            END LOOP;
        EXCEPTION WHEN OTHERS THEN
            action_status := 'failed';
            action_message := SQLERRM;
        END;

    ELSE
        RAISE EXCEPTION 'Invalid access_type: %. Must be one of: select, write, ddladmin, owner.', access_type;
    END IF;

    -- Insert log
    INSERT INTO info.account_log_history (
        action_type,
        target_entity,
        associated_entity,
        status,
        sql_command,
        message
    ) VALUES (
        'CREATE_ROLE',
        target_user,
        access_type,
        action_status,
        'deploy.SetRolePermissions',
        action_message
    );

    RAISE NOTICE 'Privileges assigned to user % for access type % on schema %', target_user, access_type, target_schema;
END;
$$ LANGUAGE plpgsql;
