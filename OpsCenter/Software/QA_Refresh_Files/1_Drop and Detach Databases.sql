DROP DATABASE archiveEDI;

DROP DATABASE EDI;

DROP DATABASE LetterGen;

DROP DATABASE OperationalDashboard;

DROP DATABASE OspreyDashboard;

DROP DATABASE QCModule;

DROP DATABASE SADashboard;

DROP DATABASE UniTrac;

DROP DATABASE UniTrac_DW;

DROP DATABASE UniTracArchive;

DROP DATABASE VUT;


EXEC sp_detach_db 'BSSMessageQueue', 'true';  
EXEC sp_detach_db 'DBA', 'true';  
EXEC sp_detach_db 'HDTStorage', 'true';  
EXEC sp_detach_db 'LFP', 'true';  
EXEC sp_detach_db 'LIMC', 'true';  
EXEC sp_detach_db 'PerfStats', 'true';  
EXEC sp_detach_db 'UniTracHDStorage', 'true';  
EXEC sp_detach_db 'VehicleCT', 'true';  
EXEC sp_detach_db 'VehicleUC', 'true';  

