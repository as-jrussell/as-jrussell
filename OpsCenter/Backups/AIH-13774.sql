IF EXISTS (SELECT *
           FROM   sys.servers
           WHERE  name IN ( 'DPASTATS' ))
  BEGIN
      EXEC master.dbo.Sp_dropserver
        @server=N'DPASTATS',
        @droplogins='droplogins'
  END

IF EXISTS (SELECT *
           FROM   sys.servers
           WHERE  name IN ( 'MRHAT' ))
  BEGIN
      EXEC master.dbo.Sp_dropserver
        @server=N'MRHAT',
        @droplogins='droplogins'
  END

IF EXISTS (SELECT *
           FROM   sys.servers
           WHERE  name IN ( 'UTQA-SQL' ))
  BEGIN
      EXEC master.dbo.Sp_dropserver
        @server=N'UTQA-SQL',
        @droplogins='droplogins'
  END

IF EXISTS (SELECT *
           FROM   sys.servers
           WHERE  name IN ( 'UTSTAGE01' ))
  BEGIN
      EXEC master.dbo.Sp_dropserver
        @server=N'UTSTAGE01',
        @droplogins='droplogins'
  END

IF EXISTS (SELECT *
           FROM   sys.servers
           WHERE  name IN ( 'UT-STG-LISTENER' ))
  BEGIN
      EXEC master.dbo.Sp_dropserver
        @server=N'UT-STG-LISTENER',
        @droplogins='droplogins'
  END

IF EXISTS (SELECT *
           FROM   sys.servers
           WHERE  name IN ( 'VUT-DB01' ))
  BEGIN
      EXEC master.dbo.Sp_dropserver
        @server=N'VUT-DB01',
        @droplogins='droplogins'
  END

IF EXISTS (SELECT *
           FROM   sys.servers
           WHERE  name IN ( 'WINTRAQSQL.COLO.AS.LOCAL' ))
  BEGIN
      EXEC master.dbo.Sp_dropserver
        @server=N'WINTRAQSQL.COLO.AS.LOCAL',
        @droplogins='droplogins'
  END 
