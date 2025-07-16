-- FUNCTION: deploy.setaccountrevoke(text[], text[], text[], text[], text[], boolean, boolean)

-- DROP FUNCTION IF EXISTS deploy.setaccountrevoke(text[], text[], text[], text[], text[], boolean, boolean);

CREATE OR REPLACE FUNCTION deploy.SetAccountRevoke(
    p_usernames TEXT[] DEFAULT NULL,
    p_role_names TEXT[] DEFAULT NULL,
    p_schemas TEXT[] DEFAULT NULL,
    p_inherit_roles TEXT[] DEFAULT NULL,
    p_object_roles TEXT[] DEFAULT NULL,
    p_execute_flag BOOLEAN DEFAULT FALSE,
    p_verbose_flag BOOLEAN DEFAULT FALSE
)
    RETURNS text
    LANGUAGE plpgsql
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $$
DECLARE
    v_result TEXT := '';
BEGIN
    -- Step 1: Revoke user inheritance (GRANT role TO user)
    IF p_usernames IS NOT NULL AND p_inherit_roles IS NOT NULL THEN
        v_result := v_result || deploy.SetRevokeUser(
            p_usernames := p_usernames,
            p_inherit_roles := p_inherit_roles,
            p_execute_flag := p_execute_flag
        ) || E'\n';
    END IF;

    -- Step 2: Drop users
    IF p_usernames IS NOT NULL THEN
        v_result := v_result || deploy.SetRevokeUser(
            p_usernames := p_usernames,
            p_execute_flag := p_execute_flag
        ) || E'\n';
    END IF;

    -- Step 3: Revoke object-level permissions for roles
    IF p_object_roles IS NOT NULL AND p_schemas IS NOT NULL THEN
        v_result := v_result || deploy.SetRevokeRolePermissions(
            p_roles := p_object_roles,
            p_schemas := p_schemas,
            p_execute_flag := p_execute_flag
        ) || E'\n';
    END IF;

    -- Step 4: Drop roles
    IF p_role_names IS NOT NULL THEN
        v_result := v_result || deploy.SetRoleRevoke(
            p_roles := p_role_names,
            p_execute_flag := p_execute_flag
        ) || E'\n';
    END IF;

    RETURN v_result;
END;
$$;

ALTER FUNCTION deploy.SetAccountRevoke(
    TEXT[], TEXT[], TEXT[], TEXT[], TEXT[], BOOLEAN, BOOLEAN
) OWNER TO dba_team;
