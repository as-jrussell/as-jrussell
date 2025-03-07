USE UniTrac



--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT  DIVISION_CODE_TX, L.*
--INTO    UniTracHDStorage..INC0226367
FROM    LOAN L
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX IN ( '1045' ) --AND L.DIVISION_CODE_TX = '4'
        AND l.NUMBER_TX IN ( '154460502', '1560795014', '1560795015',
                             '156942509', '159220502', '159220503',
                             '160186509', '1620235080', '162359502',
                             '162428503', '1627935011', '162867509',
                             '163747502', '165321503', '166273503',
                             '167351501', '170404502', '170404504',
                             '171125502', '172088509', '172293503',
                             '172959509', '173000509', '1736135051',
                             '173979502', '1741465012', '1741465028',
                             '1741465029', '174803501', '176658502',
                             '1779145010', '1779145011', '177914502',
                             '177914505', '177914506', '178235502',
                             '1791085050', '179224505', '179247502',
                             '179592502', '1795925050', '1801805050',
                             '180180509', '181567502', '181567503',
                             '181567505', '181567506', '1819145065',
                             '181969503', '1838555050', '1840375050',
                             '1840375051', '1840375053', '1840375054',
                             '1846805050', '1851545050', '185295502',
                             '1859755050', '186072503', '186072504',
                             '186072506', '186072507', '1867235050',
                             '187136501', '1876345050', '1884905050',
                             '1893305013', '189888501', '189909501',
                             '1900705050', '1908895050', '191087505',
                             '1912185050', '1912885051', '191359501',
                             '1917705050', '1922705050', '192733501',
                             '1929605050', '1932745051', '193703501',
                             '1938615050', '1941895050', '194420501',
                             '194809501', '1948335050', '1948905050',
                             '1948905051', '195607501', '1961395050',
                             '196420501', '196436502', '1969745050',
                             '1969955051', '1970985050', '197623501',
                             '198192501', '199327502', '1993315050',
                             '1996075050', '199710501', '2003925050',
                             '2005425050', '2009015050', '2012585050',
                             '2012595050', '2013655050', '201516501',
                             '2016565050', '2019065050', '2019565051',
                             '2019565052', '2021805050', '2027935050',
                             '202833505', '202881503', '2030865050',
                             '2037785050', '2039005050', '203910501',
                             '204069502', '204157505', '204189501',
                             '204305501', '2046546020', '2046546871',
                             '205558501', '2058195050', '2061025050',
                             '2061035050', '206174502', '206174503',
                             '206174504', '206174505', '206174506',
                             '206174507', '206174508', '2061985050',
                             '2064135050', '2064135052', '2064135053',
                             '2064135055', '2064135056', '2064135058',
                             '206584501', '206584503', '206584504',
                             '2065845050', '206691501', '207249502',
                             '2077755050', '2083455050', '2083835050',
                             '208745502', '2087765050', '2093075050',
                             '2093075051', '209595501', '2096185050',
                             '209833502', '209833503', '209833505',
                             '2098365050', '2102615051', '2102615053',
                             '2102615054', '2102615055', '210402502',
                             '2109235050', '211246501', '211424501',
                             '211512502', '2118475050', '2120635050',
                             '2123045051', '2125845050', '213116501',
                             '2135145051', '213605501', '213605502',
                             '30000152684', '30000154664', '515926850',
                             '516124150', '516297250', '517148950',
                             '517716250', '517801550', '518018050',
                             '518160550', '58486550', '594265051', '70263901',
                             '84865501', '1560795013', '1560795016',
                             '158542501', '1595295050', '162023509',
                             '166767509', '170404503', '171807503',
                             '172563503', '173462509', '176658503',
                             '1779145012', '179224504', '180430509',
                             '181567501', '181567504', '1819145062',
                             '181969504', '182904507', '1840375055',
                             '185295501', '186072502', '186072505',
                             '1864475050', '1897815050', '190045501',
                             '1928525050', '1935165050', '1940815050',
                             '194767502', '1948335051', '1969955050',
                             '1974225050', '199143501', '1999095050',
                             '200543501', '2019565050', '2019566559',
                             '202793504', '202881501', '203374501',
                             '204157508', '2046545050', '2050125050',
                             '2059295050', '206174501', '206174509',
                             '2064135051', '2064135054', '2064135057',
                             '206584502', '207797501', '2084895050',
                             '2087995050', '2093075052', '209833501',
                             '209833504', '210716501', '211368502',
                             '211749501', '2123045050', '2131145050',
                             '515764950', '516286750', '517389950',
                             '517892650', '519093550', '179592503',
                             '209307501', '186458507' )




UPDATE dbo.LOAN
SET DIVISION_CODE_TX = '10', UPDATE_DT = GETDATE(), 
UPDATE_USER_TX = 'INC0226367'
--SELECT DIVISION_CODE_TX, * FROM dbo.LOAN
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0226367)




SELECT LO.TYPE_CD, LO.CODE_TX , Lo.NAME_TX,*
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID --AND RD.DEF_ID = '105'
WHERE L.CODE_TX = '1045' AND Lo.TYPE_CD = 'DIV'


