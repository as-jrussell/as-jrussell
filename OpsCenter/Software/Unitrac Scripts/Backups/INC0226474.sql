USE UniTrac


SELECT  
LL.CODE_TX,
LL.NAME_TX,
LENDER_ID,
L.NUMBER_TX,
IH.SPECIAL_HANDLING_XML.value('(/SH/InsuranceCompanyName)[1]',
                                   'varchar (50)') [Insurance Company] ,
        IH.TYPE_CD ,
        IH.PROPERTY_ID ,
        IH.EFFECTIVE_DT ,
        IH.ISSUE_DT ,
        IH.NOTE_TX ,
        IH.SPECIAL_HANDLING_XML ,
        IH.RELATE_CLASS_TX ,
        IH.RELATE_ID ,
        IH.CREATE_DT ,
        IH.CREATE_USER_TX ,
        IH.UPDATE_DT ,
        IH.UPDATE_USER_TX ,
        IH.PURGE_DT
INTO UniTracHDStorage..INC0226474
FROM    dbo.INTERACTION_HISTORY IH
INNER JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = IH.PROPERTY_ID
INNER JOIN	dbo.LOAN L ON L.ID = C.LOAN_ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   Ih.TYPE_CD IN (  'NOTICE', 'OUTBNDCALL' )
        AND IH.CREATE_DT >= '2015-01-01'
		     --   AND IH.CREATE_DT <= '2015-06-01'
        AND IH.SPECIAL_HANDLING_XML.value('(/SH/InsuranceCompanyName)[1]',
                                       'varchar (50)') LIKE '%geico%'
ORDER BY IH.CREATE_DT ASC









