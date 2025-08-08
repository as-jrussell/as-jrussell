-- ==============================================================
-- 🚀 INITIAL INFRASTRUCTURE SETUP — Roles + Database
-- ==============================================================
-- 🔁 DRY-RUN / EXECUTION FLAG (optional)
-- \set execute_flag TRUE

-- ✅ CREATE ROLES
\i Role_creations.sql

-- ✅ CREATE DATABASE
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




-- ✅ SCHEMA CREATION
\i Schema_creation.sql

-- ✅ TABLE CREATION
\i Tablecreations.sql

-- ✅ ROLE PERMISSIONS
\i deploy.SetRolePermissions.sql

-- ✅ REVOKE PERMISSIONS
\i deploy.SetRevokeRolePermissions.sql

-- ✅ USER CREATION & ROLE ASSIGNMENT
\i deploy.SetCreateUser.sql

-- ✅ REVOKE USERS
\i deploy.SetRevokeUser.sql

-- ✅ FULL ACCOUNT SETUP
\i deploy.SetAccountSetup.sql

-- ✅ FULL ACCOUNT TEARDOWN
\i deploy.SetAccountRevoke.sql

-- ✅ PASSWORD SET FUNCTION
\i info.SetPassword.sql

-- ✅ Check Permissions
\i info.GetPrivileges.sql

-- ✅ WHOISACTIVE FUNCTION (diagnostic)
\i info.sp_whoisactive.sql

-- ✅ Create Schema Function
\i deploy.createschemawithpermissions.sql

-- ✅ Drop Schema Function
\i deploy.DropSchemaWithCleanup.sql

-- ✅ Give team access to the instance
\i Adding_DBA_team.sql

-- ✅ SetDatabaseConnectionLimit
\i admin.SetDBOffline.sql


-- ✅ Extra Credit
\i DatabaseName.sql

\i dba.GetPrivileges.sql
