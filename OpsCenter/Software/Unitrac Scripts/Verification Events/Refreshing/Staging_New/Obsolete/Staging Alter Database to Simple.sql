/*


SELECT name, recovery_model_desc
   FROM sys.databases
   
*/


USE master



ALTER DATABASE UniTrac 

SET RECOVERY SIMPLE ;


USE master



ALTER DATABASE OperationalDashboard 

SET RECOVERY SIMPLE ;



USE master



ALTER DATABASE OspreyDashboard
SET RECOVERY SIMPLE ;



USE master



ALTER DATABASE UNITRAC_TEMP 

SET RECOVERY SIMPLE ;



USE master



ALTER DATABASE UniTrac_DW 

SET RECOVERY SIMPLE ;


USE master



ALTER DATABASE VUT 

SET RECOVERY SIMPLE ;


/*


SELECT name, recovery_model_desc
   FROM sys.databases
   
*/