SELECT DISTINCT CONCAT(o.first_name_tx, ' ', o.last_name_tx, ' | ', oa.LINE_1_TX,
               ' | ', oa.LINE_2_TX, ' | ', oa.CITY_TX, ' | ', oa.STATE_PROV_TX,
               ' | ', oa.POSTAL_CODE_TX) AS [Owner] ,
        l.number_tx AS [Loan Number] ,
        l.EFFECTIVE_DT [Loan Effective Date] ,
        L.BALANCE_LAST_UPDATE_DT [Loan Balance Date] ,
        COLLATERAL_NUMBER_NO [Term Coll#] ,
        l.APR_AMOUNT_NO ,
        c.LOAN_PERCENTAGE_NO ,
        p.year_tx AS Year ,
        p.make_tx AS Make ,
        p.model_tx AS Model ,
        p.vin_tx AS VIN ,
        op.bic_name_tx AS InsuranceCompany ,
        op.policy_number_tx AS PolicyNumber ,
       MAX(op.effective_dt) AS EffectiveDate ,
        MAX(op.expiration_dt) AS PolicyExpirationDate ,
        MAX(MOST_RECENT_MAIL_DT) [Most Recent Mail Date] ,
        op.expiration_dt AS ExpirationDate ,
        op.cancellation_dt AS CancellationDate,
		CONCAT(RC6.DESCRIPTION_TX, ' ', RC5.DESCRIPTION_TX) AS [Insurance Coverage Status]
		--INTO    jcs..INC0279878_20170126
FROM    loan l 
LEFT JOIN  collateral c ON c.loan_id = l.id
LEFT JOIN  property p ON p.id = c.property_id
LEFT JOIN  required_coverage rc ON rc.property_id = p.id
LEFT JOIN property_owner_policy_relate popr ON popr.property_id = p.id
LEFT JOIN  owner_Policy op ON op.id = popr.owner_policy_id
LEFT JOIN  dbo.POLICY_COVERAGE pc ON pc.OWNER_POLICY_ID = op.ID
LEFT JOIN lender le ON le.id = l.lender_id
LEFT JOIN owner_loan_relate olr ON olr.loan_id = l.id
LEFT JOIN  owner o ON olr.owner_id = o.id
LEFT JOIN  dbo.OWNER_ADDRESS oa ON oa.ID = o.ADDRESS_ID
		        LEFT JOIN dbo.REF_CODE RC5 ON RC5.CODE_CD = op.STATUS_CD
                                       AND RC5.DOMAIN_CD = 'RequiredCoverageInsStatus'
        LEFT JOIN dbo.REF_CODE RC6 ON RC6.CODE_CD = op.SUB_STATUS_CD
                                       AND RC6.DOMAIN_CD = 'RequiredCoverageInsSubStatus'
WHERE   Le.CODE_TX = '2990' 
        AND l.number_tx IN ( '1014949L2', '1017168L3', '1036109L2.1',
                             '1044897L2.1', '1047362L50', '1047969L60',
                             '1047969L2.4', '1048427L2', '1048489L2.5',
                             '1048489L2.3', '1048489L2.1', '1048489L2.4',
                             '1048508L50', '1048892L2', '1048962L2.4',
                             '1048962L2.3', '1049268L2.1', '1049615L2.1',
                             '1049630L2', '1049633L50', '1049633L2.2',
                             '1049706L2.4', '1049706L2.2', '1049923L2',
                             '1049971L1', '1050360L2.2', '1050360L2',
                             '1050467L2.1', '1050525L2.1', '1050689L2.1',
                             '1050740L2.2', '1051149L2', '1051369L2',
                             '1051463L2.1', '1051582L60', '1051582L4',
                             '1052043L2.2', '1052043L2.1', '1052061L3',
                             '1052240L60', '1052320L2', '1052440L2.1',
                             '1052509L2', '1052522L2', '1052700L50',
                             '1052700L2.2', '1053201L2', '1053221L2',
                             '1053256L2.4', '1053363L2.1', '1053414L2',
                             '1053418L3', '1053436L2', '1053442L2.1',
                             '1053523L2.1', '1053617L2.4', '1053685L2.2',
                             '1053685L2.1', '1053738L2', '1053746L2.1',
                             '1054132L1', '1054229L2.1', '1054235L2.1',
                             '1054242L2', '1054465L2.1', '1054486L2.3',
                             '1054486L2.2', '1054486L4', '1054499L2.1',
                             '1054499L2', '1054708L50', '1054708L2.2',
                             '1054708L2.1', '1054708L2', '1054797L3',
                             '1054889L2', '1054940L2', '32000299L2',
                             '32000344L2.2', '32000344L4', '32000518L50',
                             '32000624L2', '32000655L2.2', '32000655L2.1',
                             '32000740L50', '32000793L2.2', '32000953L2',
                             '32001175L2.1', '32001231L2.1', '32001231L10',
                             '32001231L2', '32001478L2.1', '32001478L2',
                             '32001528L3', '32001606L2', '32001683L50',
                             '32001683L2', '32001766L2', '32002298L4',
                             '32002298L2', '32002357L3.3', '32002577L2',
                             '32002719L2', '32002822L3', '32002830L2',
                             '32002900L2', '32003025L2.1', '32003277L2.2',
                             '32003278L2.3', '32003745L2.1', '32003745L2',
                             '32003879L2', '32004129L60.1', '32004129L2',
                             '32004622L1', '32004890L2', '32005084L2',
                             '32005148L3', '32005252L2', '32005357L60',
                             '32005357L2.1', '32005357L2', '32005403L2.1',
                             '32005454L2', '32005814L2', '32006085L2',
                             '32006256L2', '32006304L2', '32006462L2',
                             '32006603L2', '32006738L2', '32007059L2.1',
                             '32007131L2', '32007218L2', '32007297L2',
                             '32007350L60.1', '32007350L2', '32007394L2',
                             '32007433L2', '32007538L2', '32007580L2',
                             '32007634L2', '32007760L2', '32007789L2',
                             '32008113L4', '32008424L2', '32008513L2',
                             '32008595L2', '32009085L2.1', '32009085L2',
                             '32009181L2.1', '32009311L2', '32009400L2',
                             '32009590L2.1', '32009715L2', '32009724L2',
                             '32009899L2', '32009963L2.1', '32009963L2',
                             '32010423L2', '32010548L2', '32010725L2',
                             '32010727L2.1', '32010727L2', '32011264L2',
                             '49003117L2.1', '49004141L2.1', '92001218L50',
                             '92001227L2', '92001235L30', '92001621L2.3',
                             '92001761L2', '92002681L2', '92003676L50',
                             '92005172L50', '92005172L30', '92005172L2.1',
                             '92005291L30', '92005697L50', '92005697L2.2',
                             '92005807L2', '92005839L2.2', '92005839L2',
                             '92006066L2', '92006170L2', '92009035L1',
                             '92009066L50', '92009070L2.1', '92009101L1',
                             '92009144L2', '92009165L50', '92009172L70',
                             '92009184L50', '92009184L1', '92009227L2.4',
                             '92009241L50', '92009241L2.1', '92030126L50',
                             '92030132L2', '92030195L2.2', '92030230L50',
                             '92030352L2.1', '92030362L2.2', '92030420L2.1',
                             '92030548L2.3', '92030553L2.1', '92030581L50',
                             '92030641L2.1', '92030641L2', '92030658L30',
                             '92030734L2', '92030820L2.1', '92030855L2.2',
                             '92030939L2.2', '92030946L2.2', '92030946L2.1',
                             '92031041L2.2', '92031041L2.1', '92031046L50',
                             '92031368L2', '92031425L50', '92031450L30.1',
                             '92031453L50', '92031563L2', '92031668L2',
                             '92031670L501', '92031718L2', '92031842L11',
                             '92031870L2.4', '92031903L1', '92031955L2.1',
                             '92035004L2.1', '92035011L50.2', '92035011L1',
                             '92035038L30', '92035073L2.5', '92035073L2.4',
                             '92035075L50', '92035077L2.1', '92035080L78',
                             '92035081L2', '92035084L1', '92035125L2.2',
                             '92035140L2', '92035161L78.1', '92035201L10',
                             '92035205L30', '92035205L2.2', '92035230L2.1',
                             '92082080L50', '92082116L2.1', '92082223L2',
                             '92082239L2.2', '92082370L2.2', '92082423L2',
                             '92082426L2.1', '92082644L2.3', '92082644L2.2',
                             '92082644L2.1', '92082782L2', '92082848L2.7',
                             '92082851L50', '92083001L2.6', '92083001L2.5',
                             '92083067L2.1', '92083241L2', '92083574L2.1',
                             '92083606L50', '92083606L2.1', '92083649L2',
                             '92083884L2.2', '92083908L2.2', '92084065L50',
                             '92084065L2', '92084346L2', '92084487L2.2',
                             '92084487L2.1', '92084524L2.1', '92084563L2',
                             '92084653L50.1', '92084705L2.4', '92084712L11',
                             '92084712L1', '92084765L50', '92084775L2.1',
                             '92084791L2.4', '92084822L2', '92980121L50',
                             '92980123L2.1', '92980123L2', '92980202L2.1',
                             '92980203L2', '92980208L2', '92981110L60',
                             '92981131L60', '92981131L1' ) AND op.cancellation_dt  IS NULL 
							 --AND  op.expiration_dt = '9999-12-31 23:59:59.9999999'
GROUP BY l.number_tx ,
        o.last_name_tx ,
        o.first_name_tx ,
        oa.line_1_tx ,
        oa.line_2_tx ,
        oa.city_tx ,
        oa.state_prov_tx ,
        oa.postal_code_tx ,
        p.vin_tx ,
        p.year_tx ,
        p.make_tx ,
        p.model_tx ,
        op.bic_name_tx ,
        op.policy_number_tx ,
        op.sub_status_cd ,
        op.status_cd ,
        op.effective_dt ,
        op.expiration_dt ,
        op.cancellation_dt ,
        MOST_RECENT_MAIL_DT ,
        l.EFFECTIVE_DT ,
        L.BALANCE_LAST_UPDATE_DT,
		c.COLLATERAL_NUMBER_NO,
		l.APR_AMOUNT_NO, 
		c.LOAN_PERCENTAGE_NO, RC6.DESCRIPTION_TX,  RC5.DESCRIPTION_TX, op.id
ORDER BY l.number_tx,   MAX(op.effective_dt)  DESC 