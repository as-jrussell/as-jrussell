
-- ============================================================
-- STEP 01: Create Roles (if not already present)
-- ============================================================
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'db_ddladmin2') THEN
        CREATE ROLE db_ddladmin2;
        RAISE NOTICE 'PASS: Role "db_ddladmin2" created.';
    ELSE
        RAISE NOTICE 'SKIP: Role "db_ddladmin2" already exists.';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'FAIL: Role "db_ddladmin2" - %', SQLERRM;
END$$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'db_datawriter2') THEN
        CREATE ROLE db_datawriter2;
        RAISE NOTICE 'PASS: Role "db_datawriter2" created.';
    ELSE
        RAISE NOTICE 'SKIP: Role "db_datawriter2" already exists.';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'FAIL: Role "db_datawriter2" - %', SQLERRM;
END$$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'db_datareader2') THEN
        CREATE ROLE db_datareader2;
        RAISE NOTICE 'PASS: Role "db_datareader2" created.';
    ELSE
        RAISE NOTICE 'SKIP: Role "db_datareader2" already exists.';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'FAIL: Role "db_datareader2" - %', SQLERRM;
END$$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'dba_team') THEN
        CREATE ROLE dba_team;
        RAISE NOTICE 'PASS: Role "dba_team" created.';
    ELSE
        RAISE NOTICE 'SKIP: Role "dba_team" already exists.';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'FAIL: Role "dba_team" - %', SQLERRM;
END$$;

-- ============================================================
-- STEP 02: Grant Role Memberships
-- ============================================================
DO $$
BEGIN
    GRANT db_datawriter2 TO dba_team;
    RAISE NOTICE 'PASS: Granted db_datawriter2 to dba_team.';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'FAIL: Grant db_datawriter2 to dba_team - %', SQLERRM;
END$$;

DO $$
BEGIN
    GRANT db_ddladmin2 TO dba_team;
    RAISE NOTICE 'PASS: Granted db_ddladmin2 to dba_team.';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'FAIL: Grant db_ddladmin2 to dba_team - %', SQLERRM;
END$$;

DO $$
BEGIN
    GRANT db_datareader2 TO dba_team;
    RAISE NOTICE 'PASS: Granted db_datareader2 to dba_team.';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'FAIL: Grant db_datareader2 to dba_team - %', SQLERRM;
END$$;
