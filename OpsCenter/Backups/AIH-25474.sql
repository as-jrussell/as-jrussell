use ftx
-- Get the current date and time as a string
DECLARE @Timestamp NVARCHAR(50);
DECLARE @sqluser varchar(MAX)
DECLARE @DryRun INT = 1

SET @Timestamp = REPLACE(CONVERT(NVARCHAR(50), GETDATE(), 102), '.', '_');
-- Backup the first table

select @sqluser ='
SELECT *
INTO z_Backup_fxtb_Contact_Addresses_'+@Timestamp+'
FROM fxtb_Contact_Addresses;


SELECT *
INTO z_Backup_fxtb_Contacts_'+@Timestamp+'
FROM fxtb_Contacts;


SELECT *
INTO z_Backup_fxtb_Users_'+@Timestamp+'
FROM fxtb_Users;



IF EXISTS (select 1 from z_Backup_fxtb_Contact_Addresses_'+@Timestamp+')
BEGIN
delete ca
from fxtb_Contact_Addresses ca
join fxtb_Contacts c on (ca.xContactID = c.xContactID)
where c.xUserID = ''0''
END 

IF EXISTS (select 1 from z_Backup_fxtb_Contacts_'+@Timestamp+')
BEGIN
delete c
from fxtb_Contacts c
where c.xUserID = ''0''
END

IF EXISTS (select 1 from z_Backup_fxtb_Users_'+@Timestamp+')
BEGIN
delete u
from fxtb_Users u
where u.xUserID = ''0''
END





'







IF @DryRun = 0 
BEGIN 
	EXEC ( @sqluser)

END

	ELSE
BEGIN 

	PRINT ( @sqluser)

END



