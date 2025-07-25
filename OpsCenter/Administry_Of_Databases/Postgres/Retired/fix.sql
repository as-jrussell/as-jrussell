-- ✅ STEP 6: REVOKE PERMISSIONS
\i deploy.SetRevokeRolePermissions.sql

-- ✅ STEP 13: Create Schema Function
\i deploy.createschemawithpermissions.sql

-- ✅ STEP 14: Drop Schema Function
\i deploy.DropSchemaWithCleanup.sql