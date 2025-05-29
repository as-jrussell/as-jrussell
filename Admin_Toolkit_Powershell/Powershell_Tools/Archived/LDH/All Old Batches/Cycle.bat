@echo off
cls
rem Batch file to manage all sync services

IF "%1" == "" goto :CommandUsage


rem -------------------------------------------------------
rem 			UnitracBusinessServiceBILL
rem rem PA server: 	UNITRAC-WH07
sc \\unitrac-wh07.colo.as.local %1 UnitracBusinessServiceBILL
rem -------------------------------------------------------


rem -------------------------------------------------------
rem 			UnitracBusinessServiceCycle2
rem rem PA server: 	UNITRAC-WH15
sc \\unitrac-wh15.colo.as.local %1 UnitracBusinessServiceCycle2
rem -------------------------------------------------------


rem -------------------------------------------------------
rem 			UnitracBusinessServiceCycle3
rem rem PA server: 	UNITRAC-WH16
sc \\unitrac-wh16.colo.as.local %1 UnitracBusinessServiceCycle3
rem -------------------------------------------------------


rem -------------------------------------------------------
rem 			UnitracBusinessServiceCycle4
rem rem PA server: 	UNITRAC-WH13
sc \\unitrac-wh13.colo.as.local %1 UnitracBusinessServiceCycle4
rem -------------------------------------------------------


rem -------------------------------------------------------
rem 			UnitracBusinessService
rem rem PA server: 	UNITRAC-APP01
sc \\UNITRAC-APP01.colo.as.local %1 UnitracBusinessService
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			UnitracBusinessServiceCycle
rem rem PA server: 	UNITRAC-APP02
sc \\UNITRAC-APP02.colo.as.local %1 UnitracBusinessServiceCycle
rem -------------------------------------------------------


echo Complete!!!
goto :End

:CommandUsage
echo "UniTrac_Sync <input>"
echo "Possible Commands: query, stop, start"

:End
pause