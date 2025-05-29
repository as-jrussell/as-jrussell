SELECT name AS LoginName, 
   DATEADD(DAY, CAST(LOGINPROPERTY(name, 'DaysUntilExpiration') AS int), GETDATE()) AS ExpirationDate,
   create_date
   FROM sys.server_principals
   WHERE type = 'S'
   AND    DATEADD(DAY, CAST(LOGINPROPERTY(name, 'DaysUntilExpiration') AS int), GETDATE()) IS NOT NULL
