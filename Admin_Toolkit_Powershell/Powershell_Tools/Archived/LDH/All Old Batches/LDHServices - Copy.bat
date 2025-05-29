@echo off
cls
rem Batch file to manage all sync services

IF "%1" == "" goto :CommandUsage


rem -------------------------------------------------------
rem 			LDHSERV
rem rem PA server: 	UNITRAC-WH03
sc \\unitrac-wh03.colo.as.local %1 ldhserv
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			LDHServiceVUT
rem PA server: 	UNITRAC-WH02
sc \\unitrac-wh02.colo.as.local %1 ldhserviceVUT
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			LDHServiceUSD
rem PA server: 	UNITRAC-APP02

sc \\unitrac-app02.colo.as.local %1 ldhserviceUSD
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			LDHServicePRCPA
rem PA server: 	UNITRAC-WH01

sc \\unitrac-wh01.colo.as.local %1 ldhservicePRCPA
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			LDHServiceHUNT
rem PA server: 	UNITRAC-WH07

sc \\unitrac-wh07.colo.as.local %1 ldhserviceHUNT
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			LDHServiceSANT
rem PA server: 	UNITRAC-WH19

sc \\unitrac-wh19.colo.as.local %1 ldhserviceSANT
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			LDHServiceADHOC
rem PA server: 	UNITRAC-WH04

sc \\unitrac-wh04.colo.as.local %1 ldhserviceADHOC
rem -------------------------------------------------------

rem -------------------------------------------------------
rem 			LDHServiceUSDSANT
rem PA server: 	UNITRAC-WH20

sc \\unitrac-wh20.colo.as.local %1 ldhserviceusdSANT
rem -------------------------------------------------------


echo Complete!!!
goto :End

:CommandUsage
echo "UniTrac_Sync <input>"
echo "Possible Commands: query, stop, start"

:End
pause