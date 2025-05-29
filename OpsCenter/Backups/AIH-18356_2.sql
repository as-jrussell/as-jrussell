IF( Has_perms_by_name ('sys.dm_hadr_availability_replica_states', 'OBJECT', 'execute') = 1 )
  BEGIN
      -- if this is not an AG server then return 'PRIMARY'
      IF NOT EXISTS(SELECT 1
                    FROM   sys.DATABASES d
                           INNER JOIN sys.dm_hadr_availability_replica_states hars
                                   ON d.replica_id = hars.replica_id)
        BEGIN
            EXEC [DBA].[archive].[Purgestoragetable]
              @DatabaseName = 'UnitracHDStorage',
              @WhatIf = 0

            EXEC [DBA].[archive].[Purgestoragetable]
              @DatabaseName = 'HDTStorage',
              @WhatIf = 0
        END
      ELSE
      -- else return if there is AN PRIMARY availability group PRIMARY else 'SECONDARY
      IF EXISTS(SELECT hars.role_desc
                FROM   sys.DATABASES d
                       INNER JOIN sys.dm_hadr_availability_replica_states hars
                               ON d.replica_id = hars.replica_id
                WHERE  hars.role_desc = 'PRIMARY')
        BEGIN
            EXEC [DBA].[archive].[Purgestoragetable]
              @DatabaseName = 'UnitracHDStorage',
              @WhatIf = 0

            EXEC [DBA].[archive].[Purgestoragetable]
              @DatabaseName = 'HDTStorage',
              @WhatIf = 0
        END
      ELSE
        BEGIN
            PRINT 'DO NOTHING'
        END
  END 