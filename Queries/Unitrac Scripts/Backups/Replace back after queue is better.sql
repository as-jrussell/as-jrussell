--Placing messages on hold


----From ADHOC
--UPDATE dbo.MESSAGE
--SET PROCESSED_IN = 'Y' , RECEIVED_STATUS_CD = 'HOLD' 
--WHERE ID IN (4489071, 4489073)


----FROM USD
--UPDATE  dbo.MESSAGE
--SET     PROCESSED_IN = 'Y' ,
--        RECEIVED_STATUS_CD = 'HOLD'
--WHERE   ID IN ( 4482273, 4482275, 4484387, 4487071, 4487852, 4488438, 4488608,
--                )

--Already added back
--4489476, 4489483 

--Taking them off hold for USD
UPDATE dbo.MESSAGE
SET PROCESSED_IN = 'N' , RECEIVED_STATUS_CD = 'RCVD' 
WHERE ID IN (4489476)


----Taking them off hold for ADHOC
--UPDATE dbo.MESSAGE
--SET PROCESSED_IN = 'N' , RECEIVED_STATUS_CD = 'ADHOC' 
--WHERE ID IN ()




SELECT * FROM dbo.MESSAGE
WHERE ID IN (4489476)