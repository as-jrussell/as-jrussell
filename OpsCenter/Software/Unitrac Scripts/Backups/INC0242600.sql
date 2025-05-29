USE UniTrac
SELECT * FROM dbo.MASTER_POLICY


SELECT * FROM dbo.CARRIER_PRODUCT
WHERE VUT_POLICY_TYPE_TX LIKE '%TWNHOMEVAC%'


SELECT * FROM dbo.COLLATERAL_CODE
WHERE CODE_TX IN ('TWNHOMEVAC', 'CondoVAC', 'MobHMVAC')

SELECT * FROM dbo.COLLATERAL_CODE
ORDER BY VUT_KEY ASC 


SELECT * FROM vut..tblCollateral



UPDATE dbo.COLLATERAL_CODE
SET VUT_KEY = '594', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0242600'
WHERE ID = '673'

UPDATE dbo.COLLATERAL_CODE
SET VUT_KEY = '596', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0242600'
WHERE ID = '674'

UPDATE dbo.COLLATERAL_CODE
SET VUT_KEY = '595', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0242600'
WHERE ID = '675'




--On TIMMAY

USE VUT


SELECT * FROM dbo.tblAgencyCollCode ORDER BY CollCodeKey ASC 
WHERE CollCodeID --IN ('TWNHOMEVAC', 'CondoVAC', 'MobHMVAC')


 = 'C-OTH ESC'


INSERT dbo.tblAgencyCollCode
        ( ContractTypeKey ,
          CollCodeID ,
          CollCodeDescription ,
          CreatedDate ,
          ModifiedDate ,
          SendToACV ,
          DeleteFlag ,
          APaper
        )
VALUES  ( 594 , -- ContractTypeKey - int
          'TWNHOMEVAC' , -- CollCodeID - varchar(10)
          'Townhouse/Townhome, Vac' , -- CollCodeDescription - varchar(50)
          GETDATE() , -- CreatedDate - datetime
          GETDATE() , -- ModifiedDate - datetime
          0 , -- SendToACV - int
          0 , -- DeleteFlag - int
          0  -- APaper - int
        )


		INSERT dbo.tblAgencyCollCode
        ( ContractTypeKey ,
          CollCodeID ,
          CollCodeDescription ,
          CreatedDate ,
          ModifiedDate ,
          SendToACV ,
          DeleteFlag ,
          APaper
        )
VALUES  ( 595 , -- ContractTypeKey - int
          'CondoVAC' , -- CollCodeID - varchar(10)
          'Condominium, Vacant' , -- CollCodeDescription - varchar(50)
          GETDATE() , -- CreatedDate - datetime
          GETDATE() , -- ModifiedDate - datetime
          0 , -- SendToACV - int
          0 , -- DeleteFlag - int
          0  -- APaper - int
        )


		INSERT dbo.tblAgencyCollCode
        ( ContractTypeKey ,
          CollCodeID ,
          CollCodeDescription ,
          CreatedDate ,
          ModifiedDate ,
          SendToACV ,
          DeleteFlag ,
          APaper
        )
VALUES  ( 596 , -- ContractTypeKey - int
          'MobHMVAC' , -- CollCodeID - varchar(10)
          'Mobilehome, Vac' , -- CollCodeDescription - varchar(50)
          GETDATE() , -- CreatedDate - datetime
          GETDATE() , -- ModifiedDate - datetime
          0 , -- SendToACV - int
          0 , -- DeleteFlag - int
          0  -- APaper - int
        )

