USE UniTrac	


	
--Please run the following:

update C

set

PURGE_DT = getdate()

,UPDATE_DT = getdate()

,UPDATE_USER_TX = 'INC0272473'

,LOCK_ID = C.LOCK_ID % 255 + 1
--SELECT *
from COLLATERAL as C

where C.ID in (96666177,96666178,96666180,128961949)

or C.ID between 135800952 and 137222967

or C.ID between 137222969 and 137222973

or C.ID between 137222975 and 137222984

or C.ID between 137222986 and 137223000

or C.ID between 137223002 and 137223016

EXEC SaveSearchFullText 95534274

EXEC SaveSearchFullText 95534275

EXEC SaveSearchFullText 95534277

EXEC SaveSearchFullText 127596110

EXEC SaveSearchFullText 135800952

EXEC SaveSearchFullText 135800953

EXEC SaveSearchFullText 135800954

EXEC SaveSearchFullText 135800955

EXEC SaveSearchFullText 135800956

EXEC SaveSearchFullText 135800957

EXEC SaveSearchFullText 135800958

EXEC SaveSearchFullText 135800959

EXEC SaveSearchFullText 135800960

EXEC SaveSearchFullText 135800961

EXEC SaveSearchFullText 135800962

EXEC SaveSearchFullText 135800963

EXEC SaveSearchFullText 135800964

EXEC SaveSearchFullText 135800965

EXEC SaveSearchFullText 135800966

EXEC SaveSearchFullText 135800967

EXEC SaveSearchFullText 135800968

EXEC SaveSearchFullText 135800969

EXEC SaveSearchFullText 135800970

EXEC SaveSearchFullText 135800971

EXEC SaveSearchFullText 135800972

EXEC SaveSearchFullText 135800974

EXEC SaveSearchFullText 135800975

EXEC SaveSearchFullText 135800976

EXEC SaveSearchFullText 135800977

EXEC SaveSearchFullText 135800978

EXEC SaveSearchFullText 135800979

EXEC SaveSearchFullText 135800980

EXEC SaveSearchFullText 135800981

EXEC SaveSearchFullText 135800982

EXEC SaveSearchFullText 135800983

EXEC SaveSearchFullText 135800984

EXEC SaveSearchFullText 135800986

EXEC SaveSearchFullText 135800987

EXEC SaveSearchFullText 135800988

EXEC SaveSearchFullText 135800989

EXEC SaveSearchFullText 135800990

EXEC SaveSearchFullText 135800991

EXEC SaveSearchFullText 135800992

EXEC SaveSearchFullText 135800993

EXEC SaveSearchFullText 135800994

EXEC SaveSearchFullText 135800995

EXEC SaveSearchFullText 135800996

EXEC SaveSearchFullText 135800997

EXEC SaveSearchFullText 135800998

EXEC SaveSearchFullText 135800999

EXEC SaveSearchFullText 135801000

EXEC SaveSearchFullText 135801002

EXEC SaveSearchFullText 135801003

EXEC SaveSearchFullText 135801004

EXEC SaveSearchFullText 135801005

EXEC SaveSearchFullText 135801006

EXEC SaveSearchFullText 135801007

EXEC SaveSearchFullText 135801008

EXEC SaveSearchFullText 135801009

EXEC SaveSearchFullText 135801010

EXEC SaveSearchFullText 135801011

EXEC SaveSearchFullText 135801012

EXEC SaveSearchFullText 135801013

EXEC SaveSearchFullText 135801014

EXEC SaveSearchFullText 135801015

EXEC SaveSearchFullText 13580101




UPDATE C
SET C.PURGE_DT = J.PURGE_DT

, C.UPDATE_DT = J.UPDATE_DT

,C.UPDATE_USER_TX = J.UPDATE_USER_TX

,C.LOCK_ID = J.LOCK_ID
--SELECT *
FROM  dbo.COLLATERAL C 
 JOIN UniTracHDStorage..INC0272473 J ON J.ID = C.ID
 WHERE J.PURGE_DT IS NULL 