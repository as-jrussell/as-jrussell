BEGIN

    DECLARE @fromDate AS DATETIME
    DECLARE @toDate AS DATETIME
SET @fromDate = cast('2015-06-12 10:36:00.000' AS datetime)
SET @toDate = cast('2015-06-26 15:07:00.000' AS datetime)

    SELECT  M.ID AS 'Message ID / Folder Name' ,
            DATT.NAME_TX AS 'Attachment' ,
            T.DATA.value('(/Transaction/InsuranceDocument/@Id)[1]',
                         'nvarchar(30)') AS 'Reference ID' ,
            T.DATA.value('(/Transaction/InsuranceDocument/LenderControlNumber)[1]',
                         'nvarchar(30)') AS 'Lender ID' ,
            T.DATA.value('(/Transaction/InsuranceDocument/Policy/@Number)[1]',
                         'nvarchar(100)') AS 'Policy Number' ,
            T.DATA.value('(/Transaction/InsuranceDocument/InsuranceCompany/CompanyName)[1]',
                         'nvarchar(50)') AS 'Insurance Company Name' ,
            T.DATA.value('(/Transaction/InsuranceDocument/LienHolder/CompanyName)[1]',
                         'nvarchar(50)') AS 'Lienholder Company Name' ,
            T.DATA.value('(/Transaction/InsuranceDocument/Insured/FirstName)[1]',
                         'nvarchar(100)') AS 'Insured First Name' ,
            T.DATA.value('(/Transaction/InsuranceDocument/Insured/LastName)[1]',
                         'nvarchar(100)') AS 'Insured Last Name'
    FROM    [TRANSACTION] T ( NOLOCK )
            JOIN DOCUMENT D ( NOLOCK ) ON D.ID = T.DOCUMENT_ID
            JOIN MESSAGE M ( NOLOCK ) ON M.ID = D.MESSAGE_ID
            JOIN DOCUMENT DATT ( NOLOCK ) ON DATT.MESSAGE_ID = M.ID
    WHERE   M.ID IN (
            SELECT  D.MESSAGE_ID
            FROM    dbo.TRADING_PARTNER_LOG TPL ( NOLOCK )
                    JOIN dbo.MESSAGE M ( NOLOCK ) ON M.ID = TPL.MESSAGE_ID
                    JOIN dbo.DOCUMENT D ( NOLOCK ) ON D.MESSAGE_ID = M.ID
            WHERE   M.CREATE_DT >= @fromDate
                    AND M.CREATE_DT <= @toDate
                    AND D.DELIVERY_INFO_GROUP_ID IN ( 3427, 3428, 3429 )
                    AND M.DELIVER_TO_TRADING_PARTNER_ID = 2047
                    AND ( TPL.LOG_TYPE_CD = 'ERROR'
                          OR TPL.LOG_SEVERITY_CD = 'ERROR'
                        ) )
            AND DATT.DELIVERY_INFO_GROUP_ID IN ( 3427, 3428, 3429 )
				 
END
GO			 
				 
