USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT  RC.*
INTO    UniTracHDStorage..INC0253713_RC
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX IN ( '1857')
        AND L.NUMBER_TX IN ( '771009627-1', '771019579-1', '771023940-2',
                             '771025197-3', '771025395-1', '771026022-1',
                             '771028680-1', '771029219-1', '771032034-1',
                             '771032430-1', '771032776-2', '771034153-1',
                             '771035518-1', '771036543-1', '771036571-1',
                             '771037075-1', '771041457-1', '771041465-1',
                             '771042342-1', '771042342-2', '771042475-1',
                             '771042751-1', '771042887-2', '771043206-1',
                             '771043517-1', '771044659-2', '771044768-1',
                             '771045447-1', '771045447-2', '771045447-3',
                             '771045447-4', '771045447-5', '771046252-1',
                             '771046635-1', '771046635-2', '771046659-1',
                             '771046659-2', '771048134-1', '771048223-1',
                             '771048287-2', '771048515-1', '771048715-1',
                             '771049032-2', '771049039-1', '771050386-1',
                             '771050786-1', '771050786-2', '771050858-1',
                             '771050858-2', '771051262-1', '771051486-1',
                             '771052609-2', '771053373-1', '771054400-1',
                             '771055092-1', '771055756-1', '771055899-2',
                             '771055899-3', '771056058-1', '771056058-2',
                             '771056500-1', '771057555-1', '771058349-1',
                             '771058432-1', '771059218-1', '771059218-2',
                             '771059430-1', '771059684-1', '771059957-1',
                             '771060410-1', '771060445-2', '771060884-1',
                             '771061093-1', '771061135-1', '771061451-1',
                             '771061451-2', '771061589-1', '771061589-3',
                             '771062292-1', '771062333-1', '771062754-1',
                             '771063221-1', '771063806-1', '771064401-1',
                             '771064502-1', '771064656-1', '771064845-1',
                             '771064845-2', '771065383-1', '771065389-1',
                             '771065478-1', '771065499-1', '771065982-1',
                             '771066110-1', '771066267-1', '771066595-2',
                             '771066738-1', '771066883-1', '771067360-1',
                             '771067433-1', '771067476-2', '771067829-2',
                             '771068281-1', '771068380-1', '771068495-1',
                             '771068495-2', '771068495-3', '771068495-5',
                             '771068597-1', '771068707-1', '771069082-1',
                             '771069452-1', '771069542-1', '771069542-3',
                             '771069555-1', '771069591-1', '771069675-1',
                             '771069675-4', '771069713-1', '771070037-1',
                             '771070086-1', '771070100-2', '771070100-3',
                             '771070569-1', '771070702-2', '771070810-1',
                             '771070896-1', '771070896-2', '771070896-3',
                             '771070896-4', '771070896-5', '771070911-1',
                             '771070928-1', '771071244-1', '771071370-1',
                             '771071649-1', '771071688-1', '771071688-2',
                             '771071727-1', '771071763-1', '771071770-1',
                             '771071790-1', '771071807-2', '771071828-1',
                             '771071858-1', '771071860-1', '771071860-2',
                             '771071955-2', '771071964-1', '771072074-1',
                             '771072113-1', '771072131-1', '771072131-2',
                             '771072190-2', '771072258-1', '771072265-1',
                             '771072375-2', '771072375-3', '771072385-3',
                             '771072482-1', '771072574-1', '771072677-1',
                             '771072721-1', '771072765-1', '771072806-1',
                             '771072809-2', '771072818-1', '771072942-2',
                             '771072986-1', '771072988-1', '771072988-2',
                             '771072988-3', '771072988-4', '771073064-2',
                             '771073104-1', '771073112-1', '771073112-2',
                             '771073123-2', '771073123-3', '771073128-1',
                             '771073128-2', '771073128-3', '771073152-1',
                             '771073152-2', '771073226-2', '771073330-2',
                             '771073330-3', '771073344-1', '771073362-1',
                             '771073386-2', '771073393-1', '771073417-1',
                             '771073417-2', '771073417-4', '771073525-1',
                             '771073538-1', '771073569-1', '771073569-3',
                             '771073601-1', '771073617-1', '771073639-1',
                             '771073646-1', '771073667-1', '771073668-1',
                             '771073680-1', '771073697-1', '771073697-2',
                             '771073706-1', '771073719-1', '771073719-3',
                             '771073723-2', '771073728-1', '771073816-1',
                             '771073825-1', '771073838-1', '771073838-2',
                             '771073844-1', '771073851-1', '771073856-1',
                             '771073878-2', '771073893-1', '771073954-1',
                             '771073962-1', '771073975-2', '771073985-1',
                             '771073990-1', '771074000-1', '771074000-2',
                             '771074020-1', '771074023-1', '771074047-1',
                             '771074051-1', '771074059-1', '771074063-1',
                             '771074064-1', '771074109-1', '771074133-1',
                             '771074137-1', '771074142-1', '771074183-1',
                             '771074183-2', '771074202-1', '771074202-2',
                             '771074203-1', '771074203-2', '771074222-1',
                             '771074223-1', '771074257-1', '771074266-1',
                             '771074266-2', '771074269-1', '771074291-1',
                             '771074291-2', '771074305-1', '771074312-1',
                             '771074355-1', '771074370-1', '771074374-1',
                             '771074385-1', '771074391-1', '771074404-1',
                             '771074404-2', '771074404-3', '771074432-1',
                             '771074433-1', '771074458-1', '771074464-1',
                             '771074465-1', '771074521-1', '771074525-1',
                             '771074529-1', '771074538-1', '771074543-2',
                             '771074544-1', '771074548-2', '771074556-1',
                             '771074556-2', '771074562-1', '771074576-1',
                             '771074576-2', '771074586-1', '771074586-2',
                             '771074595-1', '771074620-1', '771074623-1',
                             '771074636-1', '771074642-1', '771074655-1',
                             '771074659-1', '771074660-1', '771074662-1',
                             '771074663-1', '771074676-1', '771074682-1',
                             '771074692-1', '771074693-1', '771074716-1',
                             '771074724-1', '771074728-1', '771074738-1',
                             '771074738-2', '771074746-1', '771074755-1',
                             '771074757-1', '771074763-1', '771074766-1',
                             '771074770-1', '771074775-1', '771074781-1',
                             '771074784-1', '771074790-1', '771074808-1',
                             '771074810-1', '771074810-2', '771074819-1',
                             '771074821-1', '771074837-1', '771074843-1',
                             '771074846-1', '771074867-1', '771074867-2',
                             '771074871-1', '771074871-2', '771074872-1',
                             '771074880-1', '771074887-1', '771074889-1',
                             '771074903-1', '771074905-2', '771074934-1',
                             '771074940-1', '771074942-1', '771074947-1',
                             '771074948-1', '771074954-1', '771074962-1',
                             '771074965-1', '771074966-1', '771074972-1',
                             '771074979-1', '771074991-2', '771074991-3',
                             '771074997-1', '771075011-1', '771075013-2',
                             '771075040-1', '771075054-1', '771075063-1',
                             '771075076-1', '771075076-2', '771075086-1',
                             '771075089-1', '771075091-1', '771075093-1',
                             '771075106-1', '771075106-2', '771075112-1',
                             '771075121-1', '771075134-1', '771075134-2',
                             '771075138-1', '771075141-1', '771075145-1',
                             '771075170-1', '771075177-1', '771075194-1',
                             '771075302-1', '771075308-1', '771075310-1',
                             '771075315-1', '771075320-1', '771075322-1',
                             '771075348-1')

UPDATE RC
SET  RC.UPDATE_DT = GETDATE(),RC.UPDATE_USER_TX = 'INC0253713', RC.LOCK_ID = CASE WHEN RC.LOCK_ID >= 255 THEN 1 ELSE RC.LOCK_ID + 1 END, 
RC.STATUS_CD = IRC.STATUS_CD
--SELECT * 
FROM dbo.REQUIRED_COVERAGE RC
JOIN UniTracHDStorage..INC0253713_RC IRC ON IRC.ID =RC.ID
WHERE RC.TYPE_CD <> 'PHYS-DAMAGE'


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.RequiredCoverage' , RC.ID , ' INC0253713' , 'N' , 
 GETDATE() ,  1 , 
 'Moved to Blanket Status', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.RequiredCoverage' , RC.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
WHERE RC.ID IN (SELECT ID FROM UniTracHDStorage..INC0253713_RC)





SELECT * FROM dbo.OUTPUT_BATCH
WHERE ID IN (1089804)


SELECT CODE_CD, de FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'OutputBatchStatus'