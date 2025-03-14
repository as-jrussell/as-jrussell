USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT  L.DIVISION_CODE_TX ,
        L.NUMBER_TX
--INTO    UniTracHDStorage..INC0253090
FROM    LOAN L
WHERE   LENDER_ID = 694
        AND L.NUMBER_TX IN ( '302952-27', '304739-28', '306588-27',
                             '307245-28', '307457-27', '308146-28',
                             '308303-27', '309462-27', '312307-27',
                             '312500-27', '315849-27', '317727-27',
                             '318179-27', '318453-27', '319447-27',
                             '320943-27', '321966-29', '322033-27',
                             '322585-27', '322636-27', '322643-28',
                             '322687-27', '322700-27', '322702-27',
                             '322806-27', '322807-27', '323054-27',
                             '323173-27' )

	SELECT  L.DIVISION_CODE_TX ,
        L.NUMBER_TX
--INTO    UniTracHDStorage..INC0253090
FROM    LOAN L
WHERE   LENDER_ID = 694
        AND L.NUMBER_TX IN
		 ( '303077-21', '303157-25', '303561-21',
                             '303734-21', '304099-21', '304342-24',
                             '304438-21', '304505-21', '304682-25',
                             '304835-24', '304844-21', '304913-24',
                             '304993-21', '305052-21', '305175-21',
                             '305182-21', '305182-22', '305186-21',
                             '305186-26', '305214-24', '305373-21',
                             '305415-24', '305452-26', '305456-21',
                             '305876-21', '305943-21', '305943-22',
                             '306038-24', '306409-24', '306570-22',
                             '306805-24', '306807-21', '306854-22',
                             '307041-21', '307170-26', '307183-22',
                             '307245-21', '307363-21', '307373-22',
                             '307439-21', '308021-25', '308730-21',
                             '308917-21', '308946-22', '309151-21',
                             '309418-21', '309462-22', '309496-21',
                             '309663-26', '309855-21', '309945-22',
                             '310168-25', '310254-25', '310413-21',
                             '310426-21', '310453-21', '310467-21',
                             '310716-24', '310756-21', '310899-21',
                             '310908-21', '311077-21', '311427-21',
                             '311817-22', '311997-22', '312081-21',
                             '312246-21', '312307-26', '312480-22',
                             '312500-22', '312500-26', '312600-22',
                             '312635-22', '312785-21', '312811-21',
                             '312811-25', '312868-21', '312868-26',
                             '312922-21', '312976-22', '312984-21',
                             '312997-22', '313057-21', '313197-24',
                             '313435-21', '313501-25', '313501-26',
                             '313729-21', '313889-21', '313926-24',
                             '313926-25', '314063-21', '314128-24',
                             '314434-24', '314553-25', '314666-22',
                             '314675-21', '315034-21', '315142-21',
                             '315171-21', '315394-22', '315394-26',
                             '315397-22', '315467-21', '315563-21',
                             '315564-21', '315836-24', '315914-21',
                             '316015-21', '316299-21', '316578-25',
                             '316609-21', '316616-22', '316672-26',
                             '316720-21', '317003-24', '317006-21',
                             '317096-26', '317195-22', '317317-24',
                             '317411-21', '317454-21', '317643-21',
                             '317741-22', '317781-26', '317810-21',
                             '317810-26', '317820-21', '317837-25',
                             '317942-22', '318015-21', '318020-25',
                             '318020-26', '318146-21', '318285-21',
                             '318408-21', '318447-24', '318644-22',
                             '318644-24', '318730-21', '318809-22',
                             '318947-21', '319007-21', '319007-25',
                             '319027-25', '319061-21', '319082-22',
                             '319319-21', '319447-21', '319447-22',
                             '319447-24', '319797-21', '319819-21',
                             '320165-22', '320216-22', '320235-21',
                             '320273-24', '320332-21', '320485-22',
                             '320564-21', '320625-22', '320663-22',
                             '320747-21', '320825-24', '320932-24',
                             '320943-22', '321037-24', '321037-25',
                             '321184-21', '321396-21', '321461-25',
                             '321555-21', '321728-21', '321992-25',
                             '322140-22', '322173-24', '322210-21',
                             '322455-24', '322547-22', '322587-22',
                             '322714-21', '322893-24', '322940-21',
                             '322950-21', '322960-21', '322962-21',
                             '323107-25', '323154-21', '323156-22',
                             '323192-22', '323195-22', '323248-21',
                             '323337-25', '323386-26', '323473-25',
                             '323567-21', '323614-21', '323614-24',
                             '323616-22', '323653-21', '323705-21',
                             '323841-24', '323857-21', '323923-24',
                             '323978-22', '323995-21', '324235-21',
                             '324255-21', '324255-21', '324268-25',
                             '324325-25', '324430-25', '324452-21',
                             '324472-26', '324602-26', '324608-21',
                             '324628-21', '324628-22', '324666-22',
                             '324704-21', '324704-22', '324716-22',
                             '324743-24', '324743-26', '324805-21',
                             '324844-25', '324873-24', '324881-22',
                             '324888-24', '324950-21', '325070-22',
                             '325076-24', '325088-24', '325101-22',
                             '325101-24', '325124-25', '325136-21',
                             '325158-21', '325161-22', '325187-22',
                             '325207-24', '325225-22', '325268-21',
                             '325347-24', '325375-21', '325439-21',
                             '325544-22', '325709-21', '325716-22',
                             '325716-24', '325746-24', '325746-25',
                             '325746-26', '325747-21', '325747-22',
                             '325786-21', '325858-25', '325863-25',
                             '325882-22', '325888-21', '325895-22',
                             '325962-21', '325982-21', '325982-24',
                             '326136-21', '326255-22', '326285-22',
                             '326377-24', '326387-22', '326407-21',
                             '326429-21', '326496-22', '326522-22',
                             '326522-24', '326590-22', '326620-22',
                             '326814-21', '326820-21', '326827-21',
                             '326831-24', '326853-24', '326913-21',
                             '326954-21', '326955-21', '326984-21',
                             '327017-22', '327020-21', '327083-24',
                             '327089-21', '327092-21', '327100-21',
                             '327100-22', '327100-24', '327132-21',
                             '327174-21', '327224-21', '327244-22',
                             '327247-22', '327309-21', '327333-21',
                             '327347-22', '327357-21', '327388-24',
                             '327394-21', '327431-24', '327438-21',
                             '327462-21', '327467-21', '327478-21',
                             '327491-21', '327498-21', '327519-22',
                             '327537-22', '327557-22', '327581-21',
                             '327632-24', '327637-21', '327682-21',
                             '327682-22', '327701-21', '327703-21',
                             '327727-22', '327758-21', '327758-22',
                             '327774-24', '327783-21', '327806-22',
                             '327938-21', '327945-21', '328044-21',
                             '328160-22', '328248-21', '328293-22',
                             '328307-21', '328334-24', '328362-21',
                             '328409-21', '328480-21', '328486-21',
                             '328597-21', '328724-21', '360007-21',
                             '360155-24', '360155-25', '360215-21' )


---Finding Branch
SELECT DISTINCT LO.CODE_TX, LO.NAME_TX --, Lo.NAME_TX,*
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID --AND RD.DEF_ID = '105'
WHERE L.CODE_TX = '4150' AND Lo.TYPE_CD = 'DIV'



---Finding Collateral Code
SELECT  CC.ID ,
        CC.CODE_TX ,
        CC.DESCRIPTION_TX 
         FROM dbo.COLLATERAL_CODE CC
INNER JOIN dbo.LCCG_COLLATERAL_CODE_RELATE CCR ON CCR.COLLATERAL_CODE_ID = CC.ID
INNER JOIN dbo.LENDER_COLLATERAL_CODE_GROUP LCCG ON LCCG.ID = CCR.LCCG_ID
INNER JOIN dbo.LENDER L ON L.ID = LCCG.LENDER_ID
WHERE L.CODE_TX = '4150'

