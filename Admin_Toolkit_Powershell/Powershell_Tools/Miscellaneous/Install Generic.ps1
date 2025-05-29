#install program
cd "E:\AdminAppFiles"

Start-Process -FilePath "E:\AdminAppFiles\TS.bat" -PassThru -Wait

#uninstall program
cd "C:\Program Files (x86)\JAM Software\TreeSize Free\"

Start-Process -FilePath "E:\AdminAppFiles\BO.bat" -PassThru -Wait