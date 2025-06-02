CREATE OR REPLACE FUNCTION dba.get_user_roles(user_roles TEXT)
RETURNS TABLE (
    role_name TEXT,
    grantee_name TEXT,
    is_default_role TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Handle 'NoRole' special case: all login roles with no memberships
    IF user_roles = 'NoRole' THEN
        RETURN QUERY
        SELECT 
            NULL::TEXT AS role_name,
            r.rolname::TEXT AS grantee_name,
            NULL::TEXT AS is_default_role
        FROM pg_roles r
        WHERE r.rolcanlogin = true
          AND NOT EXISTS (
              SELECT 1 FROM pg_auth_members m WHERE m.member = r.oid
          );

    -- Handle case: user_roles is a member (grantee) of other roles
    ELSIF EXISTS (
        SELECT 1
        FROM pg_roles u
        JOIN pg_auth_members m ON m.member = u.oid
        WHERE u.rolname = user_roles
    ) THEN
        RETURN QUERY
        SELECT 
            r.rolname::TEXT AS role_name,
            user_roles::TEXT AS grantee_name,
            NULL::TEXT AS is_default_role
        FROM pg_roles u
        JOIN pg_auth_members m ON m.member = u.oid
        JOIN pg_roles r ON r.oid = m.roleid
        WHERE u.rolname = user_roles;

    -- Handle case: user_roles is a role with members
    ELSIF EXISTS (
        SELECT 1
        FROM pg_roles r
        JOIN pg_auth_members m ON m.roleid = r.oid
        WHERE r.rolname = user_roles
    ) THEN
        RETURN QUERY
        SELECT 
            user_roles::TEXT AS role_name,
            u.rolname::TEXT AS grantee_name,
            NULL::TEXT AS is_default_role
        FROM pg_roles r
        JOIN pg_auth_members m ON m.roleid = r.oid
        JOIN pg_roles u ON u.oid = m.member
        WHERE r.rolname = user_roles;

    ELSE
        -- If it's not a role or user with relationships, return nothing
        RETURN;
    END IF;
END;
$$;
