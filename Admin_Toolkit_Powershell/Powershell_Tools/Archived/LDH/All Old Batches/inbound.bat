@echo off
cls
rem Batch file to manage all sync services

IF "%1" == "" goto :CommandUsage


rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchInA
rem rem PA server: 	UNITRAC-WH05
sc \\unitrac-wh05.colo.as.local %1 UnitracBusinessServiceMatchInA
rem -------------------------------------------------------


rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchInB
rem rem PA server: 	UNITRAC-WH05
sc \\unitrac-wh05.colo.as.local %1 UnitracBusinessServiceMatchInB
rem -------------------------------------------------------


rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchInC
rem rem PA server: 	UNITRAC-WH05
sc \\unitrac-wh05.colo.as.local %1 UnitracBusinessServiceMatchInC
rem -------------------------------------------------------


rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchInD
rem rem PA server: 	UNITRAC-WH05
sc \\unitrac-wh05.colo.as.local %1 UnitracBusinessServiceMatchInD
rem -------------------------------------------------------


rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchInE
rem rem PA server: 	UNITRAC-WH05
sc \\unitrac-wh05.colo.as.local %1 UnitracBusinessServiceMatchInE
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchInF
rem rem PA server: 	UNITRAC-WH16
sc \\unitrac-wh16.colo.as.local %1 UnitracBusinessServiceMatchInF
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchInG
rem rem PA server: 	UNITRAC-WH13
sc \\unitrac-wh13.colo.as.local %1 UnitracBusinessServiceMatchInG
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchInH
rem rem PA server: 	UNITRAC-W13
sc \\unitrac-wh13.colo.as.local %1 UnitracBusinessServiceMatchInH
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchInI
rem rem PA server: 	UNITRAC-WH13
sc \\unitrac-wh13.colo.as.local %1 UnitracBusinessServiceMatchInI
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchInJ
rem rem PA server: 	UNITRAC-WH17
sc \\unitrac-wh17.colo.as.local %1 UnitracBusinessServiceMatchInJ
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchInK
rem rem PA server: 	UNITRAC-WH20
sc \\unitrac-wh20.colo.as.local %1 UnitracBusinessServiceMatchInK
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchInL
rem rem PA server: 	UNITRAC-WH04
sc \\unitrac-wh04.colo.as.local %1 UnitracBusinessServiceMatchInL
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchInM
rem rem PA server: 	UNITRAC-WH04
sc \\unitrac-wh04.colo.as.local %1 UnitracBusinessServiceMatchInM
rem -------------------------------------------------------


echo Complete!!!
goto :End

:CommandUsage
echo "UniTrac_Sync <input>"
echo "Possible Commands: query, stop, start"

:End
pause