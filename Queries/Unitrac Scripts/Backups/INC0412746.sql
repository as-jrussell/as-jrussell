﻿use unitrac

select * into unitrachdstorage..INC0412746
from loan L
where id in ('224076878',
'224109671',
'224113713',
'224109343',
'224061615',
'224063596',
'224089446',
'224109404',
'224112258',
'224121331',
'224132539',
'224073650',
'224091773',
'224121705',
'224136556',
'224064285',
'224083526',
'224100323',
'224109552',
'224157855',
'224079068',
'224083681',
'224107864',
'224081435',
'224098170',
'224103261',
'224104536',
'224129270',
'224150238',
'224151201',
'224063145',
'224073795',
'224111806',
'224130586',
'224135878',
'224152794',
'224079091',
'224129699',
'224144254',
'224164217',
'224164304',
'224070656',
'224077551',
'224095209',
'224148732',
'224165918',
'224105032',
'224123891',
'224159023',
'224072686',
'224072696',
'224077476',
'224078038',
'224099742',
'224117115',
'224122808',
'224069597',
'224075113',
'224064882',
'224100145',
'224104710',
'224110372',
'224065543',
'224073396',
'224118114',
'224129305',
'224131886',
'224147991',
'224148186',
'224167022',
'224077096',
'224085031',
'224086046',
'224105202',
'224114409',
'224149546',
'224080014',
'224081178',
'224117933',
'224128616',
'224142589',
'224150823',
'224098634',
'224155559',
'224164578',
'224170986',
'224172549',
'224172432',
'224093554',
'224136570',
'224172809',
'224173881',
'224174011',
'224156229',
'224175580',
'224176322',
'224105529',
'224137226',
'224150465',
'224179696',
'224113861',
'224141256',
'224179805',
'224179690',
'224180386',
'224180444',
'224121157',
'224169421',
'224172472',
'224182416',
'224183010',
'224183648',
'224183727',
'224185654',
'224143605',
'224160115',
'231494888',
'226050430',
'271499314',
'236998532',
'247303537',
'240658676',
'237729194',
'237729210',
'236008326',
'242100943',
'246852400',
'256630715',
'255663117',
'256567477',
'257797728',
'256093456',
'263470075',
'259974934',
'260906219',
'271533826',
'261586761',
'262033464',
'268251219',
'267850826',
'267368126',
'268269678',
'264542124',
'268663360',
'269276506',
'269091002',
'269676922',
'269188766',
'270930685',
'270455383',
'271533834',
'271499322',
'270523205',
'271499329',
'271499338',
'271499328',
'271060552',
'271499343',
'271499342',
'271499344',
'271590561',
'271499340',
'271533860',
'271533863',
'271554982',
'272983979',
'224154841',
'224191863',
'224124562',
'224140215',
'224161535',
'224164971',
'224193935',
'224194566',
'224129688',
'224181626',
'224191727',
'224196375',
'266642636',
'271499359',
'271533866',
'271590572'
)


update L
set status_cd ='U', update_dt = GETDATE(), update_user_tx = 'INC0412746', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select *
from loan L
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0412746)



INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0412746' , 'N' , 
 GETDATE() ,  1 , 
'Make Loan set to Unmatch', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0412746)




select * from loan
where id in (SELECT ID FROM UniTracHDStorage..INC0412746)


SELECT * FROM UniTracHDStorage..INC0412746