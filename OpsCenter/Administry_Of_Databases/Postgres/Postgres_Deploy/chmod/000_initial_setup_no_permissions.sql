-- ==============================================================
-- 🚀 INITIAL INFRASTRUCTURE SETUP — Roles + Database
-- ==============================================================
-- 🔁 DRY-RUN / EXECUTION FLAG (optional)
-- \set execute_flag TRUE

-- ✅ STEP 1: CREATE ROLES
\i Role_creations.sql

-- ✅ STEP 2: CREATE DATABASE
\i DBA_database_creation.sql

-- ==============================================================
-- End of initial environment prep
-- ==============================================================


\connect :"dbname"

set role dba_team;
-- ==============================================================
-- 🧪 MASTER DEPLOYMENT SCRIPT — Run All Setup Functions
-- Author: jc_the_dba
-- Date: 2025-07-14
-- ==============================================================

-- 🔁 SET DRY-RUN / EXECUTION FLAG (TRUE = execute, FALSE = dry-run)
\set execute_flag TRUE




-- ✅ STEP 3: SCHEMA CREATION
\i Schema_creation.sql

-- ✅ STEP 4: TABLE CREATION
\i Tablecreations.sql

-- ✅ STEP 5: ROLE PERMISSIONS
\i deploy.SetRolePermissions.sql

-- ✅ STEP 6: REVOKE PERMISSIONS
\i deploy.SetRevokeRolePermissions.sql

-- ✅ STEP 7: USER CREATION & ROLE ASSIGNMENT
\i deploy.SetCreateUser.sql

-- ✅ STEP 8: REVOKE USERS
\i deploy.SetRevokeUser.sql

-- ✅ STEP 9: FULL ACCOUNT SETUP
\i deploy.SetAccountSetup.sql

-- ✅ STEP 10: FULL ACCOUNT TEARDOWN
\i deploy.SetAccountRevoke.sql

-- ✅ STEP 11: PASSWORD SET FUNCTION
\i info.SetPassword.sql

-- ✅ STEP 12: WHOISACTIVE FUNCTION (diagnostic)
\i info.sp_whoisactive.sql

-- ✅ STEP 13: Create Schema Function
\i deploy.createschemawithpermissions.sql

-- ✅ STEP 14: Drop Schema Function
\i deploy.DropSchemaWithCleanup.sql

-- ✅ STEP 15: SetDatabaseConnectionLimit
\i SetDatabaseConnectionLimit.sql

