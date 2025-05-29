USE UniTrac


SELECT  ID ,
        POLICY_NUMBER_TX ,
        PATINDEX('%[^ !-~]%' COLLATE Latin1_General_BIN, POLICY_NUMBER_TX) AS [Position] ,
        SUBSTRING(POLICY_NUMBER_TX,
                  PATINDEX('%[^ !-~]%' COLLATE Latin1_General_BIN,
                           POLICY_NUMBER_TX), 1) AS [InvalidCharacter] ,
        ASCII(SUBSTRING(POLICY_NUMBER_TX,
                        PATINDEX('%[^ !-~]%' COLLATE Latin1_General_BIN,
                                 POLICY_NUMBER_TX), 1)) AS [ASCIICode]
FROM    OWNER_POLICY
WHERE   PATINDEX('%[^ !-~]%' COLLATE Latin1_General_BIN, POLICY_NUMBER_TX) > 0 


