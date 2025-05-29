SELECT 
        le.code_tx AS LenderNumber ,
        l.number_tx AS LoanNumber ,
        umr.score_detail_xml AS ScoreDetails ,
        umr.Score_No AS Score ,
        umr.Match_result_cd AS MatchResults ,
        umr.MSG_log_tx AS ErrorLog ,
        umr.log_tx AS RuleLog ,
        umr.apply_status_cd AS WiStatus ,
        umr.Utl_loan_id AS UTLIdentifier
--INTO jcs..INC0251177
FROM    utl_match_result umr
        JOIN loan l ON l.id = umr.loan_id
        JOIN lender le ON le.id = l.lender_id
WHERE   LENDER_ID = 'XXXX'
        AND umr.MSG_Log_tx LIKE '%Policy coverage invalid%'

