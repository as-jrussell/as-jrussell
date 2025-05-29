Move-Item "\\utqa-sql-14\D$\SQLBACKUP\BSSMessageQueue.mdf" "\\utqa-sql-14\e$\SQL\Data05\BSSMessageQueue.mdf"  -Force
Move-Item  "\\utqa-sql-14\D$\SQLBACKUP\BSSMessageQueue_log.ldf" "\\utqa-sql-14\e$\SQL\SQLLogs\BSSMessageQueue_log.ldf"  -Force


Move-Item "\\utqa-sql-14\D$\SQLBACKUP\DBA.mdf" "\\utqa-sql-14\e$\SQL\Data01\DBA.mdf"  -Force
Move-Item  "\\utqa-sql-14\D$\SQLBACKUP\DBA_log.ldf" "\\utqa-sql-14\e$\SQL\SQLLogs\DBA_log.ldf"  -Force

Move-Item "\\utqa-sql-14\D$\SQLBACKUP\LFP.mdf" "\\utqa-sql-14\e$\SQL\Data05\LFP.mdf"  -Force
Move-Item  "\\utqa-sql-14\D$\SQLBACKUP\LFP_log.ldf" "\\utqa-sql-14\e$\SQL\SQLLogs\LFP_log.ldf"  -Force

Move-Item "\\utqa-sql-14\Q$\SQLBACKUP\Perfstats.mdf" "\\utqa-sql-14\e$\SQL\Data05\Perfstats.mdf"
Move-Item "\\utqa-sql-14\Q$\SQLBACKUP\Perfstats_log.ldf" "\\utqa-sql-14\e$\SQL\SQLLogs\Perfstats_log.ldf"  -Force


Move-Item "\\utqa-sql-14\D$\SQLBACKUP\LIMC.mdf" "\\utqa-sql-14\e$\SQL\Data05\LIMC.mdf"  -Force
Move-Item "\\utqa-sql-14\D$\SQLBACKUP\LIMC_log.ldf" "\\utqa-sql-14\e$\SQL\SQLLogs\LIMC_log.ldf"  -Force


Move-Item "\\utqa-sql-14\D$\SQLBACKUP\UnitracHDStorage.mdf" "\\utqa-sql-14\e$\SQL\Data05\UnitracHDStorage.mdf"  -Force
Move-Item "\\utqa-sql-14\D$\SQLBACKUP\UnitracHDStorage_log.ldf" "\\utqa-sql-14\e$\SQL\SQLLogs\UnitracHDStorage_log.ldf"  -Force



Move-Item "\\utqa-sql-14\D$\SQLBACKUP\VehicleCT.mdf" "\\utqa-sql-14\e$\SQL\Data05\VehicleCT.mdf"  -Force
Move-Item "\\utqa-sql-14\D$\SQLBACKUP\VehicleCT_log.ldf" "\\utqa-sql-14\e$\SQL\SQLLogs\VehicleCT_log.ldf"  -Force

Move-Item "\\utqa-sql-14\D$\SQLBACKUP\VehicleUC.mdf" "\\utqa-sql-14\e$\SQL\Data05\VehicleUC.mdf"  -Force
Move-Item "\\utqa-sql-14\D$\SQLBACKUP\VehicleUC_log.ldf"  "\\utqa-sql-14\e$\SQL\SQLLogs\VehicleUC_log.ldf"  -Force


Move-Item "\\utqa-sql-14\D$\SQLBACKUP\HDTStorage.mdf" "\\utqa-sql-14\e$\SQL\Data05\HDTStorage.mdf"  -Force
Move-Item "\\utqa-sql-14\D$\SQLBACKUP\HDTStorage_log.ldf"  "\\utqa-sql-14\e$\SQL\SQLLogs\HDTStorage_log.ldf"  -Force


Remove-Item "\\utqa-sql-14\e$\SQL\TempDB\*.*" -Force