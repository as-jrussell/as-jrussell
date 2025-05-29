
--Please run the following:
declare @ticket nvarchar(15) = 'INC0575869'
declare @lender bigint = 2982
declare @agency bigint = 1
declare @old_prop bigint = 249905799
declare @old_collat bigint = 252192250
declare @new_prop bigint
declare @old_collat2 bigint = 253973916 --this is the NON-primary collateral
declare @line1 nvarchar(100) = '5808 S. NEWLAND'
declare @line2 nvarchar(100) = ''
declare @city nvarchar(40) = 'CHICAGO'
declare @state nvarchar(30) = 'IL'
declare @zip nvarchar(30) = '60638'

declare @new_addr bigint
--/*Backup:
select C.*
into UniTracHDStorage.dbo.INC0575869_COLLATERAL
from COLLATERAL as C
where C.ID in (@old_collat, @old_collat2)
select SFT.*
into UniTrac.HDStorage.dbo.INC0575869.SEARCH_FULLTEXT
from SEARCH_FULLTEXT as SFT
where SFT.PROPERTY_ID in (@old_prop)
--*/
　
--IMPLEMENTATION:
insert into OWNER_ADDRESS
(
UPDATE_USER_TX
,LOCK_ID
,LINE_1_TX
,LINE_2_TX
,CITY_TX
,STATE_PROV_TX
,POSTAL_CODE_TX
)
select
UPDATE_USER_TX = @ticket
,LOCK_ID = 1
,LINE_1_TX = @line1
,LINE_2_TX = @line2
,CITY_TX = @city
,STATE_PROV_TX = @state
,POSTAL_CODE_TX = @zip
;
set @new_addr = SCOPE_IDENTITY()
insert into PROPERTY
(
LENDER_ID
,AGENCY_ID
,ADDRESS_ID
,UPDATE_USER_TX
,LOCK_ID
,RECORD_TYPE_CD
,SOURCE_CD
,VACANT_IN
,TIED_DOWN_IN
,IN_PARK_IN
,ACV_VALUATION_REQUIRED_IN
,ACV_INCLUDES_LAND_IN
,IN_CONSTRUCTION_IN
,FLOOD_ACTIVE_IN
)
select
LENDER_ID = @lender
,AGENCY_ID = @agency
,ADDRESS_ID = @new_addr
,UPDATE_USER_TX = @ticket
,LOCK_ID = 1
,RECORD_TYPE_CD = 'G'
,SOURCE_CD = ''
,VACANT_IN = 'N'
,TIED_DOWN_IN = 'N'
,IN_PARK_IN = 'N'
,ACV_VALUATION_REQUIRED_IN = 'N'
,ACV_INCLUDES_LAND_IN = 'N'
,IN_CONSTRUCTION_IN = 'N'
,FLOOD_ACTIVE_IN = 'N'
;
set @new_prop = SCOPE_IDENTITY()
update TOP(2) C
set
PROPERTY_ID = iif(C.ID=@old_collat, @new_prop, C.PROPER Y_ID)
,PRIMARY_LOAN_IN = 'Y'
,EXTRACT_UNMATCH_COUNT_NO = 0
,STATUS_CD = iif(C.STATUS_CD = 'U', 'A', C.STATUS_CD)
,UPDATE_DT = GETDATE()
,UPDATE_USER_TX = @ticket
,LOCK_ID = C.LOCK_ID % 255 + 1
from COLLATERAL as C
where C.ID in (@old_collat, @old_collat2)
EXEC SaveSearchFullText @old_prop
EXEC SaveSearchFullText @new_prop
　
/*Backout:
update TOP(2) C
set
PROPERTY_ID = backout.PROPERTY_ID
,PRIMARY_LOAN_IN = backout.PRIMARY_LOAN_IN
,EXTRACT_UNMATCH_COUNT_NO = backout.EXTRACT_UNMATCH_COUNT_NO
,STATUS_CD = backout.STATUS_CD
,UPDATE_DT = backout.UPDATE_DT
,UPDATE_USER_TX = backout.UPDATE_USER_TX
,LOCK_ID = C.LOCK_ID % 255 + 1
from COLLATERAL as C
join UniTracHDStorage.dbo.INC0575869_COLLATERAL as backout on backout.ID=C.ID
DELETE TOP(1) FROM OWNER_ADDRESS WHERE ID=@new_addr
DELETE TOP(1) FROM PROPERTY WHERE ID=@new_prop
*/
 
