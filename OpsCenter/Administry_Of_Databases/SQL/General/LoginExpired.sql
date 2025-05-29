IF Object_id(N'tempdb..#LoginExpired') IS NOT NULL
  DROP TABLE #LoginExpired

CREATE TABLE #LoginExpired
  (
     [name]           VARCHAR(255),
     Password_Expires VARCHAR(5)
  );

INSERT INTO #LoginExpired
SELECT name,
       CASE
         WHEN is_expiration_checked = 1 THEN 'Y'
         ELSE 'N'
       END
FROM   sys.sql_logins
WHERE  is_expiration_checked <> '0'

SELECT *
FROM   #LoginExpired
