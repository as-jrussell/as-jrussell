USE UniTrac

 SELECT 
   *
 FROM dbo.PROCESS_DEFINITION
where active_in = 'Y' and onhold_in = 'N'  
and status_cd <> 'Expired'
and description_tx like '%3551%'



select * from process_log 
where PROCESS_DEFINITION_id in (499298,499300,499304,499306,165334,533919,499307,629097,533927)
and update_dt >= '2018-07-02'
and update_dt <= '2018-07-03'
and end_dt is not null

select * from work_item
where relate_id in (61889187,
61889404,
61889488,
61889513,
61889536,
61889537,
61889545,
61889546) and workflow_definition_id = 9


select * from work_item_action
where work_item_id in (48075541,
48075622,
48075675,
48075706,
48075715,
48075716,
48075721,
48075722) and action_note_tx <> '' 



select * from process_log 
where PROCESS_DEFINITION_id in (763496,
763576,
763699,
763554,
763774,
763775,
763782,
763783)
and update_dt >= '2018-07-02'
and update_dt <= '2018-07-03'
and end_dt is not null


select distinct relate_id from process_log_item
where process_log_id in (61898603,
61899234,
61899649,
61901071,
61902319,
61902343,
61902539,
61902540) and relate_type_cd = 'Allied.UniTrac.BillingGroup'


select * from work_item
where relate_id in (1906837,1906657,1906832,1906695,1906838,1906715,1906787,1906831)
and workflow_definition_id = 10