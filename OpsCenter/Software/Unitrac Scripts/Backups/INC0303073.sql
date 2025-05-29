USE UniTrac


SELECT  L.NUMBER_TX [Loan Number] ,
        C.ID [Collateral Number] ,
        L.BALANCE_AMOUNT_NO [Balance] ,
        CREDIT_LINE_AMOUNT_NO [Line of Credit Amount] ,
        LENDER_COLLATERAL_CODE_TX [Lender Collateral Code] ,
        VIN_TX [VIN] ,
        YEAR_TX [Year] ,
        MAKE_TX [Make] ,
        MODEL_TX [Model] ,
        OP.LINE_1_TX [Real Estate Address Line 1] ,
        OP.LINE_2_TX [Real Estate Address Line 2] ,
        OP.CITY_TX [Real Estate City] ,
        OP.STATE_PROV_TX [Real Estate State] ,
        OP.POSTAL_CODE_TX [Real Estate Zip Code] ,
        FLOOD_ZONE_TX [Flood Zone] ,
        DESCRIPTION_TX [Equipment Description] ,
        O.LAST_NAME_TX [Borrower Last Name] ,
        O.FIRST_NAME_TX [Borrower First Name] ,
        O.MIDDLE_INITIAL_TX [Borrower Middle Initial] ,
        OA.LINE_1_TX [Mailing Estate Address Line 1] ,
        OA.LINE_2_TX [Mailing Estate Address Line 2] ,
        OA.CITY_TX [Mailing City] ,
        OA.STATE_PROV_TX [Mailing State] ,
        OA.POSTAL_CODE_TX [Mailing Zip] ,
        OA.COUNTRY_TX [Mailing Country]
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        LEFT JOIN OWNER_ADDRESS OP ON P.ADDRESS_ID = OP.ID
WHERE   L.LENDER_ID IN ( '2292' )
        AND L.STATUS_CD NOT IN ( 'U', 'A' )
