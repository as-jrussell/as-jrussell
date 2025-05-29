
Select P1.name As Principal,
	P2.name As DBRole, *
From sys.database_principals As P1
Inner join sys.database_role_members As RM On RM.member_principal_id = P1.principal_id
Inner join sys.database_principals As P2 On P2.principal_id = RM.role_principal_id
Where p1.name= 'IQQBILLS-PROD'


    TO [IQQBILLS-PROD];  
GO  




IQQdbLinkedPIMSDB_IQQPROD