USE UniTrac

SELECT * FROM dbo.TRADING_PARTNER TP 
LEFT JOIN dbo.DELIVERY_INFO DI ON TP.ID = DI.TRADING_PARTNER_ID
LEFT JOIN dbo.DELIVERY_INFO_GROUP DIG ON DIG.DELIVERY_INFO_ID = DI.ID
LEFT JOIN dbo.DELIVERY_DETAIL DD ON DD.DELIVERY_INFO_GROUP_ID = DIG.ID
WHERE TP.EXTERNAL_ID_TX IN ()


SELECT * FROM dbo.PPDATTRIBUTE PPD
JOIN dbo.PREPROCESSING_DETAIL PD ON PD.ID = PPD.PREPROCESSING_DETAIL_ID
JOIN dbo.DELIVERY_INFO_GROUP DIG ON DIG.ID = PD.DELIVERY_INFO_GROUP_ID
JOIN dbo.DELIVERY_DETAIL DD ON DD.DELIVERY_INFO_GROUP_ID = DIG.ID