use iqq_live

DECLARE @DATE_RANGE_TYPE NVARCHAR(25) = 'CUSTOM'
DECLARE @START_DT DATETIME = '9/1/2022 12:00:00 AM'
DECLARE @END_DT DATETIME = '9/30/2022 11:59:59 PM'
DECLARE @LENDER_NAME NVARCHAR(100) = 'Founders Federal Credit Union'
DECLARE @ProductTypeList NVARCHAR(25) = 'GAP, MBP'
DECLARE @ORIGIN_LIST NVARCHAR(25) = 'A, API, MI, C'
DECLARE @SaleStatus NVARCHAR(25) = 'S, F'
DECLARE @DATE_TYPE_CD NVARCHAR(30) = 'Effective Date'
DECLARE @BRANCH_TYPE_CD NVARCHAR(30) = 'CLOSE'

;WITH DATES
                       AS (SELECT START_DT,
                                  END_DT
                           FROM   Fngetstartandenddates(@DATE_RANGE_TYPE, @START_DT, @END_DT))
                  SELECT DISTINCT S.SALE_DT,
                                  S.CANCELLED_DT            AS Cancellation_Date,
                                  S.BUYER_COST_NO,
                                  QP.NAME_TX,
                                  --QWI_DATA.Y,
                                  --CASE
                                  --  WHEN model.NAME_TX IS NULL THEN QWI_DATA.MD
                                  --  ELSE model.NAME_TX
                                  --END                       AS Model,
                                  --QWI_DATA.MILEAGE,
                                  --CASE
                                  --  WHEN make.NAME_TX IS NULL THEN QWI_DATA.MK
                                  --  ELSE make.NAME_TX
                                  --END                       AS Make,
                                  --QWI_DATA.VIN,
                                  --QTD_DATA.TERM_MILES,
                                  --QTD_DATA.TERM_MONTHS,
                                  CASE
                                    WHEN PER.ACCOUNT_NUMBER_TX IS NULL THEN ''
                                    ELSE PER.ACCOUNT_NUMBER_TX
                                  END                       AS ACCOUNT_NUMBER,
                                  ( CASE
                                      WHEN S.DESIGNATED_QUOTER_ID IS NULL THEN QUOTER.FAMILY_NAME_TX + ', '
                                                                               + QUOTER.GIVEN_NAME_TX
                                      ELSE PDQ.GIVEN_NAME_TX + ' ' + PDQ.FAMILY_NAME_TX
                                    END )                   AS QUOTER,
                                  SELLER.FAMILY_NAME_TX + ', '
                                  + SELLER.GIVEN_NAME_TX    AS SELLER,
                                  S.PROVIDER_CONTRACT_ID,
                                  QW.LENDER_QUOTE_NO,
                                  CASE
                                    WHEN S.STATE_CD = 'S' THEN 'SOLD'
                                    WHEN S.STATE_CD = 'F' THEN 'FLAGGED'
                                    WHEN S.STATE_CD = 'RI' THEN 'REINSTATED'
                                    WHEN S.STATE_CD = 'D' THEN 'DECLINED'
                                    WHEN S.STATE_CD = 'RQ' THEN 'CANCELLED/REQUOTED'
                                    WHEN S.STATE_CD = 'CF' THEN 'CLAIM FILED'
                                    ELSE 'CANCELLED'
                                  END                       AS STATE_CD,
                                  PER.GIVEN_NAME_TX         AS BUYER_FIRST_NAME,
                                  PER.FAMILY_NAME_TX        AS BUYER_LAST_NAME,
                                  OB.NAME_TX                AS BRANCH,
                                  CASE
                                    WHEN QW.ORIGIN_SOURCE_CD = 'A' THEN 'Lender Website'
                                    ELSE QW.ORIGIN_SOURCE_CD
                                  END                       AS ORIGIN,
                                  S.BUYER_PAYMENT_METHOD_CD AS PAYMENT_METHOD,
                                  S.EFFECTIVE_DT            AS EFFECTIVE_DT,
                                  CASE
                                    WHEN LAQWI.VALUE_TX IS NULL THEN 'N/A'
                                    ELSE LAQWI.VALUE_TX
                                  END                       AS LOAN_AMOUNT,
                                  CASE
                                    WHEN QW.COLLATERAL_CD = 'B' THEN 'Boats'
                                    WHEN QW.COLLATERAL_CD = 'M' THEN 'Motorcycles'
                                    WHEN QW.COLLATERAL_CD = 'MH' THEN 'Motor Homes'
                                    WHEN QW.COLLATERAL_CD = 'TT' THEN 'Travel Trailers'
                                    WHEN QW.COLLATERAL_CD = 'JS' THEN 'Jet Ski'
                                    WHEN QW.COLLATERAL_CD = 'AUTO_LT_TRUCK' THEN 'Autos, Light Trucks and Vans'
                                    WHEN QW.COLLATERAL_CD = 'GC' THEN 'Golf Cart'
                                    WHEN QW.COLLATERAL_CD = 'S' THEN 'Snowmobile'
                                    ELSE QW.COLLATERAL_CD
                                  END                       AS COLLATERAL_TYPE
                  FROM   SALE S
                         JOIN PRODUCT P
                           ON S.PRODUCT_ID = P.ID
                              AND P.PURGE_DT IS NULL
                         JOIN QUOTE_PLAN QP
                           ON S.QUOTE_ID = QP.QUOTE_ID
                              AND QP.PURGE_DT IS NULL
                              AND QP.SELECTED_IN = 'Y'
                         JOIN QUOTE_TERM QT
                           ON QP.ID = QT.QUOTE_PLAN_ID
                              AND QT.PURGE_DT IS NULL
                              AND QT.SELECTED_IN = 'Y'
                         JOIN QUOTE_WORKSHEET QW
                           ON S.QUOTE_WORKSHEET_ID = QW.ID
                              AND QW.PURGE_DT IS NULL
                         JOIN ORGANIZATION OB
                           ON QW.DESIGNATED_BRANCH_ID = OB.ID
                              AND OB.PURGE_DT IS NULL
                         JOIN ORGANIZATION O
                           ON OB.PARENT_ID = O.ID
                              AND O.PURGE_DT IS NULL
                         JOIN PERSON PER
                           ON S.BUYER_PERSON_ID = PER.ID
                              AND PER.PURGE_DT IS NULL
                         LEFT JOIN USER_RELATE URDQ
                                ON S.DESIGNATED_QUOTER_ID = URDQ.USER_ID
                                   AND URDQ.RELATE_CLASS_NAME_TX LIKE 'Osprey.Person'
                         LEFT JOIN PERSON PDQ
                                ON URDQ.RELATE_ID = PDQ.ID
                                   AND PDQ.PURGE_DT IS NULL
                         LEFT JOIN QUOTE_WORKSHEET_INPUT LAQWI
                                ON QW.ID = LAQWI.QUOTE_WORKSHEET_ID
                                   AND LAQWI.REF_CD = 'AMOUNT'
                                   AND LAQWI.PURGE_DT IS NULL
                         LEFT JOIN USER_RELATE QUR
                                ON S.QUOTER_ID = QUR.USER_ID
                                   AND QUR.RELATE_CLASS_NAME_TX = 'Osprey.Person'
                                   AND QUR.PURGE_DT IS NULL
                         LEFT JOIN USER_RELATE SUR
                                ON S.SELLER_ID = SUR.USER_ID
                                   AND SUR.RELATE_CLASS_NAME_TX = 'Osprey.Person'
                                   AND SUR.PURGE_DT IS NULL
                         LEFT JOIN PERSON QUOTER
                                ON QUR.RELATE_ID = QUOTER.ID
                                   AND QUOTER.PURGE_DT IS NULL
                         LEFT JOIN PERSON SELLER
                                ON SUR.RELATE_ID = SELLER.ID
                                   AND SELLER.PURGE_DT IS NULL
                         --OUTER APPLY (SELECT *
                         --             FROM   (SELECT REF_CD,
                         --                            VALUE_TX
                         --                     FROM   QUOTE_WORKSHEET_INPUT
                         --                     WHERE  PURGE_DT IS NULL
                         --                            AND QUOTE_WORKSHEET_ID = S.QUOTE_WORKSHEET_ID
                         --                            AND ( REF_CD = 'VIN'
                         --                                   OR REF_CD = 'MK'
                         --                                   OR REF_CD = 'MD'
                         --                                   OR REF_CD = 'MILEAGE'
                         --                                   OR REF_CD = 'Y' )) SUB
                         --                    PIVOT ( Max(VALUE_TX)
                         --                          FOR REF_CD IN (VIN,
                         --                                         Y,
                         --                                         MK,
                         --                                         MD,
                         --                                         MILEAGE) ) PVT) AS QWI_DATA
                         --OUTER APPLY (SELECT *
                         --             FROM   (SELECT KEY_TX,
                         --                            VALUE_TX
                         --                     FROM   QUOTE_TERM_DETAIL
                         --                     WHERE  PURGE_DT IS NULL
                         --                            AND QUOTE_TERM_ID = QT.ID
                         --                            AND ( KEY_TX = 'TERM_MILES'
                         --                                   OR KEY_TX = 'TERM_MONTHS' )) SUB
                         --                    PIVOT ( Max(VALUE_TX)
                         --                          FOR KEY_TX IN (TERM_MILES,
                         --                                         TERM_MONTHS) ) PVT) AS QTD_DATA
                         --LEFT JOIN IQQ_VEHICLE_MAKE make
                         --       ON make.ID = CASE
                         --                      WHEN Try_convert(bigint, QWI_DATA.MK) IS NULL THEN 0
                         --                      ELSE QWI_DATA.MK
                         --                    END
                         --LEFT JOIN IQQ_VEHICLE_MODEL model
                         --       ON model.ID = CASE
                         --                       WHEN Try_convert(bigint, QWI_DATA.MD) IS NULL THEN 0
                         --                       ELSE QWI_DATA.MD
                         --                     END
                  WHERE  O.NAME_TX = @LENDER_NAME
                         AND ( S.EFFECTIVE_DT BETWEEN (SELECT START_DT
                                                       FROM   DATES) AND (SELECT END_DT
                                                                          FROM   DATES)
                                OR S.CANCELLED_DT BETWEEN (SELECT START_DT
                                                           FROM   DATES) AND (SELECT END_DT
                                                                              FROM   DATES) )
                                                 AND P.TYPE_CD IN (N'GAP',N'MBP')
AND QW.ORIGIN_SOURCE_CD IN (N'A',N'API',N'C',N'MI')
AND S.STATE_CD IN (N'F',N'S')