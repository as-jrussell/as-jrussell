-- ==============================================================
-- 🧪 MASTER DEPLOYMENT SCRIPT — Run All Setup Functions
-- Author: jc_the_dba
-- Date: 2025-07-14
-- ==============================================================

-- 🔁 SET DRY-RUN / EXECUTION FLAG (TRUE = execute, FALSE = dry-run)
\set execute_flag TRUE



-- ✅ STEP 2: SCHEMA CREATION
\i 04_Schema_creation.sql

-- ✅ STEP 1: TABLE CREATION
\i 03_tablecreations.sql


-- ✅ STEP 4: ROLE PERMISSIONS
\i 07_deploy.SetRolePermissions.sql

-- ✅ STEP 5: REVOKE PERMISSIONS
\i 08_deploy.SetRevokeRolePermissions.sql

-- ✅ STEP 6: USER CREATION & ROLE ASSIGNMENT
\i 09_deploy.SetCreateUser.sql

-- ✅ STEP 7: REVOKE USERS
\i 10_deploy.SetRevokeUser.sql

-- ✅ STEP 8: FULL ACCOUNT SETUP
\i 11_deploy.SetAccountSetup.sql

-- ✅ STEP 9: FULL ACCOUNT TEARDOWN
\i 12_deploy.SetAccountRevoke.sql

-- ✅ STEP 10: PASSWORD SET FUNCTION
\i 13_info.SetPassword.sql

-- ✅ STEP 11: WHOISACTIVE FUNCTION (diagnostic)
\i 14_info.sp_whoisactive.sql

-- ✅ STEP 12: Give team access to the instance
\i 15_Adding_DBA_team.sql

-- ==============================================================
-- DONE 🎉 Output logs will show DRY_RUN or EXECUTED based on flag
-- ==============================================================

