DO $$
DECLARE
    func_oid oid;
BEGIN
    SELECT oid INTO func_oid
    FROM pg_proc
    WHERE proname = 'get_role_members'
      AND proargtypes = '25 16 16'::oidvector;  -- 25=text, 16=boolean

    IF func_oid IS NOT NULL THEN
        EXECUTE 'DROP FUNCTION get_role_members(text, boolean, boolean)';
        RAISE NOTICE 'Function get_role_members(text, boolean, boolean) dropped.';
    ELSE
        RAISE NOTICE 'Function get_role_members(text, boolean, boolean) does not exist.';
    END IF;
END
$$ LANGUAGE plpgsql;

CREATE FUNCTION get_role_members(
    p_role_name TEXT,
    dry_run BOOLEAN DEFAULT FALSE,
    is_verbose BOOLEAN DEFAULT FALSE
)
RETURNS TABLE(
    member_name TEXT,
    role_name TEXT,
    rolsuper BOOLEAN,
    rolinherit BOOLEAN,
    rolcreaterole BOOLEAN,
    rolcreatedb BOOLEAN,
    rolreplication BOOLEAN,
    rolbypassrls BOOLEAN
) AS
$$
BEGIN
    IF dry_run THEN
        IF is_verbose THEN
            RAISE NOTICE 'DRY-RUN MODE ON - Query not executed.';
            RAISE NOTICE 'SELECT FROM pg_roles WHERE rolname = %', p_role_name;
            RAISE NOTICE 'JOIN pg_auth_members and pg_roles to show membership.';
        ELSE
            RAISE NOTICE 'DRY-RUN: Would retrieve role and membership info for role: %', p_role_name;
        END IF;
        RETURN;
    END IF;

    RETURN QUERY
    SELECT
        rolname AS member_name,
        rolname AS role_name,
        rolsuper,
        rolinherit,
        rolcreaterole,
        rolcreatedb,
        rolreplication,
        rolbypassrls
    FROM
        pg_roles
    WHERE
        rolname = p_role_name

    UNION ALL

    SELECT
        member.rolname AS member_name,
        role.rolname AS role_name,
        member.rolsuper,
        member.rolinherit,
        member.rolcreaterole,
        member.rolcreatedb,
        member.rolreplication,
        member.rolbypassrls
    FROM
        pg_auth_members m
        JOIN pg_roles role ON m.roleid = role.oid
        JOIN pg_roles member ON m.member = member.oid
    WHERE
        role.rolname = p_role_name;
END;
$$ LANGUAGE plpgsql;
