USE Globalscape_ARM

  SELECT GETDATE()

select *
from tbl_authentications
where UserName like '%UnitracHOV%' AND CAST(Time_stamp AS DATE) = CAST(GETDATE() AS DATE)
order by Time_stamp DESC 


select *
from tbl_ServerInternalEvents
where UserName like '%UnitracHOV%'AND CAST(Time_stamp AS DATE) = CAST(GETDATE() AS DATE)
order by Time_stamp DESC 

select *
from tbl_ProtocolCommands
where PhysicalFolderName like '%UnitracHOV%' AND CAST(Time_stamp AS DATE) = CAST(GETDATE() AS DATE)
ORDER by Time_stamp DESC 



SELECT *
FROM   tbl_ProtocolCommands
WHERE  VirtualFolderName IN ( '/External/foer_bhup_idr/' ,
                              '/External/foer-bhup/' ,'/External/unitrachov/' ,
                              '/External/softfile_idr/'
                            )
       AND Time_stamp >= DATEADD(MINUTE, -10, GETDATE());


SELECT *
FROM   [FTP-01].[Globalscape_ARM].[dbo].[tbl_ProtocolCommands]
WHERE  VirtualFolderName IN ( '/External/foer_bhup_idr/' ,
                              '/External/foer-bhup/' ,'/External/unitrachov/' ,
                              '/External/softfile_idr/'
                            )
       AND Time_stamp >= DATEADD(MINUTE, -30, GETDATE())

	 

