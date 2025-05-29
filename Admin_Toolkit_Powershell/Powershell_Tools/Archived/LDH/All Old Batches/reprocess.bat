@echo off
cls
rem Batch file to manage all sync services

IF "%1" == "" goto :CommandUsage


rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchIn1
rem rem PA server: 	UNITRAC-WH07
sc \\unitrac-wh07.colo.as.local %1 UnitracBusinessServiceMatchIn1
rem -------------------------------------------------------


rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchIn2
rem rem PA server: 	UNITRAC-WH06
sc \\unitrac-wh06.colo.as.local %1 UnitracBusinessServiceMatchIn2
rem -------------------------------------------------------


rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchIn4
rem rem PA server: 	UNITRAC-WH09
sc \\unitrac-wh09.colo.as.local %1 UnitracBusinessServiceMatchIn4
rem -------------------------------------------------------


rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchIn5
rem rem PA server: 	UNITRAC-WH09
sc \\unitrac-wh09.colo.as.local %1 UnitracBusinessServiceMatchIn5
rem -------------------------------------------------------


rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchIn6
rem rem PA server: 	UNITRAC-WH10
sc \\unitrac-wh10.colo.as.local %1 UnitracBusinessServiceMatchIn6
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchIn8
rem rem PA server: 	UNITRAC-WH08
sc \\unitrac-wh08.colo.as.local %1 UnitracBusinessServiceMatchIn8
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchIn9
rem rem PA server: 	UNITRAC-WH02
sc \\unitrac-wh02.colo.as.local %1 UnitracBusinessServiceMatchIn9
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchIn10
rem rem PA server: 	UNITRAC-W03
sc \\unitrac-wh03.colo.as.local %1 UnitracBusinessServiceMatchIn10
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchIn11
rem rem PA server: 	UNITRAC-WH01
sc \\unitrac-wh01.colo.as.local %1 UnitracBusinessServiceMatchIn11
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchIn12
rem rem PA server: 	UNITRAC-WH11
sc \\unitrac-wh11.colo.as.local %1 UnitracBusinessServiceMatchIn12
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchIn13
rem rem PA server: 	UNITRAC-WH12
sc \\unitrac-wh12.colo.as.local %1 UnitracBusinessServiceMatchIn13
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchIn14
rem rem PA server: 	UNITRAC-WH18
sc \\unitrac-wh18.colo.as.local %1 UnitracBusinessServiceMatchIn14
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchIn15
rem rem PA server: 	UNITRAC-WH15
sc \\unitrac-wh15.colo.as.local %1 UnitracBusinessServiceMatchIn15
rem -------------------------------------------------------


rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchIn16
rem rem PA server: 	UNITRAC-WH14
sc \\unitrac-wh14.colo.as.local %1 UnitracBusinessServiceMatchIn16
rem -------------------------------------------------------


rem -------------------------------------------------------
rem 			UnitracBusinessServiceMatchIn17
rem rem PA server: 	UNITRAC-WH07
sc \\unitrac-wh07.colo.as.local %1 UnitracBusinessServiceMatchIn17
rem -------------------------------------------------------


echo Complete!!!
goto :End

:CommandUsage
echo "UniTrac_Sync <input>"
echo "Possible Commands: query, stop, start"

:End
pause