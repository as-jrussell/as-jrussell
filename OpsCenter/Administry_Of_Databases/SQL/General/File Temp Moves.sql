--Update Data files & Log Files 
DECLARE @TEMPDB nvarchar(1) = 'H'



SELECT CONCAT( 'ALTER DATABASE [tempdb] MODIFY FILE ( NAME = ',name,', FILENAME = '''+ @TEMPDB +':\TEMPDB\',name,'.mdf'')')
				  FROM sys.master_files f
where (database_id =2)
AND TYPE = '0'



SELECT DISTINCT CONCAT( 'ALTER DATABASE [tempdb] MODIFY FILE ( NAME = ',F.name,', FILENAME = '''+@TEMPDB +':\TEMPDB\',F.name,'.ldf'')')
				  FROM sys.master_files f
				  Join  sys.master_files a on A.database_id = F.database_id
where (F.database_id =2)
AND F.TYPE = '1'
AND A.TYPE = '0'








