use unitrac


--Vehicle

SELECT DISTINCT LE.CODE_TX [Lender Code], LE.NAME_TX [Lender Name],  L.NUMBER_TX [Loan Number], O.FIRST_NAME_TX [First Name], O.LAST_NAME_TX [Last Name],
P.YEAR_TX[Year],MAKE_TX[Make],MODEL_TX[Model],BODY_TX[Body], VIN_TX[Vin],
lo.NAME_tx [Property type], RC2.DESCRIPTION_TX [Owner Type]
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN OWNER_ADDRESS OAR ON P.ADDRESS_ID = OAR.ID
left join ref_code RC2 on RC2.CODE_CD = OL.OWNER_TYPE_CD and RC2.DOMAIN_CD = 'OwnerType'
left join lender_organization lo on lo.code_tx = l.division_code_tx and lo.type_cd = 'div' and lo.lender_id = l.lender_id
left join lender LE on LE.ID = L.Lender_id
WHERE  C.property_id in (select property_id from #dupCollateral) and DIVISION_CODE_tx = '3'





--Non Vehicle

SELECT DISTINCT LE.CODE_TX [Lender Code], LE.NAME_TX [Lender Name],  L.NUMBER_TX [Loan Number], O.FIRST_NAME_TX [First Name], O.LAST_NAME_TX [Last Name], concat(OAR.LINE_1_TX,' ',OAR.CITY_TX,' ',OAR.STATE_PROV_TX,' ',OAR.POSTAL_CODE_TX ) as  [Property]  , 
lo.NAME_tx [Property type], RC2.DESCRIPTION_TX [Owner Type]

FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN OWNER_ADDRESS OAR ON P.ADDRESS_ID = OAR.ID
left join ref_code RC2 on RC2.CODE_CD = OL.OWNER_TYPE_CD and RC2.DOMAIN_CD = 'OwnerType'
left join lender_organization lo on lo.code_tx = l.division_code_tx and lo.type_cd = 'div' and lo.lender_id = l.lender_id
left join lender LE on LE.ID = L.Lender_id
WHERE  C.property_id in (select property_id from #dupCollateral) and DIVISION_CODE_tx != '3'