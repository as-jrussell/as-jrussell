
BACKUP DATABASE [UniTracArchive] 
TO  DISK = '\\ON-SQLCLSTPRD-2\e$\SQL\Data01\UnitracArchive1.Bak',
DISK = '\\ON-SQLCLSTPRD-2\e$\SQL\Data02\UnitracArchive2.Bak',
DISK = '\\ON-SQLCLSTPRD-2\e$\SQL\Data03\UnitracArchive3.Bak',
DISK = '\\ON-SQLCLSTPRD-2\e$\SQL\Data04\UnitracArchive4.Bak',
DISK = '\\ON-SQLCLSTPRD-2\e$\SQL\Data05\UnitracArchive5.Bak' 
 WITH  INIT , NOUNLOAD , NAME = 'Backup', NOSKIP , STATS = 10, COMPRESSION, NOFORMAT
