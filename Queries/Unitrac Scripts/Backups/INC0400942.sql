USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.NUMBER_TX, RC.*
into unitrachdstorage..INC0400942
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2771') AND RC.TYPE_CD = 'FLOOD' and L.NUMBER_TX IN ('31758124882',
'28018814880',
'29190676881',
'28398673880',
'31558442880',
'28623263887',
'30983248888',
'31410851880',
'31833473882',
'29683198740',
'27970364744',
'28222699887',
'30388520881',
'30606756887',
'30675004888',
'26329160886',
'31770682883',
'30793564888',
'31511714888',
'29027455749',
'27323169881',
'26952775885',
'27953846741',
'27089008885',
'26322820882',
'27981990883',
'27486580742',
'30625612889',
'29051754744',
'29063872740',
'26683679745',
'26329356880',
'30345777889',
'30913597883',
'26702862884',
'31988694886',
'26325676885',
'29286321749',
'28127215888',
'30070130882',
'27721114885',
'26842673886',
'26321643889',
'31855775883',
'26312739886',
'26329183888',
'30252514887',
'32041361885',
'29314045880',
'31724250886',
'30538511889',
'27203047884',
'27616035880',
'26418325747',
'29992433887',
'31578478880',
'31678253886',
'27223878748',
'31658886887',
'28708535886',
'26314212882',
'28556775881',
'30287629882',
'31357518880',
'27385490886',
'27255538749',
'30918521748',
'26494546745',
'29153122881',
'26328873885',
'26313714888',
'31355217881',
'29353295883',
'29463004886',
'31595744884',
'30222497882',
'30679100880',
'29910221885',
'30603924884',
'28685855745',
'28491788742',
'26330762886',
'30537029883',
'30036209887',
'27001873887',
'31143550882',
'29127201886',
'29896558888',
'29940296881',
'29416307741',
'28430073883',
'29279984883',
'29926622886',
'31520391884',
'29042750744',
'27665176882',
'27670708745',
'28744963746',
'28461789886',
'26996340886',
'27455825888',
'28716103883',
'30527311887',
'30671000880',
'26991664744',
'31867567880',
'29606157880',
'32045437889',
'32014871886',
'26283903743',
'27213462743',
'26798271743',
'27541231885',
'30112604886',
'29997831887',
'30786851888',
'32003009886',
'30927004884',
'27442062884',
'32021797884',
'26330123881',
'27034210883',
'31512020889',
'31511176880',
'27277110881',
'26331085881',
'26329731884',
'26334540882',
'26727432887',
'26327971888',
'30109574886',
'27302445880',
'29489122746',
'31953480881',
'28439249740',
'31752602883',
'29630758885',
'27239564746',
'31003386880',
'27750810882',
'31909296886',
'26325980881',
'30574274889',
'31405318887',
'31714155889',
'29781636880',
'29991115881',
'27719592746',
'28415687749',
'26319507880',
'31561326880',
'31448092887',
'30033489748',
'29497038884',
'32080121885',
'29582271747',
'30705860887',
'29070984884',
'31506078885',
'30628780881',
'29721385887',
'31851949888',
'29687906882',
'29337188881',
'28976087743',
'26329983881',
'31796233885',
'26597750889',
'30516251888',
'26832558881',
'28716204889',
'29319108881',
'30746069886',
'32004374883',
'31451715887',
'26322927885',
'26940280881',
'27014775889',
'27345246881',
'30147170887',
'28120284741',
'31603676888',
'27804807884',
'28448046749',
'28966180748',
'27946020883',
'31333910888',
'29272574889',
'26107943743',
'30998562745',
'27592907888',
'27432062746',
'30888464887',
'30080020743',
'30413635886',
'28057115744',
'30033455889',
'31394657881',
'30415189882',
'27395241881',
'25575236747',
'27523063884',
'32115074885',
'27973852885',
'31515127889',
'32040476882',
'26883794880',
'26327661885',
'31832917889',
'31432964885',
'27137022748',
'31402480888',
'29425730883',
'30954420888',
'28064262885',
'27657468883',
'30038366743',
'30375024889',
'28867153885',
'30868467884',
'30342529887',
'26332189880',
'28255524887',
'31703652888',
'27003897884',
'29235006888',
'26328373886',
'31602640885',
'29424153889',
'25727993740',
'26331999883',
'26327106881',
'30419583882',
'30399940888',
'26249509881',
'31769307880',
'29274196749',
'30980871880',
'29910796886',
'30278558884',
'27581921882',
'27571090748',
'28606490887',
'27201647883',
'28486163745',
'29717403884',
'26324924880',
'26967001889',
'31333465883',
'25943125747',
'28874353882',
'28250165744',
'31001360887',
'28824449889',
'26323137880',
'31818420882',
'29767806887',
'29717332885',
'27334072884',
'26312614881',
'27711129885',
'26250838880',
'27466767749',
'28785424889',
'31336346882',
'26004529744',
'30897463888',
'29859175886',
'26334072886',
'31123486883',
'29932643884',
'31826566882',
'27014254885',
'28085695881')




UPDATE dbo.REQUIRED_COVERAGE
SET  UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0400942', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END, status_cd = 'A', PURGE_DT = NULL
--SELECT * FROM dbo.REQUIRED_COVERAGE
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0400942)




INSERT  INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.RequiredCoverage' , RC.ID , 'INC0400942' , 'N' , 
 GETDATE() ,  1 , 
 'Make Loan Active', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.RequiredCoverage' , RC.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
WHERE RC.ID IN (SELECT ID FROM UniTracHDStorage..INC0400942)