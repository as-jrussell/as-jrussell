
  SELECT * FROM sys.server_principals
WHERE name like '%PIMSAppService%'



SELECT * FROM sys.server_principals
WHERE is_disabled = 1



SELECT * FROM sys.server_principals
WHERE is_disabled = 1
and name not like '#%#' and principal_id != 1
ORDER BY name ASC



SELECT CONCAT('USE MASTER DROP LOGIN [',name, ']')
FROM sys.server_principals
WHERE is_disabled = 1
and name not like '#%#' and principal_id != 1
ORDER BY name ASC
