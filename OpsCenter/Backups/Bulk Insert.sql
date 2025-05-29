IF NOT EXISTS (SELECT 1
               FROM   sys.server_role_members dm
                      JOIN sys.server_principals rp
                        ON rp.principal_id = dm.role_principal_id
                      JOIN sys.server_principals mp
                        ON mp.principal_id = dm.member_principal_id
               WHERE  mp.NAME = 'ELDREDGE_A\IT Sys Admins'
                      AND rp.NAME = 'bulkadmin')
  BEGIN
      ALTER ROLE [bulkadmin] ADD MEMBER [ELDREDGE_A\IT Sys Admins]
  END 
