

 declare @cmd3 varchar(500)


 set @cmd3 ='USE ? SELECT DB_NAME(), * FROM SYS.TABLES WHERE NAME LIKE ''%IQQ_VEHICLE_MODEL%%'''

  exec sp_MSforeachdb @cmd3